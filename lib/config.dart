part of pdftron;

class Config {
  var _disabledElements;
  var _disabledTools;
  var _multiTabEnabled;
  var _customHeaders;
  var _longPressMenuEnabled;
  var _longPressMenuItems;
  var _overrideLongPressMenuBehavior;
  var _hideAnnotationMenu;
  var _annotationMenuItems;
  var _overrideAnnotationMenuBehavior;
  var _showLeadingNavButton;
  var _readOnly;
  var _thumbnailViewEditingEnabled;
  var _annotationAuthor;
  var _continuousAnnotationEditing;

  Config();

  set disabledElements(List value) => _disabledElements = value;
  set disabledTools(List value) => _disabledTools = value;
  set multiTabEnabled(bool value) => _multiTabEnabled = value;
  set customHeaders(Map<String, String> value) => _customHeaders = value;
  set longPressMenuEnabled(bool value) => _longPressMenuEnabled = value;
  set longPressMenuItems(List value) => _longPressMenuItems = value;
  set overrideLongPressMenuBehavior(List value) =>
      _overrideLongPressMenuBehavior = value;
  set hideAnnotationMenu(List value) => _hideAnnotationMenu = value;
  set annotationMenuItems(List value) => _annotationMenuItems = value;
  set overrideAnnotationMenuBehavior(List value) =>
      _overrideAnnotationMenuBehavior = value;
  set showLeadingNavButton(bool value) => _showLeadingNavButton = value;
  set readOnly(bool value) => _readOnly = value;
  set thumbnailViewEditingEnabled(bool value) =>
      _thumbnailViewEditingEnabled = value;
  set annotationAuthor(String value) => _annotationAuthor = value;
  set continuousAnnotationEditing(bool value) =>
      _continuousAnnotationEditing = value;

  Config.fromJson(Map<String, dynamic> json)
      : _disabledElements = json['disabledElements'],
        _disabledTools = json['disabledTools'],
        _multiTabEnabled = json['multiTabEnabled'],
        _customHeaders = json['customHeaders'],
        _longPressMenuEnabled = json['longPressMenuEnabled'],
        _longPressMenuItems = json['longPressMenuItems'],
        _overrideLongPressMenuBehavior = json['overrideLongPressMenuBehavior'],
        _hideAnnotationMenu = json['hideAnnotationMenu'],
        _annotationMenuItems = json['annotationMenuItems'],
        _overrideAnnotationMenuBehavior =
            json['overrideAnnotationMenuBehavior'],
        _showLeadingNavButton = json['showLeadingNavButton'],
        _readOnly = json['readOnly'],
        _thumbnailViewEditingEnabled = json['thumbnailViewEditingEnabled'],
        _annotationAuthor = json['annotationAuthor'],
        _continuousAnnotationEditing = json['continuousAnnotationEditing'];

  Map<String, dynamic> toJson() => {
        'disabledElements': _disabledElements,
        'disabledTools': _disabledTools,
        'multiTabEnabled': _multiTabEnabled,
        'customHeaders': _customHeaders,
        'longPressMenuEnabled': _longPressMenuEnabled,
        'longPressMenuItems': _longPressMenuItems,
        'overrideLongPressMenuBehavior': _overrideLongPressMenuBehavior,
        'hideAnnotationMenu': _hideAnnotationMenu,
        'annotationMenuItems': _annotationMenuItems,
        'overrideAnnotationMenuBehavior': _overrideAnnotationMenuBehavior,
        'showLeadingNavButton': _showLeadingNavButton,
        'readOnly': _readOnly,
        'thumbnailViewEditingEnabled': _thumbnailViewEditingEnabled,
        'annotationAuthor': _annotationAuthor,
        'continuousAnnotationEditing': _continuousAnnotationEditing,
      };
}
