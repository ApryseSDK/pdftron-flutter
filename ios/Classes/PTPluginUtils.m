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

+ (NSDictionary *)PT_idAsNSDict:(id)value
{
    if ([value isKindOfClass:[NSDictionary class]]) {
        return (NSDictionary *)value;
    }
    return nil;
}

+ (NSArray *)PT_idAsNSArray:(id)value
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
    } else if ([call.method isEqualToString:PTSetFlagForFieldsKey]) {
        NSArray *fieldNames = [PTPluginUtils PT_idAsNSArray:call.arguments[PTFieldNamesArgumentKey]];
        NSNumber *flag = [PTPluginUtils PT_idAsNSNumber:call.arguments[PTFlagArgumentKey]];
        bool flagValue = [[PTPluginUtils PT_idAsNSNumber:call.arguments[PTFlagValueArgumentKey]] boolValue];
        [PTPluginUtils setFlagForFields:fieldNames flag:flag flagValue:flagValue resultToken:result documentViewController:docVC];
    } else if ([call.method isEqualToString:PTSetValueForFieldsKey]) {
        NSString *fieldWithValuesString = [PTPluginUtils PT_idAsNSString:call.arguments[PTFieldsArgumentKey]];
        [PTPluginUtils setValueForFields:fieldWithValuesString resultToken:result documentViewController:docVC];
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

+ (void)setToolMode:(NSString *)toolMode resultToken:(FlutterResult)result documentViewController:(PTDocumentViewController *)docVC continuousAnnotationEditing:(bool)continuousAnnotEditing
{
    Class toolClass = Nil;
    
    if ([toolMode isEqualToString:PTAnnotationEditToolKey]) {
        // multi-select not implemented
    } else if([toolMode isEqualToString:PTAnnotationCreateStickyToolKey]) {
        toolClass = [PTStickyNoteCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateFreeHandToolKey]) {
        toolClass = [PTFreeHandCreate class];
    } else if ([toolMode isEqualToString:PTTextSelectToolKey]) {
        toolClass = [PTTextSelectTool class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateSoundToolKey]) {
        toolClass = [PTSound class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateTextHighlightToolKey]) {
        toolClass = [PTTextHighlightCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateTextUnderlineToolKey]) {
        toolClass = [PTTextUnderlineCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateTextSquigglyToolKey]) {
        toolClass = [PTTextSquigglyCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateTextStrikeoutToolKey]) {
        toolClass = [PTTextStrikeoutCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateFreeTextToolKey]) {
        toolClass = [PTFreeTextCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateCalloutToolKey]) {
        toolClass = [PTCalloutCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateSignatureToolKey]) {
        toolClass = [PTDigitalSignatureTool class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateLineToolKey]) {
        toolClass = [PTLineCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateArrowToolKey]) {
        toolClass = [PTArrowCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreatePolylineToolKey]) {
        toolClass = [PTPolylineCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateStampToolKey]) {
        toolClass = [PTImageStampCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateRectangleToolKey]) {
        toolClass = [PTRectangleCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateEllipseToolKey]) {
        toolClass = [PTEllipseCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreatePolygonToolKey]) {
        toolClass = [PTPolygonCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreatePolygonCloudToolKey]) {
        toolClass = [PTCloudCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateDistanceMeasurementToolKey]) {
        toolClass = [PTRulerCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreatePerimeterMeasurementToolKey]) {
        toolClass = [PTPerimeterCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateAreaMeasurementToolKey]) {
        toolClass = [PTAreaCreate class];
    } else if ([toolMode isEqualToString:PTEraserToolKey]) {
        toolClass = [PTEraser class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateFreeHighlighterToolKey]) {
        toolClass = [PTFreeHandHighlightCreate class];
    } else if ([toolMode isEqualToString:PTAnnotationCreateRubberStampToolKey]) {
        toolClass = [PTRubberStampCreate class];
        
    }
    
    if (toolClass) {
        PTTool *tool = [docVC.toolManager changeTool:toolClass];
        
        tool.backToPanToolAfterUse = !continuousAnnotEditing;

        if ([tool isKindOfClass:[PTFreeHandCreate class]]
            && ![tool isKindOfClass:[PTFreeHandHighlightCreate class]]) {
            ((PTFreeHandCreate *)tool).multistrokeMode = continuousAnnotEditing;
        }
    }
    
    result(nil);
}

+ (void)setFlagForFields:(NSArray <NSString *> *)fieldNames flag:(NSNumber *)flag flagValue:(bool)flagValue resultToken:(FlutterResult)result documentViewController:(PTDocumentViewController *)docVC
{
    if(docVC.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        return;
    }
    
    PTPDFViewCtrl *pdfViewCtrl = docVC.pdfViewCtrl;
    PTFieldFlag fieldFlag = (PTFieldFlag)flag.intValue;
    NSError *error;
  
    [pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        for (NSString *fieldName in fieldNames) {
            PTField *field = [doc GetField:fieldName];
            if ([field IsValid]) {
                [field SetFlag:fieldFlag value:flagValue];
                [pdfViewCtrl UpdateWithField:field];
            }
        }
    } error:&error];
   
    if (error) {
        @throw [NSException exceptionWithName:NSGenericException reason:error.localizedFailureReason userInfo:error.userInfo];
    }
    
    result(nil);
}

