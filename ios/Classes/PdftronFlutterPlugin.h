#import <Flutter/Flutter.h>
#import <PDFNet/PDFNet.h>
#import <Tools/Tools.h>

NS_ASSUME_NONNULL_BEGIN

// config
static NSString * const PTDisabledToolsKey = @"disabledTools";
static NSString * const PTDisabledElementsKey = @"disabledElements";
static NSString * const PTMultiTabEnabledKey = @"multiTabEnabled";
static NSString * const PTCustomHeadersKey = @"customHeaders";
static NSString * const PTFitModeKey = @"fitMode";
static NSString * const PTLayoutModeKey = @"layoutMode";
static NSString * const PTInitialPageNumberKey = @"initialPageNumber";
static NSString * const PTIsBase64StringKey = @"isBase64String";
static NSString * const PTBase64FileExtensionKey = @"base64FileExtension";
static NSString * const PTHideThumbnailFilterModesKey = @"hideThumbnailFilterModes";
static NSString * const PTLongPressMenuEnabled = @"longPressMenuEnabled";
static NSString * const PTLongPressMenuItems = @"longPressMenuItems";
static NSString * const PTOverrideLongPressMenuBehavior = @"overrideLongPressMenuBehavior";
static NSString * const PTHideAnnotationMenu = @"hideAnnotationMenu";
static NSString * const PTAnnotationMenuItems = @"annotationMenuItems";
static NSString * const PTOverrideAnnotationMenuBehavior = @"overrideAnnotationMenuBehavior";
static NSString * const PTExcludedAnnotationListTypesKey = @"excludedAnnotationListTypes";
static NSString * const PTAutoSaveEnabledKey = @"autoSaveEnabled";
static NSString * const PTPageChangeOnTapKey = @"pageChangeOnTap";
static NSString * const PTShowSavedSignaturesKey = @"showSavedSignatures";
static NSString * const PTSignaturePhotoPickerEnabledKey = @"signaturePhotoPickerEnabled";
static NSString * const PTSignatureTypingEnabledKey = @"signatureTypingEnabled";
static NSString * const PTSignatureDrawingEnabledKey = @"signatureDrawingEnabled";
static NSString * const PTUseStylusAsPenKey = @"useStylusAsPen";
static NSString * const PTSignSignatureFieldWithStampsKey = @"signSignatureFieldWithStamps";
static NSString * const PTSignatureColorsKey = @"signatureColors";
static NSString * const PTSelectAnnotationAfterCreationKey = @"selectAnnotationAfterCreation";
static NSString * const PTPageIndicatorEnabledKey = @"pageIndicatorEnabled";
static NSString * const PTPageNumberIndicatorAlwaysVisibleKey = @"pageNumberIndicatorAlwaysVisible";
static NSString * const PTShowQuickNavigationButtonKey = @"showQuickNavigationButton";
static NSString * const PTFollowSystemDarkModeKey = @"followSystemDarkModeKey";
static NSString * const PTAnnotationToolbarsKey = @"annotationToolbars";
static NSString * const PTHideDefaultAnnotationToolbarsKey = @"hideDefaultAnnotationToolbars";
static NSString * const PTHideAnnotationToolbarSwitcherKey = @"hideAnnotationToolbarSwitcher";
static NSString * const PTInitialToolbarKey = @"initialToolbar";
static NSString * const PTHideTopToolbarsKey = @"hideTopToolbars";
static NSString * const PTHideToolbarsOnTapKey = @"hideToolbarsOnTap";
static NSString * const PTHideTopAppNavBarKey = @"hideTopAppNavBar";
static NSString * const PTTopAppNavBarRightBarKey = @"topAppNavBarRightBar";
static NSString * const PTHideBottomToolbarKey = @"hideBottomToolbar";
static NSString * const PTBottomToolbarKey = @"bottomToolbar";
static NSString * const PTShowLeadingNavButtonKey = @"showLeadingNavButton";
static NSString * const PTReadOnlyKey = @"readOnly";
static NSString * const PTThumbnailViewEditingEnabledKey = @"thumbnailViewEditingEnabled";
static NSString * const PTDocumentSliderEnabledKey = @"documentSliderEnabled";
static NSString * const PTAnnotationAuthorKey = @"annotationAuthor";
static NSString * const PTContinuousAnnotationEditingKey = @"continuousAnnotationEditing";
static NSString * const PTAnnotationPermissionCheckEnabledKey = @"annotationPermissionCheckEnabled";
static NSString * const PTAnnotationsListEditingEnabledKey = @"annotationsListEditingEnabled";
static NSString * const PTUserBookmarksListEditingEnabledKey = @"userBookmarksListEditingEnabled";
static NSString * const PTOutlineListEditingEnabledKey = @"outlineListEditingEnabled";
static NSString * const PTShowNavigationListAsSidePanelOnLargeDevicesKey = @"showNavigationListAsSidePanelOnLargeDevices";
static NSString * const PTOverrideBehaviorKey = @"overrideBehavior";
static NSString * const PTTabTitleKey = @"tabTitle";
static NSString * const PTMaxTabCountKey = @"maxTabCount";
static NSString * const PTDisableEditingByAnnotationTypeKey = @"disableEditingByAnnotationType";
static NSString * const PTHideViewModeItemsKey = @"hideViewModeItems";
static NSString * const PTDefaultEraserTypeKey = @"defaultEraserType";
static NSString * const PTAutoResizeFreeTextEnabledKey = @"autoResizeFreeTextEnabled";
static NSString * const PTRestrictDownloadUsageKey = @"restrictDownloadUsage";
static NSString * const PTReflowOrientationKey = @"reflowOrientation";
static NSString * const PTImageInReflowModeEnabledKey = @"imageInReflowModeEnabled";
static NSString * const PTAnnotationManagerEnabledKey = @"annotationManagerEnabled";
static NSString * const PTUserIdKey = @"userId";
static NSString * const PTUserNameKey = @"userName";
static NSString * const PTAnnotationManagerEditModeKey = @"annotationManagerEditMode";
static NSString * const PTAnnotationManagerUndoModeKey = @"annotationManagerUndoMode";
static NSString * const PTAnnotationToolbarAlignmentKey = @"annotationToolbarAlignment";
static NSString * const PTHideScrollbarsKey = @"hideScrollbars";
static NSString * const PTQuickBookmarkCreationKey = @"quickBookmarkCreation";

