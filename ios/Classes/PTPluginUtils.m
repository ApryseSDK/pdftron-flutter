#import "PTPluginUtils.h"
#import "PdftronFlutterPlugin.h"
#import "FlutterDocumentView.h"

@implementation PTPluginUtils

+ (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result documentViewController:(PTDocumentViewController *)docVC
{
    if ([call.method isEqualToString:PTImportAnnotationsKey]) {
        NSString *xfdfCommand = [PTPluginUtils PT_idAsNSString:call.arguments[PTXfdfCommandArgumentKey]];;
        [PTPluginUtils importAnnotations:xfdfCommand resultToken:result documentViewController:docVC];
    } else if ([call.method isEqualToString:PTExportAnnotationsKey]) {
        NSString *annotationList = [PTPluginUtils PT_idAsNSString:call.arguments[PTAnnotationListArgumentKey]];;
        [PTPluginUtils exportAnnotations:annotationList resultToken:result documentViewController:docVC];
    } else if ([call.method isEqualToString:PTFlattenAnnotationsKey]) {
        bool formsOnly = [PTPluginUtils PT_idAsBool:call.arguments[PTFormsOnlyArgumentKey]];;
        [PTPluginUtils flattenAnnotations:formsOnly resultToken:result documentViewController:docVC];
    } else if ([call.method isEqualToString:PTDeleteAnnotationsKey]) {
        NSString *annotationList = [PTPluginUtils PT_idAsNSString:call.arguments[PTAnnotationListArgumentKey]];;
        [PTPluginUtils deleteAnnotations:annotationList resultToken:result documentViewController:docVC];
    } else if ([call.method isEqualToString:PTSelectAnnotationKey]) {
        NSString *annotation = [PTPluginUtils PT_idAsNSString:call.arguments[PTAnnotationArgumentKey]];
        [PTPluginUtils selectAnnotation:annotation resultToken:result documentViewController:docVC];
    } else if ([call.method isEqualToString:PTSetFlagForAnnotationsKey]) {
        NSString *annotationsWithFlags = [PTPluginUtils PT_idAsNSString:call.arguments[PTAnnotationsWithFlagsArgumentKey]];
        [PTPluginUtils setFlagForAnnotations:annotationsWithFlags resultToken:result documentViewController:docVC];
    } else if ([call.method isEqualToString:PTImportAnnotationCommandKey]) {
        NSString *xfdfCommand = [PTPluginUtils PT_idAsNSString:call.arguments[PTXfdfCommandArgumentKey]];
        [PTPluginUtils importAnnotationCommand:xfdfCommand resultToken:result documentViewController:docVC];
    } else if ([call.method isEqualToString:PTImportBookmarksKey]) {
        NSString *bookmarkJson = [PTPluginUtils PT_idAsNSString:call.arguments[PTBookmarkJsonArgumentKey]];
        [PTPluginUtils importBookmarks:bookmarkJson resultToken:result documentViewController:docVC];
    } else if ([call.method isEqualToString:PTSaveDocumentKey]) {
        [PTPluginUtils saveDocument:result documentViewController:docVC];
    } else if ([call.method isEqualToString:PTGetPageCropBoxKey]) {
        NSNumber *pageNumber = [PTPluginUtils PT_idAsNSNumber:call.arguments[PTPageNumberArgumentKey]];
        [PTPluginUtils getPageCropBox:pageNumber resultToken:result documentViewController:docVC];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

#pragma mark - Helpers

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

+ (bool)PT_idAsBool:(id)value
{
    NSNumber* numericVal = [PTPluginUtils PT_idAsNSNumber:value];
    bool result = [numericVal boolValue];
    return result;
}

+ (NSDictionary *)PT_idAsNSDict:(id)value
{
    if ([value isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)value;
    }
    return nil;
}

+ (NSArray *)PT_idAsArray:(id)value
{
    if ([value isKindOfClass:[NSArray class]]) {
        return (NSArray *)value;
    }
    return nil;
}

+ (PTAnnot *)findAnnotWithUniqueID:(NSString *)uniqueID onPageNumber:(int)pageNumber documentViewController:(PTDocumentViewController *)docVC
{
    if (uniqueID.length == 0 || pageNumber < 1) {
        return nil;
    }
    PTPDFViewCtrl *pdfViewCtrl = docVC.pdfViewCtrl;
    __block PTAnnot *resultAnnot;
    NSError *error;
    [docVC.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        NSArray<PTAnnot *> *annots = [pdfViewCtrl GetAnnotationsOnPage:pageNumber];
        for (PTAnnot *annot in annots) {
            if (![annot IsValid]) {
                continue;
            }
            
            // Check if the annot's unique ID matches.
            NSString *annotUniqueId = nil;
            PTObj *annotUniqueIdObj = [annot GetUniqueID];
            if ([annotUniqueIdObj IsValid]) {
                annotUniqueId = [annotUniqueIdObj GetAsPDFText];
            }
            if (annotUniqueId && [annotUniqueId isEqualToString:uniqueID]) {
                resultAnnot = annot;
                break;
            }
        }
    } error:&error];
   
    if(error)
    {
        NSLog(@"Error: There was an error while trying to find annotation with id and page number. %@", error.localizedDescription);
    }
    
    return resultAnnot;
}

+ (NSString *)PT_idToJSONString:(id)infoId {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoId options:0 error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (id)PT_JSONStringToId:(NSString *)jsonString {
    NSData *annotListData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:annotListData options:kNilOptions error:nil];
}

#pragma mark - Functions

+ (void)importAnnotations:(NSString *)xfdfCommand resultToken:(FlutterResult)flutterResult documentViewController:(PTDocumentViewController *)docVC
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
        
        PTFDFDoc *fdfDoc = [PTFDFDoc CreateFromXFDF:xfdfCommand];
        
        [doc FDFUpdate:fdfDoc];
        [docVC.pdfViewCtrl Update:YES];
        
    } error:&error];
    
    if(error)
    {
        NSLog(@"Error: There was an error while trying to import annotations. %@", error.localizedDescription);
    }
    
    flutterResult(nil);
}

