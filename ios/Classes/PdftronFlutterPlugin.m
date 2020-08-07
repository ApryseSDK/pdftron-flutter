#import "PdftronFlutterPlugin.h"
#import "FlutterDocumentView.h"

static NSString * const PTDisabledToolsKey = @"disabledTools";
static NSString * const PTDisabledElementsKey = @"disabledElements";
static NSString * const PTMultiTabEnabledKey = @"multiTabEnabled";
static NSString * const PTCustomHeadersKey = @"customHeaders";

const int exportAnnotationId = 1;
const int exportBookmarkId = 2;
const int documentLoadedId = 3;

@interface PTFlutterViewController : PTDocumentViewController
@property (nonatomic, strong) FlutterResult openResult;
@property (nonatomic, strong) PdftronFlutterPlugin* plugin;

@property (nonatomic) BOOL local;
@property (nonatomic) BOOL needsDocumentLoaded;
@property (nonatomic) BOOL needsRemoteDocumentLoaded;
@property (nonatomic) BOOL documentLoaded;
@end

@implementation PTFlutterViewController

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    if (self.needsDocumentLoaded) {
        self.needsDocumentLoaded = NO;
        self.needsRemoteDocumentLoaded = NO;
        self.documentLoaded = YES;

        NSString *filePath = self.coordinatedDocument.fileURL.path;
        [self.plugin docVC:self documentLoaded:filePath];
    }
}

- (void)openDocumentWithURL:(NSURL *)url password:(NSString *)password
{
    if ([url isFileURL]) {
        self.local = YES;
    } else {
        self.local = NO;
    }
    self.documentLoaded = NO;
    self.needsDocumentLoaded = NO;
    self.needsRemoteDocumentLoaded = NO;

    [super openDocumentWithURL:url password:password];
}

- (void)bookmarkViewController:(PTBookmarkViewController *)bookmarkViewController didAddBookmark:(PTUserBookmark *)bookmark
{
    [super bookmarkViewController:bookmarkViewController didAddBookmark:bookmark];
    [self bookmarksModified];
}

- (void)bookmarkViewController:(PTBookmarkViewController *)bookmarkViewController didRemoveBookmark:(PTUserBookmark *)bookmark
{
    [super bookmarkViewController:bookmarkViewController didRemoveBookmark:bookmark];
    [self bookmarksModified];
}

- (void)bookmarkViewController:(PTBookmarkViewController *)bookmarkViewController didModifyBookmark:(PTUserBookmark *)bookmark
{
    [super bookmarkViewController:bookmarkViewController didModifyBookmark:bookmark];
    [self bookmarksModified];
}

-(void)bookmarksModified
{
    __block NSString* json;
    NSError* error;
    BOOL exceptionOccurred = [self.pdfViewCtrl DocLockReadWithBlock:^(PTPDFDoc * _Nullable doc) {
        json = [PTBookmarkManager.defaultManager exportBookmarksFromDoc:doc];
    } error:&error];
    
    if( exceptionOccurred )
    {
        NSLog(@"Error: %@", error.description);
    }

    [self.plugin docVC:self bookmarkChange:json];
}

-(void)toolManager:(PTToolManager*)toolManager willRemoveAnnotation:(nonnull PTAnnot *)annotation onPageNumber:(int)pageNumber
{
    NSString* xfdf = [self generateXfdfCommandWithAdded:Nil modified:Nil removed:@[annotation]];
    [self.plugin docVC:self annotationChange:xfdf];
}

- (void)toolManager:(PTToolManager *)toolManager annotationAdded:(PTAnnot *)annotation onPageNumber:(unsigned long)pageNumber
{
    NSString* xfdf = [self generateXfdfCommandWithAdded:@[annotation] modified:Nil removed:Nil];
    [self.plugin docVC:self annotationChange:xfdf];
}

- (void)toolManager:(PTToolManager *)toolManager annotationModified:(PTAnnot *)annotation onPageNumber:(unsigned long)pageNumber
{
    NSString* xfdf = [self generateXfdfCommandWithAdded:Nil modified:@[annotation] removed:Nil];
    [self.plugin docVC:self annotationChange:xfdf];
}

