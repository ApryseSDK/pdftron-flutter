#import <Flutter/Flutter.h>
#import <PDFNet/PDFNet.h>
#import <Tools/Tools.h>

NS_ASSUME_NONNULL_BEGIN

// config
static NSString * const PTDisabledToolsKey = @"disabledTools";
static NSString * const PTDisabledElementsKey = @"disabledElements";
static NSString * const PTMultiTabEnabledKey = @"multiTabEnabled";
static NSString * const PTCustomHeadersKey = @"customHeaders";
static NSString * const PTShowLeadingNavButtonKey = @"showLeadingNavButton";
static NSString * const PTReadOnlyKey = @"readOnly";
static NSString * const PTThumbnailViewEditingEnabledKey = @"thumbnailViewEditingEnabled";
static NSString * const PTAnnotationAuthorKey = @"annotationAuthor";
static NSString * const PTContinuousAnnotationEditingKey = @"continuousAnnotationEditing";
static NSString * const PTTabTitleKey = @"tabTitle";

// tool
static NSString * const PTAnnotationEditToolKey = @"AnnotationEdit";
static NSString * const PTAnnotationCreateStickyToolKey = @"AnnotationCreateSticky";
static NSString * const PTAnnotationCreateFreeHandToolKey = @"AnnotationCreateFreeHand";
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
static NSString * const PTAnnotationCreateRubberStampToolKey = @"annotationCreateRubberStamp";
static NSString * const PTAnnotationCreateSoundToolKey = @"annotationCreateSound";
static NSString * const PTAnnotationCreateDistanceMeasurementToolKey = @"annotationCreateDistanceMeasurement";
static NSString * const PTAnnotationCreatePerimeterMeasurementToolKey = @"annotationCreatePerimeterMeasurement";
static NSString * const PTAnnotationCreateAreaMeasurementToolKey = @"annotationCreateAreaMeasurement";

// button
static NSString * const PTStickyToolButtonKey = @"stickyToolButton";
static NSString * const PTFreeHandToolButtonKey = @"freeHandToolButton";
static NSString * const PTHighlightToolButtonKey = @"highlightToolButton";
static NSString * const PTUnderlineToolButtonKey = @"underlineToolButton";
static NSString * const PTSquigglyToolButtonKey = @"squigglyToolButton";
static NSString * const PTStrikeoutToolButtonnKey = @"strikeoutToolButton";
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
static NSString * const PTImportAnnotationCommandKey = @"importAnnotationCommand";
static NSString * const PTImportBookmarksKey = @"importBookmarkJson";
static NSString * const PTSaveDocumentKey = @"saveDocument";
static NSString * const PTCommitToolKey = @"commitTool";
static NSString * const PTGetPageCountKey = @"getPageCount";
static NSString * const PTGetPageCropBoxKey = @"getPageCropBox";
static NSString * const PTSetToolModeKey = @"setToolMode";
static NSString * const PTSetFlagForFieldsKey = @"setFlagForFields";
static NSString * const PTSetValuesForFieldsKey = @"setValuesForFields";
static NSString * const PTSetLeadingNavButtonIconKey = @"setLeadingNavButtonIcon";
static NSString * const PTCloseAllTabsKey = @"closeAllTabs";

// argument
static NSString * const PTDocumentArgumentKey = @"document";
static NSString * const PTPasswordArgumentKey = @"password";
static NSString * const PTConfigArgumentKey = @"config";
static NSString * const PTXfdfCommandArgumentKey = @"xfdfCommand";
static NSString * const PTXfdfArgumentKey = @"xfdf";
static NSString * const PTBookmarkJsonArgumentKey = @"bookmarkJson";
static NSString * const PTPageNumberArgumentKey = @"pageNumber";
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
static NSString * const PTLeadingNavButtonIconArgumentKey = @"leadingNavButtonIcon";

// event strings
static NSString * const PTExportAnnotationCommandEventKey = @"export_annotation_command_event";
static NSString * const PTExportBookmarkEventKey = @"export_bookmark_event";
static NSString * const PTDocumentLoadedEventKey = @"document_loaded_event";
static NSString * const PTDocumentErrorEventKey = @"document_error_event";
static NSString * const PTAnnotationChangedEventKey = @"annotation_changed_event";
static NSString * const PTAnnotationsSelectedEventKey = @"annotations_selected_event";
static NSString * const PTFormFieldValueChangedEventKey = @"form_field_value_changed_event";
static NSString * const PTLeadingNavButtonPressedEventKey = @"leading_nav_button_pressed_event";
static NSString * const PTPageChangedEventKey = @"page_changed_event";
static NSString * const PTZoomChangedEventKey = @"zoom_changed_event";

// other keys
static NSString * const PTX1Key = @"x1";
static NSString * const PTY1Key = @"y1";
static NSString * const PTX2Key = @"x2";
static NSString * const PTY2Key = @"y2";
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

static NSString * const PTFormFieldNameKey = @"fieldName";
static NSString * const PTFormFieldValueKey = @"fieldValue";

static NSString * const PTPreviousPageNumberKey = @"previousPageNumber";
static NSString * const PTPageNumberKey = @"pageNumber";

static NSString * const PTFieldNameKey = @"fieldName";
static NSString * const PTFieldValueKey = @"fieldValue";

static NSString * const PTAnnotPageNumberKey = @"pageNumber";
static NSString * const PTAnnotIdKey = @"id";
static NSString * const PTFlagListKey = @"flags";
static NSString * const PTFlagKey = @"flag";
static NSString * const PTFlagValueKey = @"flagValue";

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

typedef enum {
    exportAnnotationId = 0,
    exportBookmarkId,
    documentLoadedId,
    documentErrorId,
    annotationChangedId,
    annotationsSelectedId,
    formFieldValueChangedId,
    leadingNavButtonPressedId,
    pageChangedId,
    zoomChangedId,
} EventSinkId;

@interface PdftronFlutterPlugin : NSObject<FlutterPlugin, FlutterStreamHandler, FlutterPlatformView>

@property (nonatomic, strong) PTTabbedDocumentViewController *tabbedDocumentViewController;

+ (PdftronFlutterPlugin *)registerWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId messenger:(NSObject<FlutterBinaryMessenger> *)messenger;

-(void)documentViewController:(PTDocumentViewController*)docVC bookmarksDidChange:(NSString*)bookmarkJson;
-(void)documentViewController:(PTDocumentViewController*)docVC annotationsAsXFDFCommand:(NSString*)xfdfCommand;
-(void)documentViewController:(PTDocumentViewController*)docVC documentLoadedFromFilePath:(NSString*)filePath;
-(void)documentViewController:(PTDocumentViewController*)docVC documentError:(nullable NSError*)error;
-(void)documentViewController:(PTDocumentViewController*)docVC annotationsChangedWithActionString:(NSString*)actionString;
-(void)documentViewController:(PTDocumentViewController*)docVC annotationsSelected:(NSString*)annotations;
-(void)documentViewController:(PTDocumentViewController*)docVC formFieldValueChanged:(NSString*)fieldString;
-(void)documentViewController:(PTDocumentViewController *)docVC leadingNavButtonClicked:(nullable NSString *)nav;
-(void)documentViewController:(PTDocumentViewController *)docVC pageChanged:(NSString*)pageNumbersString;
-(void)documentViewController:(PTDocumentViewController *)docVC zoomChanged:(NSNumber*)zoom;

- (void)topLeftButtonPressed:(UIBarButtonItem *)barButtonItem;

- (UIView*)view;

+ (NSString *)PT_idToJSONString:(id)infoId;
+ (id)PT_JSONStringToId:(NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END

