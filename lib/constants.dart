part of pdftron;

// Functions define the names of the functions
class Functions {
  static const getPlatformVersion = "getPlatformVersion";
  static const getVersion = "getVersion";
  static const initialize = "initialize";
  static const openDocument = "openDocument";
  static const importAnnotations = "importAnnotations";
  static const exportAnnotations = "exportAnnotations";
  static const flattenAnnotations = "flattenAnnotations";
  static const deleteAnnotations = "deleteAnnotations";
  static const selectAnnotation = "selectAnnotation";
  static const setFlagsForAnnotations = "setFlagsForAnnotations";
  static const importAnnotationCommand = "importAnnotationCommand";
  static const importBookmarkJson = "importBookmarkJson";
  static const saveDocument = "saveDocument";
  static const commitTool = "commitTool";
  static const getPageCount = "getPageCount";
  static const handleBackButton = "handleBackButton";
  static const getPageCropBox = "getPageCropBox";
  static const setToolMode = "setToolMode";
  static const setValuesForFields = "setValuesForFields";
  static const setFlagForFields = "setFlagForFields";
  static const setLeadingNavButtonIcon = "setLeadingNavButtonIcon";
  static const closeAllTabs = "closeAllTabs";
}

// Parameters define the parameters of the functions
class Parameters {
  static const licenseKey = "licenseKey";
  static const document = "document";
  static const password = "password";
  static const config = "config";
  static const xfdfCommand = "xfdfCommand";
  static const xfdf = "xfdf";
  static const bookmarkJson = "bookmarkJson";
  static const pageNumber = "pageNumber";
  static const toolMode = "toolMode";
  static const fieldNames = "fieldNames";
  static const fields = "fields";
  static const flag = "flag";
  static const flagValue = "flagValue";
  static const formsOnly = "formsOnly";
  static const annotations = "annotations";
  static const annotation = "annotation";
  static const annotationsWithFlags = "annotationsWithFlags";
  static const leadingNavButtonIcon = "leadingNavButtonIcon";
}

// Parameters define the parameters of the events
class EventParameters {
  static const action = "action";
  static const annotations = "annotations";
  static const xfdfCommand = "xfdfCommand";
  static const previousPageNumber = "previousPageNumber";
  static const pageNumber = "pageNumber";
}

// Buttons define the various kinds of buttons for the viewer
class Buttons {
  static const viewControlsButton = 'viewControlsButton';
  static const freeHandToolButton = 'freeHandToolButton';
  static const highlightToolButton = 'highlightToolButton';
  static const underlineToolButton = 'underlineToolButton';
  static const squigglyToolButton = 'squigglyToolButton';
  static const strikeoutToolButton = 'strikeoutToolButton';
  static const rectangleToolButton = 'rectangleToolButton';
  static const ellipseToolButton = 'ellipseToolButton';
  static const lineToolButton = 'lineToolButton';
  static const arrowToolButton = 'arrowToolButton';
  static const polylineToolButton = 'polylineToolButton';
  static const polygonToolButton = 'polygonToolButton';
  static const cloudToolButton = 'cloudToolButton';
  static const signatureToolButton = 'signatureToolButton';
  static const freeTextToolButton = 'freeTextToolButton';
  static const stickyToolButton = 'stickyToolButton';
  static const calloutToolButton = 'calloutToolButton';
  static const stampToolButton = 'stampToolButton';
  static const toolsButton = 'toolsButton';
  static const searchButton = 'searchButton';
  static const shareButton = 'shareButton';
  static const thumbnailsButton = 'thumbnailsButton';
  static const listsButton = 'listsButton';
  static const thumbnailSlider = 'thumbnailSlider';
  static const saveCopyButton = 'saveCopyButton';
  static const editPagesButton = 'editPagesButton';
  static const printButton = 'printButton';
  static const fillAndSignButton = 'fillAndSignButton';
  static const prepareFormButton = 'prepareFormButton';
  static const reflowModeButton = 'reflowModeButton';
  static const undo = 'undo';
  static const redo = 'redo';
}

