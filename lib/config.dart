part of pdftron;

class Config {
  var _disabledElements;
  var _disabledTools;
  var _multiTabEnabled;
  var _customHeaders;
  var _annotationPermissionCheckEnabled;
  var _overrideBehavior;

  Config();

  set disabledElements(List value) => _disabledElements = value;
  set disabledTools(List value) => _disabledTools = value;
  set multiTabEnabled(bool value) => _multiTabEnabled = value;
  set customHeaders(Map<String, String> value) => _customHeaders = value;
  set annotationPermissionCheckEnabled(bool value) =>
      _annotationPermissionCheckEnabled = value;
  set overrideBehavior(List<String> value) => _overrideBehavior = value;

  Config.fromJson(Map<String, dynamic> json)
      : _disabledElements = json['disabledElements'],
        _disabledTools = json['disabledTools'],
        _multiTabEnabled = json['multiTabEnabled'],
        _customHeaders = json['customHeaders'],
        _annotationPermissionCheckEnabled =
            json['annotationPermissionCheckEnabled'],
        _overrideBehavior = json['overrideBehavior'];

  Map<String, dynamic> toJson() => {
        'disabledElements': _disabledElements,
        'disabledTools': _disabledTools,
        'multiTabEnabled': _multiTabEnabled,
        'customHeaders': _customHeaders,
        'annotationPermissionCheckEnabled': _annotationPermissionCheckEnabled,
        'overrideBehavior': _overrideBehavior,
      };
}
