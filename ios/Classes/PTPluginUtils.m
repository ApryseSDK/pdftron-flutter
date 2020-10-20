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

+ (NSString *)PT_idToJSONString:(id)infoId {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoId options:0 error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (id)PT_JSONStringToId:(NSString *)jsonString {
    NSData *annotListData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:annotListData options:kNilOptions error:nil];
}

+ (PTAnnot *)findAnnotWithUniqueID:(NSString *)uniqueID onPageNumber:(int)pageNumber documentViewController:(PTDocumentViewController *)docVC error:(NSError **)error
{
    if (uniqueID.length == 0 || pageNumber < 1) {
        return nil;
    }
    PTPDFViewCtrl *pdfViewCtrl = docVC.pdfViewCtrl;
    __block PTAnnot *resultAnnot;

    [docVC.pdfViewCtrl DocLockReadWithBlock:^(PTPDFDoc * _Nullable doc) {
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
    } error:error];
   
    if(*error)
    {
        NSLog(@"Error: There was an error while trying to find annotation with id and page number. %@", (*error).localizedDescription);
    }
    
    return resultAnnot;
}

+(NSArray<PTAnnot *> *)getAnnotationsOnPage:(int)pageNumber documentViewController:(PTDocumentViewController *)docVC
{
    __block NSArray<PTAnnot *> *annots;
    NSError* error;
    [docVC.pdfViewCtrl DocLockReadWithBlock:^(PTPDFDoc * _Nullable doc) {
        annots = [docVC.pdfViewCtrl GetAnnotationsOnPage:pageNumber];
    } error:&error];
    
    if (error) {
        NSLog(@"Error: There was an error while trying to find annotations in page number. %@", error.localizedDescription);
    }
    
    return annots;
}

+(NSArray<PTAnnot *> *)findAnnotsWithUniqueIDs:(NSArray <NSDictionary *>*)idPageNumberPairs documentViewController:(PTDocumentViewController *)docVC error:(NSError **)error
{
    NSMutableArray<PTAnnot *> *resultAnnots = [[NSMutableArray alloc] init];
    
    NSMutableDictionary <NSNumber *, NSMutableArray <NSString *> *> *pageNumberAnnotDict = [[NSMutableDictionary alloc] init];
    
    // put all annotations in a dict indexed by page number
    for (NSDictionary *idPageNumberPair in idPageNumberPairs) {
        NSNumber *pageNumber = [PTPluginUtils PT_idAsNSNumber:idPageNumberPair[PTAnnotPageNumberKey]];
        NSString *annotId = [PTPluginUtils PT_idAsNSString:idPageNumberPair[PTAnnotIdKey]];
        NSMutableArray <NSString *> *annotArray;
        if (![pageNumberAnnotDict objectForKey:pageNumber]) {
            annotArray = [[NSMutableArray alloc] init];

        } else {
            annotArray = pageNumberAnnotDict[pageNumber];
        }
        
        [annotArray addObject:annotId];
        pageNumberAnnotDict[pageNumber] = annotArray;
    }
    
    // loop through page numbers
    for (NSNumber *pageNumber in [pageNumberAnnotDict allKeys]) {
        
        __block NSArray<PTAnnot *> * annotsOnCurrPage;
        
        [docVC.pdfViewCtrl DocLockReadWithBlock:^(PTPDFDoc * _Nullable doc) {
            annotsOnCurrPage = [PTPluginUtils getAnnotationsOnPage:[pageNumber intValue] documentViewController:docVC];
        } error:error];
        
        if (*error) {
            NSLog(@"Error: There was an error while trying to get annotations on page for doc. %@", (*error).localizedDescription);
            return nil;
        }
            
        for (PTAnnot *annotFromDoc in annotsOnCurrPage) {
            if (![annotFromDoc IsValid]) {
                continue;
            }
            
            NSString *annotUniqueId = nil;
            PTObj *annotUniqueIdObj = [annotFromDoc GetUniqueID];
            if ([annotUniqueIdObj IsValid]) {
                annotUniqueId = [annotUniqueIdObj GetAsPDFText];
            }
            if (annotUniqueId) {
                
                for (NSString *annotIdFromDict in pageNumberAnnotDict[pageNumber]) {
                    if ([annotIdFromDict isEqualToString:annotUniqueId]) {
                        [resultAnnots addObject:annotFromDoc];
                        break;
                    }
                }
            }
        }
    }
    
    return [resultAnnots copy];
}

