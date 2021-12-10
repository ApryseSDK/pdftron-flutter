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
  var _showDocumentSavedToast;
  var _pageChangeOnTap;
  var _showSavedSignatures;
  var _signaturePhotoPickerEnabled;
  var _useStylusAsPen;
  var _signSignatureFieldWithStamps;
  var _selectAnnotationAfterCreation;
  var _pageIndicatorEnabled;
  var _showQuickNavigationButton;
  var _followSystemDarkMode;
  var _downloadDialogEnabled;
  var _singleLineToolbar;
  var _annotationToolbars;
  var _hideDefaultAnnotationToolbars;
  var _hideAnnotationToolbarSwitcher;
  var _initialToolbar;
  var _hideTopToolbars;
  var _hideToolbarsOnTap;
  var _hideTopAppNavBar;
  var _topAppNavBarRighBar;
  var _hideBottomToolbar;
  var _bottomToolbar;
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
  var _annotationManagerEnabled;
  var _userId;
  var _userName;

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

  set showDocumentSavedToast(bool value) => _showDocumentSavedToast = value;

  set pageChangeOnTap(bool value) => _pageChangeOnTap = value;

  set showSavedSignatures(bool value) => _showSavedSignatures = value;

  set signaturePhotoPickerEnabled(bool value) => _signaturePhotoPickerEnabled = value;

  set useStylusAsPen(bool value) => _useStylusAsPen;

  set signSignatureFieldWithStamps(bool value) =>
      _signSignatureFieldWithStamps = value;

  set selectAnnotationAfterCreation(bool value) =>
      _selectAnnotationAfterCreation = value;

  set pageIndicatorEnabled(bool value) => _pageIndicatorEnabled = value;

  set showQuickNavigationButton(bool value) => _showQuickNavigationButton = value;

  set followSystemDarkMode(bool value) => _followSystemDarkMode = value;

  set downloadDialogEnabled(bool value) => _downloadDialogEnabled = value;

  set singleLineToolbar(bool value) => _singleLineToolbar = value;

  set annotationToolbars(List value) => _annotationToolbars = value;

  set hideDefaultAnnotationToolbars(List value) =>
      _hideDefaultAnnotationToolbars = value;

  set hideAnnotationToolbarSwitcher(bool value) =>
      _hideAnnotationToolbarSwitcher = value;

  set initialToolbar(String value) => _initialToolbar = value;    

  set hideTopToolbars(bool value) => _hideTopToolbars = value;

  set hideToolbarsOnTap(bool value) => _hideToolbarsOnTap = value;

  set hideTopAppNavBar(bool value) => _hideTopAppNavBar = value;

  set topAppNavBarRightBar(List value) => _topAppNavBarRighBar = value;

  set hideBottomToolbar(bool value) => _hideBottomToolbar = value;

  set bottomToolbar(List value) => _bottomToolbar = value;

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

  set annotationManagerEnabled(bool value) => _annotationManagerEnabled = value;

  set userId(String value) => _userId = value;
  
  set userName(String value) => _userName = value;

  Config.fromJson(Map<String, dynamic> json)
      : _disabledElements = json[Configs.disabledElements],
        _disabledTools = json[Configs.disabledTools],
        _multiTabEnabled = json[Configs.multiTabEnabled],
        _customHeaders = json[Configs.customHeaders],
        _fitMode = json[Configs.fitMode],
        _layoutMode = json[Configs.layoutMode],
        _tabletLayoutEnabled = json[Configs.tabletLayoutEnabled],
        _initialPageNumber = json[Configs.initialPageNumber],
        _isBase64String = json[Configs.isBase64String],
        _base64FileExtension = json[Configs.base64FileExtension],
        _hideThumbnailFilterModes = json[Configs.hideThumbnailFilterModes],
        _longPressMenuEnabled = json[Configs.longPressMenuEnabled],
        _longPressMenuItems = json[Configs.longPressMenuItems],
        _overrideLongPressMenuBehavior = json[Configs.overrideLongPressMenuBehavior],
        _hideAnnotationMenu = json[Configs.hideAnnotationMenu],
        _annotationMenuItems = json[Configs.annotationMenuItems],
        _overrideAnnotationMenuBehavior =
            json[Configs.overrideAnnotationMenuBehavior],
        _excludedAnnotationListTypes = json[Configs.excludedAnnotationListTypes],
        _exportPath = json[Configs.exportPath],
        _openUrlPath = json[Configs.openUrlPath],
        _openSavedCopyInNewTab = json[Configs.openSavedCopyInNewTab],
        _maxTabCount = json[Configs.maxTabCount],
        _autoSaveEnabled = json[Configs.autoSaveEnabled],
        _showDocumentSavedToast = json[Configs.showDocumentSavedToast],
        _pageChangeOnTap = json[Configs.pageChangeOnTap],
        _showSavedSignatures = json[Configs.showSavedSignatures],
        _signaturePhotoPickerEnabled = json[Configs.signaturePhotoPickerEnabled],
        _useStylusAsPen = json[Configs.useStylusAsPen],
        _signSignatureFieldWithStamps = json[Configs.signSignatureFieldWithStamps],
        _selectAnnotationAfterCreation = json[Configs.selectAnnotationAfterCreation],
        _pageIndicatorEnabled = json[Configs.pageIndicatorEnabled],
        _showQuickNavigationButton = json[Configs.showQuickNavigationButton],
        _followSystemDarkMode = json[Configs.followSystemDarkMode],
        _downloadDialogEnabled = json[Configs.downloadDialogEnabled],
        _singleLineToolbar = json[Configs.singleLineToolbar],
        _annotationToolbars = json[Configs.annotationToolbars],
        _hideDefaultAnnotationToolbars = json[Configs.hideDefaultAnnotationToolbars],
        _hideAnnotationToolbarSwitcher = json[Configs.hideAnnotationToolbarSwitcher],
        _initialToolbar = json[Configs.initialToolbar],
        _hideTopToolbars = json[Configs.hideTopToolbars],
        _hideToolbarsOnTap = json[Configs.hideToolbarsOnTap],
        _hideTopAppNavBar = json[Configs.hideTopAppNavBar],
        _topAppNavBarRighBar = json[Configs.topAppNavBarRightBar],
        _hideBottomToolbar = json[Configs.hideBottomToolbar],
        _bottomToolbar = json[Configs.bottomToolbar],
        _showLeadingNavButton = json[Configs.showLeadingNavButton],
        _documentSliderEnabled = json[Configs.documentSliderEnabled],
        _rememberLastUsedTool = json[Configs.rememberLastUsedTool],
        _readOnly = json[Configs.readOnly],
        _thumbnailViewEditingEnabled = json[Configs.thumbnailViewEditingEnabled],
        _annotationAuthor = json[Configs.annotationAuthor],
        _continuousAnnotationEditing = json[Configs.continuousAnnotationEditing],
        _annotationPermissionCheckEnabled =
            json[Configs.annotationPermissionCheckEnabled],
        _annotationsListEditingEnabled = json[Configs.annotationsListEditingEnabled],
        _userBookmarksListEditingEnabled = json[Configs.userBookmarksListEditingEnabled],
        _showNavigationListAsSidePanelOnLargeDevices = json[Configs.showNavigationListAsSidePanelOnLargeDevices],
        _overrideBehavior = json[Configs.overrideBehavior],
        _tabTitle = json[Configs.tabTitle],
        _pageNumberIndicatorAlwaysVisible = json[Configs.pageNumberIndicatorAlwaysVisible],
        _disableEditingByAnnotationType = json[Configs.disableEditingByAnnotationType],
        _hideViewModeItems = json[Configs.hideViewModeItems],
        _defaultEraserType = json[Configs.defaultEraserType],
        _annotationManagerEnabled = json[Configs.annotationManagerEnabled],
        _userId = json[Configs.userId],
        _userName = json[Configs.userName];


  Map<String, dynamic> toJson() => {
        Configs.disabledElements: _disabledElements,
        Configs.disabledTools: _disabledTools,
        Configs.multiTabEnabled: _multiTabEnabled,
        Configs.customHeaders: _customHeaders,
        Configs.fitMode: _fitMode,
        Configs.layoutMode: _layoutMode,
        Configs.tabletLayoutEnabled: _tabletLayoutEnabled,
        Configs.initialPageNumber: _initialPageNumber,
        Configs.isBase64String: _isBase64String,
        Configs.base64FileExtension: _base64FileExtension,
        Configs.hideThumbnailFilterModes: _hideThumbnailFilterModes,
        Configs.longPressMenuEnabled: _longPressMenuEnabled,
        Configs.longPressMenuItems: _longPressMenuItems,
        Configs.overrideLongPressMenuBehavior: _overrideLongPressMenuBehavior,
        Configs.hideAnnotationMenu: _hideAnnotationMenu,
        Configs.annotationMenuItems: _annotationMenuItems,
        Configs.overrideAnnotationMenuBehavior: _overrideAnnotationMenuBehavior,
        Configs.excludedAnnotationListTypes: _excludedAnnotationListTypes,
        Configs.exportPath: _exportPath,
        Configs.openUrlPath: _openUrlPath,
        Configs.openSavedCopyInNewTab: _openSavedCopyInNewTab,
        Configs.maxTabCount: _maxTabCount,
        Configs.autoSaveEnabled: _autoSaveEnabled,
        Configs.showDocumentSavedToast: _showDocumentSavedToast,
        Configs.pageChangeOnTap: _pageChangeOnTap,
        Configs.showSavedSignatures: _showSavedSignatures,
        Configs.signaturePhotoPickerEnabled: _signaturePhotoPickerEnabled,
        Configs.useStylusAsPen: _useStylusAsPen,
        Configs.signSignatureFieldWithStamps: _signSignatureFieldWithStamps,
        Configs.selectAnnotationAfterCreation: _selectAnnotationAfterCreation,
        Configs.pageIndicatorEnabled: _pageIndicatorEnabled,
        Configs.showQuickNavigationButton: _showQuickNavigationButton,
        Configs.followSystemDarkMode: _followSystemDarkMode,
        Configs.downloadDialogEnabled: _downloadDialogEnabled,
        Configs.singleLineToolbar: _singleLineToolbar,
        Configs.annotationToolbars: _annotationToolbars,
        Configs.hideDefaultAnnotationToolbars: _hideDefaultAnnotationToolbars,
        Configs.hideAnnotationToolbarSwitcher: _hideAnnotationToolbarSwitcher,
        Configs.initialToolbar: _initialToolbar,
        Configs.hideTopToolbars: _hideTopToolbars,
        Configs.hideToolbarsOnTap: _hideToolbarsOnTap,
        Configs.hideTopAppNavBar: _hideTopAppNavBar,
        Configs.topAppNavBarRightBar: _topAppNavBarRighBar,
        Configs.hideBottomToolbar: _hideBottomToolbar,
        Configs.bottomToolbar: _bottomToolbar,
        Configs.showLeadingNavButton: _showLeadingNavButton,
        Configs.documentSliderEnabled: _documentSliderEnabled,
        Configs.rememberLastUsedTool: _rememberLastUsedTool,
        Configs.readOnly: _readOnly,
        Configs.thumbnailViewEditingEnabled: _thumbnailViewEditingEnabled,
        Configs.annotationAuthor: _annotationAuthor,
        Configs.continuousAnnotationEditing: _continuousAnnotationEditing,
        Configs.annotationPermissionCheckEnabled: _annotationPermissionCheckEnabled,
        Configs.annotationsListEditingEnabled: _annotationsListEditingEnabled,
        Configs.userBookmarksListEditingEnabled: _userBookmarksListEditingEnabled,
        Configs.showNavigationListAsSidePanelOnLargeDevices: _showNavigationListAsSidePanelOnLargeDevices,
        Configs.overrideBehavior: _overrideBehavior,
        Configs.tabTitle: _tabTitle,
        Configs.pageNumberIndicatorAlwaysVisible: _pageNumberIndicatorAlwaysVisible,
        Configs.disableEditingByAnnotationType: _disableEditingByAnnotationType,
        Configs.hideViewModeItems: _hideViewModeItems,
        Configs.defaultEraserType: _defaultEraserType,
        Configs.annotationManagerEnabled: _annotationManagerEnabled,
        Configs.userId: _userId,
        Configs.userName: _userName
      };
}
