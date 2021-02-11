#import "PdftronFlutterPlugin.h"
#import "PTFlutterDocumentController.h"
#import "DocumentViewFactory.h"

@interface PTFlutterDocumentController()

@property (nonatomic, strong, nullable) UIBarButtonItem *leadingNavButtonItem;

@end

@implementation PTFlutterDocumentController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Workaround to ensure thumbnail slider is hidden at launch.
    self.thumbnailSliderHidden = YES;
    self.thumbnailSliderController.view.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // bottomToolBar / thumbnailSlider enabling
    self.thumbnailSliderEnabled = ![self isBottomToolbarHidden];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    if (self.needsDocumentLoaded) {
        self.needsDocumentLoaded = NO;
        self.needsRemoteDocumentLoaded = NO;
        self.documentLoaded = YES;

        NSString *filePath = self.coordinatedDocument.fileURL.path;
        [self.plugin documentController:self documentLoadedFromFilePath:filePath];
    }
    
    if (![self.toolManager isReadonly] && self.readOnly) {
        self.toolManager.readonly = YES;
    }
    
    [self.plugin.tabbedDocumentViewController.tabManager saveItems];
}

- (void)setThumbnailSliderHidden:(BOOL)hidden animated:(BOOL)animated
{
    // Prevent the thumbnail slider from being shown.
    // NOTE: This method will be called with hidden=NO when the bottomToolbarEnabled property is
    // enabled (which is just a convenience property for the thumbnailSliderEnabled property).
    if (!hidden) {
        return;
    }
    [super setThumbnailSliderHidden:hidden animated:animated];
}

- (void)openDocumentWithURL:(NSURL *)url password:(NSString *)password
{
    self.local = [url isFileURL];
    self.documentLoaded = NO;
    self.needsDocumentLoaded = NO;
    self.needsRemoteDocumentLoaded = NO;

    [super openDocumentWithURL:url password:password];
}

- (void)openDocumentWithPDFDoc:(PTPDFDoc *)document
{
    self.local = YES;
    self.documentLoaded = NO;
    self.needsDocumentLoaded = NO;
    self.needsRemoteDocumentLoaded = NO;

    [super openDocumentWithPDFDoc:document];
}

- (BOOL)isTopToolbarEnabled
{
    return (!self.topAppNavBarHidden && !self.topToolbarsHidden);
}

- (BOOL)areTopToolbarsEnabled
{
    return !self.topToolbarsHidden;
}

- (BOOL)isNavigationBarEnabled
{
    return !self.topAppNavBarHidden;;
}

- (BOOL)controlsHidden
{
    if (self.navigationController) {
        if ([self isTopToolbarEnabled]) {
            return [self.navigationController isNavigationBarHidden];
        }
        if ([self isBottomToolbarEnabled]) {
            return [self.navigationController isToolbarHidden];
        }
    }
    return [super controlsHidden];
}

- (void)setControlsHidden:(BOOL)controlsHidden animated:(BOOL)animated
{
    [super setControlsHidden:controlsHidden animated:animated];
    
    // When the top toolbars are enabled...
    if ([self areTopToolbarsEnabled] &&
        // ... but the navigation bar (app nav. bar) is disabled...
        ![self isNavigationBarEnabled] &&
        // ... and we are in a tabbed viewer...
        self.tabbedDocumentViewController.tabsEnabled) {
        // ... then manually toggle the tabbed viewer's tab bar visibility.
        [self.tabbedDocumentViewController setTabBarHidden:controlsHidden animated:animated];
    }
}

#pragma mark - <PTBookmarkViewControllerDelegate>

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

    [self.plugin documentController:self bookmarksDidChange:json];
}

