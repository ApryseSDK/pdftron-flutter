#import <Flutter/Flutter.h>
#import <PDFNet/PDFNet.h>
#import <Tools/Tools.h>
#import "PdftronFlutterPlugin.h"

NS_ASSUME_NONNULL_BEGIN

@interface PTFlutterDocumentController : PTDocumentController <PTOverridable>

@property (nonatomic, strong) FlutterResult openResult;
@property (nonatomic, weak) PdftronFlutterPlugin* plugin;

@property (nonatomic) BOOL local;
@property (nonatomic) BOOL needsDocumentLoaded;
@property (nonatomic) BOOL needsRemoteDocumentLoaded;
@property (nonatomic) BOOL documentLoaded;

// viewer options
@property (nonatomic, copy, nullable) NSString* layoutMode;
@property (nonatomic, copy, nullable) NSString* fitMode;
@property (nonatomic, assign) int initialPageNumber;
@property (nonatomic, assign, getter=isBase64) BOOL base64;
@property (nonatomic, copy, nullable) NSArray <NSString *> *hideThumbnailFilterModes;

// long-press menu customization
@property (nonatomic, assign, getter=isLongPressMenuEnabled) BOOL longPressMenuEnabled;
@property (nonatomic, copy, nullable) NSArray<NSString*>* longPressMenuItems;
@property (nonatomic, copy, nullable) NSArray<NSString*>* overrideLongPressMenuBehavior;

// annotation selection menu customization
@property (nonatomic, copy, nullable) NSArray<NSNumber *> *hideAnnotMenuTools;
@property (nonatomic, copy, nullable) NSArray<NSString*>* annotationMenuItems;
@property (nonatomic, copy, nullable) NSArray<NSString*>* overrideAnnotationMenuBehavior;

@property (nonatomic, copy, nullable) NSArray<NSString*>* excludedAnnotationListTypes;
@property (nonatomic, assign, getter=isAutoSaveEnabled) BOOL autoSaveEnabled;
@property (nonatomic, assign) BOOL pageChangesOnTap;
@property (nonatomic, assign) BOOL useStylusAsPen;
@property (nonatomic, assign) BOOL showSavedSignatures;
@property (nonatomic, assign) BOOL signSignatureFieldsWithStamps;
@property (nonatomic, assign) BOOL selectAnnotationAfterCreation;
@property (nonatomic, assign, getter=isBottomToolbarOn) BOOL bottomToolbarOn;
@property (nonatomic, copy, nullable) NSString* defaultEraserType;
@property (nonatomic, copy, nullable) NSString *reflowOrientation;
@property (nonatomic, assign) BOOL imageInReflowModeEnabled;

@property (nonatomic, copy, nullable) NSArray<NSString *> * annotationToolbars;
@property (nonatomic, copy, nullable) NSArray<NSString *> * hideDefaultAnnotationToolbars;
@property (nonatomic, assign, getter=isAnnotationToolbarSwitcherHidden) BOOL annotationToolbarSwitcherHidden; // hideAnnotationToolbarSwitcher configuration option
@property (nonatomic, copy, nullable) NSString *initialToolbar;
@property (nonatomic, assign, getter=isTopToolbarsHidden) BOOL topToolbarsHidden; // hideTopToolbars configuration option
@property (nonatomic, assign, getter=isToolbarsHiddenOnTap) BOOL toolbarsHiddenOnTap; // hideToolbarsOnTap configuration option
@property (nonatomic, assign, getter=isTopAppNavBarHidden) BOOL topAppNavBarHidden; // hideTopAppNavBar configuration option
@property (nonatomic, copy, nullable) NSArray<NSString *> *topAppNavBarRightBar; 
@property (nonatomic, assign, getter=isBottomToolbarHidden) BOOL bottomToolbarHidden; // bottomToolbarEnabled configuration option
@property (nonatomic, copy, nullable) NSArray<NSString *> *bottomToolbar;
@property (nonatomic, assign) BOOL showNavButton;

@property (nonatomic, assign, getter=isReadOnly) BOOL readOnly;
@property (nonatomic, assign, getter=isThumbnailEditingEnabled) BOOL thumbnailEditingEnabled;
@property (nonatomic, assign, getter=isContinuousAnnotationEditingEnabled) BOOL continuousAnnotationEditingEnabled; // continuousAnnotationEditing configuration option

@property (nonatomic, copy, nullable) NSString* annotationAuthor;

@property (nonatomic, assign, getter=isAnnotationPermissionCheckEnabled) BOOL annotationPermissionCheckEnabled;

@property (nonatomic, assign, getter=isAnnotationsListEditingEnabled) BOOL annotationsListEditingEnabled;
@property (nonatomic, assign, getter=isUserBookmarksListEditingEnabled) BOOL userBookmarksListEditingEnabled;
@property (nonatomic, assign) BOOL showNavigationListAsSidePanelOnLargeDevices;

@property (nonatomic, copy, nullable) NSArray<NSString *> *overrideBehavior;

@property (nonatomic, copy, nullable) NSString* leadingNavButtonIcon;

@property (nonatomic, assign) BOOL showQuickNavigationButton;

@property (nonatomic, copy, nullable) NSString* tabTitle;

@property (nonatomic, assign) int maxTabCount;

@property (nonatomic, assign) BOOL autoResizeFreeTextEnabled;

@property (nonatomic, assign) BOOL restrictDownloadUsage;

@property (nonatomic, copy, nullable) NSArray<NSString*>* uneditableAnnotTypes;

@property (nonatomic, assign, getter=isAnnotationManagerEnabled) BOOL annotationManagerEnabled;

@property (nonatomic, copy, nullable) NSString* userId;

@property (nonatomic, copy, nullable) NSString* userName;

@property (nonatomic, copy, nullable) NSString *annotationManagerEditMode;

@property (nonatomic, copy, nullable) NSString *annotationManagerUndoMode;

@property (nonatomic, assign, getter=isDocCtrlrConfigured) BOOL docCtrlrConfigured;

@property (nonatomic, assign, getter=isReadOnly) BOOL hideScrollbars;

- (void)initViewerSettings;
- (void)applyViewerSettings;

- (void)setLeadingNavButtonIcon:(NSString *)leadingNavButtonIcon;

- (BOOL)shouldSetNavigationBarHidden:(BOOL)navigationBarHidden animated:(BOOL)animated;
- (BOOL)shouldSetToolbarHidden:(BOOL)toolbarHidden animated:(BOOL)animated;

- (void)hideViewModeItems:(NSArray<NSString *> *)viewModeItems;

@end

@interface FLThumbnailsViewController : PTThumbnailsViewController

@end

@interface PTFlutterTabbedDocumentController: PTTabbedDocumentViewController

@property (nonatomic, retain) NSMutableArray *tempFiles;
@end

NS_ASSUME_NONNULL_END
