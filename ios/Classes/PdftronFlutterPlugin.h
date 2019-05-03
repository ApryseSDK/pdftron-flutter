#import <Flutter/Flutter.h>
#import <PDFNet/PDFNet.h>
#import <Tools/Tools.h>

@interface PdftronFlutterPlugin : NSObject<FlutterPlugin>

@property (nonatomic, strong) PTDocumentViewController* documentViewController;

@end
