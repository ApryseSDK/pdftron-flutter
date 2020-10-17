#import <Flutter/Flutter.h>
#import <PDFNet/PDFNet.h>
#import <Tools/Tools.h>

NS_ASSUME_NONNULL_BEGIN

@interface DocumentViewFactory : NSObject <FlutterPlatformViewFactory>
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end

NS_ASSUME_NONNULL_END
