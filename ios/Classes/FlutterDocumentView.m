#import "FlutterDocumentView.h"

@implementation DocumentViewFactory {
    NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messenger
{
    self = [super init];
    if (self) {
        _messenger = messenger;
    }
    return self;
}

- (NSObject<FlutterMessageCodec> *)createArgsCodec
{
    return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args
{
    FlutterDocumentView* documentView =
    [[FlutterDocumentView alloc] initWithWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
    return documentView;
}

@end

@implementation FlutterDocumentView {
    int64_t _viewId;
    FlutterMethodChannel* _channel;
    PTDocumentViewController* _documentViewController;
    UINavigationController* _navigationController;
    UITextView* _textView;
}

-(instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger
{
    if ([super init]) {
        _viewId = viewId;
//        _textView = [[UITextView alloc]initWithFrame:frame];
        
        // Create a PTDocumentViewController
        _documentViewController = [[PTDocumentViewController alloc] init];
        
        // The PTDocumentViewController must be in a navigation controller before a document can be opened
        _navigationController = [[UINavigationController alloc] initWithRootViewController:_documentViewController];
        
        UIViewController *parentController = UIApplication.sharedApplication.keyWindow.rootViewController;
        [parentController addChildViewController:_navigationController];
        [_navigationController didMoveToParentViewController:parentController];
        
        NSURL *fileURL = [NSURL URLWithString:@"https://pdftron.s3.amazonaws.com/downloads/pl/PDFTRON_mobile_about.pdf"];
        
        [_documentViewController openDocumentWithURL:fileURL];
        
        NSString* channelName = [NSString stringWithFormat:@"pdftron_flutter/documentview_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        __weak __typeof__(self) weakSelf = self;
        [_channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
            [weakSelf onMethodCall:call result:result];
        }];
        
    }
    return self;
}

-(UIView *)view
{
    return _navigationController.view;
    
//    _textView.text = @"some text";
//    _textView.backgroundColor = [UIColor redColor];
//    [_textView sizeToFit];
//    return _textView;
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    result(FlutterMethodNotImplemented);
}


@end
