#import "PTPluginUtils.h"
#import "PdftronFlutterPlugin.h"
#import "FlutterDocumentView.h"

@implementation PTPluginUtils

+ (NSString *)PT_idAsNSString:(id)value
{
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString *)value;
    }
    return nil;
}

+ (NSNumber *)PT_idAsNSNumber:(id)value
{
    if ([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber *)value;
    }
    return nil;
}

+ (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result documentViewController:(PTDocumentViewController *)docVC
{
    if ([call.method isEqualToString:PTImportAnnotationCommandKey]) {
        NSString *xfdfCommand = [PTPluginUtils PT_idAsNSString:call.arguments[PTXfdfCommandArgumentKey]];
        [PTPluginUtils importAnnotationCommand:xfdfCommand documentViewController:docVC];
    } else if ([call.method isEqualToString:PTImportBookmarksKey]) {
        NSString *bookmarkJson = [PTPluginUtils PT_idAsNSString:call.arguments[PTBookmarkJsonArgumentKey]];
        [PTPluginUtils importBookmarks:bookmarkJson documentViewController:docVC];
    } else if ([call.method isEqualToString:PTSaveDocumentKey]) {
        [PTPluginUtils saveDocument:result documentViewController:docVC];
    } else if ([call.method isEqualToString:PTGetPageCropBoxKey]) {
        NSNumber *pageNumber = [PTPluginUtils PT_idAsNSNumber:call.arguments[PTPageNumberArgumentKey]];
        [PTPluginUtils getPageCropBox:pageNumber resultToken:result documentViewController:docVC];
    } else {
        result(FlutterMethodNotImplemented);
    }
}


+ (void)importAnnotationCommand:(NSString *)xfdfCommand documentViewController:(PTDocumentViewController *)docVC
{
    if(docVC.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        return;
    }
    
    NSError* error;
    
    [docVC.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        if([doc HasDownloader])
        {
            // too soon
            NSLog(@"Error: The document is still being downloaded.");
            return;
        }

        PTFDFDoc* fdfDoc = [doc FDFExtract:e_ptboth];
        [fdfDoc MergeAnnots:xfdfCommand permitted_user:@""];
        [doc FDFUpdate:fdfDoc];

        [docVC.pdfViewCtrl Update:YES];

    } error:&error];
    
    if(error)
    {
        NSLog(@"Error: There was an error while trying to import annotation commands. %@", error.localizedDescription);
    }
}

+ (void)importBookmarks:(NSString *)bookmarkJson documentViewController:(PTDocumentViewController *)docVC
{
    if(docVC.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        return;
    }
    
    NSError* error;
    
    [docVC.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        if([doc HasDownloader])
        {
            // too soon
            NSLog(@"Error: The document is still being downloaded.");
            return;
        }

        [PTBookmarkManager.defaultManager importBookmarksForDoc:doc fromJSONString:bookmarkJson];

    } error:&error];
    
    if(error)
    {
        NSLog(@"Error: There was an error while trying to import bookmarks. %@", error.localizedDescription);
    }
}

+ (void)saveDocument:(FlutterResult)flutterResult documentViewController:(PTDocumentViewController *)docVC
{
    __block NSString* resultString;

    if(docVC.document == Nil)
    {
        resultString = @"Error: The document view controller has no document.";
        
        // something is wrong, no document.
        NSLog(@"%@", resultString);
        flutterResult(resultString);
        
        return;
    }
    
    NSError* error;
    
    [docVC.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        if([doc HasDownloader])
        {
            // too soon
            resultString = @"Error: The document is still being downloaded and cannot be saved.";
            NSLog(@"%@", resultString);
            flutterResult(resultString);
            return;
        }

        [docVC saveDocument:0 completionHandler:^(BOOL success) {
            if(!success)
            {
                resultString = @"Error: The file could not be saved.";
                NSLog(@"%@", resultString);
                flutterResult(resultString);
            }
            else
            {
                resultString = @"The file was successfully saved.";
                flutterResult(resultString);
            }
        }];

    } error:&error];
    
    if(error)
    {
        NSLog(@"Error: There was an error while trying to save the document. %@", error.localizedDescription);
    }
}

+ (void)getPageCropBox:(NSNumber *)pageNumber resultToken:(FlutterResult)result documentViewController:(PTDocumentViewController *)docVC
{
    NSError *error;
    [docVC.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
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
                PTX1Key: @([rect GetX1]),
                PTY1Key: @([rect GetY1]),
                PTX2Key: @([rect GetX2]),
                PTY2Key: @([rect GetY2]),
                PTWidthKey: @([rect Width]),
                PTHeightKey: @([rect Height]),
            };
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:map options:0 error:nil];
            NSString *res = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            result(res);
        }

    } error:&error];
    
    if(error)
    {
        NSLog(@"Error: There was an error while trying to get the page crop box. %@", error.localizedDescription);
    }
}

@end
