#import "PdftronFlutterPlugin.h"
#import "PTFlutterDocumentController.h"
#import "DocumentViewFactory.h"
#import "PTNavigationController.h"

@interface PdftronFlutterPlugin () <PTTabbedDocumentViewControllerDelegate, PTDocumentControllerDelegate>

@property (nonatomic, strong) id config;
@property (nonatomic, strong) FlutterEventSink xfdfEventSink;
@property (nonatomic, strong) FlutterEventSink bookmarkEventSink;
@property (nonatomic, strong) FlutterEventSink documentLoadedEventSink;
@property (nonatomic, strong) FlutterEventSink documentErrorEventSink;
@property (nonatomic, strong) FlutterEventSink annotationChangedEventSink;
@property (nonatomic, strong) FlutterEventSink annotationsSelectedEventSink;
@property (nonatomic, strong) FlutterEventSink formFieldValueChangedEventSink;
@property (nonatomic, strong) FlutterEventSink behaviorActivatedEventSink;
@property (nonatomic, strong) FlutterEventSink longPressMenuPressedEventSink;
@property (nonatomic, strong) FlutterEventSink annotationMenuPressedEventSink;
@property (nonatomic, strong) FlutterEventSink leadingNavButtonPressedEventSink;
@property (nonatomic, strong) FlutterEventSink pageChangedEventSink;
@property (nonatomic, strong) FlutterEventSink zoomChangedEventSink;
@property (nonatomic, strong) FlutterEventSink pageMovedEventSink;

@property (nonatomic, assign, getter=isWidgetView) BOOL widgetView;
@property (nonatomic, assign, getter=isMultiTabSet) BOOL multiTabSet;

@end

@implementation PdftronFlutterPlugin

#pragma mark - Initialization

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar
{
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"pdftron_flutter"
                                     binaryMessenger:[registrar messenger]];
    

    
    PdftronFlutterPlugin* instance = [[PdftronFlutterPlugin alloc] init];
    instance.widgetView = NO;
    
    [registrar addMethodCallDelegate:instance channel:channel];
    
    [instance registerEventChannels:[registrar messenger]];
    [PdftronFlutterPlugin overrideControllerClasses];
    
    DocumentViewFactory* documentViewFactory =
    [[DocumentViewFactory alloc] initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:documentViewFactory withId:@"pdftron_flutter/documentview"];
}

+ (PdftronFlutterPlugin *)registerWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId messenger:(NSObject<FlutterBinaryMessenger> *)messenger
{
    NSString* channelName = [NSString stringWithFormat:@"pdftron_flutter/documentview_%lld", viewId];
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
    
    PdftronFlutterPlugin* instance = [[PdftronFlutterPlugin alloc] init];
    instance.widgetView = YES;
    
    __weak __typeof__(instance) weakInstance = instance;
    [channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        __strong __typeof__(weakInstance) instance = weakInstance;
        if (instance) {
            [instance handleMethodCall:call result:result];
        }
    }];
    
    [instance registerEventChannels:messenger];
    
    [instance initTabbedDocumentViewController];
    [instance presentTabbedDocumentViewController];
    
    return instance;
}

- (void)initTabbedDocumentViewController
{
    // Create and wrap a tabbed controller in a navigation controller.
    self.tabbedDocumentViewController = [[PTFlutterTabbedDocumentController alloc] init];
    
    self.tabbedDocumentViewController.delegate = self;
    self.tabbedDocumentViewController.tabsEnabled = NO;
    
    NSMutableArray *tempFiles = [[NSMutableArray alloc] init];
    [(PTFlutterTabbedDocumentController *)(self.tabbedDocumentViewController) setTempFiles:[tempFiles mutableCopy]];
    
    self.tabbedDocumentViewController.viewControllerClass = [PTFlutterDocumentController class];
    
    [self.tabbedDocumentViewController.tabManager restoreItems];
    
    self.tabbedDocumentViewController.restorationIdentifier = [NSUUID UUID].UUIDString;
}

- (void)presentTabbedDocumentViewController
{
    PTNavigationController *navigationController = [[PTNavigationController alloc] initWithRootViewController:self.tabbedDocumentViewController];
    
    navigationController.tabbedDocumentViewController = self.tabbedDocumentViewController;
    
    UIViewController *presentingViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    
    if (self.isWidgetView) {
        [presentingViewController addChildViewController:navigationController];
        [navigationController didMoveToParentViewController:presentingViewController];
        
    } else {
        navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        // Show navigation (and tabbed) controller.
        [presentingViewController presentViewController:navigationController animated:YES completion:nil];
        
    }
}

+ (void)overrideControllerClasses
{
    [PTOverrides overrideClass:[PTDocumentController class] withClass:[PTFlutterDocumentController class]];
    
    [PTOverrides overrideClass:[PTThumbnailsViewController class] withClass:[FLThumbnailsViewController class]];
}