+ (void)setValueForFields:(NSString *)fieldWithValuesString resultToken:(FlutterResult)result documentViewController:(PTDocumentViewController *)docVC
{
    NSArray *fieldWithValues = [PTPluginUtils PT_idAsNSArray:[PTPluginUtils PT_JSONStringToId:fieldWithValuesString]];
    if(docVC.document == Nil)
    {
        // something is wrong, no document.
        NSLog(@"Error: The document view controller has no document.");
        return;
    }
    
    PTPDFViewCtrl *pdfViewCtrl = docVC.pdfViewCtrl;
    NSError *error;
    
    [pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        
        for (NSDictionary *fieldWithValue in fieldWithValues) {
            NSString *fieldName = [PTPluginUtils PT_idAsNSString:fieldWithValue[PTFieldNameKey]];
            id fieldValue = fieldWithValue[PTFieldValueKey];
            PTField *field = [doc GetField:fieldName];
            
            if ([field IsValid]) {
                [PTPluginUtils setFieldValue:field value:fieldValue pdfViewCtrl:pdfViewCtrl];
            }
        }
        
    } error:&error];
    
    if (error) {
        @throw [NSException exceptionWithName:NSGenericException reason:error.localizedFailureReason userInfo:error.userInfo];
    }
    
    result(nil);
}

// write-lock required around this method
+ (void)setFieldValue:(PTField *)field value:(id)value pdfViewCtrl:(PTPDFViewCtrl *)pdfViewCtrl
{
    const PTFieldType fieldType = [field GetType];
    
    // boolean or number
    if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber *numberValue = (NSNumber *)value;
        
        if (fieldType == e_ptcheck) {
            const BOOL fieldValue = numberValue.boolValue;
            PTViewChangeCollection *changeCollection = [field SetValueWithBool:fieldValue];
            [pdfViewCtrl RefreshAndUpdate:changeCollection];
        }
        else if (fieldType == e_pttext) {
            NSString *fieldValue = numberValue.stringValue;
            
            PTViewChangeCollection *changeCollection = [field SetValueWithString:fieldValue];
            [pdfViewCtrl RefreshAndUpdate:changeCollection];
        }
    }
    // string
    else if ([value isKindOfClass:[NSString class]]) {
        NSString *fieldValue = (NSString *)value;
        
        if (fieldValue &&
            (fieldType == e_pttext || fieldType == e_ptradio || fieldType == e_ptchoice)) {
            PTViewChangeCollection *changeCollection = [field SetValueWithString:fieldValue];
            [pdfViewCtrl RefreshAndUpdate:changeCollection];
        }
    }
}

@end