#pragma mark - Functions

+ (void)importAnnotations:(NSString *)xfdfCommand resultToken:(FlutterResult)flutterResult documentViewController:(PTDocumentViewController *)docVC
{
    if(docVC.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        
        flutterResult([FlutterError errorWithCode:@"import_annotations" message:@"Failed to import annotations" details:@"Error: The document view controller has no document."]);
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
        flutterResult([FlutterError errorWithCode:@"import_annotations" message:@"Failed to import annotations" details:@"Error: There was an error while trying to import annotations."]);
    } else {
        flutterResult(nil);
    }
}

+ (void)exportAnnotations:(NSString *)annotationList resultToken:(FlutterResult)flutterResult documentViewController:(PTDocumentViewController *)docVC
{
    if(docVC.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        
        flutterResult([FlutterError errorWithCode:@"export_annotations" message:@"Failed to export annotations" details:@"Error: The document view controller has no document."]);
        return;
    }
    
    NSError *error;
    
    if (!annotationList) {
        [docVC.pdfViewCtrl DocLockReadWithBlock:^(PTPDFDoc * _Nullable doc) {
            PTFDFDoc *fdfDoc = [doc FDFExtract:e_ptboth];
            flutterResult([fdfDoc SaveAsXFDFToString]);
        }error:&error];
        
        if (error) {
            NSLog(@"Error: Failed to extract fdf from doc. %@", error.localizedDescription);
            flutterResult([FlutterError errorWithCode:@"export_annotations" message:@"Failed to export annotations" details:@"Failed to extract fdf from doc."]);
        }
        return;
    }
    
    NSArray *annotArray = [PTPluginUtils PT_idAsArray:[PTPluginUtils PT_JSONStringToId:annotationList]];
    
    NSArray <PTAnnot *> *matchingAnnots = [PTPluginUtils findAnnotsWithUniqueIDs:annotArray documentViewController:docVC error:&error];
    
    if (error) {
        NSLog(@"Error: Failed to get annotations from doc. %@", error.localizedDescription);
        
        flutterResult([FlutterError errorWithCode:@"export_annotations" message:@"Failed to export annotations" details:@"Error: Failed to get annotations from doc."]);
        return;
    }
    
    if (matchingAnnots.count == 0) {
        flutterResult(@"");
    }
    
    PTVectorAnnot *resultAnnots = [[PTVectorAnnot alloc] init];
    for (PTAnnot *annot in matchingAnnots) {
        [resultAnnots add:annot];
    }
    
    __block NSString *resultString;
    [docVC.pdfViewCtrl DocLockReadWithBlock:^(PTPDFDoc * _Nullable doc) {
        
        PTFDFDoc *fdfDoc = [doc FDFExtractAnnots:resultAnnots];
        resultString = [fdfDoc SaveAsXFDFToString];
        
    } error:&error];
    
    if(error)
    {
        NSLog(@"Error: Failed to extract fdf from doc. %@", error.localizedDescription);
        flutterResult([FlutterError errorWithCode:@"export_annotations" message:@"Failed to export annotations" details:@"Error: Failed to extract fdf from doc."]);
    } else {
        flutterResult(resultString);
    }
}


+ (void)flattenAnnotations:(bool)formsOnly resultToken:(FlutterResult)flutterResult documentViewController:(PTDocumentViewController *)docVC
{
    
    [docVC.toolManager changeTool:[PTPanTool class]];
    
    if(docVC.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        
        flutterResult([FlutterError errorWithCode:@"flatten_annotations" message:@"Failed to flatten annotations" details:@"Error: The document view controller has no document."]);
        return;
    }
    
    NSError *error;
    
    [docVC.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        [doc FlattenAnnotations:formsOnly];
    } error:&error];
    
    if(error)
    {
        NSLog(@"Error: Failed to flatten annotations from doc. %@", error.localizedDescription);
        flutterResult([FlutterError errorWithCode:@"flatten_annotations" message:@"Failed to flatten annotations" details:@"Error: Failed to flatten annotations from doc."]);
    } else {
        flutterResult(nil);
    }
}

