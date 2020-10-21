#import "PdftronFlutterPlugin.h"
#import "FlutterDocumentView.h"
#import "PTPluginUtils.h"

const int exportAnnotationId = 1;
const int exportBookmarkId = 2;
const int documentLoadedId = 3;
const int documentErrorId = 4;
const int annotationChangedId = 5;
const int annotationsSelectedId = 6;
const int formFieldValueChangedId = 7;

const NSString *actionAdd = @"add";
const NSString *actionModify = @"modify";
const NSString *actionDelete = @"delete";

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
        [self.plugin docVCDocumentLoaded:filePath];
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
    
    if(exceptionOccurred)
    {
        NSLog(@"Error: %@", error.description);
    }

    [self.plugin docVCBookmarkChange:json];
}

-(void)toolManager:(PTToolManager*)toolManager willRemoveAnnotation:(nonnull PTAnnot *)annotation onPageNumber:(int)pageNumber
{
    NSString* annotationWithActionString = [self generateAnnotationWithActionString:annotation onPageNumber:pageNumber action:PTDeleteActionKey];
    if (annotationWithActionString) {
        [self.plugin docVCAnnotationChanged:annotationWithActionString];
    }
    
    NSString* xfdf = [self generateXfdfCommandWithAdded:Nil modified:Nil removed:@[annotation]];
    [self.plugin docVCExportAnnotationCommand:xfdf];
    
}

- (void)toolManager:(PTToolManager *)toolManager annotationAdded:(PTAnnot *)annotation onPageNumber:(unsigned long)pageNumber
{
    NSString* annotationWithActionString = [self generateAnnotationWithActionString:annotation onPageNumber:pageNumber action:PTAddActionKey];
    if (annotationWithActionString) {
        [self.plugin docVCAnnotationChanged:annotationWithActionString];
    }
    
    NSString* xfdf = [self generateXfdfCommandWithAdded:@[annotation] modified:Nil removed:Nil];
    [self.plugin docVCExportAnnotationCommand:xfdf];
}

- (void)toolManager:(PTToolManager *)toolManager annotationModified:(PTAnnot *)annotation onPageNumber:(unsigned long)pageNumber
{
    NSString* annotationWithActionString = [self generateAnnotationWithActionString:annotation onPageNumber:pageNumber action:PTModifyActionKey];
    if (annotationWithActionString) {
        [self.plugin docVCAnnotationChanged:annotationWithActionString];
    }
  
    NSString* xfdf = [self generateXfdfCommandWithAdded:Nil modified:@[annotation] removed:Nil];
    [self.plugin docVCExportAnnotationCommand:xfdf];
}

- (void)toolManager:(PTToolManager *)toolManager didSelectAnnotation:(PTAnnot *)annotation onPageNumber:(unsigned long)pageNumber
{
    if (annotation.IsValid) {
        
        __block NSString *uniqueId;
        __block PTPDFRect *screenRect;
        
        NSError *error;
        [self.pdfViewCtrl DocLockReadWithBlock:^(PTPDFDoc * _Nullable doc) {
            PTObj *uniqueIdObj = [annotation GetUniqueID];
            if ([uniqueIdObj IsValid] && [uniqueIdObj IsString]) {
                uniqueId = [uniqueIdObj GetAsPDFText];
            }
            screenRect = [self.pdfViewCtrl GetScreenRectForAnnot:annotation
                                                                   page_num:(int)pageNumber];
        } error:&error];
        
        if (error) {
            NSLog(@"An error occurred: %@", error);
            return;
        }
        
        NSDictionary *annotDict = @{
            PTAnnotationIdKey: uniqueId ?: @"",
            PTAnnotationPageNumberKey: [NSNumber numberWithLong:pageNumber],
            PTRectKey: @{
                    PTX1Key: @([screenRect GetX1]),
                    PTY1Key: @([screenRect GetY1]),
                    PTX2Key: @([screenRect GetX2]),
                    PTY2Key: @([screenRect GetY2]),
                    PTWidthKey: @([screenRect Width]),
                    PTHeightKey: @([screenRect Height]),
            },
        };
        
        [self.plugin docVCAnnotationsSelected:[PTPluginUtils PT_idToJSONString:@[annotDict]]];
    }
   
}

