#import "PdftronFlutterPlugin.h"
#import "PTFlutterViewController.h"
#import "DocumentViewFactory.h"

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

#pragma mark - Initialization

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar
{
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"pdftron_flutter"
                                     binaryMessenger:[registrar messenger]];
    

    
    PdftronFlutterPlugin* instance = [[PdftronFlutterPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    
    [instance registerEventChannels:[registrar messenger]];
    [instance overrideControllerClasses];
    
    DocumentViewFactory* documentViewFactory =
    [[DocumentViewFactory alloc] initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:documentViewFactory withId:@"pdftron_flutter/documentview"];
}

+ (PdftronFlutterPlugin *)registerWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId messenger:(NSObject<FlutterBinaryMessenger> *)messenger
{
    NSString* channelName = [NSString stringWithFormat:@"pdftron_flutter/documentview_%lld", viewId];
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
    
    PdftronFlutterPlugin* instance = [[PdftronFlutterPlugin alloc] init];
    
    __weak __typeof__(instance) weakInstance = instance;
    [channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        __strong __typeof__(weakInstance) instance = weakInstance;
        if (instance) {
            [instance handleMethodCall:call result:result];
        }
    }];
    
    [instance registerEventChannels:messenger];
    [instance overrideControllerClasses];
    return instance;
}

- (void)overrideControllerClasses
{
    [PTOverrides overrideClass:[PTDocumentViewController class] withClass:[PTFlutterViewController class]];
    
    [PTOverrides overrideClass:[PTThumbnailsViewController class] withClass:[FLThumbnailsViewController class]];
}

- (void)registerEventChannels:(NSObject<FlutterBinaryMessenger> *)messenger
{
    FlutterEventChannel* xfdfEventChannel = [FlutterEventChannel eventChannelWithName:EVENT_EXPORT_ANNOTATION_COMMAND binaryMessenger:messenger];

    FlutterEventChannel* bookmarkEventChannel = [FlutterEventChannel eventChannelWithName:EVENT_EXPORT_BOOKMARK binaryMessenger:messenger];

    FlutterEventChannel* documentLoadedEventChannel = [FlutterEventChannel eventChannelWithName:EVENT_DOCUMENT_LOADED binaryMessenger:messenger];
    
    FlutterEventChannel* documentErrorEventChannel = [FlutterEventChannel eventChannelWithName:EVENT_DOCUMENT_ERROR binaryMessenger:messenger];
    
    FlutterEventChannel* annotationChangedEventChannel = [FlutterEventChannel eventChannelWithName:EVENT_ANNOTATION_CHANGED binaryMessenger:messenger];
    
    FlutterEventChannel* annotationsSelectedEventChannel = [FlutterEventChannel eventChannelWithName:EVENT_ANNOTATIONS_SELECTED binaryMessenger:messenger];
    
    FlutterEventChannel* formFieldValueChangedEventChannel = [FlutterEventChannel eventChannelWithName:EVENT_FORM_FIELD_VALUE_CHANGED binaryMessenger:messenger];

    [xfdfEventChannel setStreamHandler:self];
    
    [bookmarkEventChannel setStreamHandler:self];
    
    [documentLoadedEventChannel setStreamHandler:self];
    
    [documentErrorEventChannel setStreamHandler:self];
    
    [annotationChangedEventChannel setStreamHandler:self];
    
    [annotationsSelectedEventChannel setStreamHandler:self];
    
    [formFieldValueChangedEventChannel setStreamHandler:self];
}

#pragma mark - Configurations

