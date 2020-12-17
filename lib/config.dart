part of pdftron;

class Config {
  var _disabledElements;
  var _disabledTools;
  var _multiTabEnabled;
  var _customHeaders;
  var _annotationToolbars;
  var _hideDefaultAnnotationToolbars;
  var _hideAnnotationToolbarSwitcher;
  var _hideTopToolbars;
  var _hideTopAppNavBar;
  var _showLeadingNavButton;
  var _readOnly;
  var _thumbnailViewEditingEnabled;
  var _annotationAuthor;
  var _continuousAnnotationEditing;
  var _annotationPermissionCheckEnabled;
  var _overrideBehavior;
  var _tabTitle;

  Config();

  set disabledElements(List value) => _disabledElements = value;
  set disabledTools(List value) => _disabledTools = value;
  set multiTabEnabled(bool value) => _multiTabEnabled = value;
  set customHeaders(Map<String, String> value) => _customHeaders = value;
  set annotationToolbars(List value) => _annotationToolbars = value;
  set hideDefaultAnnotationToolbars(List value) =>
      _hideDefaultAnnotationToolbars = value;
  set hideAnnotationToolbarSwitcher(bool value) =>
      _hideAnnotationToolbarSwitcher = value;
  set hideTopToolbars(bool value) => _hideTopToolbars = value;
  set hideTopAppNavBar(bool value) => _hideTopAppNavBar = value;
  set showLeadingNavButton(bool value) => _showLeadingNavButton = value;
  set readOnly(bool value) => _readOnly = value;
  set thumbnailViewEditingEnabled(bool value) =>
      _thumbnailViewEditingEnabled = value;
  set annotationAuthor(String value) => _annotationAuthor = value;
  set continuousAnnotationEditing(bool value) =>
      _continuousAnnotationEditing = value;
  set annotationPermissionCheckEnabled(bool value) =>
      _annotationPermissionCheckEnabled = value;
  set overrideBehavior(List<String> value) => _overrideBehavior = value;
  set tabTitle(String value) => _tabTitle = value;

  Config.fromJson(Map<String, dynamic> json)
      : _disabledElements = json['disabledElements'],
        _disabledTools = json['disabledTools'],
        _multiTabEnabled = json['multiTabEnabled'],
        _customHeaders = json['customHeaders'],
        _annotationToolbars = json['annotationToolbars'],
        _hideDefaultAnnotationToolbars = json['hideDefaultAnnotationToolbars'],
        _hideAnnotationToolbarSwitcher = json['hideAnnotationToolbarSwitcher'],
        _hideTopToolbars = json['hideTopToolbars'],
        _hideTopAppNavBar = json['hideTopAppNavBar'],
        _showLeadingNavButton = json['showLeadingNavButton'],
        _readOnly = json['readOnly'],
        _thumbnailViewEditingEnabled = json['thumbnailViewEditingEnabled'],
        _annotationAuthor = json['annotationAuthor'],
        _continuousAnnotationEditing = json['continuousAnnotationEditing'],
        _annotationPermissionCheckEnabled =
            json['annotationPermissionCheckEnabled'],
        _overrideBehavior = json['overrideBehavior'],
        _tabTitle = json['tabTitle'];

  Map<String, dynamic> toJson() => {
        'disabledElements': _disabledElements,
        'disabledTools': _disabledTools,
        'multiTabEnabled': _multiTabEnabled,
        'customHeaders': _customHeaders,
        'annotationToolbars': _annotationToolbars,
        'hideDefaultAnnotationToolbars': _hideDefaultAnnotationToolbars,
        'hideAnnotationToolbarSwitcher': _hideAnnotationToolbarSwitcher,
        'hideTopToolbars': _hideTopToolbars,
        'hideTopAppNavBar': _hideTopAppNavBar,
        'showLeadingNavButton': _showLeadingNavButton,
        'readOnly': _readOnly,
        'thumbnailViewEditingEnabled': _thumbnailViewEditingEnabled,
        'annotationAuthor': _annotationAuthor,
        'continuousAnnotationEditing': _continuousAnnotationEditing,
        'annotationPermissionCheckEnabled': _annotationPermissionCheckEnabled,
        'overrideBehavior': _overrideBehavior,
        'tabTitle': _tabTitle,
      };
}
