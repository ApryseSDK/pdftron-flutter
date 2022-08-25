import '../pdftron_flutter.dart';

/// A class to contain the viewer configuration options.
///
/// The class properties represent all possible viewer configuration options.
/// These options are not required and have default values. For more information on
/// these configurations, look at the [GitHub API documentation](https://github.com/PDFTron/pdftron-flutter/blob/publish-prep-nullsafe/doc/api/API.md).
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
  var _signatureTypingEnabled;
  var _signatureDrawingEnabled;
  var _useStylusAsPen;
  var _signSignatureFieldWithStamps;
  var _signatureColors;
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
  var _fullScreenModeEnabled;

  // Hygen Generated Configs (1)
  var _maxSignatureCount;

  Config();

  /// A list of [Buttons] that will be disabled in the viewer.
  ///
  /// Defaults to empty.
  set disabledElements(List value) => _disabledElements = value;

  /// A list of [Tools] that will be disabled in the viewer.
  ///
  /// Defaults to empty.
  set disabledTools(List value) => _disabledTools = value;

  /// Whether tabs will be used to facilitate the viewing of multiple documents
  /// simultaneously.
  ///
  /// If this value is true and [PdftronFlutter.openDocument(document)] is called, it
  /// will open a new tab with the associated document. Defaults to false.
  set multiTabEnabled(bool value) => _multiTabEnabled = value;

  /// The custom headers to use with HTTP/HTTPS requests.
  ///
  /// Defaults to empty.
  set customHeaders(Map<String, String> value) => _customHeaders = value;

  /// The default zoom level of the viewer.
  ///
  /// Can be set with one of the [FitModes] constants. Defaults to [FitModes.fitWidth].
  set fitMode(String value) => _fitMode = value;

  /// The layout mode of the viewer.
  ///
  /// Can be set with one of the [LayoutModes] constants. Defaults to
  /// [LayoutModes.continuous].
  set layoutMode(String value) => _layoutMode = value;

  /// Defines whether the tablet layout should be used on tablets. Otherwise uses the same layout as phones.
  ///
  /// Defaults to true.
  set tabletLayoutEnabled(bool value) => _tabletLayoutEnabled = value;

  /// The initial page number upon opening a document.
  ///
  /// Page numbers are 1-indexed.
  set initialPageNumber(int value) => _initialPageNumber = value;

  /// Whether to treat the document in [PdftronFlutter.openDocument(document)] as a base64 string.
  ///
  /// Defaults to false.
  set isBase64String(bool value) => _isBase64String = value;

  /// If _isBase64String is true, it defines the file extension to use.
  ///
  /// Defaults to ".pdf" but is required if using the base64 string of a non-pdf file.
  set base64FileExtension(String value) => _base64FileExtension = value;

  /// A list of [ThumbnailFilterModes] that will be hidden in the thumbnails browser.
  ///
  /// Defaults to empty.
  set hideThumbnailFilterModes(List value) => _hideThumbnailFilterModes = value;

  /// Whether to show a popup menu after the user long presses on text or blank space.
  ///
  /// Defaults to true.
  set longPressMenuEnabled(bool value) => _longPressMenuEnabled = value;

  /// A list of [LongPressMenuItems] that can be shown after long pressing on text
  /// or blank space.
  ///
  /// Defaults to all of [LongPressMenuItems].
  set longPressMenuItems(List value) => _longPressMenuItems = value;

  /// The long press menu items that will skip default beahaviour when pressed.
  ///
  /// These menu items will still be displayed in the long press menu.
  /// The new behaviour is defined in the [startLongPressMenuPressedListener()].
  /// Defaults to empty.
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

  /// A list of [AnnotationMenuItems] that will skip default behaviour when pressed.
  ///
  /// These menu items will still be displayed in the annotation menu.
  /// The new behaviour will be defined in the [startAnnotationMenuPressedListener()].
  /// Defaults to empty.
  set overrideAnnotationMenuBehavior(List value) =>
      _overrideAnnotationMenuBehavior = value;

  /// Defines types to be excluded from the annotation list
  ///
  /// Defaults to none
  set excludedAnnotationListTypes(List value) =>
      _excludedAnnotationListTypes = value;

  /// Where a file is saved when using actions such as: "save a password copy",
  /// "save a flattened copy", etc.
  ///
  /// Defaults to null.
  set exportPath(String value) => _exportPath = value;

  /// Where a cache file is saved when opening files from HTTPS.
  ///
  /// Defaults to null.
  set openUrlPath(String value) => _openUrlPath = value;

  ///Sets whether the new saved file should open after saving
  ///
  /// Deafaults to true
  set openSavedCopyInNewTab(bool value) => _openSavedCopyInNewTab = value;

  ///Sets the limit on the maximum number of tabs that the viewer could have at a time.
  ///Open more documents after reaching this limit will overwrite the old tabs.
  ///
  /// Defaults to unlimited
  set maxTabCount(int value) => _maxTabCount = value;

  /// Whether the document is automatically saved.
  ///
  /// Defaults to true.
  set autoSaveEnabled(bool value) => _autoSaveEnabled = value;

  /// Defines whether a toast indicating that the document has been successfully or unsuccessfully saved will appear.
  ///
  /// Defaults to true
  set showDocumentSavedToast(bool value) => _showDocumentSavedToast = value;

  /// If in a horizontal viewing mode, whether the viewer changes pages when a users
  /// taps the page's edge.
  ///
  /// Defaults to true.
  set pageChangeOnTap(bool value) => _pageChangeOnTap = value;

  /// Whether to show saved signatures for re-use.
  ///
  /// Defaults to true.
  set showSavedSignatures(bool value) => _showSavedSignatures = value;

  /// Defines whether to show the option to pick images in the signature dialog
  ///
  /// Defaults to true
  set signaturePhotoPickerEnabled(bool value) =>
      _signaturePhotoPickerEnabled = value;

  /// Defines whether to enable typing to create a new signature
  ///
  /// Defaults to true.
  set signatureTypingEnabled(bool value) => _signatureTypingEnabled = value;

  /// Defines whether to enable drawing to create a new signature.
  ///
  /// iOS only. Defaults to true.
  set signatureDrawingEnabled(bool value) => _signatureDrawingEnabled = value;

  /// Whether a stylus should act like a pen when the viewer is in pan mode.
  ///
  /// If false, it will act like a finger. Defaults to true.
  set useStylusAsPen(bool value) => _useStylusAsPen;

  /// Whether signature fields will be signed with image stamps.
  ///
  /// Defaults to false.
  set signSignatureFieldWithStamps(bool value) =>
      _signSignatureFieldWithStamps = value;

  /// A list of colors that the user can select to create a signature.
  ///
  /// ```dart
  /// config.signatureColors = [
  ///   { 'red': 255, 'green': 0, 'blue': 0 },
  ///   { 'red':   0, 'green': 0, 'blue': 0 }
  /// ];
  /// ```
  ///
  /// Each color is given by a `Map<String, int>` containing RGB values, with a
  /// maximum of three colors. On Android, when this config is set, the user
  /// will not be able to customize each color shown. Defaults to black, blue,
  /// green for Android, and black, blue, red for iOS.
  set signatureColors(List value) => _signatureColors = value;

  /// Whether the annotation is selected after creation.
  ///
  /// On iOS, this functions for shape and text markup only. Defaults to true.
  set selectAnnotationAfterCreation(bool value) =>
      _selectAnnotationAfterCreation = value;

  /// Whehter to show the page indicator.
  ///
  /// Defaults to true.
  set pageIndicatorEnabled(bool value) => _pageIndicatorEnabled = value;

  /// Defines whether the quick navigation buttons will appear in the viewer.
  ///
  /// Defaults to true.
  set showQuickNavigationButton(bool value) =>
      _showQuickNavigationButton = value;

  /// If the system is in dark mode, whether to have the UI will appear in a dark color.
  ///
  /// Android only. Defaults to true.
  set followSystemDarkMode(bool value) => _followSystemDarkMode = value;

  /// Defines whether the download dialog should be shown.
  ///
  /// Defaults to true.
  set downloadDialogEnabled(bool value) => _downloadDialogEnabled = value;

  set singleLineToolbar(bool value) => _singleLineToolbar = value;

  /// A list of [CustomToolbar] objects or [DefaultToolbars] constants that define
  /// a set of annotation toolbars.
  ///
  /// ```dart
  /// var customToolItem = new CustomToolbarItem('add_page', 'Add Page', 'ic_add_blank_page_white');
  /// var customToolbar = new CustomToolbar('myToolbar', 'myToolbar', [Tools.annotationCreateArrow, customToolItem], ToolbarIcons.favorite);
  ///
  /// config.annotationToolbars = [DefaultToolbars.annotate, customToolbar];
  /// ```
  ///
  /// If used, the default toolbars no longer show. Defaults to empty.
  set annotationToolbars(List value) => _annotationToolbars = value;

  /// A list of [DefaultToolbars] that defines the default annotation toolbars to hide
  ///
  /// It should not be used in conjunction with [annotationToolbars]. Defaults to empty.
  set hideDefaultAnnotationToolbars(List value) =>
      _hideDefaultAnnotationToolbars = value;

  /// Whether to show the toolbar switcher in the top toolbar.
  ///
  /// Defaults to false.
  set hideAnnotationToolbarSwitcher(bool value) =>
      _hideAnnotationToolbarSwitcher = value;

  /// Defines which annotationToolbar should be selected when the document is opened.
  ///
  /// Defaults to none
  set initialToolbar(String value) => _initialToolbar = value;

  /// Whether to hide both the top app navigation bar and the annotation toolbar.
  ///
  /// Defaults to false.
  set hideTopToolbars(bool value) => _hideTopToolbars = value;

  /// Defines whether an unhandled tap in the viewer should toggle the visibility of the top and bottom toolbars.
  /// When false, the top and bottom toolbar visibility will not be toggled and the page content will fit between the bars, if any.
  ///
  /// Defaults to true
  set hideToolbarsOnTap(bool value) => _hideToolbarsOnTap = value;

  /// Whether to hide the top app navigation bar.
  ///
  /// Defaults to false.
  set hideTopAppNavBar(bool value) => _hideTopAppNavBar = value;

  /// Customizes the right bar section of the top app nav bar.
  /// If passed in, the default right bar section will not be used.
  ///
  /// iOS only
  set topAppNavBarRightBar(List value) => _topAppNavBarRighBar = value;

  /// Whether to hide the bottom toolbar for the current viewer.
  ///
  /// Defaults to false.
  set hideBottomToolbar(bool value) => _hideBottomToolbar = value;

  /// Defines whether to hide the preset bar for the current viewer.
  ///
  /// Defaults to false
  set hidePresetBar(bool value) => _hidePresetBar = value;

  /// Defines a custom bottom toolbar.
  /// If passed in, the default bottom toolbar will not be used.
  set bottomToolbar(List value) => _bottomToolbar = value;

  /// Whether to show the leading navigation button.
  ///
  /// Defaults to true.
  set showLeadingNavButton(bool value) => _showLeadingNavButton = value;

  /// Defines whether the document slider of the viewer is enabled.
  ///
  /// Defaults to true
  set documentSliderEnabled(bool value) => _documentSliderEnabled = value;

  /// Defines whether the last tool used in the current viewer session will be the tool selected upon starting a new viewer session.
  ///
  /// Deafults to true. Android only
  set rememberLastUsedTool(bool value) => _rememberLastUsedTool = value;

  /// Whether the viewer allows users to edit the document.
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
  /// When the xfdfCommand is exported, this information is included.
  set annotationAuthor(String value) => _annotationAuthor = value;

  /// Whether the active annotation creation tool will remain the current annotation
  /// tool.
  ///
  /// Defaults to true.
  set continuousAnnotationEditing(bool value) =>
      _continuousAnnotationEditing = value;

  /// Whether the annotation's flags will be considered upon its selection.
  ///
  /// E.g. An annotation with a locked flag cannot be resized or moved.
  ///
  /// Defaults to false.
  set annotationPermissionCheckEnabled(bool value) =>
      _annotationPermissionCheckEnabled = value;

  /// If document editing is enabled, then this value determines if the annotation list is editable.
  ///
  /// Defaults to true
  set annotationsListEditingEnabled(bool value) =>
      _annotationsListEditingEnabled = value;

  ///Defines whether the bookmark list can be edited.
  /// If the viewer is readonly then bookmarks on Android are still editable but are saved to the device rather than the PDF.
  ///
  /// Defaults to true
  set userBookmarksListEditingEnabled(bool value) =>
      _userBookmarksListEditingEnabled = value;

  /// Defines whether the outline list can be edited.
  ///
  /// Defaults to true
  set outlineListEditingEnabled(bool value) =>
      _outlineListEditingEnabled = value;

  /// Defines whether the navigation list will be displayed as a side panel on large devices such as iPads and tablets.
  ///
  /// Defaults to true
  set showNavigationListAsSidePanelOnLargeDevices(bool value) =>
      _showNavigationListAsSidePanelOnLargeDevices = value;

  /// A list of [Behaviors] that can skip their default behaviour e.g. external link clicking.
  ///
  /// The new behaviour will be defined in [startBehaviorActivatedListener()].
  /// Defaults to empty.
  set overrideBehavior(List<String> value) => _overrideBehavior = value;

  /// If [multiTabEnabled] is true, sets the tab title.
  ///
  /// For Android, it is only supported on the [DocumentView] widget.
  /// Defaults to the file name.
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

  /// Defines whether filtering the annotation list is possible.
  ///
  /// Defaults to true. Android only
  set annotationsListFilterEnabled(bool value) =>
      _annotationsListFilterEnabled = value;

  /// A list of [ViewModePickerItem] constants that defines which view mode items to be
  /// hidden in the view mode dialog.
  ///
  /// Defaults to empty.
  set hideViewModeItems(List value) => _hideViewModeItems = value;

  /// Sets the default eraser tool type.
  ///
  /// Value only applied after a clean install.
  set defaultEraserType(String value) => _defaultEraserType = value;

  /// Defines whether to automatically resize the bounding box of free text annotations when editing.
  ///
  /// Defaults to false
  set autoResizeFreeTextEnabled(bool value) =>
      _autoResizeFreeTextEnabled = value;

  /// Defines whether to restrict data usage when viewing online PDFs.
  ///
  /// Defaults to false
  set restrictDownloadUsage(bool value) => _restrictDownloadUsage = value;

  /// Sets the scrolling direction of the reflow control.
  ///
  /// one of ReflowOrientation constants, defaults to the viewer's scroll direction.
  set reflowOrientation(String value) => _reflowOrientation = value;

  /// Whether to show images in reflow mode.
  ///
  /// Defaults to true
  set imageInReflowModeEnabled(bool value) => _imageInReflowModeEnabled = value;

  /// Defines whether the annotation manager is enabled.
  ///
  /// Defaults to false
  set annotationManagerEnabled(bool value) => _annotationManagerEnabled = value;

  /// The unique identifier of the current user.
  set userId(String value) => _userId = value;

  /// The name of the current user. Used in the annotation manager when annotationManagerEnabled is true.
  ///
  /// Android only
  set userName(String value) => _userName = value;

  /// Sets annotation manager edit mode when annotationManagerEnabled is true and userId is not null.
  ///
  /// Defaults to AnnotationManagerEditMode.All
  set annotationManagerEditMode(String value) =>
      _annotationManagerEditMode = value;

  /// Sets annotation manager undo mode when annotationManagerEnabled is true and userId is not null.
  ///
  /// Defaults to AnnotationManagerUndoMode.All
  set annotationManagerUndoMode(String value) =>
      _annotationManagerUndoMode = value;

  /// Customizes the alignment of the annotation toolbars.
  ///
  /// one of ToolbarAlignment.Start or ToolbarAlignment.End
  set annotationToolbarAlignment(String value) =>
      _annotationToolbarAlignment = value;

  /// bool, optional, iOS only, defaults to false
  ///
  /// Determines whether scrollbars will be hidden on the viewer.
  set hideScrollbars(bool value) => _hideScrollbars = value;
  /// Sets the bookmark creation as a part of the toolbar
  ///
  /// Defaults to false
  set quickBookmarkCreation(bool value) => _quickBookmarkCreation = value;

  /// Whether to enable the viewer's full screen mode.
  ///
  /// Defaults to false. Android only.
  set fullScreenModeEnabled(bool value) => _fullScreenModeEnabled = value;

  // Hygen Generated Configs (2)
  /// The maximum number of saved signatures that can be created for a document.
  ///
  /// Defaults to unlimited.
  set maxSignatureCount(int value) => _maxSignatureCount = value;

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
        _signatureTypingEnabled = json['signatureTypingEnabled'],
        _signatureDrawingEnabled = json['signatureDrawingEnabled'],
        _useStylusAsPen = json['useStylusAsPen'],
        _signSignatureFieldWithStamps = json['signSignatureFieldWithStamps'],
        _signatureColors = json['signatureColors'],
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
        _quickBookmarkCreation = json['quickBookmarkCreation'],

        // Hygen Generated Configs (3)
        _maxSignatureCount = json['maxSignatureCount'],

        _fullScreenModeEnabled = json['fullScreenModeEnabled'];

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
        'signatureTypingEnabled': _signatureTypingEnabled,
        'signatureDrawingEnabled': _signatureDrawingEnabled,
        'useStylusAsPen': _useStylusAsPen,
        'signSignatureFieldWithStamps': _signSignatureFieldWithStamps,
        'signatureColors': _signatureColors,
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
        'fullScreenModeEnabled': _fullScreenModeEnabled,

        // Hygen Generated Configs (4)
        'maxSignatureCount': _maxSignatureCount,
      };
}