+ (void)configureTabbedDocumentViewController:(PTTabbedDocumentViewController*)tabbedDocumentViewController withConfig:(NSString*)config
{
    if(config && ![config isEqualToString:@"null"])
    {
        //convert from json to dict
        id foundationObject = [PdftronFlutterPlugin PT_JSONStringToId:config];
        
        if([foundationObject isKindOfClass:[NSNull class]]) {
            return;
        }
        
        NSDictionary* configPairs = [PdftronFlutterPlugin PT_idAsNSDict:foundationObject];
        
        if(configPairs)
        {
            for (NSString* key in configPairs.allKeys) {
                if ([key isEqualToString:PTMultiTabEnabledKey]) {
                    NSError* error;
                    NSNumber* multiTabValue = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTMultiTabEnabledKey class:[NSNumber class] error:&error];
                    
                    if (error) {
                        NSLog(@"An error occurs with config %@: %@", PTMultiTabEnabledKey, error.localizedDescription);
                        continue;
                    } else if (multiTabValue) {
                        tabbedDocumentViewController.tabsEnabled = [multiTabValue boolValue];
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
    
    PTFlutterViewController* flutterViewController = (PTFlutterViewController*)documentViewController;
    
    [flutterViewController initViewerSettings];
    
    //convert from json to dict
    id foundationObject = [PdftronFlutterPlugin PT_JSONStringToId:config];
    
    if (![foundationObject isKindOfClass:[NSNull class]]) {
        
        NSDictionary* configPairs = [PdftronFlutterPlugin PT_idAsNSDict:foundationObject];
        
        if(configPairs)
        {
            
            NSError* error;
            
            for (NSString* key in configPairs.allKeys) {
                if([key isEqualToString:PTDisabledToolsKey])
                {
                    
                    NSArray* toolsToDisable = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTDisabledToolsKey class:[NSArray class] error:&error];
                    
                    if (!error && toolsToDisable) {
                        [self disableTools:toolsToDisable documentViewController:documentViewController];
                    }
                }
                else if([key isEqualToString:PTDisabledElementsKey])
                {
                    
                    NSArray* elementsToDisable = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTDisabledElementsKey class:[NSArray class] error:&error];
                    
                    if (!error && elementsToDisable) {
                        [self disableElements:(NSArray*)elementsToDisable documentViewController:documentViewController];
                    }
                }
                else if ([key isEqualToString:PTCustomHeadersKey]) {
                    
                    NSDictionary* customHeaders = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTCustomHeadersKey class:[NSDictionary class] error:&error];
                    
                    if (!error && customHeaders) {
                        documentViewController.additionalHTTPHeaders = customHeaders;
                    }
                }
                else if ([key isEqualToString:PTMultiTabEnabledKey]) {
                    // Handled by tabbed config.
                }
                else if ([key isEqualToString:PTShowLeadingNavButtonKey]) {
                    
                    NSNumber* showLeadingNavButtonNumber = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTShowLeadingNavButtonKey class:[NSNumber class] error:&error];
                    
                    if (!error && showLeadingNavButtonNumber) {
                        [flutterViewController setShowNavButton:[showLeadingNavButtonNumber boolValue]];
                    }
                }
                else if ([key isEqualToString:PTLeadingNavButtonIconKey]) {
                    
                    NSString* navIcon = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTLeadingNavButtonIconKey class:[NSString class] error:&error];
                    
                    if (!error && navIcon) {
                        [flutterViewController setNavButtonPath:navIcon];
                    }
                }
                else if ([key isEqualToString:PTReadOnlyKey]) {
                    
                    NSNumber* readOnlyNumber = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTReadOnlyKey class:[NSNumber class] error:&error];
                    
                    if (!error && readOnlyNumber) {
                        [flutterViewController setReadOnly:[readOnlyNumber boolValue]];
                    }
                }
                else if ([key isEqualToString:PTThumbnailViewEditingEnabledKey]) {
                    
                    NSNumber* thumbnailViewEditingEnabledNumber = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTThumbnailViewEditingEnabledKey class:[NSNumber class] error:&error];
                    
                    if (!error && thumbnailViewEditingEnabledNumber) {
                        [flutterViewController setThumbnailEditingEnabled:[thumbnailViewEditingEnabledNumber boolValue]];
                    }
                }
                else if ([key isEqualToString:PTAnnotationAuthorKey]) {
                    
                    NSString* annotationAuthor = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTAnnotationAuthorKey class:[NSString class] error:&error];
                    
                    if (!error && annotationAuthor) {
                        [flutterViewController setAnnotationAuthor:annotationAuthor];
                    }
                }
                else if ([key isEqualToString:PTContinuousAnnotationEditingKey]) {
                    
                    NSNumber* contEditingNumber = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTContinuousAnnotationEditingKey class:[NSNumber class] error:&error];
                    
                    if (!error && contEditingNumber) {
                        [flutterViewController setContinuousAnnotationEditing:[contEditingNumber boolValue]];
                    }
                }
                else
                {
                    NSLog(@"Unknown JSON key in config: %@.", key);
                }
                
                if (error) {
                    NSLog(@"An error occurs with config %@: %@", key, error.localizedDescription);
                }
            }
        }
        else
        {
            NSLog(@"config JSON object not in expected dictionary format.");
        }
        
        
    }
    
    [flutterViewController applyViewerSettings];
}

+ (id)getConfigValue:(NSDictionary*)configDict configKey:(NSString*)configKey class:(Class)class error:(NSError**)error
{
    id configResult = configDict[configKey];

    if (![configResult isKindOfClass:[NSNull class]]) {
        if (![configResult isKindOfClass:class]) {
            NSString* errorString = [NSString stringWithFormat:@"config %@ is not in expected %@ format.", configKey, class];
            *error = [NSError errorWithDomain:@"com.flutter.pdftron" code:NSFormattingError userInfo:@{NSLocalizedDescriptionKey: errorString}];
        }
        return configResult;
    }
    return nil;
}