// Hygen Generated Configs
static NSString * const PTMaxSignatureCountKey = @"maxSignatureCount";

// tool
static NSString * const PTAnnotationEditToolKey = @"AnnotationEdit";
static NSString * const PTAnnotationCreateStickyToolKey = @"AnnotationCreateSticky";
static NSString * const PTAnnotationCreateFreeHandToolKey = @"AnnotationCreateFreeHand";
static NSString * const PTMultiSelectToolKey = @"MultiSelect";
static NSString * const PTTextSelectToolKey = @"TextSelect";
static NSString * const PTAnnotationCreateTextHighlightToolKey = @"AnnotationCreateTextHighlight";
static NSString * const PTAnnotationCreateTextUnderlineToolKey = @"AnnotationCreateTextUnderline";
static NSString * const PTAnnotationCreateTextSquigglyToolKey = @"AnnotationCreateTextSquiggly";
static NSString * const PTAnnotationCreateTextStrikeoutToolKey = @"AnnotationCreateTextStrikeout";
static NSString * const PTAnnotationCreateFreeTextToolKey = @"AnnotationCreateFreeText";
static NSString * const PTAnnotationCreateCalloutToolKey = @"AnnotationCreateCallout";
static NSString * const PTAnnotationCreateSignatureToolKey = @"AnnotationCreateSignature";
static NSString * const PTAnnotationCreateLineToolKey = @"AnnotationCreateLine";
static NSString * const PTAnnotationCreateArrowToolKey = @"AnnotationCreateArrow";
static NSString * const PTAnnotationCreatePolylineToolKey = @"AnnotationCreatePolyline";
static NSString * const PTAnnotationCreateStampToolKey = @"AnnotationCreateStamp";
static NSString * const PTAnnotationCreateRectangleToolKey = @"AnnotationCreateRectangle";
static NSString * const PTAnnotationCreateEllipseToolKey = @"AnnotationCreateEllipse";
static NSString * const PTAnnotationCreatePolygonToolKey = @"AnnotationCreatePolygon";
static NSString * const PTAnnotationCreatePolygonCloudToolKey = @"AnnotationCreatePolygonCloud";
static NSString * const PTAnnotationCreateFreeHighlighterToolKey = @"AnnotationCreateFreeHighlighter";
static NSString * const PTEraserToolKey = @"Eraser";
static NSString * const PTAnnotationCreateRubberStampToolKey = @"AnnotationCreateRubberStamp";
static NSString * const PTAnnotationCreateSoundToolKey = @"AnnotationCreateSound";
static NSString * const PTAnnotationCreateDistanceMeasurementToolKey = @"AnnotationCreateDistanceMeasurement";
static NSString * const PTAnnotationCreatePerimeterMeasurementToolKey = @"AnnotationCreatePerimeterMeasurement";
static NSString * const PTAnnotationCreateAreaMeasurementToolKey = @"AnnotationCreateAreaMeasurement";
static NSString * const PTAnnotationCreateFileAttachmentToolKey = @"AnnotationCreateFileAttachment";
static NSString * const PTAnnotationCreateRedactionToolKey = @"AnnotationCreateRedaction";
static NSString * const PTAnnotationCreateLinkToolKey = @"AnnotationCreateLink";
static NSString * const PTAnnotationCreateRedactionTextToolKey = @"AnnotationCreateRedactionText";
static NSString * const PTAnnotationCreateLinkTextToolKey = @"AnnotationCreateLinkText";
static NSString * const PTFormCreateTextFieldToolKey = @"FormCreateTextField";
static NSString * const PTFormCreateCheckboxFieldToolKey = @"FormCreateCheckboxField";
static NSString * const PTFormCreateSignatureFieldToolKey = @"FormCreateSignatureField";
static NSString * const PTFormCreateRadioFieldToolKey = @"FormCreateRadioField";
static NSString * const PTFormCreateComboBoxFieldToolKey = @"FormCreateComboBoxField";
static NSString * const PTFormCreateListBoxFieldToolKey = @"FormCreateListBoxField";
static NSString * const PTPencilKitDrawingToolKey = @"PencilKitDrawing";
static NSString * const PTAnnotationSmartPenToolKey = @"AnnotationSmartPen";

