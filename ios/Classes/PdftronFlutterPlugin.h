#import <Flutter/Flutter.h>
#import <PDFNet/PDFNet.h>
#import <Tools/Tools.h>

@interface PdftronFlutterPlugin : NSObject<FlutterPlugin>

@property (nonatomic, strong) PTTabbedDocumentViewController *tabbedDocumentViewController;

+ (void)configureDocumentViewController:(PTDocumentViewController*)documentViewController withConfig:(NSString*)config;

@end