- (void)toolManager:(PTToolManager *)toolManager formFieldDataModified:(PTAnnot *)annotation onPageNumber:(unsigned long)pageNumber {
    if (annotation.GetType == e_ptWidget) {
        NSError *error;
        
        __block NSString *fieldName;
        __block NSString *fieldValue;
        
        [self.pdfViewCtrl DocLockReadWithBlock:^(PTPDFDoc * _Nullable doc) {
            PTWidget *widget = [[PTWidget alloc] initWithAnn:annotation];
            PTField *field = [widget GetField];
            fieldName = [field IsValid] ? [field GetName] : @"";
            fieldValue = [field IsValid] ? [field GetValueAsString] : @"";
        } error:&error];
        if (error) {
            NSLog(@"An error occurred: %@", error);
            return;
        }
        
        if (fieldName && fieldValue) {
            NSDictionary *fieldDict = @{
                PTFormFieldNameKey: fieldName,
                PTFormFieldValueKey: fieldValue,
            };
            
            [self.plugin docVCFormFieldValueChanged: [PTPluginUtils PT_idToJSONString:@[fieldDict]]];
        }
        // TODO: collab manager
        /*
         copied from RN
         
         if (!self.collaborationManager) {
             PTVectorAnnot *annots = [[PTVectorAnnot alloc] init];
             [annots add:annot];
             [self rnt_sendExportAnnotationCommandWithAction:PTModifyAnnotationActionKey xfdfCommand:[self generateXfdfCommand:[[PTVectorAnnot alloc] init] modified:annots deleted:[[PTVectorAnnot alloc] init]]];
         }
         */
    }
}