// button
static NSString * const PTStickyToolButtonKey = @"stickyToolButton";
static NSString * const PTFreeHandToolButtonKey = @"freeHandToolButton";
static NSString * const PTHighlightToolButtonKey = @"highlightToolButton";
static NSString * const PTUnderlineToolButtonKey = @"underlineToolButton";
static NSString * const PTSquigglyToolButtonKey = @"squigglyToolButton";
static NSString * const PTStrikeoutToolButtonKey = @"strikeoutToolButton";
static NSString * const PTFreeTextToolButtonKey = @"freeTextToolButton";
static NSString * const PTCalloutToolButtonKey = @"calloutToolButton";
static NSString * const PTSignatureToolButtonKey = @"signatureToolButton";
static NSString * const PTLineToolButtonKey = @"lineToolButton";
static NSString * const PTArrowToolButtonKey = @"arrowToolButton";
static NSString * const PTPolylineToolButtonKey = @"polylineToolButton";
static NSString * const PTStampToolButtonKey = @"stampToolButton";
static NSString * const PTRectangleToolButtonKey = @"rectangleToolButton";
static NSString * const PTEllipseToolButtonKey = @"ellipseToolButton";
static NSString * const PTPolygonToolButtonKey = @"polygonToolButton";
static NSString * const PTCloudToolButtonKey = @"cloudToolButton";
static NSString * const PTFreeHighlighterToolButtonKey = @"freeHighlighterToolButton";
static NSString * const PTEraserToolButtonKey = @"eraserToolButton";
static NSString * const PTToolsButtonKey = @"toolsButton";
static NSString * const PTSearchButtonKey = @"searchButton";
static NSString * const PTShareButtonKey = @"shareButton";
static NSString * const PTViewControlsButtonKey = @"viewControlsButton";
static NSString * const PTThumbnailsButtonKey = @"thumbnailsButton";
static NSString * const PTListsButtonKey = @"listsButton";
static NSString * const PTReflowModeButtonKey = @"reflowModeButton";
static NSString * const PTThumbnailSliderKey = @"thumbnailSlider";
static NSString * const PTSaveCopyButtonKey = @"saveCopyButton";
static NSString * const PTSaveIdenticalCopyButtonKey = @"saveIdenticalCopyButton";
static NSString * const PTSaveFlattenedCopyButtonKey = @"saveFlattenedCopyButton";
static NSString * const PTSaveCroppedCopyButtonKey = @"saveCroppedCopyButton";
static NSString * const PTSaveReducedCopyButtonKey = @"saveReducedCopyButton";
static NSString * const PTEditPagesButtonKey = @"editPagesButton";
static NSString * const PTPrintButtonKey = @"printButton";
static NSString * const PTCloseButtonKey = @"closeButton";
static NSString * const PTFillAndSignButtonKey = @"fillAndSignButton";
static NSString * const PTPrepareFormButtonKey = @"prepareFormButton";
static NSString * const PTOutlineListButtonKey = @"outlineListButton";
static NSString * const PTAnnotationListButtonKey = @"annotationListButton";
static NSString * const PTUserBookmarkListButtonKey = @"userBookmarkListButton";
static NSString * const PTLayerListButtonKey = @"viewLayersButton";
static NSString * const PTEditMenuButtonKey = @"editMenuButton";
static NSString * const PTCropPageButtonKey = @"cropPageButton";
static NSString * const PTMoreItemsButtonKey = @"moreItemsButton";
static NSString * const PTEditToolButtonKey = @"editToolButton";

