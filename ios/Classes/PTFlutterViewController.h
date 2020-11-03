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
@property (nonatomic, copy, setter=setFitMode:) NSString* fitMode;
@property (nonatomic, copy, setter=setLayoutMode: ) NSString* layoutMode;
@property (nonatomic, assign, setter=setInitialPageNumber: ) int initialPageNumber;
@property (nonatomic, assign, setter=setIsBase64: ) BOOL isBase64;

- (void)initViewerSettings;
- (void)applyViewerSettings;

@end

NS_ASSUME_NONNULL_END