+ (void)exportAnnotations:(NSString *)annotationList resultToken:(FlutterResult)flutterResult documentViewController:(PTDocumentViewController *)docVC
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
        
        if (!annotationList) {
            PTFDFDoc *fdfDoc = [doc FDFExtract:e_ptboth];
            flutterResult([fdfDoc SaveAsXFDFToString]);
        } else {
            PTVectorAnnot *annots = [[PTVectorAnnot alloc] init];
            
            
            NSArray *array = [PTPluginUtils PT_idAsArray:[PTPluginUtils PT_JSONStringToId:annotationList]];
            
            for (NSDictionary *annotation in array) {
                NSString *annotationId = annotation[PTAnnotIdKey];
                int pageNumber = ((NSNumber *)annotation[PTAnnotPageNumberKey]).intValue;
                if (annotationId.length > 0) {
                    PTAnnot *annot = [PTPluginUtils findAnnotWithUniqueID:annotationId onPageNumber:pageNumber documentViewController:docVC];
                    if ([annot IsValid]) {
                        [annots add:annot];
                    }
                }
            }
            
            if ([annots size] > 0) {
                PTFDFDoc *fdfDoc = [doc FDFExtractAnnots:annots];
                flutterResult([fdfDoc SaveAsXFDFToString]);
            } else {
                flutterResult(nil);
            }
        }
        
    } error:&error];
    
    if(error)
    {
        NSLog(@"Error: There was an error while trying to export annotations. %@", error.localizedDescription);
    }
}


+ (void)flattenAnnotations:(bool)formsOnly resultToken:(FlutterResult)flutterResult documentViewController:(PTDocumentViewController *)docVC
{
    if(docVC.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        return;
    }
    
    [docVC.toolManager changeTool:[PTPanTool class]];
    
    NSError *error;
    
    [docVC.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        if([doc HasDownloader])
        {
            // too soon
            NSLog(@"Error: The document is still being downloaded.");
            return;
        }
        
        [doc FlattenAnnotations:formsOnly];
        
    } error:&error];
    
    if(error)
    {
        NSLog(@"Error: There was an error while trying to flatten annotations. %@", error.localizedDescription);
    }
    
    flutterResult(nil);
}

+ (void)deleteAnnotations:(NSString *)annotationList resultToken:(FlutterResult)flutterResult documentViewController:(PTDocumentViewController *)docVC
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
        
        if (!annotationList) {
            NSLog(@"Error: Invalid delete annotation input.");
            return;
        } else {
            
            NSArray *array = [PTPluginUtils PT_idAsArray:[PTPluginUtils PT_JSONStringToId:annotationList]];
            
            for (NSDictionary *annotation in array) {
                NSString *annotationId = annotation[PTAnnotIdKey];
                int pageNumber = ((NSNumber *)annotation[PTAnnotPageNumberKey]).intValue;
                if (annotationId.length > 0) {
                    PTAnnot *annot = [PTPluginUtils findAnnotWithUniqueID:annotationId onPageNumber:pageNumber documentViewController:docVC];
                    if (annot && [annot IsValid]) {
                        PTPage *page = [doc GetPage:pageNumber];
                        if (page && [page IsValid]) {
                            [page AnnotRemoveWithAnnot:annot];
                            [docVC.pdfViewCtrl UpdateWithAnnot:annot page_num:pageNumber];
                            
                            [docVC.toolManager annotationRemoved:annot onPageNumber:pageNumber];
                        }
                    }
                }
            }
        }
        
    } error:&error];
    
    if(error)
    {
        NSLog(@"Error: There was an error while trying to export annotations. %@", error.localizedDescription);
    }
    
    [docVC.toolManager changeTool:[PTPanTool class]];
    
    flutterResult(nil);
}