// Menu Item
static NSString * const PTStyleMenuItemTitleKey = @"Style";
static NSString * const PTNoteMenuItemTitleKey = @"Note";
static NSString * const PTCopyMenuItemTitleKey = @"Copy";
static NSString * const PTDeleteMenuItemTitleKey = @"Delete";
static NSString * const PTTypeMenuItemTitleKey = @"Type";
static NSString * const PTSearchMenuItemTitleKey = @"Search";
static NSString * const PTEditMenuItemTitleKey = @"Edit";
static NSString * const PTFlattenMenuItemTitleKey = @"Flatten";
static NSString * const PTOpenMenuItemTitleKey = @"Open";
static NSString * const PTShareMenuItemTitleKey = @"Share";
static NSString * const PTReadMenuItemTitleKey = @"Read";
static NSString * const PTCalibrateMenuItemTitleKey = @"Calibrate";

static NSString * const PTStyleMenuItemIdentifierKey = @"style";
static NSString * const PTNoteMenuItemIdentifierKey = @"note";
static NSString * const PTCopyMenuItemIdentifierKey = @"copy";
static NSString * const PTDeleteMenuItemIdentifierKey = @"delete";
static NSString * const PTTypeMenuItemIdentifierKey = @"markupType";
static NSString * const PTSearchMenuItemIdentifierKey = @"search";
static NSString * const PTEditTextMenuItemIdentifierKey = @"editText";
static NSString * const PTEditInkMenuItemIdentifierKey = @"editInk";
static NSString * const PTFlattenMenuItemIdentifierKey = @"flatten";
static NSString * const PTOpenMenuItemIdentifierKey = @"OpenAttachment";
static NSString * const PTShareMenuItemIdentifierKey = @"share";
static NSString * const PTReadMenuItemIdentifierKey = @"read";
static NSString * const PTCalibrateMenuItemIdentifierKey = @"calibrate";

static NSString * const PTHighlightWhiteListKey = @"Highlight";
static NSString * const PTStrikeoutWhiteListKey = @"Strikeout";
static NSString * const PTUnderlineWhiteListKey = @"Underline";
static NSString * const PTSquigglyWhiteListKey = @"Squiggly";

// function

static NSString * const PTGetPlatformVersionKey = @"getPlatformVersion";
static NSString * const PTGetVersionKey = @"getVersion";
static NSString * const PTInitializeKey = @"initialize";
static NSString * const PTOpenDocumentKey = @"openDocument";
static NSString * const PTImportAnnotationsKey = @"importAnnotations";
static NSString * const PTExportAnnotationsKey = @"exportAnnotations";
static NSString * const PTFlattenAnnotationsKey = @"flattenAnnotations";
static NSString * const PTDeleteAnnotationsKey = @"deleteAnnotations";
static NSString * const PTSelectAnnotationKey = @"selectAnnotation";
static NSString * const PTSetFlagsForAnnotationsKey = @"setFlagsForAnnotations";
static NSString * const PTSetPropertiesForAnnotationKey = @"setPropertiesForAnnotation";
static NSString * const PTGroupAnnotationsKey = @"groupAnnotations";
static NSString * const PTUngroupAnnotationsKey = @"ungroupAnnotations";
static NSString * const PTImportAnnotationCommandKey = @"importAnnotationCommand";
static NSString * const PTImportBookmarksKey = @"importBookmarkJson";
static NSString * const PTAddBookmarkKey = @"addBookmark";
static NSString * const PTSaveDocumentKey = @"saveDocument";
static NSString * const PTCommitToolKey = @"commitTool";
static NSString * const PTGetPageCountKey = @"getPageCount";
static NSString * const PTUndoKey = @"undo";
static NSString * const PTRedoKey = @"redo";
static NSString * const PTCanUndoKey = @"canUndo";
static NSString * const PTCanRedoKey = @"canRedo";
static NSString * const PTGetPageCropBoxKey = @"getPageCropBox";
static NSString * const PTGetPageRotationKey = @"getPageRotation";
static NSString * const PTRotateClockwiseKey = @"rotateClockwise";
static NSString * const PTRotateCounterClockwiseKey = @"rotateCounterClockwise";
static NSString * const PTSetCurrentPageKey = @"setCurrentPage";
static NSString * const PTGotoPreviousPageKey = @"gotoPreviousPage";
static NSString * const PTGotoNextPageKey = @"gotoNextPage";
static NSString * const PTGotoFirstPageKey = @"gotoFirstPage";
static NSString * const PTGotoLastPageKey = @"gotoLastPage";
static NSString * const PTGetDocumentPathKey = @"getDocumentPath";
static NSString * const PTSetToolModeKey = @"setToolMode";
static NSString * const PTSetFlagForFieldsKey = @"setFlagForFields";
static NSString * const PTSetValuesForFieldsKey = @"setValuesForFields";
static NSString * const PTSetLeadingNavButtonIconKey = @"setLeadingNavButtonIcon";
static NSString * const PTCloseAllTabsKey = @"closeAllTabs";
static NSString * const PTDeleteAllAnnotationsKey = @"deleteAllAnnotations";
static NSString * const PTExportAsImageKey = @"exportAsImage";
static NSString * const PTExportAsImageFromFilePathKey = @"exportAsImageFromFilePath";
static NSString * const PTOpenAnnotationListKey = @"openAnnotationList";
static NSString * const PTOpenBookmarkListKey = @"openBookmarkList";
static NSString * const PTOpenOutlineListKey = @"openOutlineList";
static NSString * const PTOpenLayersListKey = @"openLayersList";
static NSString * const PTOpenThumbnailsViewKey = @"openThumbnailsView";
static NSString * const PTOpenAddPagesViewKey = @"openAddPagesView";
static NSString * const PTOpenViewSettingsKey = @"openViewSettings";
static NSString * const PTOpenCropKey = @"openCrop";
static NSString * const PTOpenManualCropKey = @"openManualCrop";
static NSString * const PTOpenSearchKey = @"openSearch";
static NSString * const PTOpenTabSwitcherKey = @"openTabSwitcher";
static NSString * const PTOpenGoToPageViewKey = @"openGoToPageView";
static NSString * const PTOpenNavigationListsKey = @"openNavigationLists";
static NSString * const PTGetCurrentPageKey = @"getCurrentPage";
static NSString * const PTZoomWithCenterKey = @"zoomWithCenter";
static NSString * const PTZoomToRectKey = @"zoomToRect";
static NSString * const PTGetZoomKey = @"getZoom";
static NSString * const PTSetZoomLimitsKey = @"setZoomLimits";
static NSString * const PTSmartZoomKey = @"smartZoom";
static NSString * const PTGetSavedSignaturesKey = @"getSavedSignatures";
static NSString * const PTGetSavedSignatureFolderKey = @"getSavedSignatureFolder";
static NSString * const PTSetBackgroundColorKey = @"setBackgroundColor";
static NSString * const PTSetDefaultPageColorKey = @"setDefaultPageColor";
static NSString * const PTGetScrollPosKey = @"getScrollPos";
static NSString * const PTSetHorizontalScrollPositionKey = @"setHorizontalScrollPosition";
static NSString * const PTSetVerticalScrollPositionKey = @"setVerticalScrollPosition";
static NSString * const PTStartSearchModeKey = @"startSearchMode";
static NSString * const PTExitSearchModeKey = @"exitSearchMode";