-(NSString*)generateXfdfCommandWithAdded:(NSArray<PTAnnot*>*)added modified:(NSArray<PTAnnot*>*)modified removed:(NSArray<PTAnnot*>*)removed
{
    
    PTPDFDoc* pdfDoc = self.document;
    
    if (pdfDoc) {
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

-(NSString*)generateAnnotationWithActionString:(PTAnnot *)annotation onPageNumber:(unsigned long)pageNumber action:(NSString *)action
{
    
    if (annotation.IsValid) {
        
        __block NSString *uniqueId;
        
        NSError *error;
        [self.pdfViewCtrl DocLockReadWithBlock:^(PTPDFDoc * _Nullable doc) {
            PTObj *uniqueIdObj = [annotation GetUniqueID];
            if ([uniqueIdObj IsValid] && [uniqueIdObj IsString]) {
                uniqueId = [uniqueIdObj GetAsPDFText];
            }
        } error:&error];
        
        if (error) {
            NSLog(@"An error occurred: %@", error);
            return nil;
        }
        
        NSDictionary *annotDict = @{
            PTAnnotationIdKey: uniqueId,
            PTAnnotationPageNumberKey: [NSNumber numberWithLong:pageNumber],
        };
        
        NSDictionary *resultDict = @{
            PTAnnotationListKey: @[annotDict],
            PTActionKey: action,
        };
        
        return [PTPluginUtils PT_idToJSONString:resultDict];
    }
    return nil;
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
@property (nonatomic, strong) FlutterEventSink documentErrorEventSink;
@property (nonatomic, strong) FlutterEventSink annotationChangedEventSink;
@property (nonatomic, strong) FlutterEventSink annotationsSelectedEventSink;
@property (nonatomic, strong) FlutterEventSink formFieldValueChangedEventSink;

@end

@implementation PdftronFlutterPlugin

static NSString * const EVENT_EXPORT_ANNOTATION_COMMAND = @"export_annotation_command_event";
static NSString * const EVENT_EXPORT_BOOKMARK = @"export_bookmark_event";
static NSString * const EVENT_DOCUMENT_LOADED = @"document_loaded_event";
static NSString * const EVENT_DOCUMENT_ERROR = @"document_error_event";
static NSString * const EVENT_ANNOTATION_CHANGED = @"annotation_changed_event";
static NSString * const EVENT_ANNOTATIONS_SELECTED = @"annotations_selected_event";
static NSString * const EVENT_FORM_FIELD_VALUE_CHANGED = @"form_field_value_changed_event";

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"pdftron_flutter"
                                     binaryMessenger:[registrar messenger]];
    

    
    PdftronFlutterPlugin* instance = [[PdftronFlutterPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    
    FlutterEventChannel* xfdfEventChannel = [FlutterEventChannel eventChannelWithName:EVENT_EXPORT_ANNOTATION_COMMAND binaryMessenger:[registrar messenger]];

    FlutterEventChannel* bookmarkEventChannel = [FlutterEventChannel eventChannelWithName:EVENT_EXPORT_BOOKMARK binaryMessenger:[registrar messenger]];

    FlutterEventChannel* documentLoadedEventChannel = [FlutterEventChannel eventChannelWithName:EVENT_DOCUMENT_LOADED binaryMessenger:[registrar messenger]];
    
    FlutterEventChannel* documentErrorEventChannel = [FlutterEventChannel eventChannelWithName:EVENT_DOCUMENT_ERROR binaryMessenger:[registrar messenger]];
    
    FlutterEventChannel* annotationChangedEventChannel = [FlutterEventChannel eventChannelWithName:EVENT_ANNOTATION_CHANGED binaryMessenger:[registrar messenger]];
    
    FlutterEventChannel* annotationsSelectedEventChannel = [FlutterEventChannel eventChannelWithName:EVENT_ANNOTATIONS_SELECTED binaryMessenger:[registrar messenger]];
    
    FlutterEventChannel* formFieldValueChangedEventChannel = [FlutterEventChannel eventChannelWithName:EVENT_FORM_FIELD_VALUE_CHANGED binaryMessenger:[registrar messenger]];

    [xfdfEventChannel setStreamHandler:instance];
    
    [bookmarkEventChannel setStreamHandler:instance];
    
    [documentLoadedEventChannel setStreamHandler:instance];
    
    [documentErrorEventChannel setStreamHandler:instance];
    
    [annotationChangedEventChannel setStreamHandler:instance];
    
    [annotationsSelectedEventChannel setStreamHandler:instance];
    
    [formFieldValueChangedEventChannel setStreamHandler:instance];

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
            
            if ([string isEqualToString:PTAnnotationEditToolKey]) {
                // multi-select not implemented
            }
            else if ([string isEqualToString:PTAnnotationCreateStickyToolKey] ||
                     [string isEqualToString:PTStickyToolButtonKey]) {
                toolManager.textAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:PTAnnotationCreateFreeHandToolKey] ||
                     [string isEqualToString:PTFreeHandToolButtonKey]) {
                toolManager.inkAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:PTTextSelectToolKey]) {
                toolManager.textSelectionEnabled = value;
            }
            else if ([string isEqualToString:PTAnnotationCreateTextHighlightToolKey] ||
                     [string isEqualToString:PTHighlightToolButtonKey]) {
                toolManager.highlightAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:PTAnnotationCreateTextUnderlineToolKey] ||
                     [string isEqualToString:PTUnderlineToolButtonKey]) {
                toolManager.underlineAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:PTAnnotationCreateTextSquigglyToolKey] ||
                     [string isEqualToString:PTSquigglyToolButtonKey]) {
                toolManager.squigglyAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:PTAnnotationCreateTextStrikeoutToolKey] ||
                     [string isEqualToString:PTStrikeoutToolButtonnKey]) {
                toolManager.strikeOutAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:PTAnnotationCreateFreeTextToolKey] ||
                     [string isEqualToString:PTFreeTextToolButtonKey]) {
                toolManager.freeTextAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:PTAnnotationCreateCalloutToolKey] ||
                     [string isEqualToString:PTCalloutToolButtonKey]) {
                toolManager.calloutAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:PTAnnotationCreateSignatureToolKey] ||
                     [string isEqualToString:PTSignatureToolButtonKey]) {
                toolManager.signatureAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:PTAnnotationCreateLineToolKey] ||
                     [string isEqualToString:PTLineToolButtonKey]) {
                toolManager.lineAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:PTAnnotationCreateArrowToolKey] ||
                     [string isEqualToString:PTArrowToolButtonKey]) {
                toolManager.arrowAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:PTAnnotationCreatePolylineToolKey] ||
                     [string isEqualToString:PTPolylineToolButtonKey]) {
                toolManager.polylineAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:PTAnnotationCreateStampToolKey] ||
                     [string isEqualToString:PTStampToolButtonKey]) {
                toolManager.stampAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:PTAnnotationCreateRectangleToolKey] ||
                     [string isEqualToString:PTRectangleToolButtonKey]) {
                toolManager.squareAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:PTAnnotationCreateEllipseToolKey] ||
                     [string isEqualToString:PTEllipseToolButtonKey]) {
                toolManager.circleAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:PTAnnotationCreatePolygonToolKey] ||
                     [string isEqualToString:PTPolygonToolButtonKey]) {
                toolManager.polygonAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:PTAnnotationCreatePolygonCloudToolKey] ||
                     [string isEqualToString:PTCloudToolButtonKey])
            {
                toolManager.cloudyAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:PTAnnotationCreateFreeHighlighterToolKey] ||
                     [string isEqualToString:PTFreeHighlighterToolButtonKey]) {
                toolManager.freehandHighlightAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:PTEraserToolKey] ||
                     [string isEqualToString:PTEraserToolButtonKey]) {
                toolManager.eraserEnabled = value;
            }
        }
    }
}

