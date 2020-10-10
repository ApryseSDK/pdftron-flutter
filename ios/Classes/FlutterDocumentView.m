#import "FlutterDocumentView.h"
#import "PdftronFlutterPlugin.h"
#import "PTPluginUtils.h"

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

@interface FlutterDocumentView () <PTDocumentViewControllerDelegate>

@end

@implementation FlutterDocumentView {

}

- (instancetype)initWithWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger
{
    self = [super init];
    if (self) {
        viewId = viewId;
        
        // Create a PTDocumentViewController
        self.documentViewController = [[PTDocumentViewController alloc] init];
        
        // The PTDocumentViewController must be in a navigation controller before a document can be opened
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.documentViewController];
        
        UIViewController *parentController = UIApplication.sharedApplication.keyWindow.rootViewController;
        [parentController addChildViewController:self.navigationController];
        [self.navigationController didMoveToParentViewController:parentController];
                
        NSString* channelName = [NSString stringWithFormat:@"pdftron_flutter/documentview_%lld", viewId];
        self.channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        __weak __typeof__(self) weakSelf = self;
        [self.channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
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
    return self.navigationController.view;
}

- (void)onMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result
{
    if ([call.method isEqualToString:PTOpenDocumentKey]) {
        NSString *document = [PTPluginUtils PT_idAsNSString:call.arguments[PTDocumentArgumentKey]];
        NSString *password = [PTPluginUtils PT_idAsNSString:call.arguments[PTPasswordArgumentKey]];
        NSString *config = [PTPluginUtils PT_idAsNSString:call.arguments[PTConfigArgumentKey]];
        if ([config isEqualToString:@"null"]) {
            config = nil;
        }
        [self openDocument:document password:password config:config resultToken:result];
    } else if ([call.method isEqualToString:PTSetToolModeKey]) {
        NSString *toolMode = [PTPluginUtils PT_idAsNSString:call.arguments[PTToolModeArgumentKey]];
        [PTPluginUtils setToolMode:toolMode resultToken:result documentViewController:self.documentViewController continuousAnnotationEditing:self.continuousAnnotationEditing];
    } else {
        [PTPluginUtils handleMethodCall:call result:result documentViewController:self.documentViewController];
    }
}

- (void)openDocument:(NSString *)document password:(NSString *)password config:(NSString *)config resultToken:(FlutterResult)result
{
    if (!self.documentViewController) {
        return;
    }
    
    [PdftronFlutterPlugin configureDocumentViewController:self.documentViewController
                                               withConfig:config];
    
    // Open a file URL.
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:document withExtension:@"pdf"];
    if ([document containsString:@"://"]) {
        fileURL = [NSURL URLWithString:document];
    } else if ([document hasPrefix:@"/"]) {
        fileURL = [NSURL fileURLWithPath:document];
    }
    
    self.documentViewController.delegate = self;
    self.flutterResult = result;
    
    [self.documentViewController openDocumentWithURL:fileURL password:password];
}

- (void)documentViewControllerDidOpenDocument:(PTDocumentViewController *)documentViewController
{
    NSLog(@"Document opened successfully");
    self.flutterResult(@"Opened Document Successfully");
}

- (void)documentViewController:(PTDocumentViewController *)documentViewController didFailToOpenDocumentWithError:(NSError *)error
{
    NSLog(@"Failed to open document: %@", error);
    self.flutterResult([@"Opened Document Failed: %@" stringByAppendingString:error.description]);
}

@end
