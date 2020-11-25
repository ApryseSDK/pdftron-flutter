#import "PdftronFlutterPlugin.h"
#import "PTFlutterViewController.h"
#import "DocumentViewFactory.h"

@implementation PTFlutterViewController

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    if (self.needsDocumentLoaded) {
        self.needsDocumentLoaded = NO;
        self.needsRemoteDocumentLoaded = NO;
        self.documentLoaded = YES;

        if (self.initialPageNumber > 0) {
            [self.pdfViewCtrl SetCurrentPage:self.initialPageNumber];
        }
        
        [self applyLayoutMode];
        
        if (self.base64) {
            NSString *filePath = self.coordinatedDocument.fileURL.path;
            [self.plugin documentViewController:self documentLoadedFromFilePath:filePath];
        } else {
            [self.plugin documentViewController:self documentLoadedFromFilePath:nil];
        }
    }
}

- (void)openDocumentWithURL:(NSURL *)url password:(NSString *)password
{
    if ([url isFileURL]) {
        self.local = YES;
    } else {
        self.local = NO;
    }
    self.documentLoaded = NO;
    self.needsDocumentLoaded = NO;
    self.needsRemoteDocumentLoaded = NO;

    [super openDocumentWithURL:url password:password];
}

- (void)bookmarkViewController:(PTBookmarkViewController *)bookmarkViewController didAddBookmark:(PTUserBookmark *)bookmark
{
    [super bookmarkViewController:bookmarkViewController didAddBookmark:bookmark];
    [self bookmarksModified];
}

- (void)bookmarkViewController:(PTBookmarkViewController *)bookmarkViewController didRemoveBookmark:(PTUserBookmark *)bookmark
{
    [super bookmarkViewController:bookmarkViewController didRemoveBookmark:bookmark];
    [self bookmarksModified];
}

- (void)bookmarkViewController:(PTBookmarkViewController *)bookmarkViewController didModifyBookmark:(PTUserBookmark *)bookmark
{
    [super bookmarkViewController:bookmarkViewController didModifyBookmark:bookmark];
    [self bookmarksModified];
}

-(void)bookmarksModified
{
    __block NSString* json;
    NSError* error;
    BOOL exceptionOccurred = [self.pdfViewCtrl DocLockReadWithBlock:^(PTPDFDoc * _Nullable doc) {
        json = [PTBookmarkManager.defaultManager exportBookmarksFromDoc:doc];
    } error:&error];
    
    if(exceptionOccurred)
    {
        NSLog(@"Error: %@", error.description);
    }

    [self.plugin documentViewController:self bookmarksDidChange:json];
}

-(void)toolManager:(PTToolManager*)toolManager willRemoveAnnotation:(nonnull PTAnnot *)annotation onPageNumber:(int)pageNumber
{
    NSString* annotationsWithActionString = [self generateAnnotationWithActionString:annotation onPageNumber:pageNumber action:PTDeleteActionKey];
    if (annotationsWithActionString) {
        [self.plugin documentViewController:self annotationsChangedWithActionString:annotationsWithActionString];
    }
    
    NSString* xfdf = [self generateXfdfCommandWithAdded:Nil modified:Nil removed:@[annotation]];
    [self.plugin documentViewController:self annotationsAsXFDFCommand:xfdf];
    
}

- (void)toolManager:(PTToolManager *)toolManager annotationAdded:(PTAnnot *)annotation onPageNumber:(unsigned long)pageNumber
{
    NSString* annotationsWithActionString = [self generateAnnotationWithActionString:annotation onPageNumber:pageNumber action:PTAddActionKey];
    if (annotationsWithActionString) {
        [self.plugin documentViewController:self annotationsChangedWithActionString:annotationsWithActionString];
    }
    
    NSString* xfdf = [self generateXfdfCommandWithAdded:@[annotation] modified:Nil removed:Nil];
    [self.plugin documentViewController:self annotationsAsXFDFCommand:xfdf];
}

- (void)toolManager:(PTToolManager *)toolManager annotationModified:(PTAnnot *)annotation onPageNumber:(unsigned long)pageNumber
{
    NSString* annotationsWithActionString = [self generateAnnotationWithActionString:annotation onPageNumber:pageNumber action:PTModifyActionKey];
    if (annotationsWithActionString) {
        [self.plugin documentViewController:self annotationsChangedWithActionString:annotationsWithActionString];
    }
  
    NSString* xfdf = [self generateXfdfCommandWithAdded:Nil modified:@[annotation] removed:Nil];
    [self.plugin documentViewController:self annotationsAsXFDFCommand:xfdf];
}

