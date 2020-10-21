#import <Flutter/Flutter.h>
#import <PDFNet/PDFNet.h>
#import <Tools/Tools.h>

NS_ASSUME_NONNULL_BEGIN

@interface PdftronFlutterPlugin : NSObject<FlutterPlugin, FlutterStreamHandler>

@property (nonatomic, strong) PTTabbedDocumentViewController *tabbedDocumentViewController;

+ (void)configureDocumentViewController:(PTDocumentViewController*)documentViewController withConfig:(NSString*)config;

- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(FlutterEventSink)events;
- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments;

-(void)docVCBookmarkChange:(PTDocumentViewController*)docVC bookmarkJson:(NSString*)bookmarkJson;
-(void)docVCExportAnnotationCommand:(PTDocumentViewController*)docVC xfdfCommand:(NSString*)xfdfCommand;
-(void)docVCDocumentLoaded:(PTDocumentViewController*)docVC filePath:(NSString*)filePath;
-(void)docVCDocumentError:(PTDocumentViewController*)docVC;
-(void)docVCAnnotationChanged:(PTDocumentViewController*)docVC annotationsWithActionString:(NSString*)annotationsWithActionString;
-(void)docVCAnnotationsSelected:(PTDocumentViewController*)docVC annotationsString:(NSString*)annotationsString;
-(void)docVCFormFieldValueChanged:(PTDocumentViewController*)docVC fieldsString:(NSString*)fieldsString;

@end

NS_ASSUME_NONNULL_END