- (void)topLeftButtonPressed:(UIBarButtonItem *)barButtonItem
{
    if (self.tabbedDocumentViewController) {
        [self.tabbedDocumentViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [UIApplication.sharedApplication.keyWindow.rootViewController.presentedViewController dismissViewControllerAnimated:YES completion:Nil];
    }
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

#pragma mark - PTTabbedDocumentViewControllerDelegate

- (void)tabbedDocumentViewController:(PTTabbedDocumentViewController *)tabbedDocumentViewController willAddDocumentViewController:(PTDocumentViewController *)documentViewController
{
    documentViewController.delegate = self;
    
    [[self class] configureDocumentViewController:documentViewController
                                       withConfig:self.config];
}



#pragma mark - PTDocumentViewControllerDelegate

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
    [self documentViewController:documentViewController documentError:nil];
    result([@"Opened Document Failed: %@" stringByAppendingString:error.description]);
}

#pragma mark - FlutterStreamHandler

- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(FlutterEventSink)events
{
    
    int sinkId = [arguments intValue];
    
    switch (sinkId)
    {
        case exportAnnotationId:
            self.xfdfEventSink = events;
            break;
        case exportBookmarkId:
            self.bookmarkEventSink = events;
            break;
        case documentLoadedId:
            self.documentLoadedEventSink = events;
            break;
        case documentErrorId:
            self.documentErrorEventSink = events;
            break;
        case annotationChangedId:
            self.annotationChangedEventSink = events;
            break;
        case annotationsSelectedId:
            self.annotationsSelectedEventSink = events;
            break;
        case formFieldValueChangedId:
            self.formFieldValueChangedEventSink = events;
            break;
    }
    
    return Nil;
}

- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments
{
    int sinkId = [arguments intValue];
    
    switch (sinkId)
    {
        case exportAnnotationId:
            self.xfdfEventSink = nil;
            break;
        case exportBookmarkId:
            self.bookmarkEventSink = nil;
            break;
        case documentLoadedId:
            self.documentLoadedEventSink = nil;
            break;
        case documentErrorId:
            self.documentErrorEventSink = nil;
            break;
        case annotationChangedId:
            self.annotationChangedEventSink = nil;
            break;
        case annotationsSelectedId:
            self.annotationsSelectedEventSink = nil;
            break;
        case formFieldValueChangedId:
            self.formFieldValueChangedEventSink = nil;
            break;
    }
    
    return Nil;
}

#pragma mark - FlutterPlatformView

-(UIView*)view
{
    return self.tabbedDocumentViewController.navigationController.view;
}

#pragma mark - EventSinks

-(void)documentViewController:(PTDocumentViewController*)docVC bookmarksDidChange:(NSString*)bookmarkJson
{
    if(self.bookmarkEventSink != nil)
    {
        self.bookmarkEventSink(bookmarkJson);
    }
}

-(void)documentViewController:(PTDocumentViewController*)docVC annotationsAsXFDFCommand:(NSString*)xfdfCommand
{
    if(self.xfdfEventSink != nil)
    {
        self.xfdfEventSink(xfdfCommand);
    }
}

-(void)documentViewController:(PTDocumentViewController*)docVC documentLoadedFromFilePath:(NSString*)filePath
{
    if(self.documentLoadedEventSink != nil)
    {
        self.documentLoadedEventSink(filePath);
    }
}

-(void)documentViewController:(PTDocumentViewController*)docVC documentError:(nullable NSError*)error
{
    if(self.documentErrorEventSink != nil)
    {
        self.documentErrorEventSink(nil);
    }
}

-(void)documentViewController:(PTDocumentViewController*)docVC annotationsChangedWithActionString:(NSString*)annotationsWithActionString
{
    if(self.annotationChangedEventSink != nil)
    {
        self.annotationChangedEventSink(annotationsWithActionString);
    }
}

-(void)documentViewController:(PTDocumentViewController*)docVC annotationsSelected:(NSString*)annotationsString
{
    if(self.annotationsSelectedEventSink != nil)
    {
        self.annotationsSelectedEventSink(annotationsString);
    }
}

-(void)documentViewController:(PTDocumentViewController*)docVC formFieldValueChanged:(NSString*)fieldsString
{
    if(self.formFieldValueChangedEventSink != nil)
    {
        self.formFieldValueChangedEventSink(fieldsString);
    }
}

#pragma mark - Functions

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([call.method isEqualToString:PTGetPlatformVersionKey]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if ([call.method isEqualToString:PTGetVersionKey]) {
        result([@"PDFNet " stringByAppendingFormat:@"%f", [PTPDFNet GetVersion]]);
    } else if ([call.method isEqualToString:PTInitializeKey]) {
        NSString *licenseKey = [PdftronFlutterPlugin PT_idAsNSString:call.arguments[PTLicenseArgumentKey]];
        [PTPDFNet Initialize:licenseKey];
    } else if ([call.method isEqualToString:PTOpenDocumentKey]) {
        [self handleOpenDocumentMethod:call.arguments resultToken:result];
    } else if ([call.method isEqualToString:PTImportAnnotationsKey]) {
        NSString *xfdf = [PdftronFlutterPlugin PT_idAsNSString:call.arguments[PTXfdfArgumentKey]];;
        [self importAnnotations:xfdf resultToken:result];
    } else if ([call.method isEqualToString:PTExportAnnotationsKey]) {
        NSString *annotationList = [PdftronFlutterPlugin PT_idAsNSString:call.arguments[PTAnnotationListArgumentKey]];;
        [self exportAnnotations:annotationList resultToken:result];
    } else if ([call.method isEqualToString:PTFlattenAnnotationsKey]) {
        bool formsOnly = [PdftronFlutterPlugin PT_idAsBool:call.arguments[PTFormsOnlyArgumentKey]];;
        [self flattenAnnotations:formsOnly resultToken:result];
    } else if ([call.method isEqualToString:PTDeleteAnnotationsKey]) {
        NSString *annotationList = [PdftronFlutterPlugin PT_idAsNSString:call.arguments[PTAnnotationListArgumentKey]];;
        [self deleteAnnotations:annotationList resultToken:result];
    } else if ([call.method isEqualToString:PTSelectAnnotationKey]) {
        NSString *annotation = [PdftronFlutterPlugin PT_idAsNSString:call.arguments[PTAnnotationArgumentKey]];
        [self selectAnnotation:annotation resultToken:result];
    } else if ([call.method isEqualToString:PTSetFlagsForAnnotationsKey]) {
        NSString *annotationsWithFlags = [PdftronFlutterPlugin PT_idAsNSString:call.arguments[PTAnnotationsWithFlagsArgumentKey]];
        [self setFlagsForAnnotations:annotationsWithFlags resultToken:result];
    } else if ([call.method isEqualToString:PTImportAnnotationCommandKey]) {
        NSString *xfdfCommand = [PdftronFlutterPlugin PT_idAsNSString:call.arguments[PTXfdfCommandArgumentKey]];
        [self importAnnotationCommand:xfdfCommand];
    } else if ([call.method isEqualToString:PTImportBookmarksKey]) {
        NSString *bookmarkJson = [PdftronFlutterPlugin PT_idAsNSString:call.arguments[PTBookmarkJsonArgumentKey]];
        [self importBookmarks:bookmarkJson];
    } else if ([call.method isEqualToString:PTSaveDocumentKey]) {
        [self saveDocument:result];
    } else if ([call.method isEqualToString:PTCommitToolKey]) {
        [self commitTool:result];
    } else if ([call.method isEqualToString:PTGetPageCountKey]) {
        [self getPageCount:result];
    } else if ([call.method isEqualToString:PTGetPageCropBoxKey]) {
        NSNumber *pageNumber = [PdftronFlutterPlugin PT_idAsNSNumber:call.arguments[PTPageNumberArgumentKey]];
        [self getPageCropBox:pageNumber resultToken:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

+ (PTAnnot *)findAnnotWithUniqueID:(NSString *)uniqueID onPageNumber:(int)pageNumber documentViewController:(PTDocumentViewController *)docVC error:(NSError **)error
{
    if (uniqueID.length == 0 || pageNumber < 1) {
        return nil;
    }
    PTPDFViewCtrl *pdfViewCtrl = docVC.pdfViewCtrl;
    __block PTAnnot *resultAnnot;

    [docVC.pdfViewCtrl DocLockReadWithBlock:^(PTPDFDoc * _Nullable doc) {
        NSArray<PTAnnot *> *annots = [pdfViewCtrl GetAnnotationsOnPage:pageNumber];
        for (PTAnnot *annot in annots) {
            if (![annot IsValid]) {
                continue;
            }
            
            // Check if the annot's unique ID matches.
            NSString *annotUniqueId = nil;
            PTObj *annotUniqueIdObj = [annot GetUniqueID];
            if ([annotUniqueIdObj IsValid]) {
                annotUniqueId = [annotUniqueIdObj GetAsPDFText];
            }
            if (annotUniqueId && [annotUniqueId isEqualToString:uniqueID]) {
                resultAnnot = annot;
                break;
            }
        }
    } error:error];
   
    if(*error)
    {
        NSLog(@"Error: There was an error while trying to find annotation with id and page number. %@", (*error).localizedDescription);
    }
    
    return resultAnnot;
}

+(NSArray<PTAnnot *> *)getAnnotationsOnPage:(int)pageNumber documentViewController:(PTDocumentViewController *)docVC
{
    __block NSArray<PTAnnot *> *annots;
    NSError* error;
    [docVC.pdfViewCtrl DocLockReadWithBlock:^(PTPDFDoc * _Nullable doc) {
        annots = [docVC.pdfViewCtrl GetAnnotationsOnPage:pageNumber];
    } error:&error];
    
    if (error) {
        NSLog(@"Error: There was an error while trying to find annotations in page number. %@", error.localizedDescription);
    }
    
    return annots;
}

+(NSArray<PTAnnot *> *)findAnnotsWithUniqueIDs:(NSArray <NSDictionary *>*)idPageNumberPairs documentViewController:(PTDocumentViewController *)docVC error:(NSError **)error
{
    NSMutableArray<PTAnnot *> *resultAnnots = [[NSMutableArray alloc] init];
    
    NSMutableDictionary <NSNumber *, NSMutableArray <NSString *> *> *pageNumberAnnotDict = [[NSMutableDictionary alloc] init];
    
    // put all annotations in a dict indexed by page number
    for (NSDictionary *idPageNumberPair in idPageNumberPairs) {
        NSNumber *pageNumber = [PdftronFlutterPlugin PT_idAsNSNumber:idPageNumberPair[PTAnnotPageNumberKey]];
        NSString *annotId = [PdftronFlutterPlugin PT_idAsNSString:idPageNumberPair[PTAnnotIdKey]];
        NSMutableArray <NSString *> *annotArray;
        if (!pageNumberAnnotDict[pageNumber]) {
            annotArray = [[NSMutableArray alloc] init];

        } else {
            annotArray = pageNumberAnnotDict[pageNumber];
        }
        
        [annotArray addObject:annotId];
        pageNumberAnnotDict[pageNumber] = annotArray;
    }
    
    // loop through page numbers
    for (NSNumber *pageNumber in [pageNumberAnnotDict allKeys]) {
        
        __block NSArray<PTAnnot *> * annotsOnCurrPage;
        
        [docVC.pdfViewCtrl DocLockReadWithBlock:^(PTPDFDoc * _Nullable doc) {
            annotsOnCurrPage = [PdftronFlutterPlugin getAnnotationsOnPage:[pageNumber intValue] documentViewController:docVC];
        } error:error];
        
        if (*error) {
            NSLog(@"Error: There was an error while trying to get annotations on page for doc. %@", (*error).localizedDescription);
            return nil;
        }
            
        for (PTAnnot *annotFromDoc in annotsOnCurrPage) {
            if (![annotFromDoc IsValid]) {
                continue;
            }
            
            NSString *annotUniqueId = nil;
            PTObj *annotUniqueIdObj = [annotFromDoc GetUniqueID];
            if ([annotUniqueIdObj IsValid]) {
                annotUniqueId = [annotUniqueIdObj GetAsPDFText];
            }
            if (annotUniqueId) {
                
                for (NSString *annotIdFromDict in pageNumberAnnotDict[pageNumber]) {
                    if ([annotIdFromDict isEqualToString:annotUniqueId]) {
                        [resultAnnots addObject:annotFromDoc];
                        break;
                    }
                }
            }
        }
    }
    
    return [resultAnnots copy];
}

- (void)handleOpenDocumentMethod:(NSDictionary<NSString *, id> *)arguments resultToken:(FlutterResult)result
{
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

- (void)importAnnotations:(NSString *)xfdf resultToken:(FlutterResult)flutterResult
{
    PTDocumentViewController *docVC = [self getDocumentViewController];
    if(docVC.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        
        flutterResult([FlutterError errorWithCode:@"import_annotations" message:@"Failed to import annotations" details:@"Error: The document view controller has no document."]);
        return;
    }
    
    NSError* error;
    
    [docVC.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        if([doc HasDownloader])
        {
            // too soon
            NSLog(@"Error: The document is still being downloaded.");
            flutterResult([FlutterError errorWithCode:@"import_annotations" message:@"Failed to import annotations" details:@"Error: The document is still being downloaded."]);
            return;
        }
        
        PTFDFDoc *fdfDoc = [PTFDFDoc CreateFromXFDF:xfdf];
        
        [doc FDFUpdate:fdfDoc];
        [docVC.pdfViewCtrl Update:YES];
        
    } error:&error];
    
    if(error)
    {
        NSLog(@"Error: There was an error while trying to import annotations. %@", error.localizedDescription);
        flutterResult([FlutterError errorWithCode:@"import_annotations" message:@"Failed to import annotations" details:@"Error: There was an error while trying to import annotations."]);
    } else {
        flutterResult(nil);
    }
}

- (void)exportAnnotations:(NSString *)annotationList resultToken:(FlutterResult)flutterResult
{
    PTDocumentViewController *docVC = [self getDocumentViewController];
    if(docVC.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        
        flutterResult([FlutterError errorWithCode:@"export_annotations" message:@"Failed to export annotations" details:@"Error: The document view controller has no document."]);
        return;
    }
    
    NSError *error;
    
    if (!annotationList) {
        [docVC.pdfViewCtrl DocLockReadWithBlock:^(PTPDFDoc * _Nullable doc) {
            PTFDFDoc *fdfDoc = [doc FDFExtract:e_ptboth];
            flutterResult([fdfDoc SaveAsXFDFToString]);
        }error:&error];
        
        if (error) {
            NSLog(@"Error: Failed to extract fdf from doc. %@", error.localizedDescription);
            flutterResult([FlutterError errorWithCode:@"export_annotations" message:@"Failed to export annotations" details:@"Failed to extract fdf from doc."]);
        }
        return;
    }
    
    NSArray *annotArray = [PdftronFlutterPlugin PT_idAsArray:[PdftronFlutterPlugin PT_JSONStringToId:annotationList]];
    
    NSArray <PTAnnot *> *matchingAnnots = [PdftronFlutterPlugin findAnnotsWithUniqueIDs:annotArray documentViewController:docVC error:&error];
    
    if (error) {
        NSLog(@"Error: Failed to get annotations from doc. %@", error.localizedDescription);
        
        flutterResult([FlutterError errorWithCode:@"export_annotations" message:@"Failed to export annotations" details:@"Error: Failed to get annotations from doc."]);
        return;
    }
    
    if (matchingAnnots.count == 0) {
        flutterResult(@"");
    }
    
    PTVectorAnnot *resultAnnots = [[PTVectorAnnot alloc] init];
    for (PTAnnot *annot in matchingAnnots) {
        [resultAnnots add:annot];
    }
    
    __block NSString *resultString;
    [docVC.pdfViewCtrl DocLockReadWithBlock:^(PTPDFDoc * _Nullable doc) {
        
        PTFDFDoc *fdfDoc = [doc FDFExtractAnnots:resultAnnots];
        resultString = [fdfDoc SaveAsXFDFToString];
        
    } error:&error];
    
    if(error)
    {
        NSLog(@"Error: Failed to extract fdf from doc. %@", error.localizedDescription);
        flutterResult([FlutterError errorWithCode:@"export_annotations" message:@"Failed to export annotations" details:@"Error: Failed to extract fdf from doc."]);
    } else {
        flutterResult(resultString);
    }
}


- (void)flattenAnnotations:(bool)formsOnly resultToken:(FlutterResult)flutterResult
{
    PTDocumentViewController *docVC = [self getDocumentViewController];
    [docVC.toolManager changeTool:[PTPanTool class]];
    
    if(docVC.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        
        flutterResult([FlutterError errorWithCode:@"flatten_annotations" message:@"Failed to flatten annotations" details:@"Error: The document view controller has no document."]);
        return;
    }
    
    NSError *error;
    
    [docVC.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        [doc FlattenAnnotations:formsOnly];
    } error:&error];
    
    if(error)
    {
        NSLog(@"Error: Failed to flatten annotations from doc. %@", error.localizedDescription);
        flutterResult([FlutterError errorWithCode:@"flatten_annotations" message:@"Failed to flatten annotations" details:@"Error: Failed to flatten annotations from doc."]);
    } else {
        flutterResult(nil);
    }
}

- (void)deleteAnnotations:(NSString *)annotationList resultToken:(FlutterResult)flutterResult
{
    PTDocumentViewController *docVC = [self getDocumentViewController];
    if(docVC.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");

        flutterResult([FlutterError errorWithCode:@"delete_annotations" message:@"Failed to delete annotations" details:@"Error: The document view controller has no document."]);
        return;
    }
    
    NSError* error;
    
    NSArray *annotArray = [PdftronFlutterPlugin PT_idAsArray:[PdftronFlutterPlugin PT_JSONStringToId:annotationList]];
    
    NSArray* matchingAnnots = [PdftronFlutterPlugin findAnnotsWithUniqueIDs:annotArray documentViewController:docVC error:&error];
    
    if (error) {
        NSLog(@"Error: Failed to get annotations from doc. %@", error.localizedDescription);
        
        flutterResult([FlutterError errorWithCode:@"delete_annotations" message:@"Failed to delete annotations" details:@"Error: Failed to get annotations from doc."]);
        return;
    }
    
    [docVC.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        for (PTAnnot *annot in matchingAnnots) {
            PTPage *page = [annot GetPage];
            if (page && [page IsValid]) {
                int pageNumber = [page GetIndex];
                [docVC.toolManager willRemoveAnnotation:annot onPageNumber:pageNumber];
                
                [page AnnotRemoveWithAnnot:annot];
                [docVC.toolManager annotationRemoved:annot onPageNumber:pageNumber];
            }
        }
        [docVC.pdfViewCtrl Update:YES];
    } error:&error];
        
    if (error) {
        NSLog(@"Error: Failed to delete annotations from doc. %@", error.localizedDescription);
            
        flutterResult([FlutterError errorWithCode:@"delete_annotations" message:@"Failed to delete annotations" details:@"Error: Failed to delete annotations from doc."]);
        return;
    }
    
    [docVC.toolManager changeTool:[PTPanTool class]];
    
    flutterResult(nil);
}

- (void)selectAnnotation:(NSString *)annotation resultToken:(FlutterResult)flutterResult
{
    PTDocumentViewController *docVC = [self getDocumentViewController];
    if(docVC.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        
        flutterResult([FlutterError errorWithCode:@"select_annotations" message:@"Failed to select annotations" details:@"Error: The document view controller has no document."]);
        return;
    }
    
    
    NSDictionary *annotationJson = [PdftronFlutterPlugin PT_idAsNSDict:[PdftronFlutterPlugin PT_JSONStringToId:annotation]];
    
    NSString *annotId = [PdftronFlutterPlugin PT_idAsNSString:annotationJson[PTAnnotIdKey]];
    int pageNumber = [[PdftronFlutterPlugin PT_idAsNSNumber:annotationJson[PTAnnotPageNumberKey]] intValue];
    
    NSError* error;
    
    PTAnnot *annot = [PdftronFlutterPlugin findAnnotWithUniqueID:annotId onPageNumber:pageNumber documentViewController:docVC error:&error];
    
    if (error) {
        NSLog(@"Error: Failed to find annotation with unique id. %@", error.localizedDescription);
        
        flutterResult([FlutterError errorWithCode:@"select_annotations" message:@"Failed to select annotations" details:@"Error: Failed to find annotation with unique id."]);
        return;
    }
    
    [docVC.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        [docVC.toolManager selectAnnotation:annot onPageNumber:pageNumber];
    } error:&error];
    
    if(error) {
        NSLog(@"Error: Failed to select annotation from doc. %@", error.localizedDescription);
        flutterResult([FlutterError errorWithCode:@"select_annotations" message:@"Failed to select annotations" details:@"Error: Failed to select annotation from doc."]);
    } else {
        flutterResult(nil);
    }
}

- (void)setFlagsForAnnotations:(NSString *)annotationsWithFlags resultToken:(FlutterResult)flutterResult
{
    PTDocumentViewController *docVC = [self getDocumentViewController];
    if(docVC.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        flutterResult([FlutterError errorWithCode:@"set_flag_for_annotations" message:@"Failed to set flag for annotations" details:@"Error: The document view controller has no document."]);
        return;
    }
    
    NSError* error;
    
    NSArray *annotationWithFlagsArray = [PdftronFlutterPlugin PT_idAsArray:[PdftronFlutterPlugin PT_JSONStringToId:annotationsWithFlags]];
        
    for (NSDictionary *currentAnnotationWithFlags in annotationWithFlagsArray)
    {
        NSDictionary *currentAnnotationDict = [PdftronFlutterPlugin PT_idAsNSDict:[PdftronFlutterPlugin PT_JSONStringToId:currentAnnotationWithFlags[PTAnnotationArgumentKey]]];
            
        NSString *currentAnnotationId = [PdftronFlutterPlugin PT_idAsNSString:currentAnnotationDict[PTAnnotIdKey]];
        int currentPageNumber = [[PdftronFlutterPlugin PT_idAsNSNumber:currentAnnotationDict[PTAnnotPageNumberKey]] intValue];
            
        PTAnnot *currentAnnot = [PdftronFlutterPlugin findAnnotWithUniqueID:currentAnnotationId onPageNumber:currentPageNumber documentViewController:docVC error:&error];
        
        if (error) {
            NSLog(@"Error: Failed to find annotation with unique id. %@", error.localizedDescription);
            continue;
        }
            
        NSArray *flagList = [PdftronFlutterPlugin PT_idAsArray:[PdftronFlutterPlugin PT_JSONStringToId:currentAnnotationWithFlags[PTFlagListKey]]];
            
        for (NSDictionary *currentFlagDict in flagList)
        {
            NSString *currentFlag = [PdftronFlutterPlugin PT_idAsNSString:currentFlagDict[PTFlagKey]];
            bool currentFlagValue = [PdftronFlutterPlugin PT_idAsBool:currentFlagDict[PTFlagValueKey]];
                
            int flagNumber = -1;
            if ([currentFlag isEqualToString:PTAnnotationFlagPrintKey]) {
                flagNumber = e_ptprint_annot;
            } else if ([currentFlag isEqualToString:PTAnnotationFlagHiddenKey]) {
                flagNumber = e_pthidden;
            } else if ([currentFlag isEqualToString:PTAnnotationFlagLockedKey]) {
                flagNumber = e_ptlocked;
            } else if ([currentFlag isEqualToString:PTAnnotationFlagLockedContentsKey]) {
                flagNumber = e_ptlocked_contents;
            } else if ([currentFlag isEqualToString:PTAnnotationFlagInvisibleKey]) {
                flagNumber = e_ptinvisible;
            } else if ([currentFlag isEqualToString:PTAnnotationFlagNoViewKey]) {
                flagNumber = e_ptno_view;
            } else if ([currentFlag isEqualToString:PTAnnotationFlagNoZoomKey]) {
                flagNumber = e_ptno_zoom;
            } else if ([currentFlag isEqualToString:PTAnnotationFlagNoRotateKey]) {
                flagNumber = e_ptno_rotate;
            } else if ([currentFlag isEqualToString:PTAnnotationFlagReadOnlyKey]) {
                flagNumber = e_ptread_only;
            } else if ([currentFlag isEqualToString:PTAnnotationFlagToggleNoViewKey]) {
                flagNumber = e_pttoggle_no_view;
            }
                
            if (flagNumber != -1) {
                    
                [docVC.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
                    [docVC.toolManager willModifyAnnotation:currentAnnot onPageNumber:currentPageNumber];
                    
                    [currentAnnot SetFlag:flagNumber value:currentFlagValue];
                    
                    [docVC.toolManager annotationModified:currentAnnot onPageNumber:currentPageNumber];
                    }error:&error];
                
                if (error) {
                    NSLog(@"Error: Failed to set flag for annotation. %@", error.localizedDescription);
                }
            }
        }
    }
    
    flutterResult(nil);
}

