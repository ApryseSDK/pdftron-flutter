part of pdftron;

class Config {
  var _disabledElements;
  var _disabledTools;
  var _multiTabEnabled;
  var _customHeaders;
  var _fitMode;
  var _layoutMode;
  var _tabletLayoutEnabled;
  var _initialPageNumber;
  var _isBase64String;
  var _base64FileExtension;
  var _hideThumbnailFilterModes;
  var _longPressMenuEnabled;
  var _longPressMenuItems;
  var _overrideLongPressMenuBehavior;
  var _hideAnnotationMenu;
  var _annotationMenuItems;
  var _overrideAnnotationMenuBehavior;
  var _excludedAnnotationListTypes;
  var _exportPath;
  var _openUrlPath;
  var _openSavedCopyInNewTab;
  var _maxTabCount;
  var _autoSaveEnabled;
  var _pageChangeOnTap;
  var _showSavedSignatures;
  var _useStylusAsPen;
  var _signSignatureFieldWithStamps;
  var _selectAnnotationAfterCreation;
  var _pageIndicatorEnabled;
  var _pageStackEnabled;
  var _showQuickNavigationButton;
  var _followSystemDarkMode;
  var _annotationToolbars;
  var _hideDefaultAnnotationToolbars;
  var _hideAnnotationToolbarSwitcher;
  var _hideTopToolbars;
  var _hideTopAppNavBar;
  var _hideBottomToolbar;
  var _showLeadingNavButton;
  var _documentSliderEnabled;
  var _rememberLastUsedTool;
  var _readOnly;
  var _thumbnailViewEditingEnabled;
  var _annotationAuthor;
  var _continuousAnnotationEditing;
  var _annotationPermissionCheckEnabled;
  var _annotationsListEditingEnabled;
  var _userBookmarksListEditingEnabled;
  var _showNavigationListAsSidePanelOnLargeDevices;
  var _overrideBehavior;
  var _tabTitle;
  var _pageNumberIndicatorAlwaysVisible;
  var _disableEditingByAnnotationType;
  var _hideViewModeItems;
  var _defaultEraserType;

  Config();

  set disabledElements(List value) => _disabledElements = value;

  set disabledTools(List value) => _disabledTools = value;

  set multiTabEnabled(bool value) => _multiTabEnabled = value;

  set customHeaders(Map<String, String> value) => _customHeaders = value;

  set fitMode(String value) => _fitMode = value;

  set layoutMode(String value) => _layoutMode = value;

  set tabletLayoutEnabled(bool value) => _tabletLayoutEnabled = value;

  set initialPageNumber(int value) => _initialPageNumber = value;

  set isBase64String(bool value) => _isBase64String = value;

  set base64FileExtension(String value) => _base64FileExtension = value;

  set hideThumbnailFilterModes(List value) => _hideThumbnailFilterModes = value;

  set longPressMenuEnabled(bool value) => _longPressMenuEnabled = value;

  set longPressMenuItems(List value) => _longPressMenuItems = value;

  set overrideLongPressMenuBehavior(List value) =>
      _overrideLongPressMenuBehavior = value;

  set hideAnnotationMenu(List value) => _hideAnnotationMenu = value;

  set annotationMenuItems(List value) => _annotationMenuItems = value;

  set overrideAnnotationMenuBehavior(List value) =>
      _overrideAnnotationMenuBehavior = value;

  set excludedAnnotationListTypes(List value) => 
      _excludedAnnotationListTypes = value;

  set exportPath(String value) => _exportPath = value;

  set openUrlPath(String value) => _openUrlPath = value;

  set openSavedCopyInNewTab(bool value) => _openSavedCopyInNewTab = value;

  set maxTabCount(int value) => _maxTabCount = value;

  set autoSaveEnabled(bool value) => _autoSaveEnabled = value;

  set pageChangeOnTap(bool value) => _pageChangeOnTap = value;

  set showSavedSignatures(bool value) => _showSavedSignatures = value;

  set useStylusAsPen(bool value) => _useStylusAsPen;

  set signSignatureFieldWithStamps(bool value) =>
      _signSignatureFieldWithStamps = value;

  set selectAnnotationAfterCreation(bool value) =>
      _selectAnnotationAfterCreation = value;

  set pageIndicatorEnabled(bool value) => _pageIndicatorEnabled = value;

  set showQuickNavigationButton(bool value) => _showQuickNavigationButton = value;

  set followSystemDarkMode(bool value) => _followSystemDarkMode = value;

  set annotationToolbars(List value) => _annotationToolbars = value;

