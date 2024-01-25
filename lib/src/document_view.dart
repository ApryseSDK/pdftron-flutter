import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

import '../pdftron_flutter.dart';

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
    widget.onCreated(new DocumentViewController(id));
  }
}

/// Used to initialize and control the [DocumentView] widget.
class DocumentViewController {
  DocumentViewController(int id)
      : _channel = new MethodChannel('pdftron_flutter/documentview_$id');

  final MethodChannel _channel;

  /// Opens a document in the viewer with configurations.
  ///
  /// Uses the path specified by [document]. Takes a [password] for
  /// encrypted documents, and [config] for viewer customization.
  Future<void> openDocument(String document,
      {String? password, Config? config}) {
    return _channel.invokeMethod(Functions.openDocument, <String, dynamic>{
      Parameters.document: document,
      Parameters.password: password,
      Parameters.config: jsonEncode(config)
    });
  }

  /// Imports the given XFDF annotation string to the current document.
  Future<void> importAnnotations(String xfdf) {
    return _channel.invokeMethod(
        Functions.importAnnotations, <String, dynamic>{Parameters.xfdf: xfdf});
  }

  /// Merges the given XFDF annotation string to the current document.
  Future<void> mergeAnnotations(String xfdf) {
    return _channel.invokeMethod(
        Functions.mergeAnnotations, <String, dynamic>{Parameters.xfdf: xfdf});
  }

  /// Exports the specified annotations in the current document as a XFDF annotation string.
  ///
  /// ```dart
  /// List<Annot> annotList = new List<Annot>.empty(growable: true);
  /// annotList.add(new Annot('Hello', 1));
  /// annotList.add(new Annot('World', 2));
  ///
  /// var xfdf = await controller.exportAnnotations(annotList);
  /// ```
  ///
  /// If [annotationList] is null, exports all annotations from
  /// the current document; else exports the valid ones specified.
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
  ///
  /// ```dart
  /// List<Annot> annotList = new List<Annot>.empty(growable: true);
  /// annotList.add(new Annot('Hello', 1));
  /// annotList.add(new Annot('World', 2));
  ///
  /// await controller.deleteAnnotations(annotList);
  /// ```
  Future<void> deleteAnnotations(List<Annot> annotationList) {
    return _channel.invokeMethod(Functions.deleteAnnotations,
        <String, dynamic>{Parameters.annotations: jsonEncode(annotationList)});
  }

  /// Selects the specified annotation in the current document.
  ///
  /// ```dart
  /// await controller.selectAnnotation(new Annot('Hello', 1));
  /// ```
  Future<void> selectAnnotation(Annot annotation) {
    return _channel.invokeMethod(Functions.selectAnnotation,
        <String, dynamic>{Parameters.annotation: jsonEncode(annotation)});
  }

  /// Sets flags for the specified annotations in the current document.
  ///
  /// ```dart
  /// List<AnnotWithFlags> annotsWithFlags = new List<AnnotWithFlags>.empty(growable: true);
  ///
  /// Annot hello = new Annot('Hello', 1);
  /// Annot world = new Annot('World', 3);
  /// AnnotFlag printOn = new AnnotFlag(AnnotationFlags.print, true);
  /// AnnotFlag unlock = new AnnotFlag(AnnotationFlags.locked, false);
  ///
  /// // You can add an AnnotWithFlags object flexibly like this:
  /// annotWithFlags.add(new AnnotWithFlags.fromAnnotAndFlags(hello, [printOn, unlock]));
  /// annotWithFlags.add(new AnnotWithFlags.fromAnnotAndFlags(world, [unlock]));
  ///
  /// // Or simply use the constructor like this:
  /// annotsWithFlags.add(new AnnotWithFlags('Pdftron', 10, AnnotationFlags.noZoom, true));
  /// await controller.setFlagsForAnnotations(annotsWithFlags);
  /// ```
  Future<void> setFlagsForAnnotations(
      List<AnnotWithFlag> annotationWithFlagsList) {
    return _channel.invokeMethod(
        Functions.setFlagsForAnnotations, <String, dynamic>{
      Parameters.annotationsWithFlags: jsonEncode(annotationWithFlagsList)
    });
  }