// Tools define the various kinds of tools for the viewer
class Tools {
  static const annotationEdit = 'AnnotationEdit';
  static const textSelect = 'TextSelect';
  static const annotationCreateSticky = 'AnnotationCreateSticky';
  static const annotationCreateFreeHand = 'AnnotationCreateFreeHand';
  static const annotationCreateTextHighlight = 'AnnotationCreateTextHighlight';
  static const annotationCreateTextUnderline = 'AnnotationCreateTextUnderline';
  static const annotationCreateTextSquiggly = 'AnnotationCreateTextSquiggly';
  static const annotationCreateTextStrikeout = 'AnnotationCreateTextStrikeout';
  static const annotationCreateFreeText = 'AnnotationCreateFreeText';
  static const annotationCreateCallout = 'AnnotationCreateCallout';
  static const annotationCreateSignature = 'AnnotationCreateSignature';
  static const annotationCreateLine = 'AnnotationCreateLine';
  static const annotationCreateArrow = 'AnnotationCreateArrow';
  static const annotationCreatePolyline = 'AnnotationCreatePolyline';
  static const annotationCreateStamp = 'AnnotationCreateStamp';
  static const annotationCreateRectangle = 'AnnotationCreateRectangle';
  static const annotationCreateEllipse = 'AnnotationCreateEllipse';
  static const annotationCreatePolygon = 'AnnotationCreatePolygon';
  static const annotationCreatePolygonCloud = 'AnnotationCreatePolygonCloud';
  static const annotationCreateDistanceMeasurement =
      'AnnotationCreateDistanceMeasurement';
  static const annotationCreatePerimeterMeasurement =
      'AnnotationCreatePerimeterMeasurement';
  static const annotationCreateAreaMeasurement =
      'AnnotationCreateAreaMeasurement';
  static const annotationCreateSound = 'AnnotationCreateSound';
  static const annotationCreateFreeHighlighter =
      'AnnotationCreateFreeHighlighter';
  static const annotationCreateRubberStamp = 'AnnotationCreateRubberStamp';
  static const eraser = 'Eraser';
}

// FieldFlags define the property flags for a form field
class FieldFlags {
  static const ReadOnly = 0;
  static const Required = 1;
}

// AnnotationFlags define the flags for any annotation in the document
class AnnotationFlags {
  static const hidden = "hidden";
  static const invisible = "invisible";
  static const locked = "locked";
  static const lockedContents = "lockedContents";
  static const noRotate = "noRotate";
  static const noView = "noView";
  static const noZoom = "noZoom";
  static const print = "print";
  static const readOnly = "readOnly";
  static const toggleNoView = "toggleNoView";
}

// DefaultToolbars define a set of pre-designed toolbars for easier customization
class DefaultToolbars {
  static const view = "PDFTron_View";
  static const annotate = "PDFTron_Annotate";
  static const draw = "PDFTron_Draw";
  static const insert = "PDFTron_Insert";
  static const fillAndSign = "PDFTron_Fill_and_Sign";
  static const prepareForm = "PDFTron_Prepare_Form";
  static const measure = "PDFTron_Measure";
  static const pens = "PDFTron_Pens";
  static const favorite = "PDFTron_Favorite";
}

// ToolbarIcons define default toolbar icons for use for potential custom toolbars
class ToolbarIcons {
  static const view = "PDFTron_View";
  static const annotate = "PDFTron_Annotate";
  static const draw = "PDFTron_Draw";
  static const insert = "PDFTron_Insert";
  static const fillAndSign = "PDFTron_Fill_and_Sign";
  static const prepareForm = "PDFTron_Prepare_Form";
  static const measure = "PDFTron_Measure";
  static const pens = "PDFTron_Pens";
  static const favorite = "PDFTron_Favorite";
}
