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
@property (nonatomic, assign) BOOL readOnly;
@property (nonatomic, assign) BOOL thumbnailViewEditingEnabled;

- (void)initViewerSettings;
- (void)applyViewerSettings;

- (void)setAnnotationAuthor:(NSString *)annotationAuthor;
- (void)setContinuousAnnotationEditing:(BOOL)continuousAnnotationEditing;

@end

@interface FLThumbnailsViewController : PTThumbnailsViewController

@end

NS_ASSUME_NONNULL_END