- (void)importAnnotationCommand:(NSString *)xfdfCommand
{
    PTDocumentViewController *docVC = [self getDocumentViewController];
    if(docVC.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        return;
    }
    
    NSError* error;
    
    [docVC.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        if([doc HasDownloader])
        {
            // too soon
            NSLog(@"Error: The document is still being downloaded.");
            return;
        }

        PTFDFDoc* fdfDoc = [doc FDFExtract:e_ptboth];
        [fdfDoc MergeAnnots:xfdfCommand permitted_user:@""];
        [doc FDFUpdate:fdfDoc];

        [docVC.pdfViewCtrl Update:YES];

    } error:&error];
    
    if(error)
    {
        NSLog(@"Error: There was an error while trying to import annotation commands. %@", error.localizedDescription);
    }
}

- (void)importBookmarks:(NSString *)bookmarkJson
{
    PTDocumentViewController *docVC = [self getDocumentViewController];
    if(docVC.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        return;
    }
    
    NSError* error;
    
    [docVC.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        if([doc HasDownloader])
        {
            // too soon
            NSLog(@"Error: The document is still being downloaded.");
            return;
        }

        [PTBookmarkManager.defaultManager importBookmarksForDoc:doc fromJSONString:bookmarkJson];

    } error:&error];
    
    if(error)
    {
        NSLog(@"Error: There was an error while trying to import bookmarks. %@", error.localizedDescription);
    }
}

