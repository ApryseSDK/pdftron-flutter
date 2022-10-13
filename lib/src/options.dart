import 'dart:convert';
import 'constants.dart';

/// An annotation object.
class Annot {
  /// An annotation has its id in XFDF as name.
  String? id;

  /// Page numbers are 1-indexed here, but 0-indexed in XFDF strings.
  int? pageNumber;

  Annot(this.id, this.pageNumber);

  factory Annot.fromJson(dynamic json) {
    return Annot(json['id'], json['pageNumber']);
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'pageNumber': pageNumber,
      };
}

/// An annotation associated with its rectangle.
class AnnotWithRect {
  String? id;
  int? pageNumber;
  Rect? rect;

  AnnotWithRect(this.id, this.pageNumber, this.rect);

  factory AnnotWithRect.fromJson(dynamic json) {
    return AnnotWithRect(
        json['id'], json['pageNumber'], Rect.fromJson(json['rect']));
  }
}

/// A field object for the viewer.
class Field {
  String? fieldName;
  dynamic fieldValue;
  Field(this.fieldName, this.fieldValue);

  factory Field.fromJson(dynamic json) {
    return Field(json['fieldName'], (json['fieldValue']));
  }

  Map<String, dynamic> toJson() =>
      {'fieldName': fieldName, 'fieldValue': fieldValue};
}

/// A rect object for the viewer.
class Rect {
  double? x1, y1, x2, y2, width, height;
  Rect(this.x1, this.y1, this.x2, this.y2, this.width, this.height);

  Rect.fromCoordinates(this.x1, this.y1, this.x2, this.y2) {
    if (x1 != null && x2 != null) {
      width = (x2 as double) - (x1 as double);
    }

    if (y1 != null && y2 != null) {
      height = (y2 as double) - (y1 as double);
    }
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

  /// A helper for JSON number decoding.
  static getDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else {
      return value;
    }
  }

  Map<String, dynamic> toJson() => {
        'x1': x1,
        'y1': y1,
        'x2': x2,
        'y2': y2,
        'width': width,
        'height': height,
      };
}

/// A flag object for an annotation.
class AnnotFlag {
  /// One of the [AnnotationFlags] constants.
  String? flag;

  /// Represents toggling the flag on or off.
  bool? flagValue;
  AnnotFlag(this.flag, this.flagValue);

  Map<String, dynamic> toJson() => {
        'flag': flag,
        'flagValue': flagValue,
      };
}

/// An annotation object associated with its flags.
class AnnotWithFlag {
  late Annot annotation;
  late List<AnnotFlag> flags;

  AnnotWithFlag.fromAnnotAndFlags(this.annotation, this.flags);

  AnnotWithFlag(
      String? annotId, int? pageNumber, String? flag, bool? flagValue) {
    annotation = new Annot(annotId, pageNumber);
    flags = new List<AnnotFlag>.empty(growable: true);
    flags.add(new AnnotFlag(flag, flagValue));
  }

  Map<String, dynamic> toJson() =>
      {'annotation': jsonEncode(annotation), 'flags': jsonEncode(flags)};
}

/// An annotation property object.
///
/// Some of this object's properties are markup annotation exclusive, some are not.
class AnnotProperty {
  /// Not markup exclusive.
  Rect? rect;

  /// Not markup exclusive.
  String? contents;

  /// Not markup exclusive.
  int? rotation;

  /// Markup exclusive.
  String? subject;

  /// Markup exclusive.
  String? title;

  /// Markup exclusive.
  Rect? contentRect;

  AnnotProperty();

  Map<String, dynamic> toJson() => {
        AnnotationProperties.rect: jsonEncode(rect),
        AnnotationProperties.contents: contents,
        AnnotationProperties.subject: subject,
        AnnotationProperties.title: title,
        AnnotationProperties.contentRect: jsonEncode(rect),
        AnnotationProperties.rotation: rotation,
      };
}

/// A custom toolbar item.
///
/// Custom toolbar items can be included in a custom toolbar by adding the object
/// to the [CustomToolbar.items] list. Android only.
class CustomToolbarItem {
  /// Unique identifier of the toolbar item.
  String? id;

  String? name;

  /// Name of the image resource to be used as the item's icon.
  String? icon;

  CustomToolbarItem(this.id, this.name, this.icon);

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'icon': icon};
}

/// A custom toolbar.
class CustomToolbar {
  /// Unique identifier of the toolbar.
  String? id;

  String? name;

  /// An array of [Buttons] / [Tools] constants or [CustomToolbarItem] objects.
  List<Object>? items;

  /// A [ToolbarIcons] constant. Optional.
  String? icon;

  CustomToolbar(this.id, this.name, this.items, [this.icon]);

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'items': jsonEncode(items), 'icon': icon};
}