- (void)registerEventChannels:(NSObject<FlutterBinaryMessenger> *)messenger
{
    FlutterEventChannel* xfdfEventChannel = [FlutterEventChannel eventChannelWithName:PTExportAnnotationCommandEventKey binaryMessenger:messenger];

    FlutterEventChannel* bookmarkEventChannel = [FlutterEventChannel eventChannelWithName:PTExportBookmarkEventKey binaryMessenger:messenger];

    FlutterEventChannel* documentLoadedEventChannel = [FlutterEventChannel eventChannelWithName:PTDocumentLoadedEventKey binaryMessenger:messenger];
    
    FlutterEventChannel* documentErrorEventChannel = [FlutterEventChannel eventChannelWithName:PTDocumentErrorEventKey binaryMessenger:messenger];
    
    FlutterEventChannel* annotationChangedEventChannel = [FlutterEventChannel eventChannelWithName:PTAnnotationChangedEventKey binaryMessenger:messenger];
    
    FlutterEventChannel* annotationsSelectedEventChannel = [FlutterEventChannel eventChannelWithName:PTAnnotationsSelectedEventKey binaryMessenger:messenger];
    
    FlutterEventChannel* formFieldValueChangedEventChannel = [FlutterEventChannel eventChannelWithName:PTFormFieldValueChangedEventKey binaryMessenger:messenger];
    
    FlutterEventChannel* behaviorActivatedEventChannel = [FlutterEventChannel eventChannelWithName:PTBehaviorActivatedEventKey binaryMessenger:messenger];
    
    FlutterEventChannel* longPressMenuPressedEventChannel = [FlutterEventChannel eventChannelWithName:PTLongPressMenuPressedEventKey binaryMessenger:messenger];
    
    FlutterEventChannel* annotationMenuPressedEventChannel = [FlutterEventChannel eventChannelWithName:PTAnnotationMenuPressedEventKey binaryMessenger:messenger];

    FlutterEventChannel* leadingNavButtonPressedEventChannel = [FlutterEventChannel eventChannelWithName:PTLeadingNavButtonPressedEventKey binaryMessenger:messenger];

    FlutterEventChannel* pageChangedEventChannel = [FlutterEventChannel eventChannelWithName:PTPageChangedEventKey binaryMessenger:messenger];

    FlutterEventChannel* zoomChangedEventChannel = [FlutterEventChannel eventChannelWithName:PTZoomChangedEventKey binaryMessenger:messenger];
    
    FlutterEventChannel* pageMovedEventChannel = [FlutterEventChannel eventChannelWithName:PTPageMovedEventKey binaryMessenger:messenger];

    [xfdfEventChannel setStreamHandler:self];
    
    [bookmarkEventChannel setStreamHandler:self];
    
    [documentLoadedEventChannel setStreamHandler:self];
    
    [documentErrorEventChannel setStreamHandler:self];
    
    [annotationChangedEventChannel setStreamHandler:self];
    
    [annotationsSelectedEventChannel setStreamHandler:self];
    
    [formFieldValueChangedEventChannel setStreamHandler:self];
    
    [behaviorActivatedEventChannel setStreamHandler:self];

    [longPressMenuPressedEventChannel setStreamHandler:self];
    
    [annotationMenuPressedEventChannel setStreamHandler:self];

    [leadingNavButtonPressedEventChannel setStreamHandler:self];
    
    [pageChangedEventChannel setStreamHandler:self];
    
    [zoomChangedEventChannel setStreamHandler:self];
    
    [pageMovedEventChannel setStreamHandler:self];
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
                else if ([key isEqualToString:PTMaxTabCountKey]) {
                    NSError* error;
                    NSNumber* maxTabCount = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTMaxTabCountKey class:[NSNumber class] error:&error];
                    
                    if (!error && maxTabCount) {
                        tabbedDocumentViewController.maximumTabCount = [maxTabCount intValue];
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

+ (void)configureDocumentController:(PTFlutterDocumentController*)documentController withConfig:(NSString*)config
{

    [documentController initViewerSettings];
    
    if (config.length == 0 || [config isEqualToString:@"null"]) {
        [documentController applyViewerSettings];
        return;
    }
   
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
                        [self disableTools:toolsToDisable documentController:documentController];
                    }
                }
                else if([key isEqualToString:PTDisabledElementsKey])
                {
                    
                    NSArray* elementsToDisable = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTDisabledElementsKey class:[NSArray class] error:&error];
                    
                    if (!error && elementsToDisable) {
                        [self disableElements:(NSArray*)elementsToDisable documentController:documentController];
                    }
                }
                else if ([key isEqualToString:PTCustomHeadersKey]) {
                    
                    NSDictionary* customHeaders = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTCustomHeadersKey class:[NSDictionary class] error:&error];
                    
                    if (!error && customHeaders) {
                        documentController.additionalHTTPHeaders = customHeaders;
                    }
                }
                else if ([key isEqualToString:PTMultiTabEnabledKey]) {
                    // Handled by tabbed config.
                }
                else if ([key isEqualToString:PTMaxTabCountKey]) {
                    // Handled by tabbed config.
                }
                else if ([key isEqualToString:PTFitModeKey]) {
                    
                    NSString* fitMode = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTFitModeKey class:[NSString class] error:&error];
                    
                    if (!error && fitMode) {
                        [documentController setFitMode:fitMode];
                    }
                }
                else if ([key isEqualToString:PTLayoutModeKey]) {
                    
                    NSString* layoutMode = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTLayoutModeKey class:[NSString class] error:&error];
                    
                    if (!error && layoutMode) {
                        [documentController setLayoutMode:layoutMode];
                    }
                }
                else if ([key isEqualToString:PTInitialPageNumberKey]) {
                    
                    NSNumber* initialPageNumber = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTInitialPageNumberKey class:[NSNumber class] error:&error];
                    
                    if (!error && initialPageNumber) {
                        [documentController setInitialPageNumber:[initialPageNumber intValue]];
                    }
                }
                else if ([key isEqualToString:PTIsBase64StringKey]) {
                    
                    NSNumber* isBase64 = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTIsBase64StringKey class:[NSNumber class] error:&error];
                    
                    if (!error && isBase64) {
                        [documentController setBase64:[isBase64 boolValue]];
                    }
                }
                else if ([key isEqualToString:PTHideThumbnailFilterModesKey]) {
                    
                    NSArray* hideThumbnailFilterModes = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTHideThumbnailFilterModesKey class:[NSArray class] error:&error];
                    
                    if (!error && hideThumbnailFilterModes) {
                        [documentController setHideThumbnailFilterModes: hideThumbnailFilterModes];
                    }
                }
                else if ([key isEqualToString:PTDocumentSliderEnabledKey]) {
                    
                    NSNumber* documentSliderEnabled = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTDocumentSliderEnabledKey class:[NSNumber class] error:&error];
                    
                    if (!error && documentSliderEnabled) {
                        [documentController setDocumentSliderEnabled:[documentSliderEnabled boolValue]];
                    }
                }
                else if ([key isEqualToString:PTLongPressMenuEnabled]) {
                    
                    NSNumber* longPressMenuEnabledNumber = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTLongPressMenuEnabled class:[NSNumber class] error:&error];
                    
                    if (!error && longPressMenuEnabledNumber) {
                        [documentController setLongPressMenuEnabled:[longPressMenuEnabledNumber boolValue]];
                    }
                }
                else if ([key isEqualToString:PTLongPressMenuItems]) {
                    
                    NSArray* longPressMenuItems = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTLongPressMenuItems class:[NSArray class] error:&error];
                    
                    if (!error && longPressMenuItems) {
                        [documentController setLongPressMenuItems:longPressMenuItems];
                    }
                }
                else if ([key isEqualToString:PTOverrideLongPressMenuBehavior]) {
                    
                    NSArray* overrideLongPressMenuBehavior = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTOverrideLongPressMenuBehavior class:[NSArray class] error:&error];
                    
                    if (!error && overrideLongPressMenuBehavior) {
                        [documentController setOverrideLongPressMenuBehavior:overrideLongPressMenuBehavior];
                    }
                }
                else if ([key isEqualToString:PTHideAnnotationMenu]) {
                    
                    NSArray* hideAnnotationMenuTools = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTHideAnnotationMenu class:[NSArray class] error:&error];
                    
                    if (!error && hideAnnotationMenuTools) {
                        [documentController setHideAnnotMenuTools:hideAnnotationMenuTools];
                    }
                }
                else if ([key isEqualToString:PTAnnotationMenuItems]) {
                    
                    NSArray* annotationMenuItems = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTAnnotationMenuItems class:[NSArray class] error:&error];
                    
                    if (!error && annotationMenuItems) {
                        [documentController setAnnotationMenuItems:annotationMenuItems];
                    }
                }
                else if ([key isEqualToString:PTOverrideAnnotationMenuBehavior]) {
                    
                    NSArray* overrideAnnotationMenuBehavior = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTOverrideAnnotationMenuBehavior class:[NSArray class] error:&error];
                    
                    if (!error && overrideAnnotationMenuBehavior) {
                        [documentController setOverrideAnnotationMenuBehavior:overrideAnnotationMenuBehavior];
                    }
                }
                else if ([key isEqualToString:PTExcludedAnnotationListTypesKey]) {
                    
                    NSArray* excludedAnnotationListTypes = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTExcludedAnnotationListTypesKey class:[NSArray class] error:&error];
                    
                    if (!error && excludedAnnotationListTypes) {
                        [documentController setExcludedAnnotationListTypes:excludedAnnotationListTypes];
                    }
                }
                else if ([key isEqualToString:PTAutoSaveEnabledKey]) {
                    
                    NSNumber* autoSaveEnabledNumber = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTAutoSaveEnabledKey class:[NSNumber class] error:&error];
                    if (!error && autoSaveEnabledNumber) {
                        [documentController setAutoSaveEnabled:[autoSaveEnabledNumber boolValue]];
                    }
                }
                else if ([key isEqualToString:PTPageChangeOnTapKey]) {
                    
                    NSNumber* pageChangeOnTapNumber = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTPageChangeOnTapKey class:[NSNumber class] error:&error];
                    if (!error && pageChangeOnTapNumber) {
                        [documentController setPageChangesOnTap:[pageChangeOnTapNumber boolValue]];
                    }
                }
                else if ([key isEqualToString:PTShowSavedSignaturesKey]) {
                    
                    NSNumber* showSavedSignatureNumber = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTShowSavedSignaturesKey class:[NSNumber class] error:&error];
                    if (!error && showSavedSignatureNumber) {
                        [documentController setShowSavedSignatures:[showSavedSignatureNumber boolValue]];
                    }
                }
                else if ([key isEqualToString:PTUseStylusAsPenKey]) {
                    
                    NSNumber* useStylusAsPenNumber = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTUseStylusAsPenKey class:[NSNumber class] error:&error];
                    if (!error && useStylusAsPenNumber) {
                        [documentController setUseStylusAsPen:[useStylusAsPenNumber boolValue]];
                    }
                }
                else if ([key isEqualToString:PTSignSignatureFieldWithStampsKey]) {
                    
                    NSNumber* signSignatureFieldsWithStampsNumber = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTSignSignatureFieldWithStampsKey class:[NSNumber class] error:&error];
                    if (!error && signSignatureFieldsWithStampsNumber) {
                        [documentController setSignSignatureFieldsWithStamps:[signSignatureFieldsWithStampsNumber boolValue]];
                    }
                }
                else if ([key isEqualToString:PTSelectAnnotationAfterCreationKey]) {
                    
                    NSNumber* selectAnnotAfterCreationNumber = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTSelectAnnotationAfterCreationKey class:[NSNumber class] error:&error];
                    
                    if (!error && selectAnnotAfterCreationNumber) {
                        [documentController setSelectAnnotationAfterCreation:[selectAnnotAfterCreationNumber boolValue]];
                    }
                }
                else if ([key isEqualToString:PTPageIndicatorEnabledKey]) {
                    
                    NSNumber* pageIndicatorEnabledNumber = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTPageIndicatorEnabledKey class:[NSNumber class] error:&error];
                    
                    if (!error && pageIndicatorEnabledNumber) {
                        [documentController setPageIndicatorEnabled:[pageIndicatorEnabledNumber boolValue]];
                    }
                }
                else if ([key isEqualToString:PTPageNumberIndicatorAlwaysVisibleKey]) {

                    NSNumber* pageIndicatorAlwaysVisibleNumber = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTPageNumberIndicatorAlwaysVisibleKey class:[NSNumber class] error:&error];

                    if (!error && pageIndicatorAlwaysVisibleNumber) {
                        [documentController setPageIndicatorAlwaysVisible:[pageIndicatorAlwaysVisibleNumber boolValue]];
                    }
                }
                else if ([key isEqualToString:PTShowQuickNavigationButtonKey]) {
                    
                    NSNumber *showQuickNavButton = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTShowQuickNavigationButtonKey class:[NSNumber class] error:&error];
                    
                    if (!error && showQuickNavButton) {
                        documentController.showQuickNavigationButton = [showQuickNavButton boolValue];
                    }
                }
                else if ([key isEqualToString:PTFollowSystemDarkModeKey]) {
                    // Android only.
                }
                else if ([key isEqualToString:PTAnnotationToolbarsKey]) {
                    
                    NSArray* annotationToolbars = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTAnnotationToolbarsKey class:[NSArray class] error:&error];
                    
                    if (!error && annotationToolbars) {
                        documentController.annotationToolbars = annotationToolbars;
                    }
                }
                else if ([key isEqualToString:PTHideDefaultAnnotationToolbarsKey]) {
                    
                    NSArray* hideDefaultAnnotationToolbars = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTHideDefaultAnnotationToolbarsKey class:[NSArray class] error:&error];
                    
                    if (!error && hideDefaultAnnotationToolbars) {
                        documentController.hideDefaultAnnotationToolbars = hideDefaultAnnotationToolbars;
                    }
                }
                else if ([key isEqualToString:PTHideAnnotationToolbarSwitcherKey]) {
                    
                    NSNumber* hideAnnotationToolbarSwitcherNumber = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTHideAnnotationToolbarSwitcherKey class:[NSNumber class] error:&error];
                    
                    if (!error && hideAnnotationToolbarSwitcherNumber) {
                        documentController.annotationToolbarSwitcherHidden = [hideAnnotationToolbarSwitcherNumber boolValue];
                    }
                }
                else if ([key isEqualToString:PTInitialToolbarKey]) {
                    
                    NSString *initialToolbar = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTInitialToolbarKey class:[NSString class] error:&error];
                    
                    if (!error && initialToolbar) {
                        documentController.initialToolbar = initialToolbar;
                    }
                }
                else if ([key isEqualToString:PTHideTopToolbarsKey]) {
                    
                    NSNumber* hideTopToolbarsNumber = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTHideTopToolbarsKey class:[NSNumber class] error:&error];
                    
                    if (!error && hideTopToolbarsNumber) {
                        documentController.topToolbarsHidden = [hideTopToolbarsNumber boolValue];
                    }
                }
                else if ([key isEqualToString:PTHideToolbarsOnTapKey]) {
                    
                    NSNumber* hideToolbarsOnTapNumber = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTHideToolbarsOnTapKey class:[NSNumber class] error:&error];
                    
                    if (!error && hideToolbarsOnTapNumber) {
                        documentController.toolbarsHiddenOnTap = [hideToolbarsOnTapNumber boolValue];
                    }
                }
                else if ([key isEqualToString:PTHideTopAppNavBarKey]) {
                    
                    NSNumber* hideTopAppNavBarNumber = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTHideTopAppNavBarKey class:[NSNumber class] error:&error];
                    
                    if (!error && hideTopAppNavBarNumber) {
                        documentController.topAppNavBarHidden = [hideTopAppNavBarNumber boolValue];
                    }
                }
                else if ([key isEqualToString:PTTopAppNavBarRightBarKey]) {
                    
                    NSArray *topAppNavBarRightBar = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTTopAppNavBarRightBarKey class:[NSArray class] error:&error];
                    
                    if (!error && topAppNavBarRightBar) {
                        documentController.topAppNavBarRightBar = topAppNavBarRightBar;
                    }
                }
                else if ([key isEqualToString:PTHideBottomToolbarKey]) {
                    
                    NSNumber* hideBottomToolbarNumber = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTHideBottomToolbarKey class:[NSNumber class] error:&error];
                    
                    if (!error && hideBottomToolbarNumber) {
                        documentController.bottomToolbarHidden = [hideBottomToolbarNumber boolValue];
                    }
                }
                else if ([key isEqualToString:PTBottomToolbarKey]) {
                    NSArray *bottomToolbar = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTBottomToolbarKey class:[NSArray class] error:&error];
                    
                    if (!error && bottomToolbar) {
                        documentController.bottomToolbar = bottomToolbar;
                    }
                }
                else if ([key isEqualToString:PTShowLeadingNavButtonKey]) {
                    
                    NSNumber* showLeadingNavButtonNumber = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTShowLeadingNavButtonKey class:[NSNumber class] error:&error];
                    
                    if (!error && showLeadingNavButtonNumber) {
                        [documentController setShowNavButton:[showLeadingNavButtonNumber boolValue]];
                    }
                }
                else if ([key isEqualToString:PTReadOnlyKey]) {
                    
                    NSNumber* readOnlyNumber = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTReadOnlyKey class:[NSNumber class] error:&error];
                    
                    if (!error && readOnlyNumber) {
                        [documentController setReadOnly:[readOnlyNumber boolValue]];
                    }
                }
                else if ([key isEqualToString:PTThumbnailViewEditingEnabledKey]) {
                    
                    NSNumber* thumbnailViewEditingEnabledNumber = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTThumbnailViewEditingEnabledKey class:[NSNumber class] error:&error];
                    
                    if (!error && thumbnailViewEditingEnabledNumber) {
                        [documentController setThumbnailEditingEnabled:[thumbnailViewEditingEnabledNumber boolValue]];
                    }
                }
                else if ([key isEqualToString:PTAnnotationAuthorKey]) {
                    
                    NSString* annotationAuthor = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTAnnotationAuthorKey class:[NSString class] error:&error];
                    
                    if (!error && annotationAuthor) {
                        [documentController setAnnotationAuthor:annotationAuthor];
                    }
                }
                else if ([key isEqualToString:PTContinuousAnnotationEditingKey]) {
                    
                    NSNumber* contEditingNumber = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTContinuousAnnotationEditingKey class:[NSNumber class] error:&error];
                    
                    if (!error && contEditingNumber) {
                        [documentController setContinuousAnnotationEditingEnabled:[contEditingNumber boolValue]];
                    }
                }
                else if ([key isEqualToString:PTAnnotationPermissionCheckEnabledKey]) {
                    
                    NSNumber* checkEnabledNumber = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTAnnotationPermissionCheckEnabledKey class:[NSNumber class] error:&error];
                    
                    if (!error && checkEnabledNumber) {
                        
                        [documentController setAnnotationPermissionCheckEnabled:[checkEnabledNumber boolValue]];
                    }
                }
                else if ([key isEqualToString:PTAnnotationsListEditingEnabledKey]) {
                    
                    NSNumber* annotationsListEditingEnabled = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTAnnotationsListEditingEnabledKey class:[NSNumber class] error:&error];
                    
                    if (!error && annotationsListEditingEnabled) {
                        
                        [documentController setAnnotationsListEditingEnabled:[annotationsListEditingEnabled boolValue]];
                    }
                }
                else if ([key isEqualToString:PTUserBookmarksListEditingEnabledKey]) {
                    
                    NSNumber* userBookmarksListEditingEnabled = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTUserBookmarksListEditingEnabledKey class:[NSNumber class] error:&error];
                    
                    if (!error && userBookmarksListEditingEnabled) {
                        
                        [documentController setUserBookmarksListEditingEnabled:[userBookmarksListEditingEnabled boolValue]];
                    }
                }
                else if ([key isEqualToString:PTShowNavigationListAsSidePanelOnLargeDevicesKey]) {
                    
                    NSNumber* showNavigationListAsSidePanelOnLargeDevices = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTShowNavigationListAsSidePanelOnLargeDevicesKey class:[NSNumber class] error:&error];
                    
                    if (!error && showNavigationListAsSidePanelOnLargeDevices) {
                        
                        [documentController setShowNavigationListAsSidePanelOnLargeDevices:[showNavigationListAsSidePanelOnLargeDevices boolValue]];
                    }
                }
                else if ([key isEqualToString:PTOverrideBehaviorKey]) {
                    
                    NSArray* overrideBehavior = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTOverrideBehaviorKey class:[NSArray class] error:&error];
                    
                    if (!error && overrideBehavior) {
                        [documentController setOverrideBehavior:overrideBehavior];
                    }
                }
                else if ([key isEqualToString:PTTabTitleKey]) {
                    
                    NSString* tabTitle = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTTabTitleKey class:[NSString class] error:&error];
                    
                    if (!error && tabTitle) {
                        [documentController setTabTitle:tabTitle];
                    }
                }
                else if ([key isEqualToString:PTDisableEditingByAnnotationTypeKey])
                {
                    
                    NSArray* uneditableAnnotTypes = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTDisableEditingByAnnotationTypeKey class:[NSArray class] error:&error];
                    
                    if (!error && uneditableAnnotTypes) {
                        [documentController setUneditableAnnotTypes:uneditableAnnotTypes];
                    }
                }
                else if ([key isEqualToString:PTHideViewModeItemsKey])
                {
                    
                    NSArray* viewModeItems = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTHideViewModeItemsKey class:[NSArray class] error:&error];
                    
                    if (!error && viewModeItems) {
                        [documentController hideViewModeItems:viewModeItems];
                    }
                }
                else if ([key isEqualToString:PTDefaultEraserTypeKey])
                {
                    
                    NSString* defaultEraserType = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTDefaultEraserTypeKey class:[NSString class] error:&error];
                    
                    if (!error && defaultEraserType) {
                        [documentController setDefaultEraserType:defaultEraserType];
                    }
                }
                else if ([key isEqualToString:PTAutoResizeFreeTextEnabledKey]) 
                {
                    
                    NSNumber *autoResizeFreeTextEnabledNumber = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTAutoResizeFreeTextEnabledKey class:[NSNumber class] error:&error];
                    
                    if (!error && autoResizeFreeTextEnabledNumber) {
                        documentController.autoResizeFreeTextEnabled = [autoResizeFreeTextEnabledNumber boolValue];
                    }
                }
                else if ([key isEqualToString:PTRestrictDownloadUsageKey]) 
                {
                    
                    NSNumber *restrictDownloadUsageNumber = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTRestrictDownloadUsageKey class:[NSNumber class] error:&error];
                    
                    if (!error && restrictDownloadUsageNumber) {
                        documentController.restrictDownloadUsage = [restrictDownloadUsageNumber boolValue];
                    }
                }
                else if ([key isEqualToString:PTReflowOrientationKey]) 
                {
                    
                    NSString *reflowOrientation = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTReflowOrientationKey class:[NSString class] error:&error];
                    
                    if (!error && reflowOrientation) {
                        [documentController setReflowOrientation:reflowOrientation];
                    }
                }
                else if ([key isEqualToString:PTImageInReflowModeEnabledKey]) 
                {
                    
                    NSNumber *imageInReflowModeEnabledNumber = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTImageInReflowModeEnabledKey class:[NSNumber class] error:&error];
                    
                    if (!error && imageInReflowModeEnabledNumber) {
                        [documentController setImageInReflowModeEnabled:[imageInReflowModeEnabledNumber boolValue]];
                    }
                }
                else if ([key isEqualToString:PTAnnotationManagerEnabledKey])
                {
                    NSNumber* annotationManagerEnabledNumber = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTAnnotationManagerEnabledKey class:[NSNumber class] error:&error];
                    
                    if (!error && annotationManagerEnabledNumber) {
                        [documentController setAnnotationManagerEnabled:[annotationManagerEnabledNumber boolValue]];
                    }
                }
                else if ([key isEqualToString:PTUserIdKey])
                {
                    NSString* userId = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTUserIdKey class:[NSString class] error:&error];
                    
                    if (!error && userId) {
                        [documentController setUserId:userId];
                    }
                }
                else if ([key isEqualToString:PTUserNameKey])
                {
                    NSString* userName = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTUserNameKey class:[NSString class] error:&error];
                    
                    if (!error && userName) {
                        [documentController setUserName:userName];
                    }
                }
                else if ([key isEqualToString:PTAnnotationManagerEditModeKey])
                {
                    NSString *editMode = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTAnnotationManagerEditModeKey class:[NSString class] error:&error];
                    
                    if (!error && editMode) {
                        documentController.annotationManagerEditMode = [editMode copy];
                    }
                }
                else if ([key isEqualToString:PTAnnotationManagerUndoModeKey])
                {
                    NSString *undoMode = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTAnnotationManagerUndoModeKey class:[NSString class] error:&error];
                    
                    if (!error && undoMode) {
                        documentController.annotationManagerUndoMode = [undoMode copy];
                    }
                }
                else if ([key isEqualToString:PTAnnotationToolbarAlignmentKey])
                {
                    NSString *alignmentString = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTAnnotationToolbarAlignmentKey class:[NSString class] error:&error];

                    if (!error && alignmentString) {
                        if ([alignmentString isEqualToString:PTAnnotationToolbarAlignmentEndKey]) {
                            documentController.toolGroupToolbar.itemsAlignment = PTToolGroupToolbarAlignmentTrailing;
                        } else {
                            documentController.toolGroupToolbar.itemsAlignment = PTToolGroupToolbarAlignmentLeading;
                        }
                    }
                }
                else if([key isEqualToString:PTQuickBookmarkCreationKey])
                {
                    NSNumber* quickBookmarkCreation = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PTQuickBookmarkCreationKey class:[NSNumber class] error:&error];

                    if (!error && quickBookmarkCreation) {
                        documentController.bookmarkPageButtonHidden = ![quickBookmarkCreation boolValue];
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
    
    [documentController applyViewerSettings];
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
    if (!self.isWidgetView) {
        [self.tabbedDocumentViewController.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    
    [self documentController:[self getDocumentController] leadingNavButtonClicked:nil];
}

+ (void)disableTools:(NSArray<id> *)toolsToDisable documentController:(PTDocumentController *)documentController
{
    PTToolManager *toolManager = documentController.toolManager;
    
    for (id item in toolsToDisable) {
        BOOL value = NO;
        
        if ([item isKindOfClass:[NSString class]]) {
            NSString *string = (NSString *)item;
            
            if ([string isEqualToString:PTAnnotationEditToolKey] ||
                [string isEqualToString:PTEditToolButtonKey] ||
                [string isEqualToString:PTMultiSelectToolKey]) {
                toolManager.allowsMultipleAnnotationSelection = value;
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
                     [string isEqualToString:PTStrikeoutToolButtonKey]) {
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
                toolManager.imageStampAnnotationOptions.canCreate = value;
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
            else if ([string isEqualToString:PTAnnotationCreateFileAttachmentToolKey]) {
                toolManager.fileAttachmentAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:PTAnnotationCreateRedactionToolKey]) {
                toolManager.redactAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:PTAnnotationCreateLinkToolKey]) {
                toolManager.linkAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:PTAnnotationCreateDistanceMeasurementToolKey]) {
                toolManager.rulerAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:PTAnnotationCreatePerimeterMeasurementToolKey]) {
                toolManager.perimeterAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:PTAnnotationCreateAreaMeasurementToolKey]) {
                toolManager.areaAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:PTAnnotationCreateRubberStampToolKey]) {
                toolManager.stampAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:PTAnnotationCreateRedactionTextToolKey]) {
                // TODO
            }
            else if ([string isEqualToString:PTAnnotationCreateLinkTextToolKey]) {
                // TODO
            }
            else if ([string isEqualToString:PTFormCreateTextFieldToolKey]) {
                // TODO
            }
            else if ([string isEqualToString:PTFormCreateCheckboxFieldToolKey]) {
                // TODO
            }
            else if ([string isEqualToString:PTFormCreateSignatureFieldToolKey]) {
                // TODO
            }
            else if ([string isEqualToString:PTFormCreateRadioFieldToolKey]) {
                // TODO
            }
            else if ([string isEqualToString:PTFormCreateComboBoxFieldToolKey]) {
                // TODO
            }
            else if ([string isEqualToString:PTFormCreateListBoxFieldToolKey]) {
                // TODO
            }
            else if ([string isEqualToString:PTAnnotationCreateFreeHighlighterToolKey]) {
                toolManager.freehandHighlightAnnotationOptions.canCreate = value;
            }
            else if ([string isEqualToString:PTPencilKitDrawingToolKey]) {
                toolManager.pencilDrawingAnnotationOptions.canCreate = value;
            }
        }
    }
}

