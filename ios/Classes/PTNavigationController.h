#import <Flutter/Flutter.h>
#import <PDFNet/PDFNet.h>
#import <Tools/Tools.h>

#import "PTFlutterDocumentController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PTNavigationController : UINavigationController

@property (nonatomic, weak, nullable) PTFlutterDocumentController* flutterDocumentController;

@end

NS_ASSUME_NONNULL_END
