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
@property (nonatomic, copy, nullable) NSArray<NSString *> * annotationToolbars;
@property (nonatomic, copy, nullable) NSArray<NSString *> * hideDefaultAnnotationToolbars;
@property (nonatomic, assign) BOOL hideAnnotationToolbarSwitcher;
@property (nonatomic, assign) BOOL hideTopToolbars;
@property (nonatomic, assign) BOOL hideTopAppNavBar;
@property (nonatomic, assign) BOOL showNavButton;

@property (nonatomic, assign, getter=isReadOnly) BOOL readOnly;
@property (nonatomic, assign, getter=isThumbnailEditingEnabled) BOOL thumbnailEditingEnabled;
@property (nonatomic, assign, getter=isContinuousAnnotationEditing) BOOL continuousAnnotationEditing;

@property (nonatomic, copy, nullable) NSString* annotationAuthor;

- (void)initViewerSettings;
- (void)applyViewerSettings;

- (void)setLeadingNavButtonIcon:(NSString *)leadingNavButtonIcon;

- (BOOL)shouldSetNavigationBarHidden:(BOOL)navigationBarHidden animated:(BOOL)animated;
- (BOOL)shouldSetToolbarHidden:(BOOL)toolbarHidden animated:(BOOL)animated;

@end

@interface FLThumbnailsViewController : PTThumbnailsViewController

@end

NS_ASSUME_NONNULL_END