-(NSString*)generateXfdfCommandWithAdded:(NSArray<PTAnnot*>*)added modified:(NSArray<PTAnnot*>*)modified removed:(NSArray<PTAnnot*>*)removed
{
    
    PTPDFDoc* pdfDoc = self.document;
    
    if ( pdfDoc ) {
        PTVectorAnnot* addedV = [[PTVectorAnnot alloc] init];
        for(PTAnnot* annot in added)
        {
            [addedV add:annot];
        }
        
        PTVectorAnnot* modifiedV = [[PTVectorAnnot alloc] init];
        for(PTAnnot* annot in modified)
        {
            [modifiedV add:annot];
        }
        
        PTVectorAnnot* removedV = [[PTVectorAnnot alloc] init];
        for(PTAnnot* annot in removed)
        {
            [removedV add:annot];
        }
        
        PTFDFDoc* fdfDoc = [pdfDoc FDFExtractCommand:addedV annot_modified:modifiedV annot_deleted:removedV];
        
        return [fdfDoc SaveAsXFDFToString];
    }
    return Nil;
}

#pragma mark - <PTPDFViewCtrlDelegate>

- (void)pdfViewCtrl:(PTPDFViewCtrl *)pdfViewCtrl onSetDoc:(PTPDFDoc *)doc
{
    [super pdfViewCtrl:pdfViewCtrl onSetDoc:doc];

    if (self.local && !self.documentLoaded) {
        self.needsDocumentLoaded = YES;
    }
    else if (!self.local && !self.documentLoaded && self.needsRemoteDocumentLoaded) {
        self.needsDocumentLoaded = YES;
    }
    else if (!self.local && !self.documentLoaded && self.coordinatedDocument.fileURL) {
        self.needsDocumentLoaded = YES;
    }
}

- (void)pdfViewCtrl:(PTPDFViewCtrl *)pdfViewCtrl downloadEventType:(PTDownloadedType)type pageNumber:(int)pageNum message:(NSString *)message
{
    if (type == e_ptdownloadedtype_finished && !self.documentLoaded) {
        self.needsRemoteDocumentLoaded = YES;
    }

    [super pdfViewCtrl:pdfViewCtrl downloadEventType:type pageNumber:pageNum message:message];
}

@end

@interface PdftronFlutterPlugin () <PTTabbedDocumentViewControllerDelegate, PTDocumentViewControllerDelegate>

@property (nonatomic, strong) id config;
@property (nonatomic, strong) FlutterEventSink xfdfEventSink;
@property (nonatomic, strong) FlutterEventSink bookmarkEventSink;
@property (nonatomic, strong) FlutterEventSink documentLoadedEventSink;

@end

@implementation PdftronFlutterPlugin

