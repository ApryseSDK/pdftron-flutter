#import "FlutterDocumentView.h"

#import "PdftronFlutterPlugin.h"

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

- (instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger
{
    self = [super init];
    if (self) {
        _viewId = viewId;
        
        // Create a PTDocumentViewController
        _documentViewController = [[PTDocumentViewController alloc] init];
        
        // The PTDocumentViewController must be in a navigation controller before a document can be opened
        _navigationController = [[UINavigationController alloc] initWithRootViewController:_documentViewController];
        
        UIViewController *parentController = UIApplication.sharedApplication.keyWindow.rootViewController;
        [parentController addChildViewController:_navigationController];
        [_navigationController didMoveToParentViewController:parentController];
                
        NSString* channelName = [NSString stringWithFormat:@"pdftron_flutter/documentview_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        __weak __typeof__(self) weakSelf = self;
        [_channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
            __strong __typeof__(weakSelf) self = weakSelf;
            if (self) {
                [self onMethodCall:call result:result];
            }
        }];
        
    }
    return self;
}

- (UIView *)view
{
    return _navigationController.view;
}

static NSString * _Nullable PT_idAsNSString(id value)
{
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString *)value;
    }
    return nil;
}

- (void)onMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result
{
    if ([call.method isEqualToString:@"openDocument"]) {
        NSString *document = PT_idAsNSString(call.arguments[@"document"]);
        NSString *password = PT_idAsNSString(call.arguments[@"password"]);
        NSString *config = PT_idAsNSString(call.arguments[@"config"]);
        if ([config isEqualToString:@"null"]) {
            config = nil;
        }
        
        [self openDocument:document password:password config:config];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)openDocument:(NSString *)document password:(NSString *)password config:(NSString *)config
{
    if (!_documentViewController) {
        return;
    }
    
    [PdftronFlutterPlugin configureDocumentViewController:_documentViewController
                                               withConfig:config];
    
    // Open a file URL.
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:document withExtension:@"pdf"];
    if ([document containsString:@"://"]) {
        fileURL = [NSURL URLWithString:document];
    } else if ([document hasPrefix:@"/"]) {
        fileURL = [NSURL fileURLWithPath:document];
    }
    
    [_documentViewController openDocumentWithURL:fileURL password:password];
}

@end