  set hideDefaultAnnotationToolbars(List value) =>
      _hideDefaultAnnotationToolbars = value;

  set hideAnnotationToolbarSwitcher(bool value) =>
      _hideAnnotationToolbarSwitcher = value;

  set hideTopToolbars(bool value) => _hideTopToolbars = value;

  set hideTopAppNavBar(bool value) => _hideTopAppNavBar = value;

  set hideBottomToolbar(bool value) => _hideBottomToolbar = value;

  set showLeadingNavButton(bool value) => _showLeadingNavButton = value;

  set documentSliderEnabled(bool value) => _documentSliderEnabled = value;
  
  set rememberLastUsedTool(bool value) => _rememberLastUsedTool = value;

  set readOnly(bool value) => _readOnly = value;

  set thumbnailViewEditingEnabled(bool value) =>
      _thumbnailViewEditingEnabled = value;

  set annotationAuthor(String value) => _annotationAuthor = value;

  set continuousAnnotationEditing(bool value) =>
      _continuousAnnotationEditing = value;

  set annotationPermissionCheckEnabled(bool value) =>
      _annotationPermissionCheckEnabled = value;

  set annotationsListEditingEnabled(bool value) =>
      _annotationsListEditingEnabled = value;

  set userBookmarksListEditingEnabled(bool value) =>
      _userBookmarksListEditingEnabled = value;

  set showNavigationListAsSidePanelOnLargeDevices(bool value) =>
      _showNavigationListAsSidePanelOnLargeDevices = value;

  set overrideBehavior(List<String> value) => _overrideBehavior = value;

  set tabTitle(String value) => _tabTitle = value;

  set pageNumberIndicatorAlwaysVisible(bool value) =>
      _pageNumberIndicatorAlwaysVisible = value;

  set disableEditingByAnnotationType(List value) => _disableEditingByAnnotationType = value;

  set hideViewModeItems(List value) => _hideViewModeItems = value;

  set defaultEraserType(String value) => _defaultEraserType = value;

  Config.fromJson(Map<String, dynamic> json)
      : _disabledElements = json['disabledElements'],
        _disabledTools = json['disabledTools'],
        _multiTabEnabled = json['multiTabEnabled'],
        _customHeaders = json['customHeaders'],
        _fitMode = json['fitMode'],
        _layoutMode = json['layoutMode'],
        _tabletLayoutEnabled = json['tabletLayoutEnabled'],
        _initialPageNumber = json['initialPageNumber'],
        _isBase64String = json['isBase64String'],
        _base64FileExtension = json['base64FileExtension'],
        _hideThumbnailFilterModes = json['hideThumbnailFilterModes'],
        _longPressMenuEnabled = json['longPressMenuEnabled'],
        _longPressMenuItems = json['longPressMenuItems'],
        _overrideLongPressMenuBehavior = json['overrideLongPressMenuBehavior'],
        _hideAnnotationMenu = json['hideAnnotationMenu'],
        _annotationMenuItems = json['annotationMenuItems'],
        _overrideAnnotationMenuBehavior =
            json['overrideAnnotationMenuBehavior'],
        _excludedAnnotationListTypes = json['excludedAnnotationListTypes'],
        _exportPath = json['exportPath'],
        _openUrlPath = json['openUrlPath'],
        _openSavedCopyInNewTab = json['openSavedCopyInNewTab'],
        _maxTabCount = json['maxTabCount'],
        _autoSaveEnabled = json['autoSaveEnabled'],
        _pageChangeOnTap = json['pageChangeOnTap'],
        _showSavedSignatures = json['showSavedSignatures'],
        _useStylusAsPen = json['useStylusAsPen'],
        _signSignatureFieldWithStamps = json['signSignatureFieldWithStamps'],
        _selectAnnotationAfterCreation = json['selectAnnotationAfterCreation'],
        _pageIndicatorEnabled = json['pageIndicatorEnabled'],
        _showQuickNavigationButton = json['showQuickNavigationButton'],
        _followSystemDarkMode = json['followSystemDarkMode'],
        _annotationToolbars = json['annotationToolbars'],
        _hideDefaultAnnotationToolbars = json['hideDefaultAnnotationToolbars'],
        _hideAnnotationToolbarSwitcher = json['hideAnnotationToolbarSwitcher'],
        _hideTopToolbars = json['hideTopToolbars'],
        _hideTopAppNavBar = json['hideTopAppNavBar'],
        _hideBottomToolbar = json['hideBottomToolbar'],
        _showLeadingNavButton = json['showLeadingNavButton'],
        _documentSliderEnabled = json['documentSliderEnabled'],
        _rememberLastUsedTool = json['rememberLastUsedTool'],
        _readOnly = json['readOnly'],
        _thumbnailViewEditingEnabled = json['thumbnailViewEditingEnabled'],
        _annotationAuthor = json['annotationAuthor'],
        _continuousAnnotationEditing = json['continuousAnnotationEditing'],
        _annotationPermissionCheckEnabled =
            json['annotationPermissionCheckEnabled'],
        _annotationsListEditingEnabled = json['annotationsListEditingEnabled'],
        _userBookmarksListEditingEnabled = json['userBookmarksListEditingEnabled'],
        _showNavigationListAsSidePanelOnLargeDevices = json['showNavigationListAsSidePanelOnLargeDevices'],
        _overrideBehavior = json['overrideBehavior'],
        _tabTitle = json['tabTitle'],
        _pageNumberIndicatorAlwaysVisible = json['pageNumberIndicatorAlwaysVisible'],
        _disableEditingByAnnotationType = json['disableEditingByAnnotationType'],
        _hideViewModeItems = json['hideViewModeItems'],
        _defaultEraserType = json['defaultEraserType'];

