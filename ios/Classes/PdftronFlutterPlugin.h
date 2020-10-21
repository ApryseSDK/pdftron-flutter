#import <Flutter/Flutter.h>
#import <PDFNet/PDFNet.h>
#import <Tools/Tools.h>

NS_ASSUME_NONNULL_BEGIN

@interface PdftronFlutterPlugin : NSObject<FlutterPlugin, FlutterStreamHandler>

@property (nonatomic, strong) PTTabbedDocumentViewController *tabbedDocumentViewController;

+ (void)configureDocumentViewController:(PTDocumentViewController*)documentViewController withConfig:(NSString*)config;

- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(FlutterEventSink)events;
- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments;

-(void)docVCExportAnnotationCommand:(NSString*)xfdfCommand;
-(void)docVCBookmarkChange:(NSString*)bookmarkJson;
-(void)docVCDocumentLoaded:(NSString*)filePath;
-(void)docVCDocumentError;
-(void)docVCAnnotationChanged:(NSString*)annotationsWithActionString;
-(void)docVCAnnotationsSelected:(NSString*)annotationsString;
-(void)docVCFormFieldValueChanged:(NSString*)fieldsString;

@end

NS_ASSUME_NONNULL_END
