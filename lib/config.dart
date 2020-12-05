part of pdftron;

class Config {
  var _disabledElements;
  var _disabledTools;
  var _multiTabEnabled;
  var _customHeaders;
  var _autoSaveEnabled;
  var _pageChangeOnTap;
  var _showSavedSignatures;
  var _useStylusAsPen;
  var _signSignatureFieldWithStamps;
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
  set autoSaveEnabled(bool value) => _autoSaveEnabled = value;
  set pageChangeOnTap(bool value) => _pageChangeOnTap = value;
  set showSavedSignatures(bool value) => _showSavedSignatures = value;
  set useStylusAsPen(bool value) => _useStylusAsPen;
  set signSignatureFieldWithStamps(bool value) =>
      _signSignatureFieldWithStamps = value;
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
        _autoSaveEnabled = json['autoSaveEnabled'],
        _pageChangeOnTap = json['pageChangeOnTap'],
        _showSavedSignatures = json['showSavedSignatures'],
        _useStylusAsPen = json['useStylusAsPen'],
        _signSignatureFieldWithStamps = json['signSignatureFieldWithStamps'],
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
        'autoSaveEnabled': _autoSaveEnabled,
        'pageChangeOnTap': _pageChangeOnTap,
        'showSavedSignatures': _showSavedSignatures,
        'useStylusAsPen': _useStylusAsPen,
        'signSignatureFieldWithStamps': _signSignatureFieldWithStamps,
        'showLeadingNavButton': _showLeadingNavButton,
        'readOnly': _readOnly,
        'thumbnailViewEditingEnabled': _thumbnailViewEditingEnabled,
        'annotationAuthor': _annotationAuthor,
        'continuousAnnotationEditing': _continuousAnnotationEditing,
      };
}
