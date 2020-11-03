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
        
        NSString *filePath = self.coordinatedDocument.fileURL.path;
        [self.plugin docVC:self documentLoaded:filePath];
        
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

    [self.plugin docVC:self bookmarkChange:json];
}

-(void)toolManager:(PTToolManager*)toolManager willRemoveAnnotation:(nonnull PTAnnot *)annotation onPageNumber:(int)pageNumber
{
    NSString* xfdf = [self generateXfdfCommandWithAdded:Nil modified:Nil removed:@[annotation]];
    [self.plugin docVC:self annotationChange:xfdf];
}

- (void)toolManager:(PTToolManager *)toolManager annotationAdded:(PTAnnot *)annotation onPageNumber:(unsigned long)pageNumber
{
    NSString* xfdf = [self generateXfdfCommandWithAdded:@[annotation] modified:Nil removed:Nil];
    [self.plugin docVC:self annotationChange:xfdf];
}

- (void)toolManager:(PTToolManager *)toolManager annotationModified:(PTAnnot *)annotation onPageNumber:(unsigned long)pageNumber
{
    NSString* xfdf = [self generateXfdfCommandWithAdded:Nil modified:@[annotation] removed:Nil];
    [self.plugin docVC:self annotationChange:xfdf];
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
    // left for other configs
}

- (void)applyViewerSettings
{
    // LayoutMode
    [self applyLayoutMode];
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

- (void)setFitMode:(NSString*)fitMode
{
    if ([fitMode isEqualToString:PTFitPageKey]) {
        [self.pdfViewCtrl SetPageViewMode:e_trn_fit_page];
        [self.pdfViewCtrl SetPageRefViewMode:e_trn_fit_page];
    }
    else if ([fitMode isEqualToString:PTFitWidthKey]) {
        [self.pdfViewCtrl SetPageViewMode:e_trn_fit_width];
        [self.pdfViewCtrl SetPageRefViewMode:e_trn_fit_width];
    }
    else if ([fitMode isEqualToString:PTFitHeightKey]) {
        [self.pdfViewCtrl SetPageViewMode:e_trn_fit_height];
        [self.pdfViewCtrl SetPageRefViewMode:e_trn_fit_height];
    }
    else if ([fitMode isEqualToString:PTZoomKey]) {
        [self.pdfViewCtrl SetPageViewMode:e_trn_zoom];
        [self.pdfViewCtrl SetPageRefViewMode:e_trn_zoom];
    }
}

#pragma mark - Other

- (void)topLeftButtonPressed:(UIBarButtonItem *)barButtonItem
{
    [self.plugin topLeftButtonPressed:barButtonItem];
}

@end
