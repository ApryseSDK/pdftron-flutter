part of pdftron;

class Config {
  var _dElements;
  var _dTools;
  var _multiTab;
  var _mCustomHeaders;
  var _lNavButtonIcon;
  var _sLeadingNavButton;
  var _rOnly;
  var _thumbnailViewEditing;
  var _annotAuthor;
  var _cAnnotationEditing;

  Config();

  set disabledElements(List value) => _dElements = value;
  set disabledTools(List value) => _dTools = value;
  set multiTabEnabled(bool value) => _multiTab = value;
  set customHeaders(Map<String, String> value) => _mCustomHeaders = value;
  set leadingNavButtonIcon(String value) => _lNavButtonIcon = value;
  set showleadingNavButton(bool value) => _sLeadingNavButton = value;
  set readOnly(bool value) => _rOnly = value;
  set thumbnailViewEditingEnabled(bool value) => _thumbnailViewEditing = value;
  set annotationAuthor(String value) => _annotAuthor = value;
  set continuousAnnotationEditing(bool value) => _cAnnotationEditing = value;

  Config.fromJson(Map<String, dynamic> json)
      : _dElements = json['disabledElements'],
        _dTools = json['disabledTools'],
        _multiTab = json['multiTabEnabled'],
        _mCustomHeaders = json['customHeaders'],
        _lNavButtonIcon = json['leadingNavButtonIcon'],
        _sLeadingNavButton = json['showLeadingNavButton'],
        _rOnly = json['readOnly'],
        _thumbnailViewEditing = json['thumbnailViewEditingEnabled'],
        _annotAuthor = json['annotationAuthor'],
        _cAnnotationEditing = json['continuousAnnotationEditing'];

  Map<String, dynamic> toJson() => {
        'disabledElements': _dElements,
        'disabledTools': _dTools,
        'multiTabEnabled': _multiTab,
        'customHeaders': _mCustomHeaders,
        'leadingNavButtonIcon': _lNavButtonIcon,
        'showLeadingNavButton': _sLeadingNavButton,
        'readOnly': _rOnly,
        'thumbnailViewEditingEnabled': _thumbnailViewEditing,
        'annotationAuthor': _annotAuthor,
        'continuousAnnotationEditing': _cAnnotationEditing,
      };
}
