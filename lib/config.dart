part of pdftron;

class Config {
  var dElements;
  var dTools;
  var multiTab;
  var mCustomHeaders;

  Config();

  set disabledElements(List value) => dElements = value;
  set disabledTools(List value) => dTools = value;
  set multiTabEnabled(bool value) => multiTab = value;
  set customHeaders(Map<String, String> value) => mCustomHeaders = value;

  Config.fromJson(Map<String, dynamic> json)
      : dElements = json['disabledElements'],
        dTools = json['disabledTools'],
        multiTab = json['multiTabEnabled'],
        mCustomHeaders = json['customHeaders'];

  Map<String, dynamic> toJson() => {
        'disabledElements': dElements,
        'disabledTools': dTools,
        'multiTabEnabled': multiTab,
        'customHeaders': mCustomHeaders,
      };
}
