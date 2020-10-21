part of pdftron;

class PTAnnot {
  // note that an annotation has its id in xfdf as name
  // page numbers are 1-indexed here, but 0-indexed in xfdf
  String id;
  int pageNumber;
  PTAnnot(this.id, this.pageNumber);

  factory PTAnnot.fromJson(dynamic json) {
    return PTAnnot(json['id'], json['pageNumber']);
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'pageNumber': pageNumber,
      };
}

class PTAnnotWithRect {
  String id;
  int pageNumber;
  PTRect rect;

  PTAnnotWithRect(this.id, this.pageNumber, this.rect);

  factory PTAnnotWithRect.fromJson(dynamic json) {
    return PTAnnotWithRect(
        json['id'], json['pageNumber'], PTRect.fromJson(json['rect']));
  }
}

class PTField {
  String fieldName;
  dynamic fieldValue;
  PTField(this.fieldName, this.fieldValue);

  factory PTField.fromJson(dynamic json) {
    print(json['fieldValue'] is int);
    print(json['fieldValue'] is bool);
    print(json['fieldValue'] is String);
    return PTField(json['fieldName'], (json['fieldValue']));
  }

  Map<String, dynamic> toJson() =>
      {'fieldName': fieldName, 'fieldValue': fieldValue};
}

class PTRect {
  double x1, y1, x2, y2, width, height;
  PTRect(this.x1, this.y1, this.x2, this.y2, this.width, this.height);

  factory PTRect.fromJson(dynamic json) {
    return PTRect(
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

class Functions {
  static const getPlatformVersion = "getPlatformVersion";
  static const getVersion = "getVersion";
  static const initialize = "initialize";
  static const openDocument = "openDocument";
  static const importAnnotationCommand = "importAnnotationCommand";
  static const importBookmarkJson = "importBookmarkJson";
  static const saveDocument = "saveDocument";
  static const commitTool = "commitTool";
  static const getPageCount = "getPageCount";
  static const handleBackButton = "handleBackButton";
  static const getPageCropBox = "getPageCropBox";
}

class Parameters {
  static const licenseKey = "licenseKey";
  static const document = "document";
  static const password = "password";
  static const config = "config";
  static const xfdfCommand = "xfdfCommand";
  static const bookmarkJson = "bookmarkJson";
  static const pageNumber = "pageNumber";
}

class EventParameters {
  static const action = "action";
  static const annotations = "annotations";
  static const xfdfCommand = "xfdfCommand";
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
