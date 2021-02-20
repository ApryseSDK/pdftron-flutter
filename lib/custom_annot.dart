part of pdftron;

/*
  This file is for function addAnnotations.
*/

/* 
  The class for all annotations. rect and pageNumber are required when initialized
*/
abstract class CustomAnnot {
  Rect rect; // the rectangle area around the annotation
  int pageNumber; // the page in which the annotation exists
  BorderStyleObject
      borderStyleObject; // border style for the annotation. Typically used for Link annotations.
  int rotation; // rotation (in degrees) for the annotation. Should be multiples of 90
  Map<String, String>
      customData; // custom data to be associated with the annotation
  String contents; // contents of the annotation
  Color color; // color of the annotation
  bool
      _markup; // whether this is a markup annotation. Should not be set externally

  CustomAnnot(this.rect, this.pageNumber);

  Map<String, dynamic> toJson() => {
        'rect': jsonEncode(rect),
        'pageNumber': pageNumber,
        'borderStyleObject': jsonEncode(borderStyleObject),
        'rotation': rotation,
        'customData': jsonEncode(customData),
        'contents': contents,
        'color': convertColorToJSONString(color),
        'markup': _markup,
      };
}

/* 
  The class for all markup annotations. rect and pageNumber are required when initialized
*/
abstract class CustomMarkupAnnot extends CustomAnnot {
  String title; // title of the markup
  String subject; // subject of the markup
  double
      opacity; // opacity of the markup, between [0, 1]. 1 is the default value, meaning 100% visible
  String
      borderEffect; // border effect of the markup. Should be an AnnotationBorderEffect constant
  double
      borderEffectIntensity; // Intensity for the border effect, between [0, 2]. 0 is the default value
  Color interiorColor; // Interior color of the markup
  Rect contentRect; // the content rectangle area of the markup
  Rect
      paddingRect; // the paddings describing the difference between the rect and the actual boundary
  String
      _markupType; // which type of markup annotation. Should not be set externally

  CustomMarkupAnnot(Rect rect, int pageNumber) : super(rect, pageNumber) {
    _markup = true;
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'subject': subject,
        'opacity': opacity,
        'borderEffect': borderEffect,
        'borderEffectIntensity': borderEffectIntensity,
        'interiorColor': convertColorToJSONString(interiorColor),
        'contentRect': jsonEncode(contentRect),
        'paddingRect': jsonEncode(paddingRect),
        'markupType': _markupType,
      }..addAll(super.toJson());
}

/* 
  The class for FreeText annotation. rect and pageNumber are required when initialized
*/
class CustomFreeTextAnnot extends CustomMarkupAnnot {
  String defaultAppearance; // default appearance of the FreeText
  String
      quaddingFormat; // quadding format of the FreeText. should be a FreeTextQuaddingFormat constant. Left-justified by default
  String
      intentName; // intent of the FreeText. should be a FreeTextIntentName constant
  Color textColor; // text color of the FreeText
  Color lineColor; // line color of the FreeText
  double fontSize; // font size of the FreeText

  CustomFreeTextAnnot(Rect rect, int pageNumber) : super(rect, pageNumber) {
    _markupType = 'freeText';
  }

  Map<String, dynamic> toJson() => {
        'defaultAppearance': defaultAppearance,
        'quaddingFormat': quaddingFormat,
        'intentName': intentName,
        'textColor': convertColorToJSONString(textColor),
        'lineColor': convertColorToJSONString(lineColor),
        'fontSize': fontSize,
      }..addAll(super.toJson());
}

/* 
  The class for border styles. all but dashPattern are required when initialized
*/
class BorderStyleObject {
  String
      style; // style type of the border. Should be an AnnotationBorderStyle constant
  double horizontalCornerRadius; // horizontal corner radius of the border
  double verticalCornerRadius; // vertical corner radius of the border
  double width; // width of the border
  List<double> dashPattern; // dashPattern of the border

  BorderStyleObject(this.style, this.horizontalCornerRadius,
      this.verticalCornerRadius, this.width,
      [this.dashPattern]);

  Map<String, dynamic> toJson() => {
        'style': style,
        'horizontalCornerRadius': horizontalCornerRadius,
        'verticalCornerRadius': verticalCornerRadius,
        'width': width,
        'dashPattern': jsonEncode(dashPattern),
      };
}

/* 
  A customized JSON string conversion from Color
*/
String convertColorToJSONString(Color color) {
  if (color == null) {
    return null;
  }

  double red = color.red / 256;
  double green = color.green / 256;
  double blue = color.blue / 256;

  Map<String, double> colorMap = {
    'red': red,
    'green': green,
    'blue': blue,
  };

  return jsonEncode(colorMap);
}
