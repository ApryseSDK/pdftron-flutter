import 'package:json_annotation/json_annotation.dart';

part 'config.g.dart';

@JsonSerializable(includeIfNull: false)
class Config {
  List<String> disabledElements;
  List<String> disabledTools;
  bool multiTabEnabled;
  Map<String, String> customHeaders;
  List<dynamic> annotationToolbars;
  List<String> hideDefaultAnnotationToolbars;
  bool hideAnnotationToolbarSwitcher;
  bool hideTopToolbars;
  bool hideTopAppNavBar;
  bool hideBottomToolbar;
  bool showLeadingNavButton;
  bool readOnly;
  bool thumbnailViewEditingEnabled;
  String annotationAuthor;
  bool continuousAnnotationEditing;
  String tabTitle;

  Config();

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigToJson(this);
}
