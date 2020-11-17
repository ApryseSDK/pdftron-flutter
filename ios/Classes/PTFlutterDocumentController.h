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

- (void)initViewerSettings;
- (void)applyViewerSettings;

- (BOOL)shouldSetNavigationBarHidden:(BOOL)navigationBarHidden animated:(BOOL)animated;
- (BOOL)shouldSetToolbarHidden:(BOOL)toolbarHidden animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
