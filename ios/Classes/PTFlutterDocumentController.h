#import <Flutter/Flutter.h>
#import <PDFNet/PDFNet.h>
#import <Tools/Tools.h>
#import "PdftronFlutterPlugin.h"

NS_ASSUME_NONNULL_BEGIN

@interface PTFlutterDocumentController : PTDocumentController

@property (nonatomic, strong) FlutterResult openResult;
@property (nonatomic, strong) PdftronFlutterPlugin* plugin;

@property (nonatomic) BOOL local;
@property (nonatomic) BOOL needsDocumentLoaded;
@property (nonatomic) BOOL needsRemoteDocumentLoaded;
@property (nonatomic) BOOL documentLoaded;

// viewer options
@property (nonatomic, copy, nullable) NSArray <NSString *> *hideThumbnailFilterModes;

@property (nonatomic, copy, nullable) NSArray<NSString *> * annotationToolbars;
@property (nonatomic, copy, nullable) NSArray<NSString *> * hideDefaultAnnotationToolbars;
@property (nonatomic, assign, getter=isAnnotationToolbarSwitcherHidden) BOOL annotationToolbarSwitcherHidden; // hideAnnotationToolbarSwitcher configuration option
@property (nonatomic, assign, getter=isTopToolbarsHidden) BOOL topToolbarsHidden; // hideTopToolbars configuration option
@property (nonatomic, assign, getter=isTopAppNavBarHidden) BOOL topAppNavBarHidden; // hideTopAppNavBar configuration option
@property (nonatomic, assign) BOOL showNavButton;

@property (nonatomic, assign, getter=isReadOnly) BOOL readOnly;
@property (nonatomic, assign, getter=isThumbnailEditingEnabled) BOOL thumbnailEditingEnabled;
@property (nonatomic, assign, getter=isContinuousAnnotationEditingEnabled) BOOL continuousAnnotationEditingEnabled; // continuousAnnotationEditing configuration option

@property (nonatomic, copy, nullable) NSString* annotationAuthor;

@property (nonatomic, copy, nullable) NSString* leadingNavButtonIcon;

- (void)initViewerSettings;
- (void)applyViewerSettings;

- (void)setLeadingNavButtonIcon:(NSString *)leadingNavButtonIcon;

- (BOOL)shouldSetNavigationBarHidden:(BOOL)navigationBarHidden animated:(BOOL)animated;
- (BOOL)shouldSetToolbarHidden:(BOOL)toolbarHidden animated:(BOOL)animated;

@end

@interface FLThumbnailsViewController : PTThumbnailsViewController

@end

NS_ASSUME_NONNULL_END