- (void)toolManager:(PTToolManager *)toolManager didSelectAnnotation:(PTAnnot *)annotation onPageNumber:(unsigned long)pageNumber
{
    if (annotation.IsValid) {
        
        __block NSString *uniqueId;
        __block PTPDFRect *screenRect;
        
        NSError *error;
        [self.pdfViewCtrl DocLockReadWithBlock:^(PTPDFDoc * _Nullable doc) {
            PTObj *uniqueIdObj = [annotation GetUniqueID];
            if ([uniqueIdObj IsValid] && [uniqueIdObj IsString]) {
                uniqueId = [uniqueIdObj GetAsPDFText];
            }
            screenRect = [self.pdfViewCtrl GetScreenRectForAnnot:annotation
                                                                   page_num:(int)pageNumber];
        } error:&error];
        
        if (error) {
            NSLog(@"An error occurred: %@", error);
            return;
        }
        
        NSDictionary *annotDict = @{
            PTAnnotationIdKey: uniqueId ?: @"",
            PTAnnotationPageNumberKey: [NSNumber numberWithLong:pageNumber],
            PTRectKey: @{
                    PTX1Key: @([screenRect GetX1]),
                    PTY1Key: @([screenRect GetY1]),
                    PTX2Key: @([screenRect GetX2]),
                    PTY2Key: @([screenRect GetY2]),
                    PTWidthKey: @([screenRect Width]),
                    PTHeightKey: @([screenRect Height]),
            },
        };
        
        [self.plugin documentViewController:self annotationsSelected:[PdftronFlutterPlugin PT_idToJSONString:@[annotDict]]];
    }
}

- (void)toolManager:(PTToolManager *)toolManager formFieldDataModified:(PTAnnot *)annotation onPageNumber:(unsigned long)pageNumber {
    if (annotation.GetType == e_ptWidget) {
        NSError *error;
        
        __block NSString *fieldName;
        __block NSString *fieldValue;
        
        [self.pdfViewCtrl DocLockReadWithBlock:^(PTPDFDoc * _Nullable doc) {
            PTWidget *widget = [[PTWidget alloc] initWithAnn:annotation];
            PTField *field = [widget GetField];
            fieldName = [field IsValid] ? [field GetName] : @"";
            fieldValue = [field IsValid] ? [field GetValueAsString] : @"";
        } error:&error];
        if (error) {
            NSLog(@"An error occurred: %@", error);
            return;
        }
        
        if (fieldName && fieldValue) {
            NSDictionary *fieldDict = @{
                PTFormFieldNameKey: fieldName,
                PTFormFieldValueKey: fieldValue,
            };
            
            [self.plugin documentViewController:self formFieldValueChanged:[PdftronFlutterPlugin PT_idToJSONString:@[fieldDict]]];
        }
        // TODO: collab manager
        /*
         copied from RN
         
         if (!self.collaborationManager) {
             PTVectorAnnot *annots = [[PTVectorAnnot alloc] init];
             [annots add:annot];
             [self rnt_sendExportAnnotationCommandWithAction:PTModifyAnnotationActionKey xfdfCommand:[self generateXfdfCommand:[[PTVectorAnnot alloc] init] modified:annots deleted:[[PTVectorAnnot alloc] init]]];
         }
         */
    }
}

-(NSString*)generateXfdfCommandWithAdded:(NSArray<PTAnnot*>*)added modified:(NSArray<PTAnnot*>*)modified removed:(NSArray<PTAnnot*>*)removed
{
    
    PTPDFDoc* pdfDoc = self.document;
    
    if (pdfDoc) {
        PTVectorAnnot* addedV = [[PTVectorAnnot alloc] init];
        for(PTAnnot* annot in added)
        {
            [addedV add:annot];
        }
        
        PTVectorAnnot* modifiedV = [[PTVectorAnnot alloc] init];
        for(PTAnnot* annot in modified)
        {
            [modifiedV add:annot];
        }
        
        PTVectorAnnot* removedV = [[PTVectorAnnot alloc] init];
        for(PTAnnot* annot in removed)
        {
            [removedV add:annot];
        }
        
        NSError *error;
        
        __block PTFDFDoc* fdfDoc;
        [self.pdfViewCtrl DocLockReadWithBlock:^(PTPDFDoc * _Nullable doc) {
            fdfDoc = [pdfDoc FDFExtractCommand:addedV annot_modified:modifiedV annot_deleted:removedV];
        } error:&error];
        
        if (!error) {
            return [fdfDoc SaveAsXFDFToString];
        }
        NSLog(@"Error: %@", error.description);
    }
    return Nil;
}

