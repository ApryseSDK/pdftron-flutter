// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Config _$ConfigFromJson(Map<String, dynamic> json) {
  return Config()
    ..disabledElements =
        (json['disabledElements'] as List)?.map((e) => e as String)?.toList()
    ..disabledTools =
        (json['disabledTools'] as List)?.map((e) => e as String)?.toList()
    ..multiTabEnabled = json['multiTabEnabled'] as bool
    ..customHeaders = (json['customHeaders'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    )
    ..annotationToolbars = json['annotationToolbars'] as List
    ..hideDefaultAnnotationToolbars =
        (json['hideDefaultAnnotationToolbars'] as List)
            ?.map((e) => e as String)
            ?.toList()
    ..hideAnnotationToolbarSwitcher =
        json['hideAnnotationToolbarSwitcher'] as bool
    ..hideTopToolbars = json['hideTopToolbars'] as bool
    ..hideTopAppNavBar = json['hideTopAppNavBar'] as bool
    ..hideBottomToolbar = json['hideBottomToolbar'] as bool
    ..showLeadingNavButton = json['showLeadingNavButton'] as bool
    ..readOnly = json['readOnly'] as bool
    ..thumbnailViewEditingEnabled = json['thumbnailViewEditingEnabled'] as bool
    ..annotationAuthor = json['annotationAuthor'] as String
    ..continuousAnnotationEditing = json['continuousAnnotationEditing'] as bool
    ..tabTitle = json['tabTitle'] as String;
}

Map<String, dynamic> _$ConfigToJson(Config instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('disabledElements', instance.disabledElements);
  writeNotNull('disabledTools', instance.disabledTools);
  writeNotNull('multiTabEnabled', instance.multiTabEnabled);
  writeNotNull('customHeaders', instance.customHeaders);
  writeNotNull('annotationToolbars', instance.annotationToolbars);
  writeNotNull(
      'hideDefaultAnnotationToolbars', instance.hideDefaultAnnotationToolbars);
  writeNotNull(
      'hideAnnotationToolbarSwitcher', instance.hideAnnotationToolbarSwitcher);
  writeNotNull('hideTopToolbars', instance.hideTopToolbars);
  writeNotNull('hideTopAppNavBar', instance.hideTopAppNavBar);
  writeNotNull('hideBottomToolbar', instance.hideBottomToolbar);
  writeNotNull('showLeadingNavButton', instance.showLeadingNavButton);
  writeNotNull('readOnly', instance.readOnly);
  writeNotNull(
      'thumbnailViewEditingEnabled', instance.thumbnailViewEditingEnabled);
  writeNotNull('annotationAuthor', instance.annotationAuthor);
  writeNotNull(
      'continuousAnnotationEditing', instance.continuousAnnotationEditing);
  writeNotNull('tabTitle', instance.tabTitle);
  return val;
}