+ (void)disableElements:(NSArray*)elementsToDisable documentController:(PTDocumentController *)documentController
{
    typedef void (^HideElementBlock)(void);
    
    NSDictionary *hideElementActions = @{
        PTToolsButtonKey:
            ^{
//                TODO: unsupported: documentController.annotationToolbarButtonHidden = YES;
            },
        PTSearchButtonKey:
            ^{
                documentController.searchButtonHidden = YES;
            },
        PTShareButtonKey:
            ^{
                documentController.shareButtonHidden = YES;
            },
        PTViewControlsButtonKey:
            ^{
                documentController.viewerSettingsButtonHidden = YES;
            },
        PTThumbnailsButtonKey:
            ^{
                documentController.thumbnailBrowserButtonHidden = YES;
            },
        PTListsButtonKey:
            ^{
                documentController.navigationListsButtonHidden = YES;
            },
        PTReflowModeButtonKey:
            ^{
                documentController.readerModeButtonHidden = YES;
                documentController.settingsViewController.viewModeReaderHidden = YES;
            },
        PTThumbnailSliderKey:
            ^{
                documentController.thumbnailSliderHidden = YES;
            },
        PTSaveCopyButtonKey:
            ^{
                documentController.exportButtonHidden = YES;
            },
        PTEditPagesButtonKey:
            ^{
                documentController.addPagesButtonHidden = YES;
            },
//        PTPrintButtonKey:
//            ^{
//
//            },
//        PTCloseButtonKey:
//            ^{
//
//            },
//        PTFillAndSignButtonKey:
//            ^{
//
//            },
//        PTPrepareFormButtonKey:
//            ^{
//
//            },
        PTOutlineListButtonKey:
            ^{
                documentController.outlineListHidden = YES;
            },
        PTAnnotationListButtonKey:
            ^{
                documentController.annotationListHidden = YES;
            },
        PTUserBookmarkListButtonKey:
            ^{
                documentController.bookmarkListHidden = YES;
            },
        PTLayerListButtonKey:
            ^{
                documentController.pdfLayerListHidden = YES;
                documentController.navigationListsViewController.pdfLayerViewControllerVisibility = PTNavigationListsViewControllerVisibilityAlwaysHidden;
            },
        PTEditMenuButtonKey:
            ^{
                documentController.toolGroupManager.editingEnabled = NO;
            },
        PTCropPageButtonKey:
            ^{
                documentController.settingsViewController.cropPagesHidden = YES;
            },
        PTUndoKey:
            ^{
                [documentController.toolManager.undoManager disableUndoRegistration];
            },
        PTRedoKey:
            ^{
                [documentController.toolManager.undoManager disableUndoRegistration];
            },
        PTMoreItemsButtonKey:
            ^{
                documentController.moreItemsButtonHidden = YES;
            },
        PTSaveIdenticalCopyButtonKey:
            ^ {
                if (![documentController isExportButtonHidden]) {
                    NSMutableArray * exportItems = [documentController.exportItems mutableCopy];
                    [exportItems removeObject:documentController.exportCopyButtonItem];
                    documentController.exportItems = [exportItems copy];
                }
            },
        PTSaveFlattenedCopyButtonKey:
            ^{
                if (![documentController isExportButtonHidden]) {
                    NSMutableArray * exportItems = [documentController.exportItems mutableCopy];
                    [exportItems removeObject:documentController.exportFlattenedCopyButtonItem];
                    documentController.exportItems = [exportItems copy];
                }
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
    
    [self disableTools:elementsToDisable documentController:documentController];
}

#pragma mark - PTTabbedDocumentViewControllerDelegate

- (void)tabbedDocumentViewController:(PTTabbedDocumentViewController *)tabbedDocumentViewController willAddDocumentViewController:(PTFlutterDocumentController *)documentController
{
    documentController.delegate = self;
    documentController.plugin = self;
    
    if (self.config && documentController.isDocCtrlrConfigured == NO) {
        [[self class] configureDocumentController:documentController
                                           withConfig:self.config];
        documentController.docCtrlrConfigured = YES;
    }
}

- (BOOL)tabbedDocumentViewController:(PTTabbedDocumentViewController *)tabbedDocumentViewController shouldHideTabBarForTraitCollection:(UITraitCollection *)traitCollection
{
    // Always show tab bar when enabled, regardless of the trait collection.
    return NO;
}

#pragma mark - PTDocumentControllerDelegate

- (void)documentControllerDidOpenDocument:(PTDocumentController *)documentController
{
    NSLog(@"Document opened successfully");
    FlutterResult result = ((PTFlutterDocumentController*)documentController).openResult;
    if (result) {
        result(@"Opened Document Successfully");
    }
}

- (void)documentController:(PTDocumentController *)documentController didFailToOpenDocumentWithError:(NSError *)error
{
    NSLog(@"Failed to open document: %@", error);
    FlutterResult result = ((PTFlutterDocumentController*)documentController).openResult;
    [self documentController:documentController documentError:nil];
    if (result) {
        result([@"Opened Document Failed: %@" stringByAppendingString:error.description]);
    } 
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
        case behaviorActivatedId:
            self.behaviorActivatedEventSink = events;
            break;
        case longPressMenuPressedId:
            self.longPressMenuPressedEventSink = events;
            break;
        case annotationMenuPressedId:
            self.annotationMenuPressedEventSink = events;
            break;
        case leadingNavButtonPressedId:
            self.leadingNavButtonPressedEventSink = events;
            break;
        case pageChangedId:
            self.pageChangedEventSink = events;
            break;
        case zoomChangedId:
            self.zoomChangedEventSink = events;
            break;
        case pageMovedId:
            self.pageMovedEventSink = events;
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
        case behaviorActivatedId:
            self.behaviorActivatedEventSink = nil;
            break;
        case longPressMenuPressedId:
            self.longPressMenuPressedEventSink = nil;
            break;
        case annotationMenuPressedId:
            self.annotationMenuPressedEventSink = nil;
            break;
        case leadingNavButtonPressedId:
            self.leadingNavButtonPressedEventSink = nil;
            break;
        case pageChangedId:
            self.pageChangedEventSink = nil;
            break;
        case zoomChangedId:
            self.zoomChangedEventSink = nil;
            break;
        case pageMovedId:
            self.pageMovedEventSink = nil;
            break;
    }
    
    return Nil;
}

#pragma mark - FlutterPlatformView

-(UIView*)view
{
    // Note: this will only be called if it is the widget version
    return self.tabbedDocumentViewController.navigationController.view;
}

#pragma mark - Cleanup

-(void)dealloc
{
    if (self.isWidgetView)
    {
        [self.tabbedDocumentViewController.navigationController willMoveToParentViewController:nil];
        [self.tabbedDocumentViewController.navigationController removeFromParentViewController];
    }
}

#pragma mark - EventSinks

-(void)documentController:(PTDocumentController*)documentController bookmarksDidChange:(NSString*)bookmarkJson
{
    if(self.bookmarkEventSink != nil)
    {
        self.bookmarkEventSink(bookmarkJson);
    }
}

-(void)documentController:(PTDocumentController*)documentController annotationsAsXFDFCommand:(NSString*)xfdfCommand
{
    if(self.xfdfEventSink != nil)
    {
        self.xfdfEventSink(xfdfCommand);
    }
}

-(void)documentController:(PTDocumentController*)documentController documentLoadedFromFilePath:(NSString*)filePath
{
    if(self.documentLoadedEventSink != nil)
    {
        self.documentLoadedEventSink(filePath);
    }
}

-(void)documentController:(PTDocumentController*)documentController documentError:(nullable NSError*)error
{
    if(self.documentErrorEventSink != nil)
    {
        self.documentErrorEventSink(nil);
    }
}

-(void)documentController:(PTDocumentController*)documentController annotationsChangedWithActionString:(NSString*)annotationsWithActionString
{
    if(self.annotationChangedEventSink != nil)
    {
        self.annotationChangedEventSink(annotationsWithActionString);
    }
}

-(void)documentController:(PTDocumentController*)documentController annotationsSelected:(NSString*)annotationsString
{
    if(self.annotationsSelectedEventSink != nil)
    {
        self.annotationsSelectedEventSink(annotationsString);
    }
}

-(void)documentController:(PTDocumentController*)documentController formFieldValueChanged:(NSString*)fieldsString
{
    if(self.formFieldValueChangedEventSink != nil)
    {
        self.formFieldValueChangedEventSink(fieldsString);
    }
}

-(void)documentController:(PTDocumentViewController*)docVC behaviorActivated:(NSString*)behaviorString
{
    if(self.behaviorActivatedEventSink != nil)
    {
        self.behaviorActivatedEventSink(behaviorString);
    }
}

-(void)documentController:(PTDocumentController*)docVC longPressMenuPressed:(NSString*)longPressMenuPressedString
{
    if (self.longPressMenuPressedEventSink != nil)
    {
        self.longPressMenuPressedEventSink(longPressMenuPressedString);
    }
}

-(void)documentController:(PTDocumentController *)docVC annotationMenuPressed:(NSString*)annotationMenuPressedString
{
    if (self.annotationMenuPressedEventSink != nil)
    {
        self.annotationMenuPressedEventSink(annotationMenuPressedString);
    }
}
    
-(void)documentController:(PTDocumentController *)docVC leadingNavButtonClicked:(nullable NSString *)nav
{
    if (self.leadingNavButtonPressedEventSink != nil)
    {
        self.leadingNavButtonPressedEventSink(nil);
    }
}

-(void)documentController:(PTDocumentController *)docVC pageChanged:(NSString*)pageNumbersString
{
    if (self.pageChangedEventSink != nil)
    {
        self.pageChangedEventSink(pageNumbersString);
    }
}

-(void)documentController:(PTDocumentController *)docVC zoomChanged:(NSNumber*)zoom
{
    if (self.zoomChangedEventSink != nil)
    {
        self.zoomChangedEventSink(zoom);
    }
}

-(void)documentController:(PTDocumentController *)docVC pageMoved:(NSString *)pageNumbersString
{
    if (self.pageMovedEventSink != nil)
    {
        self.pageMovedEventSink(pageNumbersString);
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
    } else if ([call.method isEqualToString:PTSetPropertiesForAnnotationKey]) {
        NSString *annotation = [PdftronFlutterPlugin PT_idAsNSString:call.arguments[PTAnnotationArgumentKey]];
        NSString *properties = [PdftronFlutterPlugin PT_idAsNSString:call.arguments[PTAnnotationPropertiesArgumentKey]];
        [self setPropertiesForAnnotation:annotation properties:properties resultToken:result];
    } else if ([call.method isEqualToString:PTGroupAnnotationsKey]) {
        NSString *primaryAnnotation = [PdftronFlutterPlugin PT_idAsNSString:call.arguments[PTAnnotationArgumentKey]];
        NSString *subAnnotations = [PdftronFlutterPlugin PT_idAsNSString:call.arguments[PTAnnotationListArgumentKey]];
        [self groupAnnotations:primaryAnnotation subAnnotations:subAnnotations resultToken:result];
    } else if ([call.method isEqualToString:PTUngroupAnnotationsKey]) {
        NSString *annotations = [PdftronFlutterPlugin PT_idAsNSString:call.arguments[PTAnnotationListArgumentKey]];
        [self ungroupAnnotations:annotations resultToken:result];
    } else if ([call.method isEqualToString:PTImportAnnotationCommandKey]) {
        NSString *xfdfCommand = [PdftronFlutterPlugin PT_idAsNSString:call.arguments[PTXfdfCommandArgumentKey]];
        [self importAnnotationCommand:xfdfCommand resultToken:result];
    } else if ([call.method isEqualToString:PTImportBookmarksKey]) {
        NSString *bookmarkJson = [PdftronFlutterPlugin PT_idAsNSString:call.arguments[PTBookmarkJsonArgumentKey]];
        [self importBookmarks:bookmarkJson resultToken:result];
    } else if ([call.method isEqualToString:PTAddBookmarkKey]) {
        NSString *title = [PdftronFlutterPlugin PT_idAsNSString:call.arguments[PTBookmarkTitleArgumentKey]];
        NSNumber *pageNumber = [PdftronFlutterPlugin PT_idAsNSNumber:call.arguments[PTPageNumberArgumentKey]];
        [self addBookmark:title pageNumber:pageNumber resultToken:result];
    } else if ([call.method isEqualToString:PTSaveDocumentKey]) {
        [self saveDocument:result];
    } else if ([call.method isEqualToString:PTCommitToolKey]) {
        [self commitTool:result];
    } else if ([call.method isEqualToString:PTGetPageCountKey]) {
        [self getPageCount:result];
    } else if ([call.method isEqualToString:PTUndoKey]) {
        [self undo:result];
    } else if ([call.method isEqualToString:PTRedoKey]) {
        [self redo:result];
    } else if ([call.method isEqualToString:PTCanUndoKey]) {
        [self canUndo:result];
    } else if ([call.method isEqualToString:PTCanRedoKey]) {
        [self canRedo:result];
    } else if ([call.method isEqualToString:PTGetPageCropBoxKey]) {
        NSNumber *pageNumber = [PdftronFlutterPlugin PT_idAsNSNumber:call.arguments[PTPageNumberArgumentKey]];
        [self getPageCropBox:pageNumber resultToken:result];
    } else if ([call.method isEqualToString:PTGetPageRotationKey]) {
        NSNumber *pageNumber = [PdftronFlutterPlugin PT_idAsNSNumber:call.arguments[PTPageNumberArgumentKey]];
        [self getPageRotation:pageNumber resultToken:result];
    } else if ([call.method isEqualToString:PTRotateClockwiseKey]) {
        [self rotateClockwise:result];
    } else if ([call.method isEqualToString:PTRotateCounterClockwiseKey]) {
        [self rotateCounterClockwise:result];
    } else if ([call.method isEqualToString:PTSetCurrentPageKey]) {
        NSNumber* pageNumber = [PdftronFlutterPlugin PT_idAsNSNumber:call.arguments[PTPageNumberArgumentKey]];
        [self setCurrentPage:pageNumber resultToken:result];
    } else if ([call.method isEqualToString:PTGotoPreviousPageKey]) {
        [self gotoPreviousPage:result];
    } else if ([call.method isEqualToString:PTGotoNextPageKey]) {
        [self gotoNextPage:result];
    } else if ([call.method isEqualToString:PTGotoFirstPageKey]) {
        [self gotoFirstPage:result];
    } else if ([call.method isEqualToString:PTGotoLastPageKey]) {
        [self gotoLastPage:result];

    } else if ([call.method isEqualToString:PTGetDocumentPathKey]) {
        [self getDocumentPath:result];
    } else if ([call.method isEqualToString:PTSetToolModeKey]) {
           NSString *toolMode = [PdftronFlutterPlugin PT_idAsNSString:call.arguments[PTToolModeArgumentKey]];
           [self setToolMode:toolMode resultToken:result];
    } else if ([call.method isEqualToString:PTSetFlagForFieldsKey]) {
        NSArray *fieldNames = [PdftronFlutterPlugin PT_idAsArray:call.arguments[PTFieldNamesArgumentKey]];
        NSNumber *flag = [PdftronFlutterPlugin PT_idAsNSNumber:call.arguments[PTFlagArgumentKey]];
        bool flagValue = [[PdftronFlutterPlugin PT_idAsNSNumber:call.arguments[PTFlagValueArgumentKey]] boolValue];
        [self setFlagForFields:fieldNames flag:flag flagValue:flagValue resultToken:result];
    } else if ([call.method isEqualToString:PTSetValuesForFieldsKey]) {
        NSString *fieldWithValuesString = [PdftronFlutterPlugin PT_idAsNSString:call.arguments[PTFieldsArgumentKey]];
        [self setValuesForFields:fieldWithValuesString resultToken:result];
    } else if ([call.method isEqualToString:PTSetLeadingNavButtonIconKey]) {
        NSString* leadingNavButtonIcon = [PdftronFlutterPlugin PT_idAsNSString:call.arguments[PTLeadingNavButtonIconArgumentKey]];
        [self setLeadingNavButtonIcon:leadingNavButtonIcon resultToken:result];
    } else if ([call.method isEqualToString:PTCloseAllTabsKey]) {
        [self closeAllTabs:result];
    } else if ([call.method isEqualToString:PTDeleteAllAnnotationsKey]) {
        [self deleteAllAnnotations:result];
    } else if ([call.method isEqualToString:PTExportAsImageKey]) {
        NSNumber* pageNumber = [PdftronFlutterPlugin PT_idAsNSNumber:call.arguments[PTPageNumberArgumentKey]];
        NSNumber* dpi = [PdftronFlutterPlugin PT_idAsNSNumber:call.arguments[PTDpiArgumentKey]];
        NSString* exportFormat = [PdftronFlutterPlugin PT_idAsNSString:call.arguments[PTExportFormatArgumentKey]];
        [self exportAsImage:pageNumber dpi:dpi exportFormat:exportFormat filePath:Nil resultToken:result];
    } else if ([call.method isEqualToString:PTExportAsImageFromFilePathKey]) {
        NSNumber* pageNumber = [PdftronFlutterPlugin PT_idAsNSNumber:call.arguments[PTPageNumberArgumentKey]];
        NSNumber* dpi = [PdftronFlutterPlugin PT_idAsNSNumber:call.arguments[PTDpiArgumentKey]];
        NSString* exportFormat = [PdftronFlutterPlugin PT_idAsNSString:call.arguments[PTExportFormatArgumentKey]];
        NSString* filePath = [PdftronFlutterPlugin PT_idAsNSString:call.arguments[PTPathArgumentKey]];
        [self exportAsImage:pageNumber dpi:dpi exportFormat:exportFormat filePath:filePath resultToken:result];
    } else if ([call.method isEqualToString:PTOpenAnnotationListKey]) {
        [self openAnnotationList:result];
    } else if ([call.method isEqualToString:PTOpenBookmarkListKey]) {
        [self openBookmarkList:result];
    } else if ([call.method isEqualToString:PTOpenOutlineListKey]) {
        [self openOutlineList:result];
    } else if ([call.method isEqualToString:PTOpenLayersListKey]) {
        [self openLayersList:result];
    } else if ([call.method isEqualToString:PTOpenThumbnailsViewKey]) {
        [self openThumbnailsView:result];
    } else if ([call.method isEqualToString:PTOpenAddPagesViewKey]) {
        NSDictionary* rect = [PdftronFlutterPlugin PT_idAsNSDict:call.arguments[PTSourceRectArgumentKey]];
        [self openAddPagesView:result rect:rect];
    } else if ([call.method isEqualToString:PTOpenViewSettingsKey]) {
        NSDictionary* rect = [PdftronFlutterPlugin PT_idAsNSDict:call.arguments[PTSourceRectArgumentKey]];
        [self openViewSettings:result rect:rect];
    } else if ([call.method isEqualToString:PTOpenCropKey]) {
        [self openCrop:result];
    } else if ([call.method isEqualToString:PTOpenManualCropKey]) {
        [self openManualCrop:result];
    } else if ([call.method isEqualToString:PTOpenSearchKey]) {
        [self openSearch:result];
    } else if ([call.method isEqualToString:PTOpenTabSwitcherKey]) {
        [self openTabSwitcher:result];
    } else if ([call.method isEqualToString:PTOpenGoToPageViewKey]) {
        [self openGoToPageView:result];
    } else if ([call.method isEqualToString:PTOpenNavigationListsKey]) {
        [self openNavigationLists:result];
    } else if ([call.method isEqualToString:PTGetCurrentPageKey]) {
        [self getCurrentPage:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

+ (PTAnnot *)findAnnotWithUniqueID:(NSString *)uniqueID onPageNumber:(int)pageNumber documentController:(PTDocumentController *)documentController error:(NSError **)error
{
    if (uniqueID.length == 0 || pageNumber < 1) {
        return nil;
    }
    PTPDFViewCtrl *pdfViewCtrl = documentController.pdfViewCtrl;
    __block PTAnnot *resultAnnot;

    [documentController.pdfViewCtrl DocLockReadWithBlock:^(PTPDFDoc * _Nullable doc) {
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

+(NSArray<PTAnnot *> *)getAnnotationsOnPage:(int)pageNumber documentController:(PTDocumentController *)documentController
{
    __block NSArray<PTAnnot *> *annots;
    NSError* error;
    [documentController.pdfViewCtrl DocLockReadWithBlock:^(PTPDFDoc * _Nullable doc) {
        annots = [documentController.pdfViewCtrl GetAnnotationsOnPage:pageNumber];
    } error:&error];
    
    if (error) {
        NSLog(@"Error: There was an error while trying to find annotations in page number. %@", error.localizedDescription);
    }
    
    return annots;
}

+(NSArray<PTAnnot *> *)findAnnotsWithUniqueIDs:(NSArray <NSDictionary *>*)idPageNumberPairs documentController:(PTDocumentController *)documentController error:(NSError **)error
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
        
        [documentController.pdfViewCtrl DocLockReadWithBlock:^(PTPDFDoc * _Nullable doc) {
            annotsOnCurrPage = [PdftronFlutterPlugin getAnnotationsOnPage:[pageNumber intValue] documentController:documentController];
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

- (void)handleOpenDocumentMethod:(NSDictionary<NSString *, id> *)arguments resultToken:(FlutterResult)flutterResult
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
    
    NSString* config = arguments[PTConfigArgumentKey];
    self.config = config;
    
    // get base
    
    if (!self.tabbedDocumentViewController) {
        [self initTabbedDocumentViewController];
    }
    
    [PdftronFlutterPlugin configureTabbedDocumentViewController:self.tabbedDocumentViewController withConfig:config];
    
    NSError* error;
    
    NSDictionary *configDict = [PdftronFlutterPlugin PT_idAsNSDict:[PdftronFlutterPlugin PT_JSONStringToId:config]];
    
    bool isBase64 = NO;
    if([[configDict allKeys] containsObject:PTIsBase64StringKey]) {
        NSNumber* isBase64Number= [PdftronFlutterPlugin getConfigValue:configDict configKey:PTIsBase64StringKey class:[NSNumber class] error:&error];
        if (error) {
            NSLog(@"An error occurs with config %@: %@", PTIsBase64StringKey, error.localizedDescription);
        }
        
        isBase64 = [isBase64Number boolValue];
    }
    
    if (!isBase64) {
        // Open a file URL.
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:document withExtension:@"pdf"];
        if ([document containsString:@"://"]) {
            fileURL = [NSURL URLWithString:document];
        } else if ([document hasPrefix:@"/"]) {
            fileURL = [NSURL fileURLWithPath:document];
        }
            
        [self.tabbedDocumentViewController openDocumentWithURL:fileURL
                                                      password:password];
    } else {
        NSString *base64FileExtension = @".pdf";
        if([[configDict allKeys] containsObject:PTBase64FileExtensionKey]) {
            NSString *extension = [PdftronFlutterPlugin getConfigValue:configDict configKey:PTBase64FileExtensionKey class:[NSString class] error:&error];
            if (error) {
                NSLog(@"An error occurs with config %@: %@", PTBase64FileExtensionKey, error.localizedDescription);
            } else {
                base64FileExtension = extension;
            }
            
            NSData *data = [[NSData alloc] initWithBase64EncodedString:document options:0];

            NSMutableString *path = [[NSMutableString alloc] init];
            [path appendFormat:@"%@tmp%@%@", NSTemporaryDirectory(), [[NSUUID UUID] UUIDString], base64FileExtension];

            NSURL *fileURL = [NSURL fileURLWithPath:path isDirectory:NO];
            NSError* error;

            [data writeToURL:fileURL options:NSDataWritingAtomic error:&error];
            
            if (error) {
                NSLog(@"Error: There was an error while trying to create a temporary file for base64 string. %@", error.localizedDescription);
                return;
            }
            
            [[(PTFlutterTabbedDocumentController *)(self.tabbedDocumentViewController) tempFiles] addObject:path];
            
            [self.tabbedDocumentViewController openDocumentWithURL:fileURL
                                                          password:password];
        }
    }
    
    if (!self.tabbedDocumentViewController.navigationController) {
        
        [self presentTabbedDocumentViewController];
    }
    
    ((PTFlutterDocumentController*)self.tabbedDocumentViewController.childViewControllers.lastObject).openResult = flutterResult;
    
    PTFlutterDocumentController *documentController = (PTFlutterDocumentController *) [self getDocumentController];
    if (!documentController.isDocCtrlrConfigured) {
        [[self class] configureDocumentController:documentController
                                           withConfig:self.config];
        documentController.docCtrlrConfigured = YES;
    }
}

- (void)importAnnotations:(NSString *)xfdf resultToken:(FlutterResult)flutterResult
{
    PTDocumentController *documentController = [self getDocumentController];
    if(documentController.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        
        flutterResult([FlutterError errorWithCode:@"import_annotations" message:@"Failed to import annotations" details:@"Error: The document view controller has no document."]);
        return;
    }
    
    __block BOOL hasDownloader = NO;
    
    NSError* error;
    [documentController.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        hasDownloader = [doc HasDownloader];
    } error:&error];
    if (hasDownloader) {
        // too soon
        NSLog(@"Error: The document is still being downloaded.");
        flutterResult([FlutterError errorWithCode:@"import_annotation_command" message:@"Failed to import annotation command" details:@"Error: The document is still being downloaded."]);
        return;
    }
    
    PTAnnotationManager * const annotationManager = documentController.toolManager.annotationManager;
    
    NSError *updateError = nil;
    const BOOL updateSuccess = [annotationManager updateAnnotationsWithXFDFString:xfdf
                                                                            error:&updateError];
    if (!updateSuccess) {
        if (updateError) {
            NSLog(@"Error: There was an error while trying to import annotation command. %@", updateError.localizedDescription);
        }
        flutterResult([FlutterError errorWithCode:@"import_annotation_command" message:@"Failed to import annotation command" details:@"Error: There was an error while trying to import annotation command."]);
    } else {
        flutterResult(nil);
    }
}

- (void)exportAnnotations:(NSString *)annotationList resultToken:(FlutterResult)flutterResult
{
    PTDocumentController *documentController = [self getDocumentController];
    if(documentController.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        
        flutterResult([FlutterError errorWithCode:@"export_annotations" message:@"Failed to export annotations" details:@"Error: The document view controller has no document."]);
        return;
    }
    
    NSError *error;
    
    if (!annotationList) {
        [documentController.pdfViewCtrl DocLockReadWithBlock:^(PTPDFDoc * _Nullable doc) {
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
    
    NSArray <PTAnnot *> *matchingAnnots = [PdftronFlutterPlugin findAnnotsWithUniqueIDs:annotArray documentController:documentController error:&error];
    
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
    [documentController.pdfViewCtrl DocLockReadWithBlock:^(PTPDFDoc * _Nullable doc) {
        
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
    PTDocumentController *documentController = [self getDocumentController];
    [documentController.toolManager changeTool:[PTPanTool class]];
    
    if(documentController.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        
        flutterResult([FlutterError errorWithCode:@"flatten_annotations" message:@"Failed to flatten annotations" details:@"Error: The document view controller has no document."]);
        return;
    }
    
    NSError *error;
    
    [documentController.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
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
    PTDocumentController *documentController = [self getDocumentController];
    if(documentController.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");

        flutterResult([FlutterError errorWithCode:@"delete_annotations" message:@"Failed to delete annotations" details:@"Error: The document view controller has no document."]);
        return;
    }
    
    NSError* error;
    
    NSArray *annotArray = [PdftronFlutterPlugin PT_idAsArray:[PdftronFlutterPlugin PT_JSONStringToId:annotationList]];
    
    NSArray* matchingAnnots = [PdftronFlutterPlugin findAnnotsWithUniqueIDs:annotArray documentController:documentController error:&error];
    
    if (error) {
        NSLog(@"Error: Failed to get annotations from doc. %@", error.localizedDescription);
        
        flutterResult([FlutterError errorWithCode:@"delete_annotations" message:@"Failed to delete annotations" details:@"Error: Failed to get annotations from doc."]);
        return;
    }
    
    [documentController.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        for (PTAnnot *annot in matchingAnnots) {
            PTPage *page = [annot GetPage];
            if (page && [page IsValid]) {
                int pageNumber = [page GetIndex];
                [documentController.toolManager willRemoveAnnotation:annot onPageNumber:pageNumber];
                
                [page AnnotRemoveWithAnnot:annot];
                [documentController.toolManager annotationRemoved:annot onPageNumber:pageNumber];
            }
        }
        [documentController.pdfViewCtrl Update:YES];
    } error:&error];
        
    if (error) {
        NSLog(@"Error: Failed to delete annotations from doc. %@", error.localizedDescription);
            
        flutterResult([FlutterError errorWithCode:@"delete_annotations" message:@"Failed to delete annotations" details:@"Error: Failed to delete annotations from doc."]);
        return;
    }
    
    [documentController.toolManager changeTool:[PTPanTool class]];
    
    flutterResult(nil);
}

- (void)deleteAllAnnotations:(FlutterResult)flutterResult
{
    PTDocumentController *documentController = [self getDocumentController];
    if(documentController.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");

        flutterResult([FlutterError errorWithCode:@"delete_all_annotations" message:@"Failed to delete all annotations" details:@"Error: The document view controller has no document."]);
        return;
    }

    NSError* error;

    if (error) {
        NSLog(@"Error: Failed to get annotations from doc. %@", error.localizedDescription);

        flutterResult([FlutterError errorWithCode:@"delete_all_annotations" message:@"Failed to delete all annotations" details:@"Error: Failed to delete all annotations from doc."]);
        return;
    }

    [documentController.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        PTPageIterator *pageIterator = [doc GetPageIterator:1];
        int pageNumber = 1;
        while ([pageIterator HasNext]) {
            PTPage *page = [pageIterator Current];
            if ([page IsValid]) {
                int num_annots = [page GetNumAnnots];
                for (int i = num_annots - 1; i >= 0; i--)
                {
                    PTAnnot* annot = [page GetAnnot:i];
                    if (![annot IsValid] || annot == nil) {
                        continue;
                    }
                    if ([annot GetType] != e_ptLink && [annot GetType] != e_ptWidget) {
                        [documentController.toolManager willRemoveAnnotation:annot onPageNumber:pageNumber];
                        [page AnnotRemoveWithAnnot:annot];
                        [documentController.toolManager annotationRemoved:annot onPageNumber:pageNumber];
                    }
                }
            }
            [pageIterator Next];
            pageNumber++;
        }
    } error:&error];

    [documentController.pdfViewCtrl Update:YES];
    [documentController.toolManager changeTool:[PTPanTool class]];

    if (error) {
        NSLog(@"Error: Failed to delete all annotations from doc. %@", error.localizedDescription);

        flutterResult([FlutterError errorWithCode:@"delete_all_annotations" message:@"Failed to delete annotations" details:@"Error: Failed to delete annotations from doc."]);
        return;
    }

    flutterResult(nil);
}

- (void)selectAnnotation:(NSString *)annotation resultToken:(FlutterResult)flutterResult
{
    PTDocumentController *documentController = [self getDocumentController];
    if(documentController.document == Nil)
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
    
    PTAnnot *annot = [PdftronFlutterPlugin findAnnotWithUniqueID:annotId onPageNumber:pageNumber documentController:documentController error:&error];
    
    if (error) {
        NSLog(@"Error: Failed to find annotation with unique id. %@", error.localizedDescription);
        
        flutterResult([FlutterError errorWithCode:@"select_annotations" message:@"Failed to select annotations" details:@"Error: Failed to find annotation with unique id."]);
        return;
    }
    
    [documentController.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        [documentController.toolManager selectAnnotation:annot onPageNumber:pageNumber];
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
    PTDocumentController *documentController = [self getDocumentController];
    if(documentController.document == Nil)
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
            
        PTAnnot *currentAnnot = [PdftronFlutterPlugin findAnnotWithUniqueID:currentAnnotationId onPageNumber:currentPageNumber documentController:documentController error:&error];
        
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
                    
                [documentController.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
                    [documentController.toolManager willModifyAnnotation:currentAnnot onPageNumber:currentPageNumber];
                    
                    [currentAnnot SetFlag:flagNumber value:currentFlagValue];
                    
                    [documentController.toolManager annotationModified:currentAnnot onPageNumber:currentPageNumber];
                    }error:&error];
                
                if (error) {
                    NSLog(@"Error: Failed to set flag for annotation. %@", error.localizedDescription);
                }
            }
        }
    }
    
    flutterResult(nil);
}

- (void)setPropertiesForAnnotation:(NSString *)annotation properties:(NSString *)properties resultToken:(FlutterResult)flutterResult
{
    PTDocumentController *documentController = [self getDocumentController];
    if(documentController.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        flutterResult([FlutterError errorWithCode:@"set_properties_for_annotation" message:@"Failed to set properties for annotation" details:@"Error: The document view controller has no document."]);
        return;
    }
    
    NSDictionary *annotationMap = [PdftronFlutterPlugin PT_idAsNSDict:[PdftronFlutterPlugin PT_JSONStringToId:annotation]];
    
    NSString *annotId = [PdftronFlutterPlugin PT_idAsNSString:annotationMap[PTAnnotIdKey]];
    int pageNumber = [[PdftronFlutterPlugin PT_idAsNSNumber:annotationMap[PTAnnotPageNumberKey]] intValue];
    
    NSError* error;
    
    PTAnnot *annot = [PdftronFlutterPlugin findAnnotWithUniqueID:annotId onPageNumber:pageNumber documentController:documentController error:&error];
    
    if (error) {
        NSLog(@"Error: Failed to find annotation with unique id. %@", error.localizedDescription);
        
        flutterResult([FlutterError errorWithCode:@"set_properties_for_annotation" message:@"Failed to set properties for annotation" details:@"Error: Failed to find annotation with unique id."]);
        return;
    } else if (![annot IsValid]) {
        NSLog(@"Error: Failed to find annotation with unique id. The requested annotation does not exist");
        
        flutterResult([FlutterError errorWithCode:@"set_properties_for_annotation" message:@"Failed to set properties for annotation" details:@"Error: Failed to find annotation with unique id."]);
        return;
    }
    
    // Update the properties
    
    [documentController.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        
        NSDictionary *propertyMap = [PdftronFlutterPlugin PT_idAsNSDict:[PdftronFlutterPlugin PT_JSONStringToId:properties]];
        
        if (!propertyMap) {
            return;
        }
        
        [documentController.toolManager willModifyAnnotation:annot onPageNumber:pageNumber];
        
        // contents
        NSString* annotContents = [PdftronFlutterPlugin PT_idAsNSString:propertyMap[PTContentsAnnotationPropertyKey]];
        if (annotContents) {
            [annot SetContents:annotContents];
        }
        
        // rect
        NSDictionary *annotRect = [PdftronFlutterPlugin PT_idAsNSDict:[PdftronFlutterPlugin PT_JSONStringToId:propertyMap[PTRectAnnotationPropertyKey]]];
        if (annotRect) {
            NSNumber *rectX1 = [PdftronFlutterPlugin PT_idAsNSNumber:annotRect[PTX1Key]];
            NSNumber *rectY1 = [PdftronFlutterPlugin PT_idAsNSNumber:annotRect[PTY1Key]];
            NSNumber *rectX2 = [PdftronFlutterPlugin PT_idAsNSNumber:annotRect[PTX2Key]];
            NSNumber *rectY2 = [PdftronFlutterPlugin PT_idAsNSNumber:annotRect[PTY2Key]];
            if (rectX1 && rectY1 && rectX2 && rectY2) {
                PTPDFRect *rect = [[PTPDFRect alloc] initWithX1:[rectX1 doubleValue] y1:[rectY1 doubleValue] x2:[rectX2 doubleValue] y2:[rectY2 doubleValue]];
                [annot SetRect:rect];
            }
        }
        
        // rotation
        NSNumber *annotRotation = [PdftronFlutterPlugin PT_idAsNSNumber:propertyMap[PTRotationAnnotationPropertyKey]];
        if (annotRotation) {
            [annot SetRotation:annotRotation.intValue];
            [annot RefreshAppearance];
        }
        
        if ([annot IsMarkup]) {
            PTMarkup *markupAnnot = [[PTMarkup alloc] initWithAnn:annot];
            
            // subject
            NSString *annotSubject = [PdftronFlutterPlugin PT_idAsNSString:propertyMap[PTSubjectAnnotationPropertyKey]];
            if (annotSubject) {
                [markupAnnot SetSubject:annotSubject];
            }
            
            // title
            NSString *annotTitle = [PdftronFlutterPlugin PT_idAsNSString:propertyMap[PTTitleAnnotationPropertyKey]];
            if (annotTitle) {
                [markupAnnot SetTitle:annotTitle];
            }
            
            // contentRect
            NSDictionary *annotContentRect = [PdftronFlutterPlugin PT_idAsNSDict:[PdftronFlutterPlugin PT_JSONStringToId:propertyMap[PTContentRectAnnotationPropertyKey]]];
            if (annotRect) {
                NSNumber *rectX1 = [PdftronFlutterPlugin PT_idAsNSNumber:annotContentRect[PTX1Key]];
                NSNumber *rectY1 = [PdftronFlutterPlugin PT_idAsNSNumber:annotContentRect[PTY1Key]];
                NSNumber *rectX2 = [PdftronFlutterPlugin PT_idAsNSNumber:annotContentRect[PTX2Key]];
                NSNumber *rectY2 = [PdftronFlutterPlugin PT_idAsNSNumber:annotContentRect[PTY2Key]];
                if (rectX1 && rectY1 && rectX2 && rectY2) {
                    PTPDFRect *contentRect = [[PTPDFRect alloc] initWithX1:[rectX1 doubleValue] y1:[rectY1 doubleValue] x2:[rectX2 doubleValue] y2:[rectY2 doubleValue]];
                    [markupAnnot SetContentRect:contentRect];
                }
            }
        }
        
        [documentController.pdfViewCtrl UpdateWithAnnot:annot page_num:(int)pageNumber];
        
        [documentController.toolManager annotationModified:annot onPageNumber:(int)pageNumber];
    } error:&error];
    
    if (error) {
        NSLog(@"Error: Failed to set properties for annotation from doc. %@", error.localizedDescription);
        flutterResult([FlutterError errorWithCode:@"set_properties_for_annotation" message:@"Failed to set properties for annotation" details:@"Error: Failed to set properties for annotation from doc."]);
    } else {
        flutterResult(nil);
    }
}

- (void)groupAnnotations:(NSString *)primaryAnnotation subAnnotations:(NSString *)subAnnotations resultToken:(FlutterResult)flutterResult
{
    PTDocumentController *documentController = [self getDocumentController];
    if(documentController.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        flutterResult([FlutterError errorWithCode:@"group_annotations" message:@"Failed to group annotations" details:@"Error: The document view controller has no document."]);
        return;
    }

    NSDictionary *annotationMap = [PdftronFlutterPlugin PT_idAsNSDict:[PdftronFlutterPlugin PT_JSONStringToId:primaryAnnotation]];

    NSString *annotId = [PdftronFlutterPlugin PT_idAsNSString:annotationMap[PTAnnotIdKey]];
    int pageNumber = [[PdftronFlutterPlugin PT_idAsNSNumber:annotationMap[PTAnnotPageNumberKey]] intValue];

    NSError* error;

    // parent annotation
    PTAnnot *mainAnnot = [PdftronFlutterPlugin findAnnotWithUniqueID:annotId onPageNumber:pageNumber documentController:documentController error:&error];

    if (error) {
        NSLog(@"Error: Failed to find annotation with unique id. %@", error.localizedDescription);

        flutterResult([FlutterError errorWithCode:@"group_annotations" message:@"Failed to group annotations" details:@"Error: Failed to find main annotation with unique id."]);
        return;
    } else if (![mainAnnot IsValid]) {
        NSLog(@"Error: Failed to find main annotation with unique id. The requested annotation does not exist");

        flutterResult([FlutterError errorWithCode:@"group_annotations" message:@"Failed to set properties for annotation" details:@"Error: Failed to find main annotation with unique id."]);
        return;
    }

    // child annotations
    NSArray *annotArray = [PdftronFlutterPlugin PT_idAsArray:[PdftronFlutterPlugin PT_JSONStringToId:subAnnotations]];

    NSArray <PTAnnot *> *matchingAnnots = [PdftronFlutterPlugin findAnnotsWithUniqueIDs:annotArray documentController:documentController error:&error];

    if (error) {
        NSLog(@"Error: Failed to get annotations from doc. %@", error.localizedDescription);

        flutterResult([FlutterError errorWithCode:@"group_annotations" message:@"Failed to group annotations" details:@"Error: Failed to get child annotations from doc."]);
        return;
    }

    if (matchingAnnots.count == 0) {
        flutterResult(@"");
    }

    // group the annotations

    [documentController.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        NSString *mainAnnotID = [mainAnnot GetUniqueIDAsString];
        if (mainAnnotID == nil) {
            mainAnnotID = [NSUUID UUID].UUIDString;
            int bytes = (int)[mainAnnotID lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
            [mainAnnot SetUniqueID:mainAnnotID id_buf_sz:bytes];
        }
        for (PTAnnot *annot in matchingAnnots) {
            [documentController.toolManager willModifyAnnotation:annot onPageNumber:pageNumber];

            PTObj *annotSDFObj = [annot GetSDFObj];
            [annotSDFObj EraseDictElementWithKey:@"RT"];
            [annotSDFObj EraseDictElementWithKey:@"IRT"];
            if (![annot isEqualTo:mainAnnot]) {
                [annotSDFObj PutName:@"RT" name:@"Group"];
                [annotSDFObj Put:@"IRT" obj:[mainAnnot GetSDFObj]];
            }
            [documentController.toolManager annotationModified:annot onPageNumber:(int)pageNumber];
        }
    } error:&error];

    if (error) {
        NSLog(@"Error: Failed to group annotations from doc. %@", error.localizedDescription);
        flutterResult([FlutterError errorWithCode:@"group_annotations" message:@"Failed to group annotations" details:@"Error: Failed to group annotations from doc."]);
    } else {
        flutterResult(nil);
    }
}

- (void)ungroupAnnotations:(NSString *)annotations resultToken:(FlutterResult)flutterResult
{
    PTDocumentController *documentController = [self getDocumentController];
    if(documentController.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        flutterResult([FlutterError errorWithCode:@"ungroup_annotations" message:@"Failed to ungroup annotations" details:@"Error: The document view controller has no document."]);
        return;
    }

    // annotations
    NSArray *annotArray = [PdftronFlutterPlugin PT_idAsArray:[PdftronFlutterPlugin PT_JSONStringToId:annotations]];

    NSError* error;
    NSArray <PTAnnot *> *matchingAnnots = [PdftronFlutterPlugin findAnnotsWithUniqueIDs:annotArray documentController:documentController error:&error];

    if (error) {
        NSLog(@"Error: Failed to get annotations from doc. %@", error.localizedDescription);

        flutterResult([FlutterError errorWithCode:@"ungroup_annotations" message:@"Failed to ungroup annotations" details:@"Error: Failed to get annotations from doc."]);
        return;
    }

    if (matchingAnnots.count == 0) {
        flutterResult(@"");
    }

    [documentController.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        for (NSDictionary *currentAnnotation in annotArray)
        {
            NSString *currentAnnotationId = [PdftronFlutterPlugin PT_idAsNSString:currentAnnotation[PTAnnotIdKey]];
            int pageNumber = [[PdftronFlutterPlugin PT_idAsNSNumber:currentAnnotation[PTAnnotPageNumberKey]] intValue];

            NSError* findAnnotError;
            PTAnnot *annot = [PdftronFlutterPlugin findAnnotWithUniqueID:currentAnnotationId onPageNumber:pageNumber documentController:documentController error:&findAnnotError];
            if (findAnnotError) {
                NSLog(@"Error: Failed to find annotation with unique id. %@", findAnnotError.localizedDescription);
                continue;
            }

            PTObj *annotSDFObj = [annot GetSDFObj];
            [documentController.toolManager willModifyAnnotation:annot onPageNumber:(int)pageNumber];
            [annotSDFObj EraseDictElementWithKey:@"RT"];
            [annotSDFObj EraseDictElementWithKey:@"IRT"];
            [documentController.toolManager annotationModified:annot onPageNumber:(int)pageNumber];
        }
    } error:&error];

    if (error) {
        NSLog(@"Error: Failed to ungroup annotations from doc. %@", error.localizedDescription);
        flutterResult([FlutterError errorWithCode:@"ungroup_annotations" message:@"Failed to ungroup annotations" details:@"Error: Failed to ungroup annotations from doc."]);
    } else {
        flutterResult(nil);
    }
}

- (void)importAnnotationCommand:(NSString *)xfdfCommand resultToken:(FlutterResult)flutterResult
{
    PTDocumentController *documentController = [self getDocumentController];
    if(documentController.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        flutterResult([FlutterError errorWithCode:@"import_annotation_command" message:@"Failed to import annotation command" details:@"Error: The document view controller has no document."]);
        return;
    }
    
    __block BOOL hasDownloader = NO;
    
    NSError* error;
    [documentController.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        hasDownloader = [doc HasDownloader];
    } error:&error];
    if (hasDownloader) {
        // too soon
        NSLog(@"Error: The document is still being downloaded.");
        flutterResult([FlutterError errorWithCode:@"import_annotation_command" message:@"Failed to import annotation command" details:@"Error: The document is still being downloaded."]);
        return;
    }

    PTAnnotationManager * const annotationManager = documentController.toolManager.annotationManager;
    
    NSError *updateError = nil;
    const BOOL updateSuccess = [annotationManager updateAnnotationsWithXFDFCommand:xfdfCommand
                                                                             error:&updateError];
    if (!updateSuccess) {
        if (updateError) {
            NSLog(@"Error: There was an error while trying to import annotation command. %@", updateError.localizedDescription);
        }
        flutterResult([FlutterError errorWithCode:@"import_annotation_command" message:@"Failed to import annotation command" details:@"Error: There was an error while trying to import annotation command."]);
    } else {
        flutterResult(nil);
    }
}

- (void)importBookmarks:(NSString *)bookmarkJson resultToken:(FlutterResult)flutterResult
{
    PTDocumentController *documentController = [self getDocumentController];
    if(documentController.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        flutterResult([FlutterError errorWithCode:@"import_bookmark_json" message:@"Failed to import bookmark json" details:@"Error: The document view controller has no document."]);
        return;
    }
    
    NSError* error;
    
    [documentController.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        if([doc HasDownloader])
        {
            // too soon
            NSLog(@"Error: The document is still being downloaded.");
            flutterResult([FlutterError errorWithCode:@"import_bookmark_json" message:@"Failed to import bookmark json" details:@"Error: The document is still being downloaded."]);
            return;
        }

        [PTBookmarkManager.defaultManager importBookmarksForDoc:doc fromJSONString:bookmarkJson];

    } error:&error];
    
    if(error)
    {
        NSLog(@"Error: There was an error while trying to import annotation command. %@", error.localizedDescription);
        flutterResult([FlutterError errorWithCode:@"import_bookmark_json" message:@"Failed to import bookmark json" details:@"Error: There was an error while trying to import annotation command."]);
    } else {
        flutterResult(nil);
    }
}

- (void)addBookmark:(NSString *)title pageNumber:(NSNumber *)pageNumber resultToken:(FlutterResult)flutterResult
{
    PTDocumentController *documentController = [self getDocumentController];
    if(documentController.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        flutterResult([FlutterError errorWithCode:@"add_bookmark" message:@"Failed to add bookmark" details:@"Error: The document view controller has no document."]);
        return;
    }
    
    NSError* error;
    __block PTUserBookmark * bookmark;
    
    [documentController.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        if([doc HasDownloader])
        {
            // too soon
            NSLog(@"Error: The document is still being downloaded.");
            flutterResult([FlutterError errorWithCode:@"add_bookmark" message:@"Failed to add bookmark" details:@"Error: The document is still being downloaded."]);
            return;
        }
        
        // Export bookmarks to JSON, then to array.
        NSString* json = [PTBookmarkManager.defaultManager exportBookmarksFromDoc:doc];
        NSMutableArray<PTUserBookmark *> * bookmarks = [NSMutableArray arrayWithArray:[PTBookmarkManager.defaultManager bookmarksFromJSONString:json]];
        bookmark = [[PTUserBookmark alloc] initWithTitle:title pageNumber:[pageNumber intValue]];
        [bookmarks addObject:bookmark];
        
        // Convert array back to JSON and import.
        NSString* newJson = [PTBookmarkManager.defaultManager JSONStringFromBookmarks:bookmarks];
        [PTBookmarkManager.defaultManager importBookmarksForDoc:doc fromJSONString:newJson];

    } error:&error];
    
    if(error)
    {
        NSLog(@"Error: There was an error while trying to add bookmark. %@", error.localizedDescription);
        flutterResult([FlutterError errorWithCode:@"add_bookmark" message:@"Failed to add bookmark" details:@"Error: There was an error while trying to add bookmark."]);
    } else {
        flutterResult(nil);
    }
    
    // Raise event.
    PTBookmarkViewController *bookmarkViewController = documentController.navigationListsViewController.bookmarkViewController;
    PTFlutterDocumentController *flutterDocumentController = (PTFlutterDocumentController *) documentController;
    [flutterDocumentController bookmarkViewController:bookmarkViewController didAddBookmark:bookmark];
}

- (void)saveDocument:(FlutterResult)flutterResult
{
    PTFlutterDocumentController *documentController = (PTFlutterDocumentController *)[self getDocumentController];
    
    if(documentController.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        flutterResult([FlutterError errorWithCode:@"save_document" message:@"Failed to save document" details:@"Error: The document view controller has no document."]);
        return;
    }
    
    NSString *filePath = documentController.coordinatedDocument.fileURL.path;
    
    [documentController saveDocument:e_ptincremental completionHandler:^(BOOL success) {
        if (![documentController isBase64]) {
            flutterResult(success ? filePath : nil);
        } else if (!success) {
            flutterResult(nil);
        } else {
            __block NSString *base64String = nil;
            NSError *error = nil;
            [documentController.pdfViewCtrl DocLockReadWithBlock:^(PTPDFDoc * _Nullable doc) {
                NSData *data = [doc SaveToBuf:0];

                base64String = [data base64EncodedStringWithOptions:0];
            } error:&error];
            flutterResult((error == nil) ? base64String : nil);
        }
    }];
}

- (void)commitTool:(FlutterResult)flutterResult
{
    PTDocumentController *documentController = [self getDocumentController];
    PTToolManager *toolManager = documentController.toolManager;
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
    PTDocumentController *documentController = [self getDocumentController];
    if(documentController.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        flutterResult([FlutterError errorWithCode:@"get_page_count" message:@"Failed to get page count" details:@"Error: The document view controller has no document."]);
        return;
    }

    flutterResult([NSNumber numberWithInt:documentController.pdfViewCtrl.pageCount]);
}

- (void)undo:(FlutterResult)flutterResult
{
    PTDocumentController *documentController = [self getDocumentController];
    if (documentController.undoManager == Nil) {
        NSLog(@"Error: The document view controller has no undo manager.");
        flutterResult([FlutterError errorWithCode:@"undo" message:@"Failed to undo" details:@"Error: The document view controller has no undo manager."]);
        return;
    }
    
    [documentController.undoManager undo];
    flutterResult(nil);
}

- (void)redo:(FlutterResult)flutterResult
{
    PTDocumentController *documentController = [self getDocumentController];
    if (documentController.undoManager == Nil) {
        NSLog(@"Error: The document view controller has no undo manager.");
        flutterResult([FlutterError errorWithCode:@"redo" message:@"Failed to redo" details:@"Error: The document view controller has no undo manager."]);
        return;
    }
    
    [documentController.undoManager redo];
    flutterResult(nil);
}

- (void)canUndo:(FlutterResult)flutterResult
{
    PTDocumentController *documentController = [self getDocumentController];
    if (documentController.undoManager == Nil) {
        NSLog(@"Error: The document view controller has no undo manager.");
        flutterResult([FlutterError errorWithCode:@"undo" message:@"Failed to get canUndo" details:@"Error: The document view controller has no undo manager."]);
        return;
    }
    bool canUndo = [documentController.undoManager canUndo];
    flutterResult([NSNumber numberWithBool:canUndo]);
}

- (void)canRedo:(FlutterResult)flutterResult
{
    PTDocumentController *documentController = [self getDocumentController];
    if (documentController.undoManager == Nil) {
        NSLog(@"Error: The document view controller has no undo manager.");
        flutterResult([FlutterError errorWithCode:@"redo" message:@"Failed to get canRedo" details:@"Error: The document view controller has no undo manager."]);
        return;
    }
    
    bool canRedo = [documentController.undoManager canRedo];
    flutterResult([NSNumber numberWithBool:canRedo]);
}

- (void)getPageCropBox:(NSNumber *)pageNumber resultToken:(FlutterResult)flutterResult
{
    PTDocumentController *documentController = [self getDocumentController];
    
    if(documentController.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        flutterResult([FlutterError errorWithCode:@"get_page_crop_box" message:@"Failed to get page crop box" details:@"Error: The document view controller has no document."]);
        return;
    }
    
    NSError *error;
    [documentController.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        
        PTPage *page = [doc GetPage:[pageNumber intValue]];
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
            flutterResult(res);
        } else {
            flutterResult(nil);
        }

    } error:&error];
    
    if(error)
    {
        NSLog(@"Error: There was an error while trying to get page crop box. %@", error.localizedDescription);
        flutterResult([FlutterError errorWithCode:@"save_document" message:@"Failed to get page crop box" details:@"Error: There was an error while trying to get page crop box"]);
    }
}

