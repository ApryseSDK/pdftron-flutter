part of pdftron;

class Annot {
  // note that an annotation has its id in xfdf as name
  // page numbers are 1-indexed here, but 0-indexed in xfdf
  String id;
  int pageNumber;
  Annot(this.id, this.pageNumber);

  factory Annot.fromJson(dynamic json) {
    return Annot(json['id'], json['pageNumber']);
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'pageNumber': pageNumber,
      };
}

class AnnotWithRect {
  String id;
  int pageNumber;
  Rect rect;

  AnnotWithRect(this.id, this.pageNumber, this.rect);

  factory AnnotWithRect.fromJson(dynamic json) {
    return AnnotWithRect(
        json['id'], json['pageNumber'], Rect.fromJson(json['rect']));
  }
}

class Field {
  String fieldName;
  dynamic fieldValue;
  Field(this.fieldName, this.fieldValue);

  factory Field.fromJson(dynamic json) {
    return Field(json['fieldName'], (json['fieldValue']));
  }

  Map<String, dynamic> toJson() =>
      {'fieldName': fieldName, 'fieldValue': fieldValue};
}

class Rect {
  double x1, y1, x2, y2, width, height;
  Rect(this.x1, this.y1, this.x2, this.y2, this.width, this.height);

  factory Rect.fromJson(dynamic json) {
    return Rect(
        getDouble(json['x1']),
        getDouble(json['y1']),
        getDouble(json['x2']),
        getDouble(json['y2']),
        getDouble(json['width']),
        getDouble(json['height']));
  }

  // a helper for JSON number decoding
  static getDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else {
      return value;
    }
  }
}

class AnnotFlag {
  // flag comes from AnnotationFlags constants
  // flagValue represents toggling on/off
  String flag;
  bool flagValue;
  AnnotFlag(this.flag, this.flagValue);

  Map<String, dynamic> toJson() => {
        'flag': flag,
        'flagValue': flagValue,
      };
}

class AnnotWithFlag {
  Annot annotation;
  List<AnnotFlag> flags;

  AnnotWithFlag.fromAnnotAndFlags(this.annotation, this.flags);

  AnnotWithFlag(String annotId, int pageNumber, String flag, bool flagValue) {
    annotation = new Annot(annotId, pageNumber);
    flags = new List<AnnotFlag>();
    flags.add(new AnnotFlag(flag, flagValue));
  }

  Map<String, dynamic> toJson() =>
      {'annotation': jsonEncode(annotation), 'flags': jsonEncode(flags)};
}

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
  static const setCurrentPage = "setCurrentPage";
  static const getDocumentPath = "getDocumentPath";
  static const setToolMode = "setToolMode";
  static const setValuesForFields = "setValuesForFields";
  static const setFlagForFields = "setFlagForFields";
  static const setLeadingNavButtonIcon = "setLeadingNavButtonIcon";
}

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

class EventParameters {
  static const action = "action";
  static const annotations = "annotations";
  static const xfdfCommand = "xfdfCommand";
  static const previousPageNumber = "previousPageNumber";
  static const pageNumber = "pageNumber";
}

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

class FitModes {
  static const fitPage = 'FitPage';
  static const fitWidth = 'FitWidth';
  static const fitHeight = 'FitHeight';
  static const zoom = 'Zoom';
}

class LayoutModes {
  static const single = 'Single';
  static const continuous = 'Continuous';
  static const facing = 'Facing';
  static const facingContinuous = 'FacingContinuous';
  static const facingCover = 'FacingCover';
  static const facingCoverContinuous = 'FacingCoverContinuous';
}

class FieldFlags {
  static const ReadOnly = 0;
  static const Required = 1;
}

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