  Map<String, dynamic> toJson() => {
        'disabledElements': _disabledElements,
        'disabledTools': _disabledTools,
        'multiTabEnabled': _multiTabEnabled,
        'customHeaders': _customHeaders,
        'fitMode': _fitMode,
        'layoutMode': _layoutMode,
        'tabletLayoutEnabled': _tabletLayoutEnabled,
        'initialPageNumber': _initialPageNumber,
        'isBase64String': _isBase64String,
        'base64FileExtension': _base64FileExtension,
        'hideThumbnailFilterModes': _hideThumbnailFilterModes,
        'longPressMenuEnabled': _longPressMenuEnabled,
        'longPressMenuItems': _longPressMenuItems,
        'overrideLongPressMenuBehavior': _overrideLongPressMenuBehavior,
        'hideAnnotationMenu': _hideAnnotationMenu,
        'annotationMenuItems': _annotationMenuItems,
        'overrideAnnotationMenuBehavior': _overrideAnnotationMenuBehavior,
        'excludedAnnotationListTypes': _excludedAnnotationListTypes,
        'exportPath': _exportPath,
        'openUrlPath': _openUrlPath,
        'openSavedCopyInNewTab': _openSavedCopyInNewTab,
        'maxTabCount': _maxTabCount,
        'autoSaveEnabled': _autoSaveEnabled,
        'pageChangeOnTap': _pageChangeOnTap,
        'showSavedSignatures': _showSavedSignatures,
        'useStylusAsPen': _useStylusAsPen,
        'signSignatureFieldWithStamps': _signSignatureFieldWithStamps,
        'selectAnnotationAfterCreation': _selectAnnotationAfterCreation,
        'pageIndicatorEnabled': _pageIndicatorEnabled,
        'showQuickNavigationButton': _showQuickNavigationButton,
        'followSystemDarkMode': _followSystemDarkMode,
        'annotationToolbars': _annotationToolbars,
        'hideDefaultAnnotationToolbars': _hideDefaultAnnotationToolbars,
        'hideAnnotationToolbarSwitcher': _hideAnnotationToolbarSwitcher,
        'hideTopToolbars': _hideTopToolbars,
        'hideTopAppNavBar': _hideTopAppNavBar,
        'hideBottomToolbar': _hideBottomToolbar,
        'showLeadingNavButton': _showLeadingNavButton,
        'documentSliderEnabled': _documentSliderEnabled,
        'rememberLastUsedTool': _rememberLastUsedTool,
        'readOnly': _readOnly,
        'thumbnailViewEditingEnabled': _thumbnailViewEditingEnabled,
        'annotationAuthor': _annotationAuthor,
        'continuousAnnotationEditing': _continuousAnnotationEditing,
        'annotationPermissionCheckEnabled': _annotationPermissionCheckEnabled,
        'annotationsListEditingEnabled': _annotationsListEditingEnabled,
        'userBookmarksListEditingEnabled': _userBookmarksListEditingEnabled,
        'showNavigationListAsSidePanelOnLargeDevices': _showNavigationListAsSidePanelOnLargeDevices,
        'overrideBehavior': _overrideBehavior,
        'tabTitle': _tabTitle,
        'pageNumberIndicatorAlwaysVisible': _pageNumberIndicatorAlwaysVisible,
        'disableEditingByAnnotationType': _disableEditingByAnnotationType,
        'hideViewModeItems': _hideViewModeItems,
        'defaultEraserType' : _defaultEraserType,
      };
}
