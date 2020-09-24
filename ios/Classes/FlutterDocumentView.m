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

@interface FlutterDocumentView () <PTDocumentViewControllerDelegate>

@end

@implementation FlutterDocumentView {
    int64_t _viewId;
    FlutterMethodChannel* _channel;
    PTDocumentViewController* _documentViewController;
    UINavigationController* _navigationController;
    UITextView* _textView;
    FlutterResult flutterResult;
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

static NSNumber * _Nullable PT_idAsNSNumber(id value)
{
    if ([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber *)value;
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
        
        [self openDocument:document password:password config:config resultToken:result];
    } else if ([call.method isEqualToString:@"importAnnotationCommand"]) {
        NSString *xfdfCommand = PT_idAsNSString(call.arguments[@"xfdfCommand"]);
        [self importAnnotationCommand:xfdfCommand];
    } else if ([call.method isEqualToString:@"importBookmarkJson"]) {
        NSString *bookmarkJson = PT_idAsNSString(call.arguments[@"bookmarkJson"]);
        [self importBookmarks:bookmarkJson];
    } else if ([call.method isEqualToString:@"saveDocument"]) {
        [self saveDocument:result];
    } else if ([call.method isEqualToString:@"getPageCropBox"]) {
        NSNumber *pageNumber = PT_idAsNSNumber(call.arguments[@"pageNumber"]);
        [self getPageCropBox:pageNumber resultToken:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)openDocument:(NSString *)document password:(NSString *)password config:(NSString *)config resultToken:(FlutterResult)result
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
    
    _documentViewController.delegate = self;
    flutterResult = result;
    
    [_documentViewController openDocumentWithURL:fileURL password:password];
}

- (void)importAnnotationCommand:(NSString *)xfdfCommand
{
    if(_documentViewController.document == Nil )
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        return;
    }
    
    NSError* error;
    
    [_documentViewController.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        if( [doc HasDownloader] )
        {
            // too soon
            NSLog(@"Error: The document is still being downloaded.");
            return;
        }

        PTFDFDoc* fdfDoc = [doc FDFExtract:e_ptboth];
        [fdfDoc MergeAnnots:xfdfCommand permitted_user:@""];
        [doc FDFUpdate:fdfDoc];

        [_documentViewController.pdfViewCtrl Update:YES];


    } error:&error];
}

-(void)importBookmarks:(NSString *)bookmarkJson
{
    if( _documentViewController.document == Nil )
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        return;
    }
    
    NSError* error;
    
    [_documentViewController.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        if( [doc HasDownloader] )
        {
            // too soon
            NSLog(@"Error: The document is still being downloaded.");
            return;
        }

        [PTBookmarkManager.defaultManager importBookmarksForDoc:doc fromJSONString:bookmarkJson];


    } error:&error];
}

-(void)saveDocument:(FlutterResult)result
{
    __block NSString* resultString;
    
    if( _documentViewController.document == Nil )
    {
        resultString = @"Error: The document view controller has no document.";
        
        // something is wrong, no document.
        NSLog(@"%@", resultString);
        result(resultString);
        
        return;
    }
    
    NSError* error;
    
    [_documentViewController.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        if( [doc HasDownloader] )
        {
            // too soon
            resultString = @"Error: The document is still being downloaded and cannot be saved.";
            NSLog(@"%@", resultString);
            result(resultString);
            return;
        }

        [_documentViewController saveDocument:0 completionHandler:^(BOOL success) {
            if(!success)
            {
                resultString = @"Error: The file could not be saved.";
                NSLog(@"%@", resultString);
                result(resultString);
            }
            else
            {
                resultString = @"The file was successfully saved.";
                result(resultString);
            }
        }];


    } error:&error];
    
    if( error )
    {
        NSLog(@"Error: There was an error while trying to save the document. %@", error.localizedDescription);
    }
    
}
- (void)getPageCropBox:(NSNumber *)pageNumber resultToken:(FlutterResult)result{
    
    
    NSError *error;
    [_documentViewController.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        if([doc HasDownloader])
        {
            // too soon
            NSLog(@"Error: The document is still being downloaded.");
            return;
        }
        
        PTPage *page = [doc GetPage:(int)pageNumber];
        if (page) {
            PTPDFRect *rect = [page GetCropBox];
            NSDictionary<NSString *, NSNumber *> *map = @{
                @"x1": @([rect GetX1]),
                @"y1": @([rect GetY1]),
                @"x2": @([rect GetX2]),
                @"y2": @([rect GetY2]),
                @"width": @([rect Width]),
                @"height": @([rect Height]),
            };
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:map options:0 error:nil];
            NSString *res = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            result(res);
        }

    } error:&error];
}

- (void)documentViewControllerDidOpenDocument:(PTDocumentViewController *)documentViewController
{
    NSLog(@"Document opened successfully");
    flutterResult(@"Opened Document Successfully");
}

- (void)documentViewController:(PTDocumentViewController *)documentViewController didFailToOpenDocumentWithError:(NSError *)error
{
    NSLog(@"Failed to open document: %@", error);
    flutterResult([@"Opened Document Failed: %@" stringByAppendingString:error.description]);
}

@end
