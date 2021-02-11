part of pdftron;

class Annot {
  /*  
      Description: The annotation associated with its rectangle
      Note: an annotation has its id in xfdf as name;
            page numbers are 1-indexed here, but 0-indexed in xfdf strings
  */
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
  /*  
      Description: The annotation associated with its rectangle
  */
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
  /*  
      Description: The field object for the viewer
  */
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
  /*  
      Description: The rect object for the viewer
  */
  double x1, y1, x2, y2, width, height;
  Rect(this.x1, this.y1, this.x2, this.y2, this.width, this.height);

  Rect.fromCoordinates(this.x1, this.y1, this.x2, this.y2) {
    this.width = this.x2 - this.x1;
    this.height = this.y2 - this.y1;
  }

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
  /*  
      Description: The flag object for an annotation
      Note: Flag comes from AnnotationFlags constants;
            FlagValue represents toggling on/off
  */
  String flag;
  bool flagValue;
  AnnotFlag(this.flag, this.flagValue);

  Map<String, dynamic> toJson() => {
        'flag': flag,
        'flagValue': flagValue,
      };
}

class AnnotWithFlag {
  /*
      Description: The annotation object associated with its flags
  */
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

class CustomToolbar {
  /*
    Description: The annotation object associated with its flags
    Note: id should be unique;
          items should be array of Buttons / Tools constants;
          icon (optional) should be a ToolbarIcons constant
  */

  String id;
  String name;
  List<String> items;
  String icon;

  CustomToolbar(this.id, this.name, this.items, [this.icon]);

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'items': jsonEncode(items), 'icon': icon};
}