- (void)saveDocument:(FlutterResult)flutterResult
{
    PTDocumentViewController *docVC = [self getDocumentViewController];
    __block NSString* resultString;

    if(docVC.document == Nil)
    {
        resultString = @"Error: The document view controller has no document.";
        
        // something is wrong, no document.
        NSLog(@"%@", resultString);
        flutterResult(resultString);
        
        return;
    }
    
    NSError* error;
    
    [docVC.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        if([doc HasDownloader])
        {
            // too soon
            resultString = @"Error: The document is still being downloaded and cannot be saved.";
            NSLog(@"%@", resultString);
            flutterResult(resultString);
            return;
        }

        [docVC saveDocument:0 completionHandler:^(BOOL success) {
            if(!success)
            {
                resultString = @"Error: The file could not be saved.";
                NSLog(@"%@", resultString);
                flutterResult(resultString);
            }
            else
            {
                resultString = @"The file was successfully saved.";
                flutterResult(resultString);
            }
        }];

    } error:&error];
    
    if(error)
    {
        NSLog(@"Error: There was an error while trying to save the document. %@", error.localizedDescription);
    }
}

- (void)commitTool:(FlutterResult)flutterResult
{
    PTDocumentViewController *docVC = [self getDocumentViewController];
    PTToolManager *toolManager = docVC.toolManager;
    if ([toolManager.tool respondsToSelector:@selector(commitAnnotation)]) {
        [toolManager.tool performSelector:@selector(commitAnnotation)];

        [toolManager changeTool:[PTPanTool class]];

        flutterResult([NSNumber numberWithBool:YES]);
    } else {
        flutterResult([NSNumber numberWithBool:NO]);
    }
}