// Hygen Generated Methods
static NSString * const PTSetLayoutModeKey = @"setLayoutMode";
static NSString * const PTSetFitModeKey = @"setFitMode";
static NSString * const PTGetAnnotationsOnPageKey = @"getAnnotationsOnPage";

// argument
static NSString * const PTDocumentArgumentKey = @"document";
static NSString * const PTPasswordArgumentKey = @"password";
static NSString * const PTConfigArgumentKey = @"config";
static NSString * const PTXfdfCommandArgumentKey = @"xfdfCommand";
static NSString * const PTXfdfArgumentKey = @"xfdf";
static NSString * const PTBookmarkJsonArgumentKey = @"bookmarkJson";
static NSString * const PTPageNumberArgumentKey = @"pageNumber";
static NSString * const PTBookmarkTitleArgumentKey = @"title";
static NSString * const PTLicenseArgumentKey = @"licenseKey";
static NSString * const PTToolModeArgumentKey = @"toolMode";
static NSString * const PTFieldNamesArgumentKey = @"fieldNames";
static NSString * const PTFlagArgumentKey = @"flag";
static NSString * const PTFlagValueArgumentKey = @"flagValue";
static NSString * const PTFieldsArgumentKey = @"fields";
static NSString * const PTAnnotationListArgumentKey = @"annotations";
static NSString * const PTFormsOnlyArgumentKey = @"formsOnly";
static NSString * const PTAnnotationArgumentKey = @"annotation";
static NSString * const PTAnnotationsWithFlagsArgumentKey = @"annotationsWithFlags";
static NSString * const PTAnnotationPropertiesArgumentKey = @"annotationProperties";
static NSString * const PTLeadingNavButtonIconArgumentKey = @"leadingNavButtonIcon";
static NSString * const PTSourceRectArgumentKey = @"sourceRect";
static NSString * const PTPathArgumentKey = @"path";
static NSString * const PTDpiArgumentKey = @"dpi";
static NSString * const PTExportFormatArgumentKey = @"exportFormat";
static NSString * const PTRedKey = @"red";
static NSString * const PTBlueKey = @"blue";
static NSString * const PTGreenKey = @"green";
static NSString * const PTHorizontalScrollPositionArgumentKey = @"horizontalScrollPosition";
static NSString * const PTVerticalScrollPositionArgumentKey = @"verticalScrollPosition";
static NSString * const PTSearchStringArgumentKey = @"searchString";
static NSString * const PTMatchCaseArgumentKey = @"matchCase";
static NSString * const PTMatchWholeWordArgumentKey = @"matchWholeWord";
static NSString * const PTAnimatedArgumentKey = @"animated";