- (void)getPageRotation:(NSNumber *)pageNumber resultToken:(FlutterResult)flutterResult {
    PTDocumentController *documentController = [self getDocumentController];
    if(documentController.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        flutterResult([FlutterError errorWithCode:@"get_page_rotation" message:@"Failed to get page rotation" details:@"Error: The document view controller has no document."]);
        return;
    }

    __block NSNumber *pageRotation;
    NSError* error;
    [documentController.pdfViewCtrl DocLockReadWithBlock:^(PTPDFDoc * _Nullable doc) {
        PTRotate rotation = [[doc GetPage:pageNumber.unsignedIntValue] GetRotation];
        pageRotation = [NSNumber numberWithInt:(rotation * 90)];
    } error:&error];

    if (error) {
        NSLog(@"Error: There was an error while trying to get the page rotation for page number. %@", error.localizedDescription);
    }
    flutterResult(pageRotation);
}

- (void)rotateClockwise:(FlutterResult)flutterResult {
    PTDocumentController *documentController = [self getDocumentController];
    [documentController.pdfViewCtrl RotateClockwise];
    flutterResult(nil);
}

- (void)rotateCounterClockwise:(FlutterResult)flutterResult {
    PTDocumentController *documentController = [self getDocumentController];
    [documentController.pdfViewCtrl RotateCounterClockwise];
    flutterResult(nil);
}

