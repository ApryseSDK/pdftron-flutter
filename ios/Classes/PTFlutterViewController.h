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
@property (nonatomic, assign) BOOL showNavButton;
@property (nonatomic, copy, nullable) NSString *navButtonPath;

@property (nonatomic, assign, getter=isReadOnly) BOOL readOnly;
@property (nonatomic, getter=isThumbnailEditingEnabled) BOOL thumbnailEditingEnabled;
@property (nonatomic, getter=isContinuousAnnotationEditing) BOOL continuousAnnotationEditing;

@property (nonatomic, copy, nullable, getter=getAnnotationAuthor) NSString* annotationAuthor;

- (void)initViewerSettings;
- (void)applyViewerSettings;

@end

@interface FLThumbnailsViewController : PTThumbnailsViewController

@end

NS_ASSUME_NONNULL_END