static NSString * const EVENT_EXPORT_ANNOTATION_COMMAND = @"export_annotation_command_event";
static NSString * const EVENT_EXPORT_BOOKMARK = @"export_bookmark_event";
static NSString * const EVENT_DOCUMENT_LOADED = @"document_loaded_event";

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"pdftron_flutter"
                                     binaryMessenger:[registrar messenger]];
    

    
    PdftronFlutterPlugin* instance = [[PdftronFlutterPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    
    FlutterEventChannel* xfdfEventChannel = [FlutterEventChannel eventChannelWithName:EVENT_EXPORT_ANNOTATION_COMMAND binaryMessenger:[registrar messenger]];

    FlutterEventChannel* bookmarkEventChannel = [FlutterEventChannel eventChannelWithName:EVENT_EXPORT_BOOKMARK binaryMessenger:[registrar messenger]];

    FlutterEventChannel* documentLoadedEventChannel = [FlutterEventChannel eventChannelWithName:EVENT_DOCUMENT_LOADED binaryMessenger:[registrar messenger]];

    [xfdfEventChannel setStreamHandler:instance];
    
    [bookmarkEventChannel setStreamHandler:instance];
    
    [documentLoadedEventChannel setStreamHandler:instance];

    DocumentViewFactory* documentViewFactory =
    [[DocumentViewFactory alloc] initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:documentViewFactory withId:@"pdftron_flutter/documentview"];
}

+ (void)disableTools:(NSArray<id> *)toolsToDisable documentViewController:(PTDocumentViewController *)documentViewController
{
    PTToolManager *toolManager = documentViewController.toolManager;
    
    for (id item in toolsToDisable) {
        BOOL value = NO;
        
        if ([item isKindOfClass:[NSString class]]) {
            NSString *string = (NSString *)item;
            
            if ([string isEqualToString:@"AnnotationEdit"]) {
                // multi-select not implemented
            }
            else if ([string isEqualToString:@"AnnotationCreateSticky"] ||
                     [string isEqualToString:@"stickyToolButton"]) {
                toolManager.textAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:@"AnnotationCreateFreeHand"] ||
                     [string isEqualToString:@"freeHandToolButton"]) {
                toolManager.inkAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:@"TextSelect"]) {
                toolManager.textSelectionEnabled = value;
            }
            else if ([string isEqualToString:@"AnnotationCreateTextHighlight"] ||
                     [string isEqualToString:@"highlightToolButton"]) {
                toolManager.highlightAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:@"AnnotationCreateTextUnderline"] ||
                     [string isEqualToString:@"underlineToolButton"]) {
                toolManager.underlineAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:@"AnnotationCreateTextSquiggly"] ||
                     [string isEqualToString:@"squigglyToolButton"]) {
                toolManager.squigglyAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:@"AnnotationCreateTextStrikeout"] ||
                     [string isEqualToString:@"strikeoutToolButton"]) {
                toolManager.strikeOutAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:@"AnnotationCreateFreeText"] ||
                     [string isEqualToString:@"freeTextToolButton"]) {
                toolManager.freeTextAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:@"AnnotationCreateCallout"] ||
                     [string isEqualToString:@"calloutToolButton"]) {
                toolManager.calloutAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:@"AnnotationCreateSignature"] ||
                     [string isEqualToString:@"signatureToolButton"]) {
                toolManager.signatureAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:@"AnnotationCreateLine"] ||
                     [string isEqualToString:@"lineToolButton"]) {
                toolManager.lineAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:@"AnnotationCreateArrow"] ||
                     [string isEqualToString:@"arrowToolButton"]) {
                toolManager.arrowAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:@"AnnotationCreatePolyline"] ||
                     [string isEqualToString:@"polylineToolButton"]) {
                toolManager.polylineAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:@"AnnotationCreateStamp"] ||
                     [string isEqualToString:@"stampToolButton"]) {
                toolManager.stampAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:@"AnnotationCreateRectangle"] ||
                     [string isEqualToString:@"rectangleToolButton"]) {
                toolManager.squareAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:@"AnnotationCreateEllipse"] ||
                     [string isEqualToString:@"ellipseToolButton"]) {
                toolManager.circleAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:@"AnnotationCreatePolygon"] ||
                     [string isEqualToString:@"polygonToolButton"]) {
                toolManager.polygonAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:@"AnnotationCreatePolygonCloud"] ||
                     [string isEqualToString:@"cloudToolButton"])
            {
                toolManager.cloudyAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:@"AnnotationCreateFreeHighlighter"] ||
                     [string isEqualToString:@"freeHighlighterToolButton"]) {
                toolManager.freehandHighlightAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:@"Eraser"] ||
                     [string isEqualToString:@"eraserToolButton"]) {
                toolManager.eraserEnabled = value;
            }
        }
    }
}

+ (void)disableElements:(NSArray*)elementsToDisable documentViewController:(PTDocumentViewController *)documentViewController
{
    typedef void (^HideElementBlock)(void);
    
    NSDictionary *hideElementActions = @{
        @"toolsButton":
            ^{
                documentViewController.annotationToolbarButtonHidden = YES;
            },
        @"searchButton":
            ^{
                documentViewController.searchButtonHidden = YES;
            },
        @"shareButton":
            ^{
                documentViewController.shareButtonHidden = YES;
            },
        @"viewControlsButton":
            ^{
                documentViewController.viewerSettingsButtonHidden = YES;
            },
        @"thumbnailsButton":
            ^{
                documentViewController.thumbnailBrowserButtonHidden = YES;
            },
        @"listsButton":
            ^{
                documentViewController.navigationListsButtonHidden = YES;
            },
        @"reflowModeButton": ^{
            documentViewController.readerModeButtonHidden = YES;
        },
        @"thumbnailSlider":
            ^{
                documentViewController.thumbnailSliderHidden = YES;
            },
        @"saveCopyButton":
            ^{
                documentViewController.exportButtonHidden = YES;
            },
    };
    
    for(NSObject* item in elementsToDisable)
    {
        if( [item isKindOfClass:[NSString class]])
        {
            HideElementBlock block = hideElementActions[item];
            if (block)
            {
                block();
            }
        }
    }
    
    [self disableTools:elementsToDisable documentViewController:documentViewController];
}