- (void)setCurrentPage:(NSNumber *)pageNumber resultToken:(FlutterResult)flutterResult {
    PTDocumentController *documentController = [self getDocumentController];
    flutterResult([NSNumber numberWithBool:[documentController.pdfViewCtrl SetCurrentPage:[pageNumber intValue]]]);
}

- (void)gotoPreviousPage:(FlutterResult)flutterResult {
    PTDocumentController *documentController = [self getDocumentController];
    flutterResult([NSNumber numberWithBool:[documentController.pdfViewCtrl GotoPreviousPage]]);
}

- (void)gotoNextPage:(FlutterResult)flutterResult {
    PTDocumentController *documentController = [self getDocumentController];
    flutterResult([NSNumber numberWithBool:[documentController.pdfViewCtrl GotoNextPage]]);
}

- (void)gotoFirstPage:(FlutterResult)flutterResult {
    PTDocumentController *documentController = [self getDocumentController];
    flutterResult([NSNumber numberWithBool:[documentController.pdfViewCtrl GotoFirstPage]]);
}

- (void)gotoLastPage:(FlutterResult)flutterResult {
    PTDocumentController *documentController = [self getDocumentController];
    flutterResult([NSNumber numberWithBool:[documentController.pdfViewCtrl GotoLastPage]]);
}

