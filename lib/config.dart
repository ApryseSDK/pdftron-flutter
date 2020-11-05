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

  Config.fromJson(Map<String, dynamic> json)
      : _disabledElements = json['disabledElements'],
        _disabledTools = json['disabledTools'],
        _multiTabEnabled = json['multiTabEnabled'],
        _customHeaders = json['customHeaders'],
        _selectAnnotationAfterCreation = json['selectAnnotationAfterCreation'],
        _bottomToolbarEnabled = json['bottomToolbarEnabled'],
        _pageIndicatorEnabled = json['pageIndicatorEnabled'],
        _followSystemDarkMode = json['followSystemDarkMode'];

  Map<String, dynamic> toJson() => {
        'disabledElements': _disabledElements,
        'disabledTools': _disabledTools,
        'multiTabEnabled': _multiTabEnabled,
        'customHeaders': _customHeaders,
        'selectAnnotationAfterCreation': _selectAnnotationAfterCreation,
        'bottomToolbarEnabled': _bottomToolbarEnabled,
        'pageIndicatorEnabled': _pageIndicatorEnabled,
        'followSystemDarkMode': _followSystemDarkMode,
      };
}