+ (void)configureTabbedDocumentViewController:(PTTabbedDocumentViewController*)tabbedDocumentViewController withConfig:(NSString*)config
{
    if( config && ![config isEqualToString:@"null"] )
    {
        //convert from json to dict
        NSData* jsonData = [config dataUsingEncoding:NSUTF8StringEncoding];
        id foundationObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:Nil];
        
        NSAssert( [foundationObject isKindOfClass:[NSDictionary class]], @"config JSON object not in expected dictionary format." );
        
        if( [foundationObject isKindOfClass:[NSDictionary class]] )
        {
            NSDictionary* configPairs = (NSDictionary*)foundationObject;
            
            for (NSString* key in configPairs.allKeys) {
                if ([key isEqualToString:PTMultiTabEnabledKey]) {
                    id multiTabEnabledValue = configPairs[PTMultiTabEnabledKey];
                    if ([multiTabEnabledValue isKindOfClass:[NSNumber class]]) {
                        BOOL multiTabEnabled = ((NSNumber *)multiTabEnabledValue).boolValue;
                        tabbedDocumentViewController.tabsEnabled = multiTabEnabled;
                    }
                }
            }
        }
        else
        {
            NSLog(@"config JSON object not in expected dictionary format.");
        }
    }
}

+ (void)configureDocumentViewController:(PTDocumentViewController*)documentViewController withConfig:(NSString*)config
{
    if (config.length == 0 || [config isEqualToString:@"null"]) {
        return;
    }
    
    //convert from json to dict
    NSData* jsonData = [config dataUsingEncoding:NSUTF8StringEncoding];
    id foundationObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:Nil];
    
    NSAssert( [foundationObject isKindOfClass:[NSDictionary class]], @"config JSON object not in expected dictionary format." );
    
    if( [foundationObject isKindOfClass:[NSDictionary class]] )
    {
        //convert from json to dict
        NSData* jsonData = [config dataUsingEncoding:NSUTF8StringEncoding];
        id foundationObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:Nil];

        NSAssert( [foundationObject isKindOfClass:[NSDictionary class]], @"config JSON object not in expected dictionary format." );
        
        if( [foundationObject isKindOfClass:[NSDictionary class]] )
        {
            NSDictionary* configPairs = (NSDictionary*)foundationObject;
            
            for (NSString* key in configPairs.allKeys) {
                if( [key isEqualToString:PTDisabledToolsKey] )
                {
                    id toolsToDisable = configPairs[PTDisabledToolsKey];
                    if( ![toolsToDisable isEqual:[NSNull null]] )
                    {
                        NSAssert( [toolsToDisable isKindOfClass:[NSArray class]], @"disabledTools JSON object not in expected array format." );
                        if( [toolsToDisable isKindOfClass:[NSArray class]] )
                        {
                            [self disableTools:(NSArray*)toolsToDisable documentViewController:documentViewController];
                        }
                        else
                        {
                            NSLog(@"disabledTools JSON object not in expected array format.");
                        }
                    }
                }
                else if( [key isEqualToString:PTDisabledElementsKey] )
                {
                    id elementsToDisable = configPairs[PTDisabledElementsKey];
                    
                    if( ![elementsToDisable isEqual:[NSNull null]] )
                    {
                        NSAssert( [elementsToDisable isKindOfClass:[NSArray class]], @"disabledTools JSON object not in expected array format." );
                        if( [elementsToDisable isKindOfClass:[NSArray class]] )
                        {
                            [self disableElements:(NSArray*)elementsToDisable documentViewController:documentViewController];
                        }
                        else
                        {
                            NSLog(@"disabledTools JSON object not in expected array format.");
                        }
                    }
                }
                else if ([key isEqualToString:PTCustomHeadersKey]) {
                    id customHeadersValue = configPairs[PTCustomHeadersKey];
                    if ([customHeadersValue isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *customHeaders = (NSDictionary *)customHeadersValue;
                        
                        documentViewController.additionalHTTPHeaders = customHeaders;
                    }
                }
                else if ([key isEqualToString:PTMultiTabEnabledKey]) {
                    // Handled by tabbed config.
                }
                else
                {
                    NSLog(@"Unknown JSON key in config: %@.", key);
                    NSAssert( false, @"Unknown JSON key in config." );
                }
            }
        }
        else
        {
            NSLog(@"config JSON object not in expected dictionary format.");
        }
    }
}