- (void)getCurrentPage:(FlutterResult)flutterResult {
    PTDocumentController *documentController = [self getDocumentController];
    flutterResult([NSNumber numberWithInt:documentController.pdfViewCtrl.currentPage]);
}

- (void)getDocumentPath:(FlutterResult)flutterResult {
    PTDocumentController *documentController = [self getDocumentController];
    flutterResult(documentController.coordinatedDocument.fileURL.path);
}

- (void)setToolMode:(NSString *)toolMode resultToken:(FlutterResult)flutterResult;
{
    PTDocumentController *documentController = [self getDocumentController];
    Class toolClass = Nil;

    if ([toolMode isEqualToString:PTAnnotationEditToolKey]) {
        // multi-select not implemented
    } else if([toolMode isEqualToString:PTAnnotationCreateStickyToolKey]) {
        toolClass = [PTStickyNoteCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateFreeHandToolKey]) {
        toolClass = [PTFreeHandCreate class];
    } else if ([toolMode isEqualToString:PTTextSelectToolKey]) {
        toolClass = [PTTextSelectTool class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateSoundToolKey]) {
        toolClass = [PTSound class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateTextHighlightToolKey]) {
        toolClass = [PTTextHighlightCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateTextUnderlineToolKey]) {
        toolClass = [PTTextUnderlineCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateTextSquigglyToolKey]) {
        toolClass = [PTTextSquigglyCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateTextStrikeoutToolKey]) {
        toolClass = [PTTextStrikeoutCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateFreeTextToolKey]) {
        toolClass = [PTFreeTextCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateCalloutToolKey]) {
        toolClass = [PTCalloutCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateSignatureToolKey]) {
        toolClass = [PTDigitalSignatureTool class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateLineToolKey]) {
        toolClass = [PTLineCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateArrowToolKey]) {
        toolClass = [PTArrowCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreatePolylineToolKey]) {
        toolClass = [PTPolylineCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateStampToolKey]) {
        toolClass = [PTImageStampCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateRectangleToolKey]) {
        toolClass = [PTRectangleCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateEllipseToolKey]) {
        toolClass = [PTEllipseCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreatePolygonToolKey]) {
        toolClass = [PTPolygonCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreatePolygonCloudToolKey]) {
        toolClass = [PTCloudCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateDistanceMeasurementToolKey]) {
        toolClass = [PTRulerCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreatePerimeterMeasurementToolKey]) {
        toolClass = [PTPerimeterCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateAreaMeasurementToolKey]) {
        toolClass = [PTAreaCreate class];
    } else if ([toolMode isEqualToString:PTEraserToolKey]) {
        toolClass = [PTEraser class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateFreeHighlighterToolKey]) {
        toolClass = [PTFreeHandHighlightCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateRubberStampToolKey]) {
        toolClass = [PTRubberStampCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateFileAttachmentToolKey]) {
        toolClass = [PTFileAttachmentCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateRedactionToolKey]) {
        toolClass = [PTRectangleRedactionCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateLinkToolKey]) {
        // TODO
    } else if ([toolMode isEqualToString:PTAnnotationCreateRedactionTextToolKey]) {
        toolClass = [PTTextRedactionCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateLinkTextToolKey]) {
        // TODO
    } else if ([toolMode isEqualToString:PTFormCreateTextFieldToolKey]) {
        // TODO
    } else if ([toolMode isEqualToString:PTFormCreateCheckboxFieldToolKey]) {
        // TODO
    } else if ([toolMode isEqualToString:PTFormCreateSignatureFieldToolKey]) {
        // TODO
    } else if ([toolMode isEqualToString:PTFormCreateRadioFieldToolKey]) {
        // TODO
    } else if ([toolMode isEqualToString:PTFormCreateComboBoxFieldToolKey]) {
        // TODO
    } else if ([toolMode isEqualToString:PTFormCreateListBoxFieldToolKey]) {
        // TODO
    } else if ([toolMode isEqualToString:PTPencilKitDrawingToolKey]) {
        toolClass = [PTPencilDrawingCreate class];
    }

    if (toolClass) {
        PTTool *tool = [documentController.toolManager changeTool:toolClass];

        tool.backToPanToolAfterUse = !((PTFlutterDocumentController *)documentController).isContinuousAnnotationEditingEnabled;

        if ([tool isKindOfClass:[PTFreeHandCreate class]]
            && ![tool isKindOfClass:[PTFreeHandHighlightCreate class]]) {
            ((PTFreeHandCreate *)tool).multistrokeMode = YES;
        }
    }

    flutterResult(nil);
}

