#import <Flutter/Flutter.h>
#import <PDFNet/PDFNet.h>
#import <Tools/Tools.h>

NS_ASSUME_NONNULL_BEGIN

@interface PTFlutterViewController : PTDocumentViewController

@property (nonatomic, strong) FlutterResult openResult;
@property (nonatomic, strong) PdftronFlutterPlugin* plugin;

@property (nonatomic) BOOL local;
@property (nonatomic) BOOL needsDocumentLoaded;
@property (nonatomic) BOOL needsRemoteDocumentLoaded;
@property (nonatomic) BOOL documentLoaded;

// viewer options
@property (nonatomic) BOOL selectAnnotationAfterCreation;
@property (nonatomic, assign, getter=isBottomToolbarOn) BOOL bottomToolbarOn;

- (void)initViewerSettings;
- (void)applyViewerSettings;


@end

@interface FLThumbnailsViewController : PTThumbnailsViewController

@end

NS_ASSUME_NONNULL_END
