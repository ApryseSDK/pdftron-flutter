part of pdftron;

/// A class to contain the viewer configuration options.
///
/// The class properties represent all possible viewer configuration options.
/// These options are not required and have default values.
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
  var _hidePresetBar;
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
  var _outlineListEditingEnabled;
  var _showNavigationListAsSidePanelOnLargeDevices;
  var _overrideBehavior;
  var _tabTitle;
  var _pageNumberIndicatorAlwaysVisible;
  var _disableEditingByAnnotationType;
  var _annotationsListFilterEnabled;
  var _hideViewModeItems;
  var _defaultEraserType;
  var _autoResizeFreeTextEnabled;
  var _restrictDownloadUsage;
  var _reflowOrientation;
  var _imageInReflowModeEnabled;
  var _annotationManagerEnabled;
  var _userId;
  var _userName;
  var _annotationManagerEditMode;
  var _annotationManagerUndoMode;
  var _annotationToolbarAlignment;
  var _hideScrollbars;
  var _quickBookmarkCreation;

  Config();

  /// A list of [Buttons] that will be disabled in the viewer.
  ///
  /// Defaults to empty.
  set disabledElements(List value) => _disabledElements = value;

  /// A list of [Tools] that will be disabled in the viewer.
  ///
  /// Defaults to empty.
  set disabledTools(List value) => _disabledTools = value;

  /// Whether the viewer will use tabs to enable having multiple documents open
  /// simultaneously.
  ///
  /// If this [value] is true and [PdftronFlutter.openDocument] or
  /// [DocumentViewController.openDocument] is called, it will open a new tab
  /// with the associated document. Defaults to false.
  set multiTabEnabled(bool value) => _multiTabEnabled = value;

  /// A map containing custom headers to use with HTTP/HTTPS requests.
  ///
  /// ```dart
  /// config.customHeaders = {'headerName': 'headerValue'};
  /// ```
  ///
  /// Defaults to empty.
  set customHeaders(Map<String, String> value) => _customHeaders = value;

  /// The default zoom level of the viewer.
  ///
  /// The [value] is given as one of the [FitModes] constants. Defaults to
  /// [FitModes.fitWidth].
  set fitMode(String value) => _fitMode = value;

  /// The layout mode of the viewer.
  ///
  /// The [value] is given as one of the [LayoutModes] constants. Defaults to
  /// [LayoutModes.continuous].
  set layoutMode(String value) => _layoutMode = value;

  /// Whether the tablet layout should be used on tablets.
  ///
  /// If false, tablets use the same layout as phones. Defaults to true.
  set tabletLayoutEnabled(bool value) => _tabletLayoutEnabled = value;

  /// The initial page number upon opening a document.
  ///
  /// Page numbers are 1-indexed. Defaults to 1.
  set initialPageNumber(int value) => _initialPageNumber = value;

  /// Whether to treat the document being opened as a base64 string.
  ///
  /// When viewing a document initialized with a base64 string, a temporary file
  /// is created on Android, but not on iOS. Defaults to false.
  set isBase64String(bool value) => _isBase64String = value;

  /// The file extension to use when [isBase64String] is true.
  ///
  /// ```dart
  /// config.base64FileExtension = '.jpeg';
  /// ```
  ///
  /// Defaults to ".pdf", but is required if using the base64 string of a
  /// non-pdf file.
  set base64FileExtension(String value) => _base64FileExtension = value;

  /// A list of [ThumbnailFilterModes] that will be hidden in the thumbnails browser.
  ///
  /// Defaults to empty.
  set hideThumbnailFilterModes(List value) => _hideThumbnailFilterModes = value;

  /// Whether to show a popup menu after the user long presses on text or blank space.
  ///
  /// Defaults to true.
  set longPressMenuEnabled(bool value) => _longPressMenuEnabled = value;

  /// A list of [LongPressMenuItems] that will be shown after a long press on text
  /// or blank space.
  ///
  /// Defaults to all of [LongPressMenuItems].
  set longPressMenuItems(List value) => _longPressMenuItems = value;

  /// A list of [LongPressMenuItems] that will skip default behavior when pressed.
  ///
  /// These menu items will still be displayed in the long press menu. When pressed,
  /// the event listener [startLongPressMenuPressedListener] will be called
  /// instead where custom behavior can be implemented. Defaults to empty.
  set overrideLongPressMenuBehavior(List value) =>
      _overrideLongPressMenuBehavior = value;

  /// A list of [Tools] that will not show in the default annotation menu.
  ///
  /// Defaults to empty.
  set hideAnnotationMenu(List value) => _hideAnnotationMenu = value;

  /// A list of [AnnotationMenuItems] that will show when an annotation is selected.
  ///
  /// Defaults to all of [AnnotationMenuItems].
  set annotationMenuItems(List value) => _annotationMenuItems = value;

  /// A list of [AnnotationMenuItems] that will skip default behavior when pressed.
  ///
  /// These menu items will still be displayed in the annotation menu. When pressed,
  /// the event listener [startAnnotationMenuPressedListener] will be called
  /// instead where custom behavior can be implemented. Defaults to empty.
  set overrideAnnotationMenuBehavior(List value) =>
      _overrideAnnotationMenuBehavior = value;

  /// A list of [Tools] that will be excluded from the annotation list.
  ///
  /// Defaults to empty.
  set excludedAnnotationListTypes(List value) =>
      _excludedAnnotationListTypes = value;

  /// The folder path where the file will be saved for actions to save a copy of
  /// the document.
  ///
  /// The actions include saving a password copy and saving a flattened copy.
  /// Defaults to null. Android only.
  set exportPath(String value) => _exportPath = value;

  /// The folder path where cache files are saved when opening files from HTTPS.
  ///
  /// Defaults to null. Android only.
  set openUrlPath(String value) => _openUrlPath = value;

  /// Whether newly saved files should open in a new tab after saving.
  ///
  /// Applicable when [multiTabEnabled] is true. Defaults to true. Android only.
  set openSavedCopyInNewTab(bool value) => _openSavedCopyInNewTab = value;

  /// The maximum number of tabs that the viewer could have at a time.
  ///
  /// Applicable when [multiTabEnabled] is true. Opening more documents after
  /// reaching this limit will overwrite the old tabs. Defaults to unlimited.
  set maxTabCount(int value) => _maxTabCount = value;

  /// Whether the document is automatically saved.
  ///
  /// Defaults to true.
  set autoSaveEnabled(bool value) => _autoSaveEnabled = value;

  /// Whether a toast indicating that the document has been successfully or
  /// unsuccessfully saved will appear.
  ///
  /// Defaults to true. Android only.
  set showDocumentSavedToast(bool value) => _showDocumentSavedToast = value;

  /// Whether the viewer should change pages when the user taps the edge of a page
  /// if the viewer is in a horizontal viewing mode.
  ///
  /// Defaults to true.
  set pageChangeOnTap(bool value) => _pageChangeOnTap = value;

  /// Whether to enable saving multiple signatures for re-use.
  ///
  /// Defaults to true.
  set showSavedSignatures(bool value) => _showSavedSignatures = value;

  /// Whether to show the option to select images in the signature dialog.
  ///
  /// Defaults to true.
  set signaturePhotoPickerEnabled(bool value) =>
      _signaturePhotoPickerEnabled = value;

  /// Whether a stylus should act like a pen when the viewer is in pan mode.
  ///
  /// If false, it will act like a finger. Defaults to true.
  set useStylusAsPen(bool value) => _useStylusAsPen;

  /// Whether signature fields will be signed with image stamps.
  ///
  /// Can be useful if saving XFDF to remote source. Defaults to false.
  set signSignatureFieldWithStamps(bool value) =>
      _signSignatureFieldWithStamps = value;

  /// Whether annotations are selected after creation.
  ///
  /// On iOS, this applies to shape and text markup only. Defaults to true.
  set selectAnnotationAfterCreation(bool value) =>
      _selectAnnotationAfterCreation = value;

  /// Whehter to show the page indicator in the viewer.
  ///
  /// Defaults to true.
  set pageIndicatorEnabled(bool value) => _pageIndicatorEnabled = value;

  /// Whether the quick navigation buttons will appear in the viewer.
  ///
  /// Defaults to true.
  set showQuickNavigationButton(bool value) =>
      _showQuickNavigationButton = value;

  /// Whether the UI will appear in a dark color when the system is in dark mode.
  ///
  /// If false, it will use the viewer setting instead. Defaults to true.
  /// Android only.
  set followSystemDarkMode(bool value) => _followSystemDarkMode = value;

  /// Whether the download dialog should be shown.
  ///
  /// Defaults to true. Android only.
  set downloadDialogEnabled(bool value) => _downloadDialogEnabled = value;

  /// Whether to use a single-line toolbar instead of a double-line toolbar.
  ///
  /// Defaults to false. Android only.
  set singleLineToolbar(bool value) => _singleLineToolbar = value;

  /// A list of [CustomToolbar] objects or [DefaultToolbars] constants that define a
  /// custom toolbar.
  ///
  /// If used the default toolbar no longer shows. Defualts to empty.
  set annotationToolbars(List value) => _annotationToolbars = value;

  /// A list of [DefaultToolbars] that will be hidden.
  ///
  /// Not to be used in conjunction with [annotationToolbars]. Defaults to empty.
  set hideDefaultAnnotationToolbars(List value) =>
      _hideDefaultAnnotationToolbars = value;

  /// Whether to show the toolbar switcher in the top toolbar.
  ///
  /// Defaults to false.
  set hideAnnotationToolbarSwitcher(bool value) =>
      _hideAnnotationToolbarSwitcher = value;

  /// The annotation toolbar that will be selected when the document is opened.
  ///
  /// The [value] is given as either one of the [DefaultToolbars] constants or
  /// the [CustomToolbar.id] of a custom toolbar object. Defaults to none.
  set initialToolbar(String value) => _initialToolbar = value;

  /// Whether to hide the top app navigation bar and the annotation toolbar.
  ///
  /// Defaults to false.
  set hideTopToolbars(bool value) => _hideTopToolbars = value;

  /// Whether an unhandled tap in the viewer should toggle the visibility of the
  /// top and bottom toolbars.
  ///
  /// If false, the top and bottom toolbar visibility will not be toggled and
  /// the page content will fit between the bars, if any. Defaults to true.
  set hideToolbarsOnTap(bool value) => _hideToolbarsOnTap = value;

  /// Whether to hide the top app navigation bar.
  ///
  /// Defaults to false.
  set hideTopAppNavBar(bool value) => _hideTopAppNavBar = value;

  /// A list of [Buttons] that will appear in the right bar section of the top
  /// app navigation bar.
  ///
  /// If used, the default right bar section will not be used. Defaults to
  /// [Buttons.searchButton] and [Buttons.moreItemsButton]. iOS only.
  set topAppNavBarRightBar(List value) => _topAppNavBarRighBar = value;

  /// Whether to hide the bottom toolbar for the current viewer.
  ///
  /// Defaults to false.
  set hideBottomToolbar(bool value) => _hideBottomToolbar = value;

  /// Whether to hide the preset bar for the current viewer.
  ///
  /// Defaults to false.
  set hidePresetBar(bool value) => _hidePresetBar = value;

  /// A list of [Buttons] that will appear in the bottom toolbar.
  ///
  /// If used, the default bottom toolbar will not be used. Supported buttons are:
  /// * [Buttons.listsButton]
  /// * [Buttons.thumbnailsButton]
  /// * [Buttons.shareButton]
  /// * [Buttons.viewControlsButton]
  /// * [Buttons.reflowModeButton]
  /// * [Buttons.searchButton]
  /// * [Buttons.moreItemsButton] (iOS only)
  set bottomToolbar(List value) => _bottomToolbar = value;

  /// Whether to show the leading navigation button.
  ///
  /// Defaults to true.
  set showLeadingNavButton(bool value) => _showLeadingNavButton = value;

  /// Whether the document slider of the viewer is enabled.
  ///
  /// Defaults to true.
  set documentSliderEnabled(bool value) => _documentSliderEnabled = value;

  /// Whether the last tool used in the current viewer session will be the tool
  /// selected upon starting a new viewer session.
  ///
  /// Defults to true. Android only.
  set rememberLastUsedTool(bool value) => _rememberLastUsedTool = value;

  /// Whether the viewer will allow users to edit the document.
  ///
  /// Defaults to false.
  set readOnly(bool value) => _readOnly = value;

  /// Whether the user can edit the document from the thumbnail view.
  ///
  /// Defaults to true.
  set thumbnailViewEditingEnabled(bool value) =>
      _thumbnailViewEditingEnabled = value;

  /// The author name for all annotations created on the current document.
  ///
  /// When the XFDF command is exported, this information will be included.
  set annotationAuthor(String value) => _annotationAuthor = value;

  /// Whether the active annotation creation tool will remain the current annotation
  /// tool.
  ///
  /// If false, it will revert to the pan tool after an annotation is created.
  /// Defaults to true.
  set continuousAnnotationEditing(bool value) =>
      _continuousAnnotationEditing = value;

  /// Whether the annotation's flags will be considered upon its selection.
  ///
  /// For example, an annotation with a locked flag cannot be resized or moved.
  /// Defaults to false.
  set annotationPermissionCheckEnabled(bool value) =>
      _annotationPermissionCheckEnabled = value;

  /// Whether the annotation list is editable if document editing is enabled.
  ///
  /// Defaults to true.
  set annotationsListEditingEnabled(bool value) =>
      _annotationsListEditingEnabled = value;

  /// Whether the bookmark list is editable.
  ///
  /// If the viewer is read-only, then bookmarks on Android will still be editable
  /// but are saved to the device rather than the PDF. Defaults to true.
  set userBookmarksListEditingEnabled(bool value) =>
      _userBookmarksListEditingEnabled = value;

  /// Whether the outline list is editable.
  ///
  /// Defaults to true.
  set outlineListEditingEnabled(bool value) =>
      _outlineListEditingEnabled = value;

  /// Whether the navigation list will be displayed as a side panel on large
  /// devices such as iPads and tablets.
  ///
  /// Defaults to true.
  set showNavigationListAsSidePanelOnLargeDevices(bool value) =>
      _showNavigationListAsSidePanelOnLargeDevices = value;

  /// A list of [Behaviors] that will skip their default behavior.
  ///
  /// When the behavior is activated, the event listener
  /// [startBehaviorActivatedListener] will be called instead where custom
  /// behavior can be implemented. Defaults to empty.
  set overrideBehavior(List<String> value) => _overrideBehavior = value;

  /// The tab title if [multiTabEnabled] is true.
  ///
  /// Only supported on the [DocumentView] widget for Android. Defaults to the
  /// file name.
  set tabTitle(String value) => _tabTitle = value;

  /// Whether the page indicator is always visible.
  ///
  /// Defaults to false.
  set pageNumberIndicatorAlwaysVisible(bool value) =>
      _pageNumberIndicatorAlwaysVisible = value;

  /// A list of [Tools] that cannot be edited after creation.
  ///
  /// Defaults to empty.
  set disableEditingByAnnotationType(List value) =>
      _disableEditingByAnnotationType = value;

  /// Whether filtering the annotation list is possible.
  ///
  /// Defaults to true. Android only.
  set annotationsListFilterEnabled(bool value) =>
      _annotationsListFilterEnabled = value;

  /// The view mode items to be hidden in the view mode dialog.
  ///
  /// The [value] is given as a list of [ViewModePickerItem] constants.
  /// Defaults to empty.
  set hideViewModeItems(List value) => _hideViewModeItems = value;

  /// The default eraser tool type.
  ///
  /// The [value] is given as one of the [DefaultEraserType] constants. Only
  /// applied after a clean install.
  set defaultEraserType(String value) => _defaultEraserType = value;

  /// Whether to automatically resize the bounding box of free text annotations
  /// when editing.
  ///
  /// Defaults to false.
  set autoResizeFreeTextEnabled(bool value) =>
      _autoResizeFreeTextEnabled = value;

  /// Whether to restrict data usage when viewing online PDFs.
  ///
  /// Defaults to false.
  set restrictDownloadUsage(bool value) => _restrictDownloadUsage = value;

  /// The scrolling direction of the reflow control.
  ///
  /// The [value] is given as one of the [ReflowOrientation] constants. Defaults
  /// to the viewer's scroll direction.
  set reflowOrientation(String value) => _reflowOrientation = value;

  /// Whether to show images in reflow mode.
  ///
  /// Defaults to true.
  set imageInReflowModeEnabled(bool value) => _imageInReflowModeEnabled = value;

  /// Defines whether the annotation manager is enabled.
  ///
  /// Defaults to false.
  set annotationManagerEnabled(bool value) => _annotationManagerEnabled = value;

  /// The unique identifier of the current user.
  ///
  /// Defaults to null.
  set userId(String value) => _userId = value;

  /// The name of the current user.
  ///
  /// Used in the annotation manager when [annotationManagerEnabled] is true.
  /// Android only.
  set userName(String value) => _userName = value;

  /// The annotation manager's edit mode when [annotationManagerEnabled] is true
  /// and [userId] is not null.
  ///
  /// The [value] is given as one of the [AnnotationManagerEditMode] constants.
  /// Defaults to [AnnotationManagerEditMode.All].
  set annotationManagerEditMode(String value) =>
      _annotationManagerEditMode = value;

  /// The annotation manager's undo mode when [annotationManagerEnabled] is true
  /// and [userId] is not null.
  ///
  /// The [value] is given as one of the [AnnotationManagerUndoMode] constants.
  /// Defaults to [AnnotationManagerUndoMode.All].
  set annotationManagerUndoMode(String value) =>
      _annotationManagerUndoMode = value;

  /// The alignment of the annotation toolbars.
  ///
  /// The [value] is given as one of the [ToolbarAlignment] constants. Defaults
  /// to [ToolbarAlignment.End].
  set annotationToolbarAlignment(String value) =>
      _annotationToolbarAlignment = value;

  /// Whether scroll bars will be hidden in the viewer.
  ///
  /// Defaults to false. iOS only.
  set hideScrollbars(bool value) => _hideScrollbars = value;

  /// Whether a bookmark creation button will be included in the bottom toolbar.
  ///
  /// Pressing the button will booksmark the current page. Defaults to false.
  set quickBookmarkCreation(bool value) => _quickBookmarkCreation = value;

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
        _showDocumentSavedToast = json['showDocumentSavedToast'],
        _pageChangeOnTap = json['pageChangeOnTap'],
        _showSavedSignatures = json['showSavedSignatures'],
        _signaturePhotoPickerEnabled = json['signaturePhotoPickerEnabled'],
        _useStylusAsPen = json['useStylusAsPen'],
        _signSignatureFieldWithStamps = json['signSignatureFieldWithStamps'],
        _selectAnnotationAfterCreation = json['selectAnnotationAfterCreation'],
        _pageIndicatorEnabled = json['pageIndicatorEnabled'],
        _showQuickNavigationButton = json['showQuickNavigationButton'],
        _followSystemDarkMode = json['followSystemDarkMode'],
        _downloadDialogEnabled = json['downloadDialogEnabled'],
        _singleLineToolbar = json['_singleLineToolbar'],
        _annotationToolbars = json['annotationToolbars'],
        _hideDefaultAnnotationToolbars = json['hideDefaultAnnotationToolbars'],
        _hideAnnotationToolbarSwitcher = json['hideAnnotationToolbarSwitcher'],
        _initialToolbar = json['initialToolbar'],
        _hideTopToolbars = json['hideTopToolbars'],
        _hideToolbarsOnTap = json['hideToolbarsOnTap'],
        _hideTopAppNavBar = json['hideTopAppNavBar'],
        _topAppNavBarRighBar = json['topAppNavBarRightBar'],
        _hideBottomToolbar = json['hideBottomToolbar'],
        _hidePresetBar = json['hidePresetBar'],
        _bottomToolbar = json['bottomToolbar'],
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
        _userBookmarksListEditingEnabled =
            json['userBookmarksListEditingEnabled'],
        _showNavigationListAsSidePanelOnLargeDevices =
            json['showNavigationListAsSidePanelOnLargeDevices'],
        _overrideBehavior = json['overrideBehavior'],
        _tabTitle = json['tabTitle'],
        _pageNumberIndicatorAlwaysVisible =
            json['pageNumberIndicatorAlwaysVisible'],
        _disableEditingByAnnotationType =
            json['disableEditingByAnnotationType'],
        _annotationsListFilterEnabled = json['annotationsListFilterEnabled'],
        _hideViewModeItems = json['hideViewModeItems'],
        _defaultEraserType = json['defaultEraserType'],
        _autoResizeFreeTextEnabled = json['autoResizeFreeTextEnabled'],
        _restrictDownloadUsage = json['restrictDownloadUsage'],
        _reflowOrientation = json['reflowOrientation'],
        _imageInReflowModeEnabled = json['imageInReflowModeEnabled'],
        _annotationManagerEnabled = json['annotationManagerEnabled'],
        _userId = json['userId'],
        _userName = json['userName'],
        _annotationManagerEditMode = json['annotationManagerEditMode'],
        _annotationManagerUndoMode = json['annotationManagerUndoMode'],
        _annotationToolbarAlignment = json['annotationToolbarAlignment'],
        _outlineListEditingEnabled = json['outlineListEditingEnabled'],
        _hideScrollbars = json['hideScrollbars'],
        _quickBookmarkCreation = json['quickBookmarkCreation'];

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
        'showDocumentSavedToast': _showDocumentSavedToast,
        'pageChangeOnTap': _pageChangeOnTap,
        'showSavedSignatures': _showSavedSignatures,
        'signaturePhotoPickerEnabled': _signaturePhotoPickerEnabled,
        'useStylusAsPen': _useStylusAsPen,
        'signSignatureFieldWithStamps': _signSignatureFieldWithStamps,
        'selectAnnotationAfterCreation': _selectAnnotationAfterCreation,
        'pageIndicatorEnabled': _pageIndicatorEnabled,
        'showQuickNavigationButton': _showQuickNavigationButton,
        'followSystemDarkMode': _followSystemDarkMode,
        'downloadDialogEnabled': _downloadDialogEnabled,
        'singleLineToolbar': _singleLineToolbar,
        'annotationToolbars': _annotationToolbars,
        'hideDefaultAnnotationToolbars': _hideDefaultAnnotationToolbars,
        'hideAnnotationToolbarSwitcher': _hideAnnotationToolbarSwitcher,
        'initialToolbar': _initialToolbar,
        'hideTopToolbars': _hideTopToolbars,
        'hideToolbarsOnTap': _hideToolbarsOnTap,
        'hideTopAppNavBar': _hideTopAppNavBar,
        'topAppNavBarRightBar': _topAppNavBarRighBar,
        'hideBottomToolbar': _hideBottomToolbar,
        'hidePresetBar': _hidePresetBar,
        'bottomToolbar': _bottomToolbar,
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
        'showNavigationListAsSidePanelOnLargeDevices':
            _showNavigationListAsSidePanelOnLargeDevices,
        'overrideBehavior': _overrideBehavior,
        'tabTitle': _tabTitle,
        'pageNumberIndicatorAlwaysVisible': _pageNumberIndicatorAlwaysVisible,
        'disableEditingByAnnotationType': _disableEditingByAnnotationType,
        'annotationsListFilterEnabled': _annotationsListFilterEnabled,
        'hideViewModeItems': _hideViewModeItems,
        'defaultEraserType': _defaultEraserType,
        'autoResizeFreeTextEnabled': _autoResizeFreeTextEnabled,
        'restrictDownloadUsage': _restrictDownloadUsage,
        'reflowOrientation': _reflowOrientation,
        'imageInReflowModeEnabled': _imageInReflowModeEnabled,
        'annotationManagerEnabled': _annotationManagerEnabled,
        'userId': _userId,
        'userName': _userName,
        'annotationManagerEditMode': _annotationManagerEditMode,
        'annotationManagerUndoMode': _annotationManagerUndoMode,
        'annotationToolbarAlignment': _annotationToolbarAlignment,
        'outlineListEditingEnabled': _outlineListEditingEnabled,
        'hideScrollbars': _hideScrollbars,
        'quickBookmarkCreation': _quickBookmarkCreation,
      };
}