- (void)setFlagForFields:(NSArray <NSString *> *)fieldNames flag:(NSNumber *)flag flagValue:(bool)flagValue resultToken:(FlutterResult)flutterResult
{
    PTDocumentController *documentController = [self getDocumentController];
    if(documentController.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        flutterResult([FlutterError errorWithCode:@"set_flag_for_fields" message:@"Failed to set flag for fields" details:@"Error: The document view controller has no document."]);
        return;
    }

    PTPDFViewCtrl *pdfViewCtrl = documentController.pdfViewCtrl;
    PTFieldFlag fieldFlag = (PTFieldFlag)flag.intValue;
    NSError *error;

    [pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        for (NSString *fieldName in fieldNames) {
            PTField *field = [doc GetField:fieldName];
            if ([field IsValid]) {
                [field SetFlag:fieldFlag value:flagValue];
                [pdfViewCtrl UpdateWithField:field];
            }
        }
    } error:&error];

    if (error) {
        NSLog(@"Error: Failed to set flag for fields. %@", error.localizedDescription);
        flutterResult([FlutterError errorWithCode:@"set_flag_for_fields" message:@"Failed to set flag for fields" details:@"Error: Failed to set flag for fields."]);
    } else {
        flutterResult(nil);
    }
}

- (void)setValuesForFields:(NSString *)fieldWithValuesString resultToken:(FlutterResult)flutterResult
{
    PTDocumentController *documentController = [self getDocumentController];
    NSArray *fieldWithValues = [PdftronFlutterPlugin PT_idAsArray:[PdftronFlutterPlugin PT_JSONStringToId:fieldWithValuesString]];
    if(documentController.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        flutterResult([FlutterError errorWithCode:@"set_values_for_fields" message:@"Failed to set values for fields" details:@"Error: The document view controller has no document."]);
        return;
    }

    PTPDFViewCtrl *pdfViewCtrl = documentController.pdfViewCtrl;
    NSError *error;

    [pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {

        for (NSDictionary *fieldWithValue in fieldWithValues) {
            NSString *fieldName = [PdftronFlutterPlugin PT_idAsNSString:fieldWithValue[PTFieldNameKey]];
            id fieldValue = fieldWithValue[PTFieldValueKey];
            PTField *field = [doc GetField:fieldName];

            if ([field IsValid]) {
                [self setFieldValue:field value:fieldValue pdfViewCtrl:pdfViewCtrl];
            }
        }

    } error:&error];

    if (error) {
        NSLog(@"Error: Failed to set values for fields. %@", error.localizedDescription);
        flutterResult([FlutterError errorWithCode:@"set_values_for_fields" message:@"Failed to set values for fields" details:@"Error: Failed to set values for fields."]);
    } else {
        flutterResult(nil);
    }
}

// write-lock required around this method
- (void)setFieldValue:(PTField *)field value:(id)value pdfViewCtrl:(PTPDFViewCtrl *)pdfViewCtrl
{
    const PTFieldType fieldType = [field GetType];

    // boolean or number
    if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber *numberValue = (NSNumber *)value;

        if (fieldType == e_ptcheck) {
            const BOOL fieldValue = numberValue.boolValue;
            PTViewChangeCollection *changeCollection = [field SetValueWithBool:fieldValue];
            [pdfViewCtrl RefreshAndUpdate:changeCollection];
        }
        else if (fieldType == e_pttext) {
            NSString *fieldValue = numberValue.stringValue;

            PTViewChangeCollection *changeCollection = [field SetValueWithString:fieldValue];
            [pdfViewCtrl RefreshAndUpdate:changeCollection];
        }
    }
    // string
    else if ([value isKindOfClass:[NSString class]]) {
        NSString *fieldValue = (NSString *)value;

        if (fieldValue &&
            (fieldType == e_pttext || fieldType == e_ptradio || fieldType == e_ptchoice)) {
            PTViewChangeCollection *changeCollection = [field SetValueWithString:fieldValue];
            [pdfViewCtrl RefreshAndUpdate:changeCollection];
        }
    }
}

- (void)setLeadingNavButtonIcon:(NSString *)leadingNavButtonIcon resultToken:(FlutterResult)flutterResult
{
    PTDocumentController *documentController = [self getDocumentController];
    if(documentController == Nil)
    {
        // something is wrong, document view controller is not present
        NSLog(@"Error: The document view controller is not initialized.");
        flutterResult([FlutterError errorWithCode:@"set_leading_nav_button_icon" message:@"Failed to set leading nav button icon" details:@"Error: The document view controller is not initialized."]);
        return;
    }

    [(PTFlutterDocumentController *)documentController setLeadingNavButtonIcon:leadingNavButtonIcon];
    
    flutterResult(nil);
}

-(void)closeAllTabs:(FlutterResult)flutterResult
{
    PTDocumentTabManager *tabManager = self.tabbedDocumentViewController.tabManager;
    NSArray<PTDocumentTabItem *> *items = [tabManager.items copy];
    
    // Close all tabs except the selected tab, which is displaying a view controller.
    for (PTDocumentTabItem *item in items) {
        if (item != tabManager.selectedItem) {
            [tabManager removeItem:item];
        }
    }
    // Close the selected tab last.
    if (tabManager.selectedItem) {
        [tabManager removeItem:tabManager.selectedItem];
    }
    
    flutterResult(nil);
}

-(void)exportAsImage:(NSNumber*)pageNumber dpi:(NSNumber*)dpi exportFormat:(NSString *)exportFormat filePath:(NSString*)filePath resultToken:(FlutterResult)flutterResult
{
    if (filePath == Nil) {
        PTDocumentController *documentController = [self getDocumentController];
        if(documentController == Nil)
        {
            // something is wrong, document view controller is not present
            NSLog(@"Error: The document view controller is not initialized.");
            flutterResult([FlutterError errorWithCode:@"export_as_image" message:@"Failed to export image from file" details:@"Error: The document view controller is not initialized."]);
            return;
        }
        
        PTPDFViewCtrl *pdfViewCtrl = documentController.pdfViewCtrl;
        
        [self exportAsImageHelper:[pdfViewCtrl GetDoc] pageNumber:pageNumber dpi:dpi exportFormat:exportFormat usesFilePath:NO resultToken:flutterResult];
    } else {
        [self exportAsImageHelper:[[PTPDFDoc alloc] initWithFilepath:filePath] pageNumber:pageNumber dpi:dpi exportFormat:exportFormat usesFilePath:YES resultToken:flutterResult];
    }
}

