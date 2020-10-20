#import <Flutter/Flutter.h>
#import <PDFNet/PDFNet.h>
#import <Tools/Tools.h>

// config
static NSString * const PTDisabledToolsKey = @"disabledTools";
static NSString * const PTDisabledElementsKey = @"disabledElements";
static NSString * const PTMultiTabEnabledKey = @"multiTabEnabled";
static NSString * const PTCustomHeadersKey = @"customHeaders";

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
static NSString * const PTImportAnnotationCommandKey = @"importAnnotationCommand";
static NSString * const PTImportBookmarksKey = @"importBookmarkJson";
static NSString * const PTSaveDocumentKey = @"saveDocument";
static NSString * const PTCommitToolKey = @"commitTool";
static NSString * const PTGetPageCountKey = @"getPageCount";
static NSString * const PTGetPageCropBoxKey = @"getPageCropBox";
static NSString * const PTSetToolModeKey = @"setToolMode";
static NSString * const PTSetFlagForFieldsKey = @"setFlagForFields";
static NSString * const PTSetValueForFieldsKey = @"setValueForFields";


// argument
static NSString * const PTDocumentArgumentKey = @"document";
static NSString * const PTPasswordArgumentKey = @"password";
static NSString * const PTConfigArgumentKey = @"config";
static NSString * const PTXfdfCommandArgumentKey = @"xfdfCommand";
static NSString * const PTBookmarkJsonArgumentKey = @"bookmarkJson";
static NSString * const PTPageNumberArgumentKey = @"pageNumber";
static NSString * const PTLicenseArgumentKey = @"licenseKey";
static NSString * const PTToolModeArgumentKey = @"toolMode";
static NSString * const PTFieldNamesArgumentKey = @"fieldNames";
static NSString * const PTFlagArgumentKey = @"flag";
static NSString * const PTFlagValueArgumentKey = @"flagValue";
static NSString * const PTFieldsArgumentKey = @"fields";

// other keys
static NSString * const PTX1Key = @"x1";
static NSString * const PTY1Key = @"y1";
static NSString * const PTX2Key = @"x2";
static NSString * const PTY2Key = @"y2";
static NSString * const PTWidthKey = @"width";
static NSString * const PTHeightKey = @"height";

static NSString * const PTFieldNameKey = @"fieldName";
static NSString * const PTFieldValueKey = @"fieldValue";

@interface PTPluginUtils : NSObject

+ (NSString *)PT_idAsNSString:(id)value;
+ (NSNumber *)PT_idAsNSNumber:(id)value;
+ (NSDictionary *)PT_idAsNSDict:(id)value;
+ (NSArray *)PT_idAsNSArray:(id)value;

+ (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result documentViewController:(PTDocumentViewController *)docVC;

+ (void)setToolMode:(NSString *)toolMode resultToken:(FlutterResult)result documentViewController:(PTDocumentViewController *)docVC continuousAnnotationEditing:(bool)continuousAnnotEditing;
@end