- (void)handleOpenDocumentMethod:(NSDictionary<NSString *, id> *)arguments resultToken:(FlutterResult)result
{

    [PTOverrides overrideClass:[PTDocumentViewController class] withClass:[PTFlutterViewController class]];
    
    // Get document argument.
    NSString *document = nil;
    id documentValue = arguments[@"document"];
    if ([documentValue isKindOfClass:[NSString class]]) {
        document = (NSString *)documentValue;
    }
    
    if (document.length == 0) {
        // error handling
        return;
    }
    
    // Get (optional) password argument.
    NSString *password = nil;
    id passwordValue = arguments[@"password"];
    if ([passwordValue isKindOfClass:[NSString class]]) {
        password = (NSString *)passwordValue;
    }
    
    // Create and wrap a tabbed controller in a navigation controller.    
    self.tabbedDocumentViewController = [[PTTabbedDocumentViewController alloc] init];
    self.tabbedDocumentViewController.delegate = self;
    self.tabbedDocumentViewController.tabsEnabled = NO;
    
    self.tabbedDocumentViewController.restorationIdentifier = [NSUUID UUID].UUIDString;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.tabbedDocumentViewController];
    
    self.tabbedDocumentViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(topLeftButtonPressed:)];
    
    NSString* config = arguments[@"config"];
    self.config = config;
    
    [[self class] configureTabbedDocumentViewController:self.tabbedDocumentViewController
                                             withConfig:config];
    
    // Open a file URL.
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:document withExtension:@"pdf"];
    if ([document containsString:@"://"]) {
        fileURL = [NSURL URLWithString:document];
    } else if ([document hasPrefix:@"/"]) {
        fileURL = [NSURL fileURLWithPath:document];
    }
        
    [self.tabbedDocumentViewController openDocumentWithURL:fileURL
                                                  password:password];
    
    ((PTFlutterViewController*)self.tabbedDocumentViewController.childViewControllers.lastObject).openResult = result;
    ((PTFlutterViewController*)self.tabbedDocumentViewController.childViewControllers.lastObject).plugin = self;
    
    UIViewController *presentingViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    
    navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    // Show navigation (and tabbed) controller.
    [presentingViewController presentViewController:navigationController animated:YES completion:nil];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if ([@"getVersion" isEqualToString:call.method]) {
        result([@"PDFNet " stringByAppendingFormat:@"%f", [PTPDFNet GetVersion]]);
    } else if ([@"initialize" isEqualToString:call.method]) {
        NSString *licenseKey = call.arguments[@"licenseKey"];
        [PTPDFNet Initialize:licenseKey];
    } else if ([@"openDocument" isEqualToString:call.method]) {
        [self handleOpenDocumentMethod:call.arguments resultToken:result];
    } else if ([@"importAnnotationCommand" isEqualToString:call.method]) {
        [self importAnnotationCommand:call.arguments];
    } else if ([@"importBookmarkJson" isEqualToString:call.method]) {
        [self importBookmarks:call.arguments];
    } else if ([@"saveDocument" isEqualToString:call.method]) {
        [self saveDocument:call.arguments resultToken:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)topLeftButtonPressed:(UIBarButtonItem *)barButtonItem
{
    if (self.tabbedDocumentViewController) {
        [self.tabbedDocumentViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [UIApplication.sharedApplication.keyWindow.rootViewController.presentedViewController dismissViewControllerAnimated:YES completion:Nil];
    }
}
- (void)importAnnotationCommand:(NSDictionary<NSString *, id> *)arguments
{
    PTDocumentViewController* docVC = self.tabbedDocumentViewController.selectedViewController;
    
    if( docVC == Nil && self.tabbedDocumentViewController.tabsEnabled == NO)
    {
        docVC = self.tabbedDocumentViewController.childViewControllers.lastObject;
    }
    
    if( docVC.document == Nil )
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        return;
    }
    
    NSError* error;
    
    [docVC.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        if( [doc HasDownloader] )
        {
            // too soon
            NSLog(@"Error: The document is still being downloaded.");
            return;
        }

        PTFDFDoc* fdfDoc = [doc FDFExtract:e_ptboth];
        [fdfDoc MergeAnnots:arguments[@"xfdfCommand"] permitted_user:@""];
        [doc FDFUpdate:fdfDoc];

        [docVC.pdfViewCtrl Update:YES];


    } error:&error];
}

