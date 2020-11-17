#import <Flutter/Flutter.h>
#import <PDFNet/PDFNet.h>
#import <Tools/Tools.h>

NS_ASSUME_NONNULL_BEGIN

@interface PTNavigationController : UINavigationController

@property (nonatomic, assign) PTFlutterDocumentController* flutterDocumentController;
@property (nonatomic, weak, nullable) id <UINavigationControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