// Hygen Generated Method Parameters
static NSString * const PTLayoutModeArgumentKey = @"layoutMode";
static NSString * const PTFitModeArgumentKey = @"fitMode";

// event strings
static NSString * const PTExportAnnotationCommandEventKey = @"export_annotation_command_event";
static NSString * const PTExportBookmarkEventKey = @"export_bookmark_event";
static NSString * const PTDocumentLoadedEventKey = @"document_loaded_event";
static NSString * const PTDocumentErrorEventKey = @"document_error_event";
static NSString * const PTAnnotationChangedEventKey = @"annotation_changed_event";
static NSString * const PTAnnotationsSelectedEventKey = @"annotations_selected_event";
static NSString * const PTFormFieldValueChangedEventKey = @"form_field_value_changed_event";
static NSString * const PTBehaviorActivatedEventKey = @"behavior_activated_event";
static NSString * const PTLongPressMenuPressedEventKey = @"long_press_menu_pressed_event";
static NSString * const PTAnnotationMenuPressedEventKey = @"annotation_menu_pressed_event";
static NSString * const PTLeadingNavButtonPressedEventKey = @"leading_nav_button_pressed_event";
static NSString * const PTPageChangedEventKey = @"page_changed_event";
static NSString * const PTZoomChangedEventKey = @"zoom_changed_event";
static NSString * const PTPageMovedEventKey = @"page_moved_event";
static NSString *const PTScrollChangedEventKey = @"scroll_changed_event";

// Hygen Generated Event Listeners (1)
static NSString * const PTAnnotationToolbarItemPressedEventKey = @"annotation_toolbar_item_pressed_event";
static NSString * const PTAppBarButtonPressedEventKey = @"app_bar_button_pressed_event";

// fit mode
static NSString * const PTFitPageKey = @"FitPage";
static NSString * const PTFitWidthKey = @"FitWidth";
static NSString * const PTFitHeightKey = @"FitHeight";
static NSString * const PTZoomKey = @"Zoom";
static NSString * const PTZoomRatioKey = @"zoom";

// layout mode
static NSString * const PTSingleKey = @"Single";
static NSString * const PTContinuousKey = @"Continuous";
static NSString * const PTFacingKey = @"Facing";
static NSString * const PTFacingContinuousKey = @"FacingContinuous";
static NSString * const PTFacingCoverKey = @"FacingCover";
static NSString * const PTFacingCoverContinuousKey = @"FacingCoverContinuous";

// other keys

static NSString * const PTX1Key = @"x1";
static NSString * const PTY1Key = @"y1";
static NSString * const PTX2Key = @"x2";
static NSString * const PTY2Key = @"y2";
static NSString * const PTXKey = @"x";
static NSString * const PTYKey = @"y";
static NSString * const PTWidthKey = @"width";
static NSString * const PTHeightKey = @"height";
static NSString * const PTRectKey = @"rect";

static NSString * const PTAddActionKey = @"add";
static NSString * const PTDeleteActionKey = @"delete";
static NSString * const PTModifyActionKey = @"modify";
static NSString * const PTActionKey = @"action";

static NSString * const PTAnnotationIdKey = @"id";
static NSString * const PTAnnotationPageNumberKey = @"pageNumber";
static NSString * const PTAnnotationListKey = @"annotations";

static NSString * const PTRectX1Key = @"x1";
static NSString * const PTRectY1Key = @"y1";
static NSString * const PTRectX2Key = @"x2";
static NSString * const PTRectY2Key = @"y2";

static NSString * const PTFormFieldNameKey = @"fieldName";
static NSString * const PTFormFieldValueKey = @"fieldValue";

static NSString * const PTPreviousPageNumberKey = @"previousPageNumber";
static NSString * const PTPageNumberKey = @"pageNumber";

static NSString * const PTFieldNameKey = @"fieldName";
static NSString * const PTFieldValueKey = @"fieldValue";

static NSString * const PTAnnotPageNumberKey = @"pageNumber";
static NSString * const PTAnnotIdKey = @"id";

static NSString * const PTContentRectAnnotationPropertyKey = @"contentRect";
static NSString * const PTContentsAnnotationPropertyKey = @"contents";
static NSString * const PTSubjectAnnotationPropertyKey = @"subject";
static NSString * const PTTitleAnnotationPropertyKey = @"title";
static NSString * const PTRectAnnotationPropertyKey = @"rect";
static NSString * const PTRotationAnnotationPropertyKey = @"rotation";