- (void)bookmarkViewControllerDidCancel:(PTBookmarkViewController *)bookmarkViewController
{
    [bookmarkViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <PTToolManagerDelegate>

- (void)toolManagerToolChanged:(PTToolManager *)toolManager
{
    PTTool *tool = toolManager.tool;
    
    const BOOL backToPan = tool.backToPanToolAfterUse;
    
    [super toolManagerToolChanged:toolManager];
    
    if (tool.backToPanToolAfterUse != backToPan) {
        tool.backToPanToolAfterUse = backToPan;
    }
}

-(void)toolManager:(PTToolManager*)toolManager willRemoveAnnotation:(nonnull PTAnnot *)annotation onPageNumber:(int)pageNumber
{
    NSString* annotationsWithActionString = [self generateAnnotationWithActionString:annotation onPageNumber:pageNumber action:PTDeleteActionKey];
    if (annotationsWithActionString) {
        [self.plugin documentController:self annotationsChangedWithActionString:annotationsWithActionString];
    }
    
    NSString* xfdf = [self generateXfdfCommandWithAdded:Nil modified:Nil removed:@[annotation]];
    [self.plugin documentController:self annotationsAsXFDFCommand:xfdf];
    
}

- (void)toolManager:(PTToolManager *)toolManager annotationAdded:(PTAnnot *)annotation onPageNumber:(unsigned long)pageNumber
{
    NSString* annotationsWithActionString = [self generateAnnotationWithActionString:annotation onPageNumber:pageNumber action:PTAddActionKey];
    if (annotationsWithActionString) {
        [self.plugin documentController:self annotationsChangedWithActionString:annotationsWithActionString];
    }
    
    NSString* xfdf = [self generateXfdfCommandWithAdded:@[annotation] modified:Nil removed:Nil];
    [self.plugin documentController:self annotationsAsXFDFCommand:xfdf];
}

- (void)toolManager:(PTToolManager *)toolManager annotationModified:(PTAnnot *)annotation onPageNumber:(unsigned long)pageNumber
{
    NSString* annotationsWithActionString = [self generateAnnotationWithActionString:annotation onPageNumber:pageNumber action:PTModifyActionKey];
    if (annotationsWithActionString) {
        [self.plugin documentController:self annotationsChangedWithActionString:annotationsWithActionString];
    }
  
    NSString* xfdf = [self generateXfdfCommandWithAdded:Nil modified:@[annotation] removed:Nil];
    [self.plugin documentController:self annotationsAsXFDFCommand:xfdf];
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
        
        [self.plugin documentController:self annotationsSelected:[PdftronFlutterPlugin PT_idToJSONString:@[annotDict]]];
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
            
            [self.plugin documentController:self formFieldValueChanged:[PdftronFlutterPlugin PT_idToJSONString:@[fieldDict]]];
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

- (void)pdfViewCtrl:(PTPDFViewCtrl*)pdfViewCtrl pdfScrollViewDidZoom:(UIScrollView *)scrollView
{
    const double zoom = self.pdfViewCtrl.zoom * self.pdfViewCtrl.zoomScale;
    [self.plugin documentController:self zoomChanged:[NSNumber numberWithDouble:zoom]];
}

- (void)pdfViewCtrl:(PTPDFViewCtrl*)pdfViewCtrl pageNumberChangedFrom:(int)oldPageNumber To:(int)newPageNumber
{
    NSDictionary *resultDict = @{
        PTPreviousPageNumberKey: [NSNumber numberWithInt:oldPageNumber],
        PTPageNumberKey: [NSNumber numberWithInt:newPageNumber],
    };

    [self.plugin documentController:self pageChanged:[PdftronFlutterPlugin PT_idToJSONString:resultDict]];
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
    // to align with Android's document-opened-event timing.
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

#pragma mark - <PTOutlineViewControllerDelegate>

- (void)outlineViewControllerDidCancel:(PTOutlineViewController *)outlineViewController
{
    [outlineViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <PTAnnotationViewControllerDelegate>

- (void)annotationViewControllerDidCancel:(PTAnnotationViewController *)annotationViewController
{
    [annotationViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Viewer Settings

- (void)initViewerSettings
{
    _annotationToolbarSwitcherHidden = NO;
    _topToolbarsHidden = NO;
    _topAppNavBarHidden = NO;
    _bottomToolbarHidden = NO;
    
    _readOnly = NO;
    
    _showNavButton = YES;
}

- (void)applyViewerSettings
{
    // nav icon
    [self applyNavIcon];
    
    // thumbnail filter mode
    [self applyHideThumbnailFilterModes];
    
    const BOOL hideNav = (self.topAppNavBarHidden || self.topToolbarsHidden);
    self.controlsHidden = hideNav;
    
    const BOOL translucent = hideNav;
    self.navigationController.navigationBar.translucent = translucent;
    self.thumbnailSliderController.toolbar.translucent = translucent;
    
    // Always enable the bottom toolbar. This is required for the custom checks in -controlsHidden
    // when the top toolbar(s) are disabled, to be able to still toggle the bottom toolbar.
    self.bottomToolbarEnabled = YES;
    
    // Always allow toggling toolbars on tap.
    BOOL hidesToolbarsOnTap = YES;
    self.hidesControlsOnTap = hidesToolbarsOnTap;
    self.pageFitsBetweenBars = !hidesToolbarsOnTap; // Tools default is enabled.
    
    [self applyToolGroupSettings];
}

- (void)applyNavIcon
{
    if (self.showNavButton) {
        UIBarButtonItem* navButton = navButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(topLeftButtonPressed:)];
        
        self.leadingNavButtonItem = navButton;
        
        NSArray<UIBarButtonItem *> *compactItems = [self.navigationItem leftBarButtonItemsForSizeClass:UIUserInterfaceSizeClassCompact];
        if (compactItems) {
            NSMutableArray<UIBarButtonItem *> *mutableItems = [compactItems mutableCopy];
            [mutableItems insertObject:navButton atIndex:0];
            compactItems = [mutableItems copy];
        } else {
            compactItems = @[navButton];
        }
        [self.navigationItem setLeftBarButtonItems:compactItems
                                            forSizeClass:UIUserInterfaceSizeClassCompact
                                                animated:NO];
        
        NSArray<UIBarButtonItem *> *regularItems = [self.navigationItem leftBarButtonItemsForSizeClass:UIUserInterfaceSizeClassRegular];
        if (regularItems) {
            NSMutableArray<UIBarButtonItem *> *mutableItems = [regularItems mutableCopy];
            [mutableItems insertObject:navButton atIndex:0];
            regularItems = [mutableItems copy];
        } else {
            regularItems = @[navButton];
        }
        [self.navigationItem setLeftBarButtonItems:regularItems
                                            forSizeClass:UIUserInterfaceSizeClassRegular
                                                animated:NO];
    }
}

- (void)applyHideThumbnailFilterModes
{
    NSMutableArray <PTFilterMode>* filterModeArray = [[NSMutableArray alloc] init];

    [filterModeArray addObject:PTThumbnailFilterAll];
    [filterModeArray addObject:PTThumbnailFilterAnnotated];
    [filterModeArray addObject:PTThumbnailFilterBookmarked];

    for (NSString * filterModeString in self.hideThumbnailFilterModes) {
        if ([filterModeString isEqualToString:PTAnnotatedFilterModeKey]) {
            [filterModeArray removeObject:PTThumbnailFilterAnnotated];
        } else if ([filterModeString isEqualToString:PTBookmarkedFilterModeKey]) {
            [filterModeArray removeObject:PTThumbnailFilterBookmarked];
        }
    }

    NSOrderedSet* filterModeSet = [[NSOrderedSet alloc] initWithArray:filterModeArray];
    self.thumbnailsViewController.filterModes = filterModeSet;
}

- (void)applyToolGroupSettings
{
    PTToolGroupManager *toolGroupManager = self.toolGroupManager;
    
    self.toolGroupsEnabled = !self.topToolbarsHidden;
    if ([self areToolGroupsEnabled]) {
        NSMutableArray<PTToolGroup *> *toolGroups = [toolGroupManager.groups mutableCopy];
        
        // Handle annotationToolbars.
        if (self.annotationToolbars.count > 0) {
            // Clear default/previous tool groups.
            [toolGroups removeAllObjects];
            
            for (id annotationToolbarValue in self.annotationToolbars) {
                
                if ([annotationToolbarValue isKindOfClass:[NSString class]]) {
                    // Default annotation toolbar key.
                    PTDefaultAnnotationToolbarKey annotationToolbar = (NSString *)annotationToolbarValue;
                    
                    PTToolGroup *toolGroup = [self toolGroupForKey:annotationToolbar
                                                  toolGroupManager:toolGroupManager];
                    if (toolGroup) {
                        [toolGroups addObject:toolGroup];
                    }
                }
                else if ([annotationToolbarValue isKindOfClass:[NSDictionary class]]) {
                    // Custom annotation toolbar dictionary.
                    NSDictionary<NSString *, id> *annotationToolbar = (NSDictionary *)annotationToolbarValue;
                    
                    PTToolGroup *toolGroup = [self createToolGroupWithDictionary:annotationToolbar
                                                                toolGroupManager:toolGroupManager];
                    [toolGroups addObject:toolGroup];
                }
            }
        }
        
        // Handle hideDefaultAnnotationToolbars.
        if (self.hideDefaultAnnotationToolbars.count > 0) {
            NSMutableArray<PTToolGroup *> *toolGroupsToRemove = [NSMutableArray array];
            for (NSString *defaultAnnotationToolbar in self.hideDefaultAnnotationToolbars) {
                if (![defaultAnnotationToolbar isKindOfClass:[NSString class]]) {
                    continue;
                }
                PTToolGroup *matchingGroup = [self toolGroupForKey:defaultAnnotationToolbar
                                                  toolGroupManager:toolGroupManager];
                if (matchingGroup) {
                    [toolGroupsToRemove addObject:matchingGroup];
                }
            }
            // Remove the indicated tool group(s).
            if (toolGroupsToRemove.count > 0) {
                [toolGroups removeObjectsInArray:toolGroupsToRemove];
            }
        }
        
        if (![toolGroupManager.groups isEqualToArray:toolGroups]) {
            toolGroupManager.groups = toolGroups;
        }
    }
    
    if (self.annotationToolbarSwitcherHidden) {
        self.navigationItem.titleView = [[UIView alloc] init];
    } else {
        if ([self areToolGroupsEnabled] && toolGroupManager.groups.count > 0) {
            self.navigationItem.titleView = self.toolGroupIndicatorView;
        } else {
            self.navigationItem.titleView = nil;
        }
    }
}

- (PTToolGroup *)toolGroupForKey:(PTDefaultAnnotationToolbarKey)key toolGroupManager:(PTToolGroupManager *)toolGroupManager
{
    NSDictionary<PTDefaultAnnotationToolbarKey, PTToolGroup *> *toolGroupMap = @{
        PTAnnotationToolbarView: toolGroupManager.viewItemGroup,
        PTAnnotationToolbarAnnotate: toolGroupManager.annotateItemGroup,
        PTAnnotationToolbarDraw: toolGroupManager.drawItemGroup,
        PTAnnotationToolbarInsert: toolGroupManager.insertItemGroup,
        //PTAnnotationToolbarFillAndSign: [NSNull null], // not implemented
        //PTAnnotationToolbarPrepareForm: [NSNull null], // not implemented
        PTAnnotationToolbarMeasure: toolGroupManager.measureItemGroup,
        PTAnnotationToolbarPens: toolGroupManager.pensItemGroup,
        PTAnnotationToolbarFavorite: toolGroupManager.favoritesItemGroup,
    };

    return toolGroupMap[key];
}

- (PTToolGroup *)createToolGroupWithDictionary:(NSDictionary<NSString *, id> *)dictionary toolGroupManager:(PTToolGroupManager *)toolGroupManager
{
    NSString *toolbarId = dictionary[PTAnnotationToolbarKeyId];
    NSString *toolbarName = dictionary[PTAnnotationToolbarKeyName];
    NSString *toolbarIcon = dictionary[PTAnnotationToolbarKeyIcon];
    NSArray<NSString *> *toolbarItems = [PdftronFlutterPlugin PT_JSONStringToId:dictionary[PTAnnotationToolbarKeyItems]];
    
    UIImage *toolbarImage = nil;
    if (toolbarIcon) {
        PTToolGroup *defaultGroup = [self toolGroupForKey:toolbarIcon
                                         toolGroupManager:toolGroupManager];
        toolbarImage = defaultGroup.image;
    }
    
    NSMutableArray<UIBarButtonItem *> *barButtonItems = [NSMutableArray array];
    
    for (NSString *toolbarItem in toolbarItems) {
        if (![toolbarItem isKindOfClass:[NSString class]]) {
            continue;
        }
        
        Class toolClass = [PdftronFlutterPlugin toolClassForKey:toolbarItem];
        if (!toolClass) {
            continue;
        }
        
        UIBarButtonItem *item = [toolGroupManager createItemForToolClass:toolClass];
        if (item) {
            [barButtonItems addObject:item];
        }
    }
    
    PTToolGroup *toolGroup = [PTToolGroup groupWithTitle:toolbarName
                                                   image:toolbarImage
                                          barButtonItems:[barButtonItems copy]];
    toolGroup.identifier = toolbarId;

    return toolGroup;
}

- (void)setThumbnailEditingEnabled:(BOOL)thumbnailEditingEnabled
{
    self.thumbnailsViewController.editingEnabled = thumbnailEditingEnabled;
}

- (BOOL)isThumbnailEditingEnabled
{
    return self.thumbnailsViewController.editingEnabled;
}

- (void)setContinuousAnnotationEditingEnabled:(BOOL)continuousAnnotationEditing
{
    self.toolManager.tool.backToPanToolAfterUse = !continuousAnnotationEditing;
}

- (BOOL)isContinuousAnnotationEditing
{
    return !self.toolManager.tool.backToPanToolAfterUse;
}

- (NSString *)annotationAuthor
{
    return self.toolManager.annotationAuthor;
}

- (void)setAnnotationAuthor:(NSString *)annotationAuthor
{
    self.toolManager.annotationAuthor = annotationAuthor;
}

- (NSString *)tabTitle
{
    return self.documentTabItem.displayName;
}

- (void)setTabTitle:(NSString *)tabTitle
{
    self.documentTabItem.displayName = tabTitle;
}

#pragma mark - Other

- (void)topLeftButtonPressed:(UIBarButtonItem *)barButtonItem
{
    [self.plugin topLeftButtonPressed:barButtonItem];
}

- (void)setLeadingNavButtonIcon:(NSString *)leadingNavButtonIcon
{
    _leadingNavButtonIcon = leadingNavButtonIcon;
    
    if (self.showNavButton) {
        UIImage *navImage = [UIImage imageNamed:leadingNavButtonIcon];
        if (navImage) {
            UIBarButtonItem* navButton = self.leadingNavButtonItem;
            if ([navButton image]) {
                [navButton setImage:navImage];
            } else {
                navButton = [[UIBarButtonItem alloc] initWithImage:navImage
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(topLeftButtonPressed:)];
                
                self.leadingNavButtonItem = navButton;
                
                NSArray<UIBarButtonItem *> *compactItems = [self.navigationItem leftBarButtonItemsForSizeClass:UIUserInterfaceSizeClassCompact];
                if (compactItems) {
                    NSMutableArray<UIBarButtonItem *> *mutableItems = [compactItems mutableCopy];
                    [mutableItems removeObjectAtIndex:0];
                    [mutableItems insertObject:navButton atIndex:0];
                    compactItems = [mutableItems copy];
                } else {
                    compactItems = @[navButton];
                }
                
                [self.navigationItem setLeftBarButtonItems:compactItems
                                                    forSizeClass:UIUserInterfaceSizeClassCompact
                                                        animated:NO];
                
                NSArray<UIBarButtonItem *> *regularItems = [self.navigationItem leftBarButtonItemsForSizeClass:UIUserInterfaceSizeClassRegular];
                if (regularItems) {
                    NSMutableArray<UIBarButtonItem *> *mutableItems = [regularItems mutableCopy];
                    [mutableItems removeObjectAtIndex:0];
                    [mutableItems insertObject:navButton atIndex:0];
                    regularItems = [mutableItems copy];
                } else {
                    regularItems = @[navButton];
                }
                
                [self.navigationItem setLeftBarButtonItems:regularItems
                                                    forSizeClass:UIUserInterfaceSizeClassRegular
                                                        animated:NO];
            }
        }
    }
}

- (BOOL)shouldSetNavigationBarHidden:(BOOL)navigationBarHidden animated:(BOOL)animated
{
    if (!navigationBarHidden) {
        return [self isTopToolbarEnabled];
    }
    return YES;
}

- (BOOL)shouldSetToolbarHidden:(BOOL)toolbarHidden animated:(BOOL)animated
{
    if (!toolbarHidden) {
        return ![self isBottomToolbarHidden];
    }
    return YES;
}

@end

#pragma mark - FLThumbnailsViewController
@implementation FLThumbnailsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = !self.editingEnabled;
}

@end