  /// Sets properties for the specified annotation in the current document.
  ///
  /// ```dart
  /// Annot pdf = new Annot('pdf', 1);
  /// AnnotProperty property = new AnnotProperty();
  ///
  /// property.rect = new Rect.fromCoordinates(1, 1.5, 100.2, 100);
  /// property.contents = 'Hello World';
  /// property.subject = 'sample';
  /// property.title = 'set-props-for-annot';
  /// property.rotation = 90;
  ///
  /// await controller.setPropertiesForAnnotation(pdf, property);
  /// ```
  Future<void> setPropertiesForAnnotation(
      Annot annotation, AnnotProperty property) {
    return _channel
        .invokeMethod(Functions.setPropertiesForAnnotation, <String, dynamic>{
      Parameters.annotation: jsonEncode(annotation),
      Parameters.annotationProperties: jsonEncode(property),
    });
  }

  /// Groups the specified annotations in the current document.
  ///
  /// ```dart
  /// Annot primaryAnnotation = new Annot(_id1, 1);
  ///
  /// List<Annot> subAnnotations = new List<Annot>();
  /// subAnnotations.add(new Annot(_id2, 1));
  /// subAnnotations.add(new Annot(_id3, 1));
  ///
  /// await controller.groupAnnotations(primaryAnnotation, subAnnotations);
  /// ```
  Future<void> groupAnnotations(
      Annot primaryAnnotation, List<Annot>? subAnnotations) {
    return _channel.invokeMethod(Functions.groupAnnotations, <String, dynamic>{
      Parameters.annotation: jsonEncode(primaryAnnotation),
      Parameters.annotations: jsonEncode(subAnnotations),
    });
  }

  /// Ungroups the specified annotations in the current document.
  ///
  /// ```dart
  /// List<Annot> annotations = new List<Annot>();
  /// annotations.add(new Annot(_id1, 1));
  /// annotations.add(new Annot(_id2, 1));
  ///
  /// await controller.ungroupAnnotations(annotations);
  /// ```
  Future<void> ungroupAnnotations(List<Annot>? annotations) {
    return _channel
        .invokeMethod(Functions.ungroupAnnotations, <String, dynamic>{
      Parameters.annotations: jsonEncode(annotations),
    });
  }

  /// Imports remote annotation command to the local document.
  ///
  /// The XFDF needs to be in a valid command format with `<add>`
  /// `<modify>` `<delete>` tags.
  Future<void> importAnnotationCommand(String xfdfCommand) {
    return _channel.invokeMethod(Functions.importAnnotationCommand,
        <String, dynamic>{Parameters.xfdfCommand: xfdfCommand});
  }

  /// Imports user bookmarks into the document.
  ///
  /// ```dart
  /// await controller.importBookmarkJson('{"0": "Page 1", "3": "Page 4"}');
  /// ```
  ///
  /// [bookmarkJson] needs to be in valid bookmark JSON format, for
  /// example {"0": "Page 1"}. Page numbers are 1-indexed.
  Future<void> importBookmarkJson(String bookmarkJson) {
    return _channel.invokeMethod(Functions.importBookmarkJson,
        <String, dynamic>{Parameters.bookmarkJson: bookmarkJson});
  }

  /// Creates a new bookmark with the given title and page number.
  ///
  /// [pageNumber] is 1-indexed.
  Future<void> addBookmark(String title, int pageNumber) {
    return _channel.invokeMethod(Functions.addBookmark, <String, dynamic>{
      Parameters.title: title,
      Parameters.pageNumber: pageNumber
    });
  }

  /// Saves the current document and returns the absolute path to the file.
  ///
  /// Must only be called when a document is open in the viewer.
  Future<String?> saveDocument() {
    return _channel.invokeMethod(Functions.saveDocument);
  }

  /// Commits the current tool.
  ///
  /// Only available for multi-stroke ink ([Tools.annotationCreateFreeHand]) and
  /// poly-shape ([Tools.annotationCreatePolygon]). Returns true if either of
  /// the two is committed, false otherwise.
  Future<bool?> commitTool() {
    return _channel.invokeMethod(Functions.commitTool);
  }

  /// Gets the total number of pages in the currently displayed document.
  Future<int?> getPageCount() {
    return _channel.invokeMethod(Functions.getPageCount);
  }

