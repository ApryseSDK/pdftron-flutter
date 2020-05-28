part of pdftron;

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
}

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
  static const annotationCreateDistanceMeasurement = 'AnnotationCreateDistanceMeasurement';
  static const annotationCreatePerimeterMeasurement = 'AnnotationCreatePerimeterMeasurement';
  static const annotationCreateAreaMeasurement = 'AnnotationCreateAreaMeasurement';
  static const annotationCreateSound = 'AnnotationCreateSound';
  static const annotationCreateFreeHighlighter = 'AnnotationCreateFreeHighlighter';
  static const annotationCreateRubberStamp = 'AnnotationCreateRubberStamp';
  static const eraser = 'Eraser';
}

class Config {
  var dElements;
  var dTools;
  var multiTab;
  var mCustomHeaders;

  Config();

  set disabledElements(List value) => dElements = value;
  set disabledTools(List value) => dTools = value;
  set multiTabEnabled(bool value) => multiTab = value;
  set customHeaders(Map<String, String> value) => mCustomHeaders = value;

  Config.fromJson(Map<String, dynamic> json)
      : dElements = json['disabledElements'],
        dTools = json['disabledTools'],
        multiTab = json['multiTabEnabled'],
        mCustomHeaders = json['customHeaders'];

  Map<String, dynamic> toJson() =>
    {
      'disabledElements': dElements,
      'disabledTools': dTools,
      'multiTabEnabled': multiTab,
      'customHeaders': mCustomHeaders,
    };

}