-(NSString*)generateAnnotationWithActionString:(PTAnnot *)annotation onPageNumber:(unsigned long)pageNumber action:(NSString *)action
{
    
    if (annotation.IsValid) {
        
        __block NSString *uniqueId;
        
        NSError *error;
        [self.pdfViewCtrl DocLockReadWithBlock:^(PTPDFDoc * _Nullable doc) {
            PTObj *uniqueIdObj = [annotation GetUniqueID];
            if ([uniqueIdObj IsValid] && [uniqueIdObj IsString]) {
                uniqueId = [uniqueIdObj GetAsPDFText];
            }
        } error:&error];
        
        if (error) {
            NSLog(@"An error occurred: %@", error);
            return nil;
        }
        
        NSDictionary *annotDict = @{
            PTAnnotationIdKey: uniqueId,
            PTAnnotationPageNumberKey: [NSNumber numberWithLong:pageNumber],
        };
        
        NSDictionary *resultDict = @{
            PTAnnotationListKey: @[annotDict],
            PTActionKey: action,
        };
        
        return [PdftronFlutterPlugin PT_idToJSONString:resultDict];
    }
    return nil;
}

#pragma mark - <PTPDFViewCtrlDelegate>

- (void)pdfViewCtrl:(PTPDFViewCtrl *)pdfViewCtrl onSetDoc:(PTPDFDoc *)doc
{
    [super pdfViewCtrl:pdfViewCtrl onSetDoc:doc];

    if (self.local && !self.documentLoaded) {
        self.needsDocumentLoaded = YES;
    }
    else if (!self.local && !self.documentLoaded && self.needsRemoteDocumentLoaded) {
        self.needsDocumentLoaded = YES;
    }
    else if (!self.local && !self.documentLoaded && self.coordinatedDocument.fileURL) {
        self.needsDocumentLoaded = YES;
    }
}

- (void)pdfViewCtrl:(PTPDFViewCtrl *)pdfViewCtrl downloadEventType:(PTDownloadedType)type pageNumber:(int)pageNum message:(NSString *)message
{
    if (type == e_ptdownloadedtype_finished && !self.documentLoaded) {
        self.needsRemoteDocumentLoaded = YES;
    }

    [super pdfViewCtrl:pdfViewCtrl downloadEventType:type pageNumber:pageNum message:message];
}

#pragma mark - Viewer Settings

- (void)initViewerSettings
{
    _base64 = NO;
}

- (void)applyViewerSettings
{
    // Fit mode.
    [self applyFitMode];
    
    BOOL hidesToolbarsOnTap = YES;
    self.hidesControlsOnTap = hidesToolbarsOnTap;
    self.pageFitsBetweenBars = !hidesToolbarsOnTap;
}

- (void)applyFitMode
{
    if (!self.fitMode) {
        return;
    }
    
    if ([self.fitMode isEqualToString:PTFitPageKey]) {
        [self.pdfViewCtrl SetPageViewMode:e_trn_fit_page];
        [self.pdfViewCtrl SetPageRefViewMode:e_trn_fit_page];
    }
    else if ([self.fitMode isEqualToString:PTFitWidthKey]) {
        [self.pdfViewCtrl SetPageViewMode:e_trn_fit_width];
        [self.pdfViewCtrl SetPageRefViewMode:e_trn_fit_width];
    }
    else if ([self.fitMode isEqualToString:PTFitHeightKey]) {
        [self.pdfViewCtrl SetPageViewMode:e_trn_fit_height];
        [self.pdfViewCtrl SetPageRefViewMode:e_trn_fit_height];
    }
    else if ([self.fitMode isEqualToString:PTZoomKey]) {
        [self.pdfViewCtrl SetPageViewMode:e_trn_zoom];
        [self.pdfViewCtrl SetPageRefViewMode:e_trn_zoom];
    }
}

- (void)applyLayoutMode
{
    if ([self.layoutMode isEqualToString:PTSingleKey]) {
        [self.pdfViewCtrl SetPagePresentationMode:e_trn_single_page];
    }
    else if ([self.layoutMode isEqualToString:PTContinuousKey]) {
        [self.pdfViewCtrl SetPagePresentationMode:e_trn_single_continuous];
    }
    else if ([self.layoutMode isEqualToString:PTFacingKey]) {
        [self.pdfViewCtrl SetPagePresentationMode:e_trn_facing];
    }
    else if ([self.layoutMode isEqualToString:PTFacingContinuousKey]) {
        [self.pdfViewCtrl SetPagePresentationMode:e_trn_facing_continuous];
    }
    else if ([self.layoutMode isEqualToString:PTFacingCoverKey]) {
        [self.pdfViewCtrl SetPagePresentationMode:e_trn_facing_cover];
    }
    else if ([self.layoutMode isEqualToString:PTFacingCoverContinuousKey]) {
        [self.pdfViewCtrl SetPagePresentationMode:e_trn_facing_continuous_cover];
    }
}

#pragma mark - Other

- (void)topLeftButtonPressed:(UIBarButtonItem *)barButtonItem
{
    [self.plugin topLeftButtonPressed:barButtonItem];
}

@end