- (void)getPageCount:(FlutterResult)flutterResult
{
    PTDocumentViewController *docVC = [self getDocumentViewController];
    if(docVC.document == Nil)
    {
        NSString *resultString = @"Error: The document view controller has no document.";

        // something is wrong, no document.
        NSLog(@"%@", resultString);
        flutterResult(resultString);

        return;
    }

    flutterResult([NSNumber numberWithInt:docVC.pdfViewCtrl.pageCount]);
}

- (void)getPageCropBox:(NSNumber *)pageNumber resultToken:(FlutterResult)result
{
    PTDocumentViewController *docVC = [self getDocumentViewController];
    NSError *error;
    [docVC.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        if([doc HasDownloader])
        {
            // too soon
            NSLog(@"Error: The document is still being downloaded.");
            return;
        }
        
        PTPage *page = [doc GetPage:(int)pageNumber];
        if (page) {
            PTPDFRect *rect = [page GetCropBox];
            NSDictionary<NSString *, NSNumber *> *map = @{
                PTX1Key: @([rect GetX1]),
                PTY1Key: @([rect GetY1]),
                PTX2Key: @([rect GetX2]),
                PTY2Key: @([rect GetY2]),
                PTWidthKey: @([rect Width]),
                PTHeightKey: @([rect Height]),
            };
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:map options:0 error:nil];
            NSString *res = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            result(res);
        }

    } error:&error];
    
    if(error)
    {
        NSLog(@"Error: There was an error while trying to get the page crop box. %@", error.localizedDescription);
    }
}

