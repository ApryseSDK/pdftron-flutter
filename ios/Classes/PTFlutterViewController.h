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
@property (nonatomic, copy, nullable) NSString* layoutMode;
@property (nonatomic, copy, nullable) NSString* fitMode;
@property (nonatomic, assign) int initialPageNumber;
@property (nonatomic, assign, getter=isBase64) BOOL base64;

- (void)applyViewerSettings;

- (void)setFitMode:(NSString*)fitMode;

@end

NS_ASSUME_NONNULL_END