-(void)importBookmarks:(NSDictionary*)bookmarkDict
{
    PTDocumentViewController* docVC = self.tabbedDocumentViewController.selectedViewController;
    
    if( docVC == Nil && self.tabbedDocumentViewController.tabsEnabled == NO)
    {
        docVC = self.tabbedDocumentViewController.childViewControllers.lastObject;
    }
    
    if( docVC.document == Nil )
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        return;
    }
    
    NSError* error;
    
    [docVC.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        if( [doc HasDownloader] )
        {
            // too soon
            NSLog(@"Error: The document is still being downloaded.");
            return;
        }

        [PTBookmarkManager.defaultManager importBookmarksForDoc:doc fromJSONString:bookmarkDict[@"bookmarkJson"]];


    } error:&error];
}

-(void)saveDocument:(NSDictionary<NSString *, id> *)arguments resultToken:(FlutterResult)result
{
    PTDocumentViewController* docVC = self.tabbedDocumentViewController.selectedViewController;
    
    if( docVC == Nil && self.tabbedDocumentViewController.tabsEnabled == NO)
    {
        docVC = self.tabbedDocumentViewController.childViewControllers.lastObject;
    }
    
    __block NSString* resultString;
    
    if( docVC.document == Nil )
    {
        resultString = @"Error: The document view controller has no document.";
        
        // something is wrong, no document.
        NSLog(@"%@", resultString);
        result(resultString);
        
        return;
    }
    
    NSError* error;
    
    [docVC.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        if( [doc HasDownloader] )
        {
            // too soon
            resultString = @"Error: The document is still being downloaded and cannot be saved.";
            NSLog(@"%@", resultString);
            result(resultString);
            return;
        }

        [docVC saveDocument:0 completionHandler:^(BOOL success) {
            if(!success)
            {
                resultString = @"Error: The file could not be saved.";
                NSLog(@"%@", resultString);
                result(resultString);
            }
            else
            {
                resultString = @"The file was successfully saved.";
                result(resultString);
            }
        }];


    } error:&error];
    
    if( error )
    {
        NSLog(@"Error: There was an error while trying to save the document. %@", error.localizedDescription);
    }
    
}

-(void)docVC:(PTDocumentViewController*)docVC bookmarkChange:(NSString*)bookmarkJson
{
    self.bookmarkEventSink(bookmarkJson);
}

-(void)docVC:(PTDocumentViewController*)docVC annotationChange:(NSString*)xfdfCommand
{
    self.xfdfEventSink(xfdfCommand);
}

-(void)docVC:(PTDocumentViewController*)docVC documentLoaded:(NSString*)filePath
{
    self.documentLoadedEventSink(filePath);
}

- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(FlutterEventSink)events
{
    if( [arguments intValue] == exportAnnotationId )
    {
        self.xfdfEventSink = events;
    }
    else if( [arguments intValue] == exportBookmarkId )
    {
        self.bookmarkEventSink = events;
    }
    else if( [arguments intValue] == documentLoadedId )
    {
        self.documentLoadedEventSink = events;
    }
    
    return Nil;
}

- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments
{
    self.xfdfEventSink = Nil;
    
    return Nil;
}


- (void)tabbedDocumentViewController:(PTTabbedDocumentViewController *)tabbedDocumentViewController willAddDocumentViewController:(PTDocumentViewController *)documentViewController
{
    documentViewController.delegate = self;
    
    [[self class] configureDocumentViewController:documentViewController
                                       withConfig:self.config];
}

- (void)documentViewControllerDidOpenDocument:(PTDocumentViewController *)documentViewController
{
    NSLog(@"Document opened successfully");
    FlutterResult result = ((PTFlutterViewController*)documentViewController).openResult;
    result(@"Opened Document Successfully");
}

- (void)documentViewController:(PTDocumentViewController *)documentViewController didFailToOpenDocumentWithError:(NSError *)error
{
    NSLog(@"Failed to open document: %@", error);
    FlutterResult result = ((PTFlutterViewController*)documentViewController).openResult;
    result([@"Opened Document Failed: %@" stringByAppendingString:error.description]);
}

@end
