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
@property (nonatomic, assign, getter=isReadOnly, setter=setReadOnly:) BOOL readOnly;
@property (nonatomic, assign, getter=isThumbnailViewEditingEnabled, setter=setThumbnailViewEditingEnabled:) BOOL thumbnailViewEditingEnabled;
@property (nonatomic, copy, getter=getAnnotationAuthor) NSString * annotationAuthor;
@property (nonatomic, assign, getter=isContinuousAnnotationEditing, setter=setContinuousAnnotationEditing:) BOOL continuousAnnotationEditing;

- (void)setAnnotationAuthor:(NSString*)annotationAuthor;

- (void)initViewerSettings;
- (void)applyViewerSettings;

@end

@interface FLPTThumbnailsViewController : PTThumbnailsViewController

@end

NS_ASSUME_NONNULL_END
