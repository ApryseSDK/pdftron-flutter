#import <Flutter/Flutter.h>
#import <PDFNet/PDFNet.h>
#import <Tools/Tools.h>

@interface FlutterDocumentView : NSObject <FlutterPlatformView>

@property (nonatomic) int64_t viewId;
@property (nonatomic, strong) FlutterMethodChannel *channel;
@property (nonatomic, strong) PTDocumentViewController *documentViewController;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) FlutterResult flutterResult;

- (instancetype)initWithWithFrame:(CGRect)frame
                   viewIdentifier:(int64_t)viewId
                        arguments:(id)args
                  binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

- (UIView*)view;
@end

@interface DocumentViewFactory : NSObject <FlutterPlatformViewFactory>
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end