+ (void)deleteAnnotations:(NSString *)annotationList resultToken:(FlutterResult)flutterResult documentViewController:(PTDocumentViewController *)docVC
{
    if(docVC.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");

        flutterResult([FlutterError errorWithCode:@"delete_annotations" message:@"Failed to delete annotations" details:@"Error: The document view controller has no document."]);
        return;
    }
    
    NSError* error;
    
    NSArray *annotArray = [PTPluginUtils PT_idAsArray:[PTPluginUtils PT_JSONStringToId:annotationList]];
    
    NSArray* matchingAnnots = [PTPluginUtils findAnnotsWithUniqueIDs:annotArray documentViewController:docVC error:&error];
    
    if (error) {
        NSLog(@"Error: Failed to get annotations from doc. %@", error.localizedDescription);
        
        flutterResult([FlutterError errorWithCode:@"delete_annotations" message:@"Failed to delete annotations" details:@"Error: Failed to get annotations from doc."]);
        return;
    }
    
    for (PTAnnot *annot in matchingAnnots) {
        [docVC.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
            PTPage *page = [annot GetPage];
            if (page && [page IsValid]) {
                int pageNumber = [page GetIndex];
                [docVC.toolManager willRemoveAnnotation:annot onPageNumber:pageNumber];
                
                [page AnnotRemoveWithAnnot:annot];
                [docVC.pdfViewCtrl UpdateWithAnnot:annot page_num:pageNumber];
                
                [docVC.toolManager annotationRemoved:annot onPageNumber:pageNumber];
            }
        } error:&error];
        
        if (error) {
            NSLog(@"Error: Failed to delete annotations from doc. %@", error.localizedDescription);
            
            flutterResult([FlutterError errorWithCode:@"delete_annotations" message:@"Failed to delete annotations" details:@"Error: Failed to delete annotations from doc."]);
            return;
        }
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
        
        flutterResult([FlutterError errorWithCode:@"select_annotations" message:@"Failed to select annotations" details:@"Error: The document view controller has no document."]);
        return;
    }
    
    
    NSDictionary *annotationJson = [PTPluginUtils PT_idAsNSDict:[PTPluginUtils PT_JSONStringToId:annotation]];
    
    NSString *annotId = [PTPluginUtils PT_idAsNSString:annotationJson[PTAnnotIdKey]];
    int pageNumber = [[PTPluginUtils PT_idAsNSNumber:annotationJson[PTAnnotPageNumberKey]] intValue];
    
    NSError* error;
    
    PTAnnot *annot = [PTPluginUtils findAnnotWithUniqueID:annotId onPageNumber:pageNumber documentViewController:docVC error:&error];
    
    if (error) {
        NSLog(@"Error: Failed to find annotation with unique id. %@", error.localizedDescription);
        
        flutterResult([FlutterError errorWithCode:@"select_annotations" message:@"Failed to select annotations" details:@"Error: Failed to find annotation with unique id."]);
        return;
    }
    
    [docVC.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        [docVC.toolManager selectAnnotation:annot onPageNumber:pageNumber];
    } error:&error];
    
    if(error) {
        NSLog(@"Error: Failed to select annotation from doc. %@", error.localizedDescription);
        flutterResult([FlutterError errorWithCode:@"select_annotations" message:@"Failed to select annotations" details:@"Error: Failed to select annotation from doc."]);
    } else {
        flutterResult(nil);
    }
}

