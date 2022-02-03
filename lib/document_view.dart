part of pdftron;

typedef void DocumentViewCreatedCallback(DocumentViewController controller);

/// A widget used to view documents and access features of the PDFTron SDK.
class DocumentView extends StatefulWidget {
  const DocumentView({Key? key, required this.onCreated}) : super(key: key);

  /// This function initialises the [DocumentView] widget after its creation.
  ///
  /// Within this function, the features of the PDFTron SDK are accessed.
  final DocumentViewCreatedCallback onCreated;

  @override
  State<StatefulWidget> createState() => _DocumentViewState();
}

class _DocumentViewState extends State<DocumentView> {
  @override
  Widget build(BuildContext context) {
    final String viewType = 'pdftron_flutter/documentview';

    if (Platform.isAndroid) {
      return PlatformViewLink(
          viewType: viewType,
          surfaceFactory:
              (BuildContext context, PlatformViewController controller) {
            return AndroidViewSurface(
                controller: controller as AndroidViewController,
                hitTestBehavior: PlatformViewHitTestBehavior.opaque,
                gestureRecognizers:
                    const <Factory<OneSequenceGestureRecognizer>>[].toSet());
          },
          onCreatePlatformView: (PlatformViewCreationParams params) {
            return PlatformViewsService.initSurfaceAndroidView(
              id: params.id,
              viewType: viewType,
              layoutDirection: TextDirection.ltr,
            )
              ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
              ..addOnPlatformViewCreatedListener(_onPlatformViewCreated)
              ..create();
          });
    } else if (Platform.isIOS) {
      return UiKitView(
        viewType: viewType,
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
    return Text('coming soon');
  }

  void _onPlatformViewCreated(int id) {
    if (widget.onCreated == null) {
      return;
    }
    widget.onCreated(new DocumentViewController._(id));
  }
}

/// Used to initialize and control the [DocumentView] widget.
class DocumentViewController {
  DocumentViewController._(int id)
      : _channel = new MethodChannel('pdftron_flutter/documentview_$id');

  final MethodChannel _channel;

  /// Opens a document in the viewer with configurations.
  ///
  /// Uses the path specified by [document]. Takes a [password] for
  /// encrypted documents, and viewer configuration options for customization.
  Future<void> openDocument(String document,
      {String? password, Config? config}) {
    return _channel.invokeMethod(Functions.openDocument, <String, dynamic>{
      Parameters.document: document,
      Parameters.password: password,
      Parameters.config: jsonEncode(config)
    });
  }

  /// Imports XFDF annotation string to current document.
  Future<void> importAnnotations(String xfdf) {
    return _channel.invokeMethod(
        Functions.importAnnotations, <String, dynamic>{Parameters.xfdf: xfdf});
  }

  /// Extracts XFDF annotation string from the current document.
  ///
  /// If [annotationList] is null, export all annotations from
  /// the document; else export the valid ones specified.
  Future<String?> exportAnnotations(List<Annot>? annotationList) async {
    if (annotationList == null) {
      return _channel.invokeMethod(Functions.exportAnnotations);
    } else {
      return _channel.invokeMethod(
          Functions.exportAnnotations, <String, dynamic>{
        Parameters.annotations: jsonEncode(annotationList)
      });
    }
  }

  /// Flattens the forms and (optionally) annotations in the current document.
  Future<void> flattenAnnotations(bool formsOnly) {
    return _channel.invokeMethod(Functions.flattenAnnotations,
        <String, dynamic>{Parameters.formsOnly: formsOnly});
  }

  /// Deletes the specified annotations in the current document.
  Future<void> deleteAnnotations(List<Annot> annotationList) {
    return _channel.invokeMethod(Functions.deleteAnnotations,
        <String, dynamic>{Parameters.annotations: jsonEncode(annotationList)});
  }

  /// Selects the specified annotation in the current document.
  Future<void> selectAnnotation(Annot annotation) {
    return _channel.invokeMethod(Functions.selectAnnotation,
        <String, dynamic>{Parameters.annotation: jsonEncode(annotation)});
  }

  /// Sets flags for specified annotations in the current document.
  Future<void> setFlagsForAnnotations(
      List<AnnotWithFlag> annotationWithFlagsList) {
    return _channel.invokeMethod(
        Functions.setFlagsForAnnotations, <String, dynamic>{
      Parameters.annotationsWithFlags: jsonEncode(annotationWithFlagsList)
    });
  }

  /// Sets properties for specified annotation in the current document.
  Future<void> setPropertiesForAnnotation(
      Annot annotation, AnnotProperty property) {
    return _channel
        .invokeMethod(Functions.setPropertiesForAnnotation, <String, dynamic>{
      Parameters.annotation: jsonEncode(annotation),
      Parameters.annotationProperties: jsonEncode(property),
    });
  }

  /// Groups specified annotations in the current document.
  Future<void> groupAnnotations(
      Annot primaryAnnotation, List<Annot> subAnnotations) {
    return _channel
        .invokeMethod(Functions.groupAnnotations, <String, dynamic>{
      Parameters.annotation: jsonEncode(primaryAnnotation),
      Parameters.annotations: jsonEncode(subAnnotations),
    });
  }

  /// Ungroups specified annotations in the current documen
  Future<void> ungroupAnnotations(
      List<Annot> annotations) {
    return _channel
        .invokeMethod(Functions.ungroupAnnotations, <String, dynamic>{
      Parameters.annotations: jsonEncode(annotations),
    });
  }

  /// Imports remote annotation command to local document.
  ///
  /// The XFDF needs to be in a valid command format with `<add>`
  /// `<modify>` `<delete>` tags.
  Future<void> importAnnotationCommand(String xfdfCommand) {
    return _channel.invokeMethod(Functions.importAnnotationCommand,
        <String, dynamic>{Parameters.xfdfCommand: xfdfCommand});
  }

  /// Imports user bookmarks into the document.
  ///
  /// The input needs to be in valid bookmark JSON format, for
  /// example {"0": "Page 1"}. Page numbers are 1-indexed.
  Future<void> importBookmarkJson(String bookmarkJson) {
    return _channel.invokeMethod(Functions.importBookmarkJson,
        <String, dynamic>{Parameters.bookmarkJson: bookmarkJson});
  }

  /// Creates a new bookmark with the given title and page number.
  ///
  /// [pageNumber] is 1-indexed
  Future<void> addBookmark(String title, int pageNumber) {
    return _channel.invokeMethod(Functions.addBookmark, <String, dynamic>{
      Parameters.title: title,
      Parameters.pageNumber: pageNumber
    });
  }

  /// Saves the currently opened document in the viewer.
  ///
  /// Also gets the absolute path to the document. Must only
  /// be called when the document is opened in the viewer.
  Future<String?> saveDocument() {
    return _channel.invokeMethod(Functions.saveDocument);
  }

  /// Commits the current tool.
  ///
  /// Returns true for multi-stroke ink ([Tools.annotationCreateFreeHand]) and
  /// poly-shape ([Tools.annotationCreatePolygon]).
  Future<bool?> commitTool() {
    return _channel.invokeMethod(Functions.commitTool);
  }

  /// Gets the total number of pages in the currently displayed document.
  Future<int?> getPageCount() {
    return _channel.invokeMethod(Functions.getPageCount);
  }

  /// Handles the back button in search mode.
  ///
  /// Android only.
  Future<bool?> handleBackButton() {
    return _channel.invokeMethod(Functions.handleBackButton);
  }

  /// Undo the last modification.
  Future<void> undo() {
    return _channel.invokeMethod(Functions.undo);
  }

  /// Redo the last modification.
  Future<void> redo() {
    return _channel.invokeMethod(Functions.redo);
  }

  /// Checks whether an undo operation can be performed from the current snapshot.
  Future<bool?> canUndo() {
    return _channel.invokeMethod(Functions.canUndo);
  }

  /// Checks whether a redo operation can be perfromed from the current snapshot.
  Future<bool?> canRedo() {
    return _channel.invokeMethod(Functions.canRedo);
  }

  /// Gets a map object of the crop box for the specified page.
  ///
  /// [pageNumber] is 1-indexed.
  Future<Rect> getPageCropBox(int pageNumber) async {
    String cropBoxString = await _channel.invokeMethod(Functions.getPageCropBox,
        <String, dynamic>{Parameters.pageNumber: pageNumber});
    return Rect.fromJson(jsonDecode(cropBoxString));
  }

  /// Gets the rotation value of the specified page in the current document.
  ///
  /// [pageNumber] is 1-indexed.
  Future<int> getPageRotation(int pageNumber) async {
    int pageRotation = await _channel.invokeMethod(Functions.getPageRotation,
        <String, dynamic>{Parameters.pageNumber: pageNumber});
    return pageRotation;
  }

  /// Rotates all pages in the current document in clockwise direction (by 90 degrees).
  Future<void> rotateClockwise() {
    return _channel.invokeMethod(Functions.rotateClockwise);
  }

  /// Rotates all pages in the current document in counter-clockwise direction (by 90 degrees).
  Future<void> rotateCounterClockwise() {
    return _channel.invokeMethod(Functions.rotateCounterClockwise);
  }

  /// Sets current page of the document.
  ///
  /// [pageNumber] is 1-indexed.
  Future<bool> setCurrentPage(int pageNumber) {
    return _channel.invokeMethod(Functions.setCurrentPage,
        <String, dynamic>{Parameters.pageNumber: pageNumber});
  }

  /// Returns the path of the current document.
  Future<String?> getDocumentPath() {
    return _channel.invokeMethod(Functions.getDocumentPath);
  }

  /// Sets the current tool mode.
  ///
  /// Takes a [Tools] string constant representing the tool mode to set.
  Future<void> setToolMode(String toolMode) {
    return _channel.invokeMethod(Functions.setToolMode,
        <String, dynamic>{Parameters.toolMode: toolMode});
  }

  /// Sets a field flag value on one or more form fields.
  ///
  /// The [flag] is one of the constants from [FieldFlags].
  Future<void> setFlagForFields(
      List<String> fieldNames, int flag, bool flagValue) {
    return _channel.invokeMethod(Functions.setFlagForFields, <String, dynamic>{
      Parameters.fieldNames: fieldNames,
      Parameters.flag: flag,
      Parameters.flagValue: flagValue
    });
  }

  /// Sets field values on one or more form fields of different types.
  ///
  /// Each field in [fields] list must be set with a name and a value.
  /// The value's type can be number, bool or string.
  Future<void> setValuesForFields(List<Field> fields) {
    return _channel.invokeMethod(Functions.setValuesForFields,
        <String, dynamic>{Parameters.fields: jsonEncode(fields)});
  }

  /// Sets the file name of the icon to be used for the leading navigation button.
  ///
  /// The button will use the specified icon if
  /// [Config.showLeadingNavButton] (which by
  /// default is true) is true in the config. To add the image file to your
  /// application, please follow the steps in the
  /// [API page](https://github.com/PDFTron/pdftron-flutter/blob/publish-prep-nullsafe/doc/api/API.md#viewer-ui-configuration).
  Future<void> setLeadingNavButtonIcon(String path) {
    return _channel.invokeMethod(Functions.setLeadingNavButtonIcon,
        <String, dynamic>{Parameters.leadingNavButtonIcon: path});
  }

  /// Closes all documents that are currently opened in a multiTab environment.
  ///
  /// A multiTab environment exists when [Config.multiTabEnabled]
  /// is true in the config.
  Future<void> closeAllTabs() {
    return _channel.invokeMethod(Functions.closeAllTabs);
  }

  /// Deletes all annotations in the current document, excluding links and widgets.
  Future<void> deleteAllAnnotations() {
    return _channel.invokeMethod(Functions.deleteAllAnnotations);
  }

  /// Export a PDF page to an image format defined in ExportFormat.
  /// The page is taken from the PDF at the given filepath.
  Future<String?> exportAsImage(int? pageNumber, int? dpi, String? exportFormat) {
    return _channel.invokeMethod(Functions.exportAsImage, <String, dynamic>{
      Parameters.pageNumber: pageNumber,
      Parameters.dpi: dpi,
      Parameters.exportFormat: exportFormat
    });
  }

  /// Displays the annotation tab of the existing list container.
  ///
  /// If this tab has been disabled, the method does nothing.
  Future<void> openAnnotationList() {
    return _channel.invokeMethod(Functions.openAnnotationList);
  }

  /// Displays the bookmark tab of the existing list container.
  ///
  /// If this tab has been disabled, the method does nothing.
  Future<void> openBookmarkList() {
    return _channel.invokeMethod(Functions.openBookmarkList);
  }

  /// Displays the outline tab of the existing list container.
  ///
  /// If this tab has been disabled, the method does nothing.
  Future<void> openOutlineList() {
    return _channel.invokeMethod(Functions.openOutlineList);
  }

  /// On Android it displays the layers dialog while on iOS it displays the layers tab of the existing list container.
  ///
  /// If this tab has been disabled or there are no layers in the document, the method does nothing.
  Future<void> openLayersList() {
    return _channel.invokeMethod(Functions.openLayersList);
  }

  /// This view allows users to navigate pages of a document.
  /// If thumbnailViewEditingEnabled is true, the user can also manipulate the document, including add, remove, re-arrange, rotate and duplicate pages
  Future<void> openThumbnailsView() {
    return _channel.invokeMethod(Functions.openThumbnailsView);
  }

  /// The dialog allows users to rotate pages of the opened document by 90, 180 and 270 degrees.
  /// It also displays a thumbnail of the current page at the selected rotation angle.
  ///
  /// Android only
  Future<void> openRotateDialog() {
    return _channel.invokeMethod(Functions.openRotateDialog);
  }

  /// Displays the add pages view.
  ///
  /// Requires a source rect in screen co-ordinates.
  /// On iOS this rect will be the anchor point for the view.
  /// The rect is ignored on Android.
  Future<void> openAddPagesView(Map<String, double>? sourceRect) {
    return _channel.invokeMethod(Functions.openAddPagesView,
        <String, dynamic>{Parameters.sourceRect: sourceRect});
  }

  /// Displays the view settings.
  ///
  /// Requires a source rect in screen co-ordinates.
  /// On iOS this rect will be the anchor point for the view.
  /// The rect is ignored on Android.
  Future<void> openViewSettings(Map<String, double>? sourceRect) {
    return _channel.invokeMethod(Functions.openViewSettings,
        <String, dynamic>{Parameters.sourceRect: sourceRect});
  }

  /// Displays the page crop options dialog.
  Future<void> openCrop() {
    return _channel.invokeMethod(Functions.openCrop);
  }

  /// Displays the manual page crop dialog.
  Future<void> openManualCrop() {
    return _channel.invokeMethod(Functions.openManualCrop);
  }

  /// Displays a search bar that allows the user to enter and search text within a document.
  Future<void> openSearch() {
    return _channel.invokeMethod(Functions.openSearch);
  }

  /// Opens the tab switcher in a multi-tab environment.
  Future<void> openTabSwitcher() {
    return _channel.invokeMethod(Functions.openTabSwitcher);
  }

  /// Opens a go-to page dialog. If the user inputs a valid page number into the dialog, the viewer will go to that page.
  Future<void> openGoToPageView() {
    return _channel.invokeMethod(Functions.openGoToPageView);
  }

  /// Displays the existing list container.
  ///
  /// Its current tab will be the one last opened.
  Future<void> openNavigationLists() {
    return _channel.invokeMethod(Functions.openNavigationLists);
  }

  /// Go to the previous page of the document.
  ///
  /// If on first page, it will stay on first page.
  Future<bool?> gotoPreviousPage() {
    return _channel.invokeMethod(Functions.gotoPreviousPage);
  }

  /// Go to the next page of the document.
  ///
  /// If on last page, it will stay on last page.
  Future<bool?> gotoNextPage() {
    return _channel.invokeMethod(Functions.gotoNextPage);
  }

  /// Go to the first page of the document.
  Future<bool?> gotoFirstPage() {
    return _channel.invokeMethod(Functions.gotoFirstPage);
  }

  /// Go to the last page of the document.
  Future<bool?> gotoLastPage() {
    return _channel.invokeMethod(Functions.gotoLastPage);
  }

  /// Gets the current page of the document.
  ///
  /// The page numbers returned are 1-indexed.
  Future<int?> getCurrentPage() {
    return _channel.invokeMethod(Functions.getCurrentPage);
  }
}