-(void)exportAsImageHelper:(PTPDFDoc*)doc pageNumber:(NSNumber*)pageNumber dpi:(NSNumber*)dpi exportFormat:(NSString *)exportFormat usesFilePath:(BOOL)usesFilePath resultToken:(FlutterResult)flutterResult
{
    __block NSString* imagePath;
    NSError *error;
    
    [doc LockReadWithBlock:^() {
        PTPDFDraw *draw = [[PTPDFDraw alloc] initWithDpi:[dpi doubleValue]];
        NSString* tempDir = NSTemporaryDirectory();
        NSString* fileName = [NSUUID UUID].UUIDString;
        imagePath = [tempDir stringByAppendingPathComponent:fileName];
        imagePath = [imagePath stringByAppendingPathExtension:exportFormat];
        [draw Export:[doc GetPage:[pageNumber doubleValue]] filename:imagePath format:exportFormat];
    }
    error:&error];
    
    if (error) {
        NSLog(@"Error: Failed to export image from file. %@", error.localizedDescription);
        NSString * errorCode = usesFilePath ? @"export_as_image_from_file_path" : @"export_as_image";
        flutterResult([FlutterError errorWithCode:errorCode message:@"Failed to export image from file" details:@"Error: Failed to export image from file"]);
    } else {
        flutterResult(imagePath);
    }
}
    
- (void)openAnnotationList:(FlutterResult)flutterResult
{
    PTDocumentController *documentController = [self getDocumentController];
    if (!documentController.annotationListHidden) {
        PTNavigationListsViewController *navigationListsViewController = documentController.navigationListsViewController;
        if (navigationListsViewController) {
            navigationListsViewController.selectedViewController = navigationListsViewController.annotationViewController;
            [documentController showNavigationLists];
        }
    }
    
    flutterResult(nil);
}

- (void)openBookmarkList:(FlutterResult)flutterResult
{
    PTDocumentController *documentController = [self getDocumentController];
    if (!documentController.bookmarkListHidden) {
        PTNavigationListsViewController *navigationListsViewController = documentController.navigationListsViewController;
        if (navigationListsViewController) {
            navigationListsViewController.selectedViewController = navigationListsViewController.bookmarkViewController;
            [documentController showNavigationLists];
        }
    }
    
    flutterResult(nil);
}

- (void)openOutlineList:(FlutterResult)flutterResult
{
    PTDocumentController *documentController = [self getDocumentController];
    if (!documentController.outlineListHidden) {
        PTNavigationListsViewController *navigationListsViewController = documentController.navigationListsViewController;
        if (navigationListsViewController) {
            navigationListsViewController.selectedViewController = navigationListsViewController.outlineViewController;
            [documentController showNavigationLists];
        }
    }
    
    
    
    flutterResult(nil);
}

- (void)openLayersList:(FlutterResult)flutterResult
{
    PTDocumentController *documentController = [self getDocumentController];
    if (!documentController.pdfLayerListHidden) {
        PTNavigationListsViewController *navigationListsViewController = documentController.navigationListsViewController;
        if (navigationListsViewController) {
            navigationListsViewController.selectedViewController = navigationListsViewController.pdfLayerViewController;
            [documentController showNavigationLists];
        }
    }
    
    flutterResult(nil);
}

-(void)openThumbnailsView:(FlutterResult)flutterResult
{
    PTDocumentController *documentController = [self getDocumentController];
    if(documentController == Nil)
    {
        // something is wrong, document view controller is not present
        NSLog(@"Error: The document view controller is not initialized.");
        flutterResult([FlutterError errorWithCode:@"open_thumbnails_view" message:@"Failed to open thumbnails view" details:@"Error: The document view controller is not initialized."]);
        return;
    }
    
    [documentController showThumbnailsController];
    flutterResult(nil);
}

-(void)openAddPagesView:(FlutterResult)flutterResult rect:(NSDictionary *)rect
{
    PTDocumentController *documentController = [self getDocumentController];
    if(documentController == Nil)
    {
        // something is wrong, document view controller is not present
        NSLog(@"Error: The document view controller is not initialized.");
        flutterResult([FlutterError errorWithCode:@"open_add_pages_view" message:@"Failed to open add pages view" details:@"Error: The document view controller is not initialized."]);
        return;
    }
    
    NSNumber *rectX1 = rect[PTRectX1Key];
    NSNumber *rectY1 = rect[PTRectY1Key];
    NSNumber *rectX2 = rect[PTRectX2Key];
    NSNumber *rectY2 = rect[PTRectY2Key];
    CGRect screenRect = CGRectMake([rectX1 doubleValue], [rectY1 doubleValue], [rectX2 doubleValue]-[rectX1 doubleValue], [rectY2 doubleValue]-[rectY1 doubleValue]);
    
    [documentController showAddPagesViewFromScreenRect:screenRect];
    flutterResult(nil);
}

-(void)openViewSettings:(FlutterResult)flutterResult rect:(NSDictionary *)rect
{
    PTDocumentController *documentController = [self getDocumentController];
    if(documentController == Nil)
    {
        // something is wrong, document view controller is not present
        NSLog(@"Error: The document view controller is not initialized.");
        flutterResult([FlutterError errorWithCode:@"open_view_settings" message:@"Failed to open view settings" details:@"Error: The document view controller is not initialized."]);
        return;
    }
    
    NSNumber *rectX1 = rect[PTRectX1Key];
    NSNumber *rectY1 = rect[PTRectY1Key];
    NSNumber *rectX2 = rect[PTRectX2Key];
    NSNumber *rectY2 = rect[PTRectY2Key];
    CGRect screenRect = CGRectMake([rectX1 doubleValue], [rectY1 doubleValue], [rectX2 doubleValue]-[rectX1 doubleValue], [rectY2 doubleValue]-[rectY1 doubleValue]);
    [documentController showSettingsFromScreenRect:screenRect];
    flutterResult(nil);
}

-(void)openCrop:(FlutterResult)flutterResult
{
    // TODO: add a source rect option to the native API (similar to the openAddPagesView call)
    PTDocumentController *documentController = [self getDocumentController];
    if(documentController == Nil)
    {
        // something is wrong, document view controller is not present
        NSLog(@"Error: The document view controller is not initialized.");
        flutterResult([FlutterError errorWithCode:@"open_crop" message:@"Failed to open crop" details:@"Error: The document view controller is not initialized."]);
        return;
    }
    PTFlutterDocumentController *flutterDocumentController = (PTFlutterDocumentController *) documentController;
    if (flutterDocumentController.isTopToolbarsHidden) {
        return;
    };
    if (documentController.navigationItem.rightBarButtonItem != nil) {
       [documentController showPageCropOptions:documentController.navigationItem.rightBarButtonItem];
    }
    flutterResult(nil);
}

-(void)openManualCrop:(FlutterResult)flutterResult
{
    PTDocumentController *documentController = [self getDocumentController];
    if(documentController == Nil)
    {
        // something is wrong, document view controller is not present
        NSLog(@"Error: The document view controller is not initialized.");
        flutterResult([FlutterError errorWithCode:@"open_manual_crop" message:@"Failed to open manual crop" details:@"Error: The document view controller is not initialized."]);
        return;
    }
    [documentController showPageCropViewController];
    flutterResult(nil);
}

-(void)openSearch:(FlutterResult)flutterResult
{
    PTDocumentController *documentController = [self getDocumentController];
    if(documentController == Nil)
    {
        // something is wrong, document view controller is not present
        NSLog(@"Error: The document view controller is not initialized.");
        flutterResult([FlutterError errorWithCode:@"open_search" message:@"Failed to open search" details:@"Error: The document view controller is not initialized."]);
        return;
    }
    
    [documentController showSearchViewController];
    flutterResult(nil);
}

-(void)openTabSwitcher:(FlutterResult)flutterResult
{
    if (self.tabbedDocumentViewController) {
        [self.tabbedDocumentViewController showTabsList:self.tabbedDocumentViewController.tabBar];
        flutterResult(nil);
        return;
    } else {
        NSLog(@"Error: The document view controller is not initialized.");
        flutterResult([FlutterError errorWithCode:@"open_tab_switcher" message:@"Failed to open tab switcher" details:@"Error: The document view controller is not initialized."]);
    }
}

-(void)openGoToPageView:(FlutterResult)flutterResult
{
    PTDocumentController *documentController = [self getDocumentController];
    if (documentController && documentController.pageIndicatorViewController) {
        PTPageIndicatorViewController * pageIndicator = documentController.pageIndicatorViewController;
        [pageIndicator presentGoToPageController];
        flutterResult(nil);
        return;
    } else {
        // something is wrong, document view controller is not present
        NSLog(@"Error: The document view controller is not initialized.");
        flutterResult([FlutterError errorWithCode:@"open_go_to_page_view" message:@"Failed to set open go to page view" details:@"Error: The document view controller is not initialized."]);
    }
}

-(void)openNavigationLists:(FlutterResult)flutterResult
{
    PTDocumentController *documentController = [self getDocumentController];
    PTNavigationListsViewController *navigationListsViewController = documentController.navigationListsViewController;
    if (navigationListsViewController) {
        [documentController showNavigationLists];
    }

    flutterResult(nil);
}

#pragma mark - Helper

- (PTDocumentController *)getDocumentController {
    return [PdftronFlutterPlugin PT_getSelectedDocumentController:self.tabbedDocumentViewController];
}

+ (PTDocumentController *)PT_getSelectedDocumentController:(PTTabbedDocumentViewController *)tabbedDocumentViewController {
    PTDocumentController* documentController = tabbedDocumentViewController.selectedViewController;
    
    if(documentController == Nil && tabbedDocumentViewController.childViewControllers.count == 1)
    {
        documentController = tabbedDocumentViewController.childViewControllers.lastObject;
    }
    return documentController;
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
    if (numericVal) {
        bool result = [numericVal boolValue];
        return result;
    }
    return false;
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

+ (Class)toolClassForKey:(NSString *)key
{
    if ([key isEqualToString:PTAnnotationEditToolKey]) {
        return [PTAnnotSelectTool class];
    }
    else if ([key isEqualToString:PTAnnotationCreateStickyToolKey] ||
             [key isEqualToString:PTStickyToolButtonKey]) {
        return [PTStickyNoteCreate class];
    }
    else if ([key isEqualToString:PTAnnotationCreateFreeHandToolKey] ||
             [key isEqualToString:PTFreeHandToolButtonKey]) {
        return [PTFreeHandCreate class];
    }
    else if ([key isEqualToString:PTTextSelectToolKey]) {
        return [PTTextSelectTool class];
    }
    else if ([key isEqualToString:PTAnnotationCreateTextHighlightToolKey] ||
             [key isEqualToString:PTHighlightToolButtonKey]) {
        return [PTTextHighlightCreate class];
    }
    else if ([key isEqualToString:PTAnnotationCreateTextUnderlineToolKey] ||
             [key isEqualToString:PTUnderlineToolButtonKey]) {
        return [PTTextUnderlineCreate class];
    }
    else if ([key isEqualToString:PTAnnotationCreateTextSquigglyToolKey] ||
             [key isEqualToString:PTSquigglyToolButtonKey]) {
        return [PTTextSquigglyCreate class];
    }
    else if ([key isEqualToString:PTAnnotationCreateTextStrikeoutToolKey] ||
             [key isEqualToString:PTStrikeoutToolButtonKey]) {
        return [PTTextStrikeoutCreate class];
    }
    else if ([key isEqualToString:PTAnnotationCreateFreeTextToolKey] ||
             [key isEqualToString:PTFreeTextToolButtonKey]) {
        return [PTFreeTextCreate class];
    }
    else if ([key isEqualToString:PTAnnotationCreateCalloutToolKey] ||
             [key isEqualToString:PTCalloutToolButtonKey]) {
        return [PTCalloutCreate class];
    }
    else if ([key isEqualToString:PTAnnotationCreateSignatureToolKey] ||
             [key isEqualToString:PTSignatureToolButtonKey]) {
        return [PTDigitalSignatureTool class];
    }
    else if ([key isEqualToString:PTAnnotationCreateLineToolKey] ||
             [key isEqualToString:PTLineToolButtonKey]) {
        return [PTLineCreate class];
    }
    else if ([key isEqualToString:PTAnnotationCreateArrowToolKey] ||
             [key isEqualToString:PTArrowToolButtonKey]) {
        return [PTArrowCreate class];
    }
    else if ([key isEqualToString:PTAnnotationCreatePolylineToolKey] ||
             [key isEqualToString:PTPolylineToolButtonKey]) {
        return [PTPolylineCreate class];
    }
    else if ([key isEqualToString:PTAnnotationCreateStampToolKey] ||
             [key isEqualToString:PTStampToolButtonKey]) {
        return [PTImageStampCreate class];
    }
    else if ([key isEqualToString:PTAnnotationCreateRectangleToolKey] ||
             [key isEqualToString:PTRectangleToolButtonKey]) {
        return [PTRectangleCreate class];
    }
    else if ([key isEqualToString:PTAnnotationCreateEllipseToolKey] ||
             [key isEqualToString:PTEllipseToolButtonKey]) {
        return [PTEllipseCreate class];
    }
    else if ([key isEqualToString:PTAnnotationCreatePolygonToolKey] ||
             [key isEqualToString:PTPolygonToolButtonKey]) {
        return [PTPolygonCreate class];
    }
    else if ([key isEqualToString:PTAnnotationCreatePolygonCloudToolKey] ||
             [key isEqualToString:PTCloudToolButtonKey]) {
        return [PTCloudCreate class];
    }
    else if ([key isEqualToString:PTAnnotationCreateFileAttachmentToolKey]) {
        return [PTFileAttachmentCreate class];
    }
    else if ([key isEqualToString:PTAnnotationCreateDistanceMeasurementToolKey]) {
        return [PTRulerCreate class];
    }
    else if ([key isEqualToString:PTAnnotationCreatePerimeterMeasurementToolKey]) {
        return [PTPerimeterCreate class];
    }
    else if ([key isEqualToString:PTAnnotationCreateAreaMeasurementToolKey]) {
        return [PTAreaCreate class];
    }
    else if ([key isEqualToString:PTAnnotationCreateFreeHighlighterToolKey]) {
        return [PTFreeHandHighlightCreate class];
    }

    return Nil;
}

@end