+ (void)setFlagForAnnotations:(NSString *)annotationsWithFlags resultToken:(FlutterResult)flutterResult documentViewController:(PTDocumentViewController *)docVC
{
    if(docVC.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        flutterResult([FlutterError errorWithCode:@"set_flag_for_annotations" message:@"Failed to set flag for annotations" details:@"Error: The document view controller has no document."]);
        return;
    }
    
    NSError* error;
    
    NSArray *annotationWithFlagsArray = [PTPluginUtils PT_idAsArray:[PTPluginUtils PT_JSONStringToId:annotationsWithFlags]];
        
    for (NSDictionary *currentAnnotationWithFlags in annotationWithFlagsArray)
    {
        NSDictionary *currentAnnotationDict = [PTPluginUtils PT_idAsNSDict:[PTPluginUtils PT_JSONStringToId:currentAnnotationWithFlags[PTAnnotationArgumentKey]]];
            
        NSString *currentAnnotationId = [PTPluginUtils PT_idAsNSString:currentAnnotationDict[PTAnnotIdKey]];
        int currentPageNumber = [[PTPluginUtils PT_idAsNSNumber:currentAnnotationDict[PTAnnotPageNumberKey]] intValue];
            
        PTAnnot *currentAnnot = [PTPluginUtils findAnnotWithUniqueID:currentAnnotationId onPageNumber:currentPageNumber documentViewController:docVC error:&error];
        
        if (error) {
            NSLog(@"Error: Failed to find annotation with unique id. %@", error.localizedDescription);
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
                    
                [docVC.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
                    [docVC.toolManager willModifyAnnotation:currentAnnot onPageNumber:currentPageNumber];
                    
                    [currentAnnot SetFlag:flagNumber value:currentFlagValue];
                    
                    [docVC.toolManager annotationModified:currentAnnot onPageNumber:currentPageNumber];
                    }error:&error];
                
                if (error) {
                    NSLog(@"Error: Failed to set flag for annotation. %@", error.localizedDescription);
                }
            }
        }
    }
    
    flutterResult(nil);
}

+ (void)importAnnotationCommand:(NSString *)xfdfCommand resultToken:(FlutterResult)flutterResult documentViewController:(PTDocumentViewController *)docVC
{
    if(docVC.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        flutterResult([FlutterError errorWithCode:@"import_annotation_command" message:@"Failed to import annotation command" details:@"Error: The document view controller has no document."]);
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
        NSLog(@"Error: Failed to import annotation commands to doc. %@", error.localizedDescription);
        flutterResult([FlutterError errorWithCode:@"import_annotation_command" message:@"Failed to import annotation command" details:@"Error: Failed to import annotation commands to doc."]);
    } else {
        flutterResult(nil);
    }
}

+ (void)importBookmarks:(NSString *)bookmarkJson resultToken:(FlutterResult)flutterResult documentViewController:(PTDocumentViewController *)docVC
{
    if(docVC.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        flutterResult([FlutterError errorWithCode:@"import_bookmarks" message:@"Failed to import bookmarks" details:@"Error: The document view controller has no document."]);
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
        NSLog(@"Error: Failed to import bookmarks to doc. %@", error.localizedDescription);
        flutterResult([FlutterError errorWithCode:@"import_bookmarks" message:@"Failed to import bookmarks" details:@"Error: Failed to import bookmarks to doc."]);
    } else {
        flutterResult(nil);
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

+ (void)commitTool:(FlutterResult)flutterResult documentViewController:(PTDocumentViewController *)docVC
{
    PTToolManager *toolManager = docVC.toolManager;
    if ([toolManager.tool respondsToSelector:@selector(commitAnnotation)]) {
        [toolManager.tool performSelector:@selector(commitAnnotation)];
        
        [toolManager changeTool:[PTPanTool class]];
        
        flutterResult([NSNumber numberWithBool:YES]);
    } else {
        flutterResult([NSNumber numberWithBool:NO]);
    }
}

+ (void)getPageCount:(FlutterResult)flutterResult documentViewController:(PTDocumentViewController *)docVC
{
    if(docVC.document == Nil)
    {
        NSString *resultString = @"Error: The document view controller has no document.";
        
        // something is wrong, no document.
        NSLog(@"%@", resultString);
        flutterResult(resultString);
        
        return;
    }
    
    flutterResult([NSNumber numberWithInt:docVC.pdfViewCtrl.pageCount]);
}

+ (void)getPageCropBox:(NSNumber *)pageNumber resultToken:(FlutterResult)result documentViewController:(PTDocumentViewController *)docVC
{
    if(docVC.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        flutterResult([FlutterError errorWithCode:@"get_page_crop_box" message:@"Failed to get page crop box" details:@"Error: The document view controller has no document."]);
        return;
    }
    
    NSError *error;
    [docVC.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        
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
            
            flutterResult([PTPluginUtils PT_idToJSONString:map]);
        }

    } error:&error];
    
    if(error)
    {
        NSLog(@"Error: Failed to get the page crop box from doc. %@", error.localizedDescription);
        flutterResult([FlutterError errorWithCode:@"get_page_crop_box" message:@"Failed to get page crop box" details:@"Error: Failed to get the page crop box from doc."]);
    }
}

@end