+ (void)selectAnnotation:(NSString *)annotation resultToken:(FlutterResult)flutterResult documentViewController:(PTDocumentViewController *)docVC
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

        NSDictionary *annotationJson = [PTPluginUtils PT_idAsNSDict:[PTPluginUtils PT_JSONStringToId:annotation]];
        
        NSString *annotId = [PTPluginUtils PT_idAsNSString:annotationJson[PTAnnotIdKey]];
        int pageNumber = [[PTPluginUtils PT_idAsNSNumber:annotationJson[PTAnnotPageNumberKey]] intValue];
        
        PTAnnot *annot = [PTPluginUtils findAnnotWithUniqueID:annotId onPageNumber:pageNumber documentViewController:docVC];
        
        [docVC.toolManager selectAnnotation:annot onPageNumber:pageNumber];

        [docVC.pdfViewCtrl UpdateWithAnnot:annot page_num:pageNumber];

    } error:&error];
    
    if(error)
    {
        NSLog(@"Error: There was an error while trying to select annotation. %@", error.localizedDescription);
    }
    
    flutterResult(nil);
}

+ (void)setFlagForAnnotations:(NSString *)annotationsWithFlags resultToken:(FlutterResult)flutterResult documentViewController:(PTDocumentViewController *)docVC
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

        NSArray *annotationWithFlagsArray = [PTPluginUtils PT_idAsArray:[PTPluginUtils PT_JSONStringToId:annotationsWithFlags]];
        
        for (NSDictionary *currentAnnotationWithFlags in annotationWithFlagsArray)
        {
            NSDictionary *currentAnnotation = [PTPluginUtils PT_idAsNSDict:[PTPluginUtils PT_JSONStringToId:currentAnnotationWithFlags[PTAnnotationArgumentKey]]];
            
            NSString *currentAnnotationId = [PTPluginUtils PT_idAsNSString:currentAnnotation[PTAnnotIdKey]];
            int currentPageNumber = [[PTPluginUtils PT_idAsNSNumber:currentAnnotation[PTAnnotPageNumberKey]] intValue];
            
            PTAnnot *currentAnnot = [PTPluginUtils findAnnotWithUniqueID:currentAnnotationId onPageNumber:currentPageNumber documentViewController:docVC];
            if (!currentAnnot || !currentAnnot.IsValid)
            {
                NSLog(@"Failed to find annotation with id \"%@\" on page number %d", currentAnnotationId, currentPageNumber);
                continue;
            }
            
            NSArray *flagList = [PTPluginUtils PT_idAsArray:[PTPluginUtils PT_JSONStringToId:currentAnnotationWithFlags[PTFlagListKey]]];
            
            for (NSDictionary *currentFlagDict in flagList)
            {
                NSString *currentFlag = [PTPluginUtils PT_idAsNSString:currentFlagDict[PTFlagKey]];
                bool currentFlagValue = [PTPluginUtils PT_idAsBool:currentFlagDict[PTFlagValueKey]];
                
                int flagNumber = -1;
                if ([currentFlag isEqualToString:PTAnnotationFlagPrintKey]) {
                    flagNumber = e_ptprint_annot;
                } else if ([currentFlag isEqualToString:PTAnnotationFlagHiddenKey]) {
                    flagNumber = e_pthidden;
                } else if ([currentFlag isEqualToString:PTAnnotationFlagLockedKey]) {
                    flagNumber = e_ptlocked;
                } else if ([currentFlag isEqualToString:PTAnnotationFlagLockedContentsKey]) {
                    flagNumber = e_ptlocked_contents;
                } else if ([currentFlag isEqualToString:PTAnnotationFlagInvisibleKey]) {
                    flagNumber = e_ptinvisible;
                } else if ([currentFlag isEqualToString:PTAnnotationFlagNoViewKey]) {
                    flagNumber = e_ptno_view;
                } else if ([currentFlag isEqualToString:PTAnnotationFlagNoZoomKey]) {
                    flagNumber = e_ptno_zoom;
                } else if ([currentFlag isEqualToString:PTAnnotationFlagNoRotateKey]) {
                    flagNumber = e_ptno_rotate;
                } else if ([currentFlag isEqualToString:PTAnnotationFlagReadOnlyKey]) {
                    flagNumber = e_ptread_only;
                } else if ([currentFlag isEqualToString:PTAnnotationFlagToggleNoViewKey]) {
                    flagNumber = e_pttoggle_no_view;
                }
                
                if (flagNumber != -1) {
                    [currentAnnot SetFlag:flagNumber value:currentFlagValue];
                }
            }
        }

    } error:&error];
    
    if(error)
    {
        NSLog(@"Error: There was an error while trying to set flag for annotations. %@", error.localizedDescription);
    }
    
    flutterResult(nil);
}

+ (void)importAnnotationCommand:(NSString *)xfdfCommand resultToken:(FlutterResult)flutterResult documentViewController:(PTDocumentViewController *)docVC
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
    
    flutterResult(nil);
}

+ (void)importBookmarks:(NSString *)bookmarkJson resultToken:(FlutterResult)flutterResult documentViewController:(PTDocumentViewController *)docVC
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
    
    flutterResult(nil);
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
            
            result([PTPluginUtils PT_idToJSONString:map]);
        }

    } error:&error];
    
    if(error)
    {
        NSLog(@"Error: There was an error while trying to get the page crop box. %@", error.localizedDescription);
    }
}

@end