static NSString * const PTMinimumKey = @"minimum";
static NSString * const PTMaximumKey = @"maximum";
static NSString * const PTZoomLimitModeKey = @"zoomLimitMode";
static NSString * const PTZoomLimitAbsoluteKey = @"absolute";
static NSString * const PTZoomLimitRelativeKey = @"relative";
static NSString * const PTZoomLimitNoneKey = @"none";

static NSString * const PTLinkPressLinkAnnotationKey = @"linkPress";
static NSString * const PTURILinkAnnotationKey = @"URI";
static NSString * const PTURLLinkAnnotationKey = @"url";
static NSString * const PTDataLinkAnnotationKey = @"data";
static NSString * const PTActionLinkAnnotationKey = @"action";

static NSString * const PTFlagListKey = @"flags";
static NSString * const PTFlagKey = @"flag";
static NSString * const PTFlagValueKey = @"flagValue";

static NSString * const PTLongPressMenuItemKey = @"longPressMenuItem";
static NSString * const PTLongPressTextKey = @"longPressText";

static NSString * const PTAnnotationMenuItemKey = @"annotationMenuItem";

static NSString * const PTAnnotationFlagHiddenKey = @"hidden";
static NSString * const PTAnnotationFlagInvisibleKey = @"invisible";
static NSString * const PTAnnotationFlagLockedKey = @"locked";
static NSString * const PTAnnotationFlagLockedContentsKey = @"lockedContents";
static NSString * const PTAnnotationFlagNoRotateKey = @"noRotate";
static NSString * const PTAnnotationFlagNoViewKey = @"noView";
static NSString * const PTAnnotationFlagNoZoomKey = @"noZoom";
static NSString * const PTAnnotationFlagPrintKey = @"print";
static NSString * const PTAnnotationFlagReadOnlyKey = @"readOnly";
static NSString * const PTAnnotationFlagToggleNoViewKey = @"toggleNoView";

static NSString * const PTAnnotatedFilterModeKey = @"annotated";
static NSString * const PTBookmarkedFilterModeKey = @"bookmarked";

static NSString * const PTViewModeCropKey = @"viewModeCrop";
static NSString * const PTViewModeRotationKey = @"viewModeRotation";
static NSString * const PTViewModeColorModeKey = @"viewModeColorMode";
static NSString * const PTViewModeVerticalScrollingKey = @"viewModeVerticalScrolling";

// DefaultEraserType keys
static NSString * const PTInkEraserModeAllKey = @"annotationEraser";
static NSString * const PTInkEraserModePointsKey = @"hybridEraser";

// ReflowOrientation
static NSString * const PTReflowOrientationHorizontalKey = @"horizontal";
static NSString * const PTReflowOrientationVerticalKey = @"vertical";

// Annotation Mananger Edit Mode
static NSString * const PTAnnotationManagerEditModeOwnKey = @"editModeOwn";
static NSString * const PTAnnotationManagerEditModeAllKey = @"editModeAll";

// Annotation Mananger Undo Mode
static NSString * const PTAnnotationManagerUndoModeOwnKey = @"undoModeOwn";
static NSString * const PTAnnotationManagerUndoModeAllKey = @"undoModeAll";

// Annotation Toolbar Alignment
static NSString * const PTAnnotationToolbarAlignmentStartKey = @"GravityStart";
static NSString * const PTAnnotationToolbarAlignmentEndKey = @"GravityEnd";

// Scroll direction
static NSString * const PTScrollHorizontalKey = @"horizontal";
static NSString * const PTScrollVerticalKey = @"vertical";

// RGB colors
static NSString * const PTColorRedKey = @"red";
static NSString * const PTColorGreenKey = @"green";
static NSString * const PTColorBlueKey = @"blue";

// Default annotation toolbar names.
typedef NSString *PTDefaultAnnotationToolbarKey;
static const PTDefaultAnnotationToolbarKey PTAnnotationToolbarView = @"PDFTron_View";
static const PTDefaultAnnotationToolbarKey PTAnnotationToolbarAnnotate = @"PDFTron_Annotate";
static const PTDefaultAnnotationToolbarKey PTAnnotationToolbarDraw = @"PDFTron_Draw";
static const PTDefaultAnnotationToolbarKey PTAnnotationToolbarInsert = @"PDFTron_Insert";
static const PTDefaultAnnotationToolbarKey PTAnnotationToolbarFillAndSign = @"PDFTron_Fill_and_Sign";
static const PTDefaultAnnotationToolbarKey PTAnnotationToolbarPrepareForm = @"PDFTron_Prepare_Form";
static const PTDefaultAnnotationToolbarKey PTAnnotationToolbarMeasure = @"PDFTron_Measure";
static const PTDefaultAnnotationToolbarKey PTAnnotationToolbarPens = @"PDFTron_Pens";
static const PTDefaultAnnotationToolbarKey PTAnnotationToolbarRedaction = @"PDFTron_Redact";
static const PTDefaultAnnotationToolbarKey PTAnnotationToolbarFavorite = @"PDFTron_Favorite";

