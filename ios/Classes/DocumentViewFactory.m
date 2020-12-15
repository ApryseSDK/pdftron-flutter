#import "PdftronFlutterPlugin.h"
#import "PTFlutterDocumentController.h"
#import "DocumentViewFactory.h"

@implementation DocumentViewFactory

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
    return [PdftronFlutterPlugin registerWithFrame:frame viewIdentifier:viewId messenger:self.messenger];
}

@end