  /// Handles the back button in search mode.
  ///
  /// Returns true if the back button is handled successfully. Android only.
  Future<bool?> handleBackButton() {
    return _channel.invokeMethod(Functions.handleBackButton);
  }

  /// Undoes the last modification.
  Future<void> undo() {
    return _channel.invokeMethod(Functions.undo);
  }

  /// Redoes the last modification.
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

  /// Gets a [Rect] object of the crop box for the specified page.
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

  /// Rotates all pages in the current document in a clockwise direction by 90 degrees.
  Future<void> rotateClockwise() {
    return _channel.invokeMethod(Functions.rotateClockwise);
  }

  /// Rotates all pages in the current document in a counter-clockwise direction by 90 degrees.
  Future<void> rotateCounterClockwise() {
    return _channel.invokeMethod(Functions.rotateCounterClockwise);
  }

  /// Sets the current page of the document to the given page number.
  ///
  /// [pageNumber] is 1-indexed. Returns true if the setting is successful.
  Future<bool?> setCurrentPage(int pageNumber) {
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

  /// Sets the value of the given [flag] to [flagValue] on the given form fields.
  ///
  /// ```dart
  /// await controller.setFlagForFields(['First Name', 'Last Name'], FieldFlags.Required, true);
  /// ```
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

  /// Sets the field value of the given form fields.
  ///
  /// ```dart
  /// await controller.setValuesForFields([
  ///   new Field('textField1', "Pdftron"),
  ///   new Field('textField2', 12.34),
  ///   new Field('checkboxField1', true),
  ///   new Field('checkboxField2', false),
  ///   new Field('radioField', "Yes"),
  ///   new Field('choiceField', "No")
  /// ]);
  /// ```
  ///
  /// Each [Field] object in [fields] must be set with a name and a value.
  /// The value's type can be number, bool, or string.
  Future<void> setValuesForFields(List<Field> fields) {
    return _channel.invokeMethod(Functions.setValuesForFields,
        <String, dynamic>{Parameters.fields: jsonEncode(fields)});
  }

  /// Sets the icon of the leading navigation button.
  ///
  /// ```dart
  /// await controller.setLeadingNavButtonIcon(Platform.isIOS ? 'ic_close_black_24px.png' : 'ic_arrow_back_white_24dp');
  /// ```
  ///
  /// [path] specifies the file name of the image resource. The button will use
  /// the specified icon if [Config.showLeadingNavButton], which is true by
  /// default, is true in the config. To add an image file to your application,
  /// please follow the steps in the [wiki page](https://github.com/PDFTron/pdftron-flutter/wiki/Adding-an-Image-Resource-To-Your-Application).
  Future<void> setLeadingNavButtonIcon(String path) {
    return _channel.invokeMethod(Functions.setLeadingNavButtonIcon,
        <String, dynamic>{Parameters.leadingNavButtonIcon: path});
  }

  /// Closes all documents that are currently open in a multi-tab environment.
  ///
  /// A multi-tab environment exists when [Config.multiTabEnabled] is true in
  /// the config.
  Future<void> closeAllTabs() {
    return _channel.invokeMethod(Functions.closeAllTabs);
  }

  /// Deletes all annotations in the current document, excluding links and widgets.
  Future<void> deleteAllAnnotations() {
    return _channel.invokeMethod(Functions.deleteAllAnnotations);
  }

  /// Exports the specified page to an image format defined by [exportFormat].
  ///
  /// ```dart
  /// var resultImagePath = await PdftronFlutter.exportAsImage(1, 92, ExportFormat.BMP);
  /// ```
  ///
  /// Returns the absolute path to the resulting image.
  /// [pageNumber] is 1-indexed, and the page is taken from the currently open
  /// document in the viewer. The image's resolution is determined by the value
  /// of [dpi]. [exportFormat] is given as one of the [ExportFormat] constants.
  Future<String?> exportAsImage(
      int? pageNumber, int? dpi, String? exportFormat) {
    return _channel.invokeMethod(Functions.exportAsImage, <String, dynamic>{
      Parameters.pageNumber: pageNumber,
      Parameters.dpi: dpi,
      Parameters.exportFormat: exportFormat
    });
  }

  /// Exports the specified page to an image format defined by [exportFormat].
  ///
  /// ```dart
  /// var resultImagePath = await PdftronFlutter.exportAsImage(1, 92, ExportFormat.BMP, "/sdcard/Download/red.pdf");
  /// ```
  ///
  /// Returns the absolute path to the resulting image.
  /// [pageNumber] is 1-indexed, and the page is taken from the PDF file at the
  /// given [filePath]. The image's resolution is determined by the value of
  /// [dpi]. [exportFormat] is given as one of the [ExportFormat] constants.
  Future<String?> exportAsImageFromFilePath(
      int? pageNumber, int? dpi, String? exportFormat, String? filePath) {
    return _channel
        .invokeMethod(Functions.exportAsImageFromFilePath, <String, dynamic>{
      Parameters.pageNumber: pageNumber,
      Parameters.dpi: dpi,
      Parameters.exportFormat: exportFormat,
      Parameters.path: filePath
    });
  }

  /// Displays the Annotation tab of the existing list container.
  ///
  /// If this tab has been disabled, this method does nothing.
  Future<void> openAnnotationList() {
    return _channel.invokeMethod(Functions.openAnnotationList);
  }

  /// Displays the Bookmark tab of the existing list container.
  ///
  /// If this tab has been disabled, this method does nothing.
  Future<void> openBookmarkList() {
    return _channel.invokeMethod(Functions.openBookmarkList);
  }

  /// Displays the Outline tab of the existing list container.
  ///
  /// If this tab has been disabled, this method does nothing.
  Future<void> openOutlineList() {
    return _channel.invokeMethod(Functions.openOutlineList);
  }

  /// Displays the Layers dialog on Android, or the Layers tab of the existing
  /// list container on iOS.
  ///
  /// If this tab has been disabled or there are no layers in the document, this
  /// method does nothing.
  Future<void> openLayersList() {
    return _channel.invokeMethod(Functions.openLayersList);
  }

  /// Displays the Thumbnails view.
  ///
  /// This view allows users to navigate pages of a document. If
  /// [Config.thumbnailViewEditingEnabled] is true, the user can also manipulate
  /// the document, including adding, removing, re-arranging, rotating and
  /// duplicating pages.
  Future<void> openThumbnailsView() {
    return _channel.invokeMethod(Functions.openThumbnailsView);
  }

  /// Displays the Rotate dialog.
  ///
  /// This dialog allows users to rotate pages of the open document by 90, 180,
  /// or 270 degrees. It also displays a thumbnail of the current page at the
  /// selected rotation angle. Android only.
  Future<void> openRotateDialog() {
    return _channel.invokeMethod(Functions.openRotateDialog);
  }

  /// Displays the Add Pages view.
  ///
  /// ```dart
  /// await controller.openAddPagesView({'x1': 10.0, 'y1': 10.0, 'x2': 20.0, 'y2': 20.0});
  /// ```
  ///
  /// Requires a source rect in screen coordinates. On iOS, this rect will be
  /// the anchor point for the view. The rect is ignored on Android.
  Future<void> openAddPagesView(Map<String, double>? sourceRect) {
    return _channel.invokeMethod(Functions.openAddPagesView,
        <String, dynamic>{Parameters.sourceRect: sourceRect});
  }

  /// Displays the view settings.
  ///
  /// ```dart
  /// await PdftronFlutter.openViewSettings({'x1': 10.0, 'y1': 10.0, 'x2': 20.0, 'y2': 20.0});
  /// ```
  ///
  /// Requires a source rect in screen coordinates. On iOS, this rect will be
  /// the anchor point for the view. The rect is ignored on Android.
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

  /// Opens a go-to page dialog.
  ///
  /// If the user inputs a valid page number into the dialog, the viewer will go to that page.
  Future<void> openGoToPageView() {
    return _channel.invokeMethod(Functions.openGoToPageView);
  }

  /// Displays the existing list container.
  ///
  /// Its current tab will be the one that was last opened.
  Future<void> openNavigationLists() {
    return _channel.invokeMethod(Functions.openNavigationLists);
  }

  /// Goes to the previous page of the document.
  ///
  /// If on the first page, it will stay on the first page. Returns true if the
  /// action was successful; no change due to being on the first page counts as
  /// being successful.
  Future<bool?> gotoPreviousPage() {
    return _channel.invokeMethod(Functions.gotoPreviousPage);
  }

  /// Goes to the next page of the document.
  ///
  /// If on the last page, it will stay on the last page. Returns true if the
  /// action was successful; no change due to being on the last page counts as
  /// being successful.
  Future<bool?> gotoNextPage() {
    return _channel.invokeMethod(Functions.gotoNextPage);
  }

  /// Goes to the first page of the document.
  Future<bool?> gotoFirstPage() {
    return _channel.invokeMethod(Functions.gotoFirstPage);
  }

  /// Goes to the last page of the document.
  Future<bool?> gotoLastPage() {
    return _channel.invokeMethod(Functions.gotoLastPage);
  }

  /// Gets the current page of the document.
  ///
  /// The page number returned is 1-indexed.
  Future<int?> getCurrentPage() {
    return _channel.invokeMethod(Functions.getCurrentPage);
  }

  /// Starts the search mode.
  ///
  /// Searches the document for [searchString] and highlights matches. The search
  /// is case-sensitive if [matchCase] is true, and only whole words are matched
  /// if [matchWholeWord] is true.
  Future<void> startSearchMode(
      String searchString, bool matchCase, bool matchWholeWord) {
    return _channel.invokeMethod(Functions.startSearchMode, <String, dynamic>{
      Parameters.searchString: searchString,
      Parameters.matchCase: matchCase,
      Parameters.matchWholeWord: matchWholeWord
    });
  }

  /// Exits the search mode.
  Future<void> exitSearchMode() {
    return _channel.invokeMethod(Functions.exitSearchMode);
  }
  
  /// Zooms the viewer to the given scale using the given coordinate as the center.
  ///
  /// The zoom center ([x],[y]) is represented in the screen space, whose origin
  /// is at the upper-left corner of the screen region.
  Future<void> zoomWithCenter(double zoom, int x, int y) {
    return _channel.invokeMethod(Functions.zoomWithCenter,
        <String, dynamic>{"zoom": zoom, "x": x, "y": y});
  }

  /// Zooms the viewer to fit the given rectangular area in the specified page.
  ///
  /// ```dart
  /// await controller.zoomToRect(1, {'x1': 10.0, 'y1': 10.0, 'x2': 20.0, 'y2': 20.0});
  /// ```
  ///
  /// [pageNumber] is 1-indexed. The [rect] must be in page coordinates, with
  /// keys x1, y1, x2, and y2.
  Future<void> zoomToRect(int pageNumber, Map<String, double> rect) {
    return _channel.invokeMethod(Functions.zoomToRect, <String, dynamic>{
      Parameters.pageNumber: pageNumber,
      "x1": rect["x1"],
      "y1": rect["y1"],
      "x2": rect["x2"],
      "y2": rect["y2"]
    });
  }

  /// Returns the current zoom scale of the current document viewer.
  Future<double?> getZoom() {
    return _channel.invokeMethod(Functions.getZoom);
  }

  /// Sets the minimum and maximum zoom bounds of the current viewer.
  ///
  /// The [mode] defines how the min and max zoom bounds are used, and is given
  /// by one of the [ZoomLimitMode] constants. If set to [ZoomLimitMode.Relative],
  /// 1.0 is defined as the zoom level where the document is displayed in page
  /// fit mode.
  Future<void> setZoomLimits(String mode, double minimum, double maximum) {
    return _channel.invokeMethod(Functions.setZoomLimits, <String, dynamic>{
      'zoomLimitMode': mode,
      'minimum': minimum,
      'maximum': maximum,
    });
  }

  /// Zooms to a paragraph that contains the specified coordinate.
  ///
  /// The paragraph has to contain more than one line and be wider than 1/5th of
  /// the page width. If no paragraph contains the coordiante, nothing occurs.
  /// The zoom center ([x],[y]) is represented in the screen space, whose origin
  /// is at the upper-left corner of the screen region. [animated] determines if
  /// the transition is animated.
  Future<void> smartZoom(int x, int y, bool animated) {
    return _channel.invokeMethod(Functions.smartZoom, <String, dynamic>{
      'x': x,
      'y': y,
      Parameters.animated: animated,
    });
  }
  
  /// Gets a list of absolute file paths to all saved signatures as PDFs.
  Future<List<String>?> getSavedSignatures() {
    return _channel.invokeMethod(Functions.getSavedSignatures);
  }

  /// Gets the absolute path to the folder containing all saved signatures as PDFs.
  ///
  /// For Android, to get the folder containing the saved signatures as JPGs,
  /// use [getSavedSignatureJpgFolder].
  Future<String?> getSavedSignatureFolder() {
    return _channel.invokeMethod(Functions.getSavedSignatureFolder);
  }

  /// Gets the absolute path to the folder containing all saved signatures as JPGs.
  ///
  /// Android only. To get the folder containing the saved signatures as PDFs,
  /// use [getSavedSignatureFolder].
  Future<String?> getSavedSignatureJpgFolder() {
    return _channel.invokeMethod(Functions.getSavedSignatureJpgFolder);
  }

  /// Sets the background color of the viewer.
  ///
  /// The color is given as RGB values, with each integer being in range between
  /// 0 and 255 inclusive.
  Future<void> setBackgroundColor(int red, int green, int blue) {
    return _channel.invokeMethod(
        Functions.setBackgroundColor, <String, dynamic>{
      Parameters.red: red,
      Parameters.green: green,
      Parameters.blue: blue
    });
  }

  /// Sets the default page color of the viewer.
  ///
  /// The color is given as RGB values, with each integer being in range between
  /// 0 and 255 inclusive.
  Future<void> setDefaultPageColor(int red, int green, int blue) {
    return _channel.invokeMethod(
        Functions.setDefaultPageColor, <String, dynamic>{
      Parameters.red: red,
      Parameters.green: green,
      Parameters.blue: blue
    });
  }
  
  /// Gets the horizontal and vertical scroll position in the current document viewer.
  ///
  /// The scroll position is returned as a `Map<String, int>` with the keys
  /// "horizontal" and "vertical".
  Future<Map?> getScrollPos() async {
    String jsonString = await _channel.invokeMethod(Functions.getScrollPos);
    dynamic json = jsonDecode(jsonString);
    Map scrollPos = {
      'horizontal': json['horizontal'],
      'vertical': json['vertical']
    };
    return scrollPos;
  }

  /// Sets the horizontal scroll position in the current document viewer.
  Future<void> setHorizontalScrollPosition(int horizontalScrollPosition) {
    return _channel.invokeMethod(
        Functions.setHorizontalScrollPosition, <String, dynamic>{
      Parameters.horizontalScrollPosition: horizontalScrollPosition
    });
  }

  /// Sets the vertical scroll position in the current document viewer.
  Future<void> setVerticalScrollPosition(int verticalScrollPosition) {
    return _channel.invokeMethod(
        Functions.setVerticalScrollPosition, <String, dynamic>{
      Parameters.verticalScrollPosition: verticalScrollPosition
    });
  }

  /// Gets the page numbers of currently visible pages in the viewer.
  Future<List<int>?> getVisiblePages() {
    return _channel.invokeMethod(Functions.getVisiblePages);
  }

  // Hygen Generated Methods
  Future<void> setLayoutMode(String layoutMode) {
    return _channel.invokeMethod(Functions.setLayoutMode, <String, dynamic>{
      Parameters.layoutMode: layoutMode
    });
  }

  Future<void> setFitMode(String fitMode) {
    return _channel.invokeMethod(Functions.setFitMode, <String, dynamic>{
      Parameters.fitMode: fitMode
    });
  }

  /// Gets the list of annotations on the given page.
  Future<List<Annot>?> getAnnotationsOnPage(int pageNumber) {
    return _channel.invokeMethod(Functions.getAnnotationsOnPage, <String, dynamic>{
      Parameters.pageNumber: pageNumber
    }).then((jsonArray) {
      List<dynamic> annotations = jsonDecode(jsonArray);
      List<Annot> annotList = new List<Annot>.empty(growable: true);
      for (dynamic annotation in annotations) {
        annotList.add(new Annot.fromJson(annotation));
      }
      return annotList;
    });
  }
}
