part of pdftron;

class Config {
  var _disabledElements;
  var _disabledTools;
  var _multiTabEnabled;
  var _customHeaders;
  var _selectAnnotationAfterCreation;
  var _bottomToolbarEnabled;
  var _pageIndicatorEnabled;
  var _followSystemDarkMode;
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
  set selectAnnotationAfterCreation(bool value) =>
      _selectAnnotationAfterCreation = value;
  set bottomToolbarEnabled(bool value) => _bottomToolbarEnabled = value;
  set pageIndicatorEnabled(bool value) => _pageIndicatorEnabled = value;
  set followSystemDarkMode(bool value) => _followSystemDarkMode = value;
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
        _selectAnnotationAfterCreation = json['selectAnnotationAfterCreation'],
        _bottomToolbarEnabled = json['bottomToolbarEnabled'],
        _pageIndicatorEnabled = json['pageIndicatorEnabled'],
        _followSystemDarkMode = json['followSystemDarkMode'],
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
        'selectAnnotationAfterCreation': _selectAnnotationAfterCreation,
        'bottomToolbarEnabled': _bottomToolbarEnabled,
        'pageIndicatorEnabled': _pageIndicatorEnabled,
        'followSystemDarkMode': _followSystemDarkMode,
        'showLeadingNavButton': _showLeadingNavButton,
        'readOnly': _readOnly,
        'thumbnailViewEditingEnabled': _thumbnailViewEditingEnabled,
        'annotationAuthor': _annotationAuthor,
        'continuousAnnotationEditing': _continuousAnnotationEditing,
      };
}