#pragma mark - Helper

- (PTDocumentViewController *)getDocumentViewController {
    PTDocumentViewController* docVC = self.tabbedDocumentViewController.selectedViewController;
    
    if(docVC == Nil && self.tabbedDocumentViewController.childViewControllers.count == 1)
    {
        docVC = self.tabbedDocumentViewController.childViewControllers.lastObject;
    }
    return docVC;
}

+ (NSString *)PT_idAsNSString:(id)value
{
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString *)value;
    }
    return nil;
}

+ (NSNumber *)PT_idAsNSNumber:(id)value
{
    if ([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber *)value;
    }
    return nil;
}

+ (bool)PT_idAsBool:(id)value
{
    NSNumber* numericVal = [PdftronFlutterPlugin PT_idAsNSNumber:value];
    bool result = [numericVal boolValue];
    return result;
}

+ (NSDictionary *)PT_idAsNSDict:(id)value
{
    if ([value isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)value;
    }
    return nil;
}

+ (NSArray *)PT_idAsArray:(id)value
{
    if ([value isKindOfClass:[NSArray class]]) {
        return (NSArray *)value;
    }
    return nil;
}

+ (NSString *)PT_idToJSONString:(id)infoId {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoId options:0 error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (id)PT_JSONStringToId:(NSString *)jsonString {
    NSData *annotListData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:annotListData options:kNilOptions error:nil];
}

@end
