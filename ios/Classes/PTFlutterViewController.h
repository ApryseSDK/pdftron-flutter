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
@property (nonatomic, copy) NSString* layoutMode;
@property (nonatomic, assign) int initialPageNumber;
@property (nonatomic, assign) BOOL isBase64;

- (void)initViewerSettings;
- (void)applyViewerSettings;

- (void)setFitMode:(NSString*)fitMode;

@end

NS_ASSUME_NONNULL_END
