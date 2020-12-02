part of pdftron;

class Config {
  var _disabledElements;
  var _disabledTools;
  var _multiTabEnabled;
  var _customHeaders;
  var _hideThumbnailFilterModes;

  Config();

  set disabledElements(List value) => _disabledElements = value;
  set disabledTools(List value) => _disabledTools = value;
  set multiTabEnabled(bool value) => _multiTabEnabled = value;
  set customHeaders(Map<String, String> value) => _customHeaders = value;
  set hideThumbnailFilterModes(List value) => _hideThumbnailFilterModes = value;

  Config.fromJson(Map<String, dynamic> json)
      : _disabledElements = json['disabledElements'],
        _disabledTools = json['disabledTools'],
        _multiTabEnabled = json['multiTabEnabled'],
        _customHeaders = json['customHeaders'],
        _hideThumbnailFilterModes = json['hideThumbnailFilterModes'];

  Map<String, dynamic> toJson() => {
        'disabledElements': _disabledElements,
        'disabledTools': _disabledTools,
        'multiTabEnabled': _multiTabEnabled,
        'customHeaders': _customHeaders,
        'hideThumbnailFilterModes': _hideThumbnailFilterModes,
      };
}