// Custom annotation toolbar keys.
typedef NSString *PTAnnotationToolbarKey;
static const PTAnnotationToolbarKey PTAnnotationToolbarKeyId = @"id";
static const PTAnnotationToolbarKey PTAnnotationToolbarKeyName = @"name";
static const PTAnnotationToolbarKey PTAnnotationToolbarKeyIcon = @"icon";
static const PTAnnotationToolbarKey PTAnnotationToolbarKeyItems = @"items";

// Custom annotation toolbar item keys.
typedef NSString *PTAnnotationToolbarItemKey NS_TYPED_EXTENSIBLE_ENUM;
static const PTAnnotationToolbarItemKey PTAnnotationToolbarItemKeyId = @"id";
static const PTAnnotationToolbarItemKey PTAnnotationToolbarItemKeyName = @"name";
static const PTAnnotationToolbarItemKey PTAnnotationToolbarItemKeyIcon = @"icon";

typedef enum
{
    exportAnnotationId = 0,
    exportBookmarkId,
    documentLoadedId,
    documentErrorId,
    annotationChangedId,
    annotationsSelectedId,
    formFieldValueChangedId,
    behaviorActivatedId,
    longPressMenuPressedId,
    annotationMenuPressedId,
    leadingNavButtonPressedId,
    pageChangedId,
    zoomChangedId,
    pageMovedId,
    // Hygen Generated Event Listeners (2)
    scrollChangedId,
    annotationToolbarItemPressedId,
    appBarButtonPressedId,
} EventSinkId;

@interface PdftronFlutterPlugin : NSObject<FlutterPlugin, FlutterStreamHandler, FlutterPlatformView>

@property (nonatomic, strong) PTTabbedDocumentViewController *tabbedDocumentViewController;
@property (nonatomic) BOOL isBase64;

+ (PdftronFlutterPlugin *)registerWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId messenger:(NSObject<FlutterBinaryMessenger> *)messenger;

- (void)documentController:(PTDocumentController *)documentController bookmarksDidChange:(NSString *)bookmarkJson;
- (void)documentController:(PTDocumentController *)documentController annotationsAsXFDFCommand:(NSString *)xfdfCommand;
- (void)documentController:(PTDocumentController *)documentController documentLoadedFromFilePath:(NSString *)filePath;
- (void)documentController:(PTDocumentController *)documentController documentError:(nullable NSError *)error;
- (void)documentController:(PTDocumentController *)documentController annotationsChangedWithActionString:(NSString *)actionString;
- (void)documentController:(PTDocumentController *)documentController annotationsSelected:(NSString *)annotations;
- (void)documentController:(PTDocumentController *)documentController formFieldValueChanged:(NSString *)fieldString;
- (void)documentController:(PTDocumentController *)docVC behaviorActivated:(NSString *)behaviorString;
- (void)documentController:(PTDocumentController *)docVC leadingNavButtonClicked:(nullable NSString *)nav;
- (void)documentController:(PTDocumentController *)docVC longPressMenuPressed:(NSString *)longPressMenuPressedString;
- (void)documentController:(PTDocumentController *)docVC annotationMenuPressed:(NSString *)annotationMenuPressedString;
- (void)documentController:(PTDocumentController *)docVC leadingNavButtonClicked:(nullable NSString *)nav;
- (void)documentController:(PTDocumentController *)docVC pageChanged:(NSString *)pageNumbersString;
- (void)documentController:(PTDocumentController *)docVC zoomChanged:(NSNumber *)zoom;
- (void)documentController:(PTDocumentController *)docVC pageMoved:(NSString *)pageNumbersString;
- (void)documentController:(PTDocumentController *)docVC scrollChanged:(NSString*)scrollString;
// Hygen Generated Event Listeners (3)
- (void)documentController:(PTDocumentController *)docVC annotationToolbarItemPressed:(NSString *)annotationToolbarItemPressedId;
- (void)documentController:(PTDocumentController *)docVC appBarButtonPressed:(NSString *)appBarButtonPressedString;

- (void)topLeftButtonPressed:(UIBarButtonItem *)barButtonItem;

- (UIView *)view;

+ (PTDocumentController *)PT_getSelectedDocumentController:(PTTabbedDocumentViewController *)tabbedDocumentViewController;
+ (NSString *)PT_idToJSONString:(id)infoId;
+ (id)PT_JSONStringToId:(NSString *)jsonString;
+ (Class)toolClassForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