+ (void)disableElements:(NSArray*)elementsToDisable documentViewController:(PTDocumentViewController *)documentViewController
{
    typedef void (^HideElementBlock)(void);
    
    NSDictionary *hideElementActions = @{
        PTToolsButtonKey:
            ^{
                documentViewController.annotationToolbarButtonHidden = YES;
            },
        PTSearchButtonKey:
            ^{
                documentViewController.searchButtonHidden = YES;
            },
        PTShareButtonKey:
            ^{
                documentViewController.shareButtonHidden = YES;
            },
        PTViewControlsButtonKey:
            ^{
                documentViewController.viewerSettingsButtonHidden = YES;
            },
        PTThumbnailsButtonKey:
            ^{
                documentViewController.thumbnailBrowserButtonHidden = YES;
            },
        PTListsButtonKey:
            ^{
                documentViewController.navigationListsButtonHidden = YES;
            },
        PTReflowModeButtonKey:
            ^{
            documentViewController.readerModeButtonHidden = YES;
            },
        PTThumbnailSliderKey:
            ^{
                documentViewController.thumbnailSliderHidden = YES;
            },
        PTSaveCopyButtonKey:
            ^{
                documentViewController.exportButtonHidden = YES;
            },
    };
    
    for(NSObject* item in elementsToDisable)
    {
        if([item isKindOfClass:[NSString class]])
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
    if(config && ![config isEqualToString:@"null"])
    {
        //convert from json to dict
        NSData* jsonData = [config dataUsingEncoding:NSUTF8StringEncoding];
        id foundationObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:Nil];
        
        NSAssert([foundationObject isKindOfClass:[NSDictionary class]], @"config JSON object not in expected dictionary format.");
        
        if([foundationObject isKindOfClass:[NSDictionary class]])
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
    
    NSAssert([foundationObject isKindOfClass:[NSDictionary class]], @"config JSON object not in expected dictionary format.");
    
    if([foundationObject isKindOfClass:[NSDictionary class]])
    {
        //convert from json to dict
        NSData* jsonData = [config dataUsingEncoding:NSUTF8StringEncoding];
        id foundationObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:Nil];

        NSAssert([foundationObject isKindOfClass:[NSDictionary class]], @"config JSON object not in expected dictionary format.");
        
        if([foundationObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* configPairs = (NSDictionary*)foundationObject;
            
            for (NSString* key in configPairs.allKeys) {
                if([key isEqualToString:PTDisabledToolsKey])
                {
                    id toolsToDisable = configPairs[PTDisabledToolsKey];
                    if(![toolsToDisable isEqual:[NSNull null]])
                    {
                        NSAssert([toolsToDisable isKindOfClass:[NSArray class]], @"disabledTools JSON object not in expected array format.");
                        if([toolsToDisable isKindOfClass:[NSArray class]])
                        {
                            [self disableTools:(NSArray*)toolsToDisable documentViewController:documentViewController];
                        }
                        else
                        {
                            NSLog(@"disabledTools JSON object not in expected array format.");
                        }
                    }
                }
                else if([key isEqualToString:PTDisabledElementsKey])
                {
                    id elementsToDisable = configPairs[PTDisabledElementsKey];
                    
                    if(![elementsToDisable isEqual:[NSNull null]])
                    {
                        NSAssert([elementsToDisable isKindOfClass:[NSArray class]], @"disabledTools JSON object not in expected array format.");
                        if([elementsToDisable isKindOfClass:[NSArray class]])
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
                    NSAssert(false, @"Unknown JSON key in config.");
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
    id documentValue = arguments[PTDocumentArgumentKey];
    if ([documentValue isKindOfClass:[NSString class]]) {
        document = (NSString *)documentValue;
    }
    
    if (document.length == 0) {
        // error handling
        return;
    }
    
    // Get (optional) password argument.
    NSString *password = nil;
    id passwordValue = arguments[PTPasswordArgumentKey];
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
    
    NSString* config = arguments[PTConfigArgumentKey];
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

- (PTDocumentViewController *)getDocumentViewController {
    PTDocumentViewController* docVC = self.tabbedDocumentViewController.selectedViewController;
    
    if(docVC == Nil && self.tabbedDocumentViewController.childViewControllers.count == 1)
    {
        docVC = self.tabbedDocumentViewController.childViewControllers.lastObject;
    }
    return docVC;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([call.method isEqualToString:PTGetPlatformVersionKey]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if ([call.method isEqualToString:PTGetVersionKey]) {
        result([@"PDFNet " stringByAppendingFormat:@"%f", [PTPDFNet GetVersion]]);
    } else if ([call.method isEqualToString:PTInitializeKey]) {
        NSString *licenseKey = [PTPluginUtils PT_idAsNSString:call.arguments[PTLicenseArgumentKey]];
        [PTPDFNet Initialize:licenseKey];
    } else if ([call.method isEqualToString:PTOpenDocumentKey]) {
        [self handleOpenDocumentMethod:call.arguments resultToken:result];
    } else {
        [PTPluginUtils handleMethodCall:call result:result documentViewController:[self getDocumentViewController]];
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

-(void)docVCBookmarkChange:(NSString*)bookmarkJson
{
    if(self.bookmarkEventSink != nil)
    {
        self.bookmarkEventSink(bookmarkJson);
    }
}

-(void)docVCExportAnnotationCommand:(NSString*)xfdfCommand
{
    if(self.xfdfEventSink != nil)
    {
        self.xfdfEventSink(xfdfCommand);
    }
}

-(void)docVCDocumentLoaded:(NSString*)filePath
{
    if(self.documentLoadedEventSink != nil)
    {
        self.documentLoadedEventSink(filePath);
    }
}

-(void)docVCDocumentError
{
    if(self.documentErrorEventSink != nil)
    {
        self.documentErrorEventSink(nil);
    }
}

-(void)docVCAnnotationChanged:(NSString*)annotationsWithActionString
{
    if(self.annotationChangedEventSink != nil)
    {
        self.annotationChangedEventSink(annotationsWithActionString);
    }
}

-(void)docVCAnnotationsSelected:(NSString*)annotationsString
{
    if(self.annotationsSelectedEventSink != nil)
    {
        self.annotationsSelectedEventSink(annotationsString);
    }
}

-(void)docVCFormFieldValueChanged:(NSString*)fieldsString
{
    if(self.formFieldValueChangedEventSink != nil)
    {
        self.formFieldValueChangedEventSink(fieldsString);
    }
}


- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(FlutterEventSink)events
{
    if([arguments intValue] == exportAnnotationId)
    {
        self.xfdfEventSink = events;
    }
    else if([arguments intValue] == exportBookmarkId)
    {
        self.bookmarkEventSink = events;
    }
    else if([arguments intValue] == documentLoadedId)
    {
        self.documentLoadedEventSink = events;
    }
    else if([arguments intValue] == documentErrorId)
    {
        self.documentErrorEventSink = events;
    }
    else if([arguments intValue] == annotationChangedId)
    {
        self.annotationChangedEventSink = events;
    }
    else if([arguments intValue] == annotationsSelectedId)
    {
        self.annotationsSelectedEventSink = events;
    }
    else if([arguments intValue] == formFieldValueChangedId)
    {
        self.formFieldValueChangedEventSink = events;
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
    
    [self docVCDocumentError];
}

@end
