/// A convenience wrapper to build Flutter apps that use the PDFTron mobile SDK for smooth, flexible, and stand-alone document viewing.
library pdftron;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

part 'options.dart';
part 'document_view.dart';
part 'events.dart';
part 'config.dart';
part 'constants.dart';

/// A native plugin for viewing documents and accessing features of the PDFTron SDK.
class PdftronFlutter {
  static const MethodChannel _channel = const MethodChannel('pdftron_flutter');

  /// The current version of the PDFTron SDK.
  static Future<String> get platformVersion async {
    final String version =
        await _channel.invokeMethod(Functions.getPlatformVersion);
    return version;
  }

  /// The current version of the OS that the app is running on.
  static Future<String> get version async {
    final String version = await _channel.invokeMethod(Functions.getVersion);
    return version;
  }

  /// Initializes the PDFTron SDK using a license key.
  ///
  /// To run in demo mode, pass an empty string to [licenseKey]. This function must
  /// be called before opening any document, whether using [PdftronFlutter] or [DocumentView].
  static Future<void> initialize([String licenseKey = ""]) {
    return _channel.invokeMethod(Functions.initialize,
        <String, dynamic>{Parameters.licenseKey: licenseKey});
  }

  /// Opens a document in the viewer with configurations.
  ///
  /// Uses the path specified by [document]. Takes a [password] for
  /// encrypted documents, and viewer configuration options for customization.
  static Future<void> openDocument(String document,
      {String? password, Config? config}) {
    return _channel.invokeMethod(Functions.openDocument, <String, dynamic>{
      Parameters.document: document,
      Parameters.password: password,
      Parameters.config: jsonEncode(config)
    });
  }

  /// Imports XFDF annotation string to current document.
  static Future<void> importAnnotations(String xfdf) {
    return _channel.invokeMethod(
        Functions.importAnnotations, <String, dynamic>{Parameters.xfdf: xfdf});
  }

  /// Extracts XFDF annotation string from the current document.
  ///
  /// If [annotationList] is null, export all annotations from
  /// the document; else export the valid ones specified.
  static Future<String?> exportAnnotations(List<Annot>? annotationList) async {
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
  static Future<void> flattenAnnotations(bool formsOnly) {
    return _channel.invokeMethod(Functions.flattenAnnotations,
        <String, dynamic>{Parameters.formsOnly: formsOnly});
  }

  /// Deletes the specified annotations in the current document.
  static Future<void> deleteAnnotations(List<Annot> annotationList) {
    return _channel.invokeMethod(Functions.deleteAnnotations,
        <String, dynamic>{Parameters.annotations: jsonEncode(annotationList)});
  }

  /// Selects the specified annotation in the current document.
  static Future<void> selectAnnotation(Annot annotation) {
    return _channel.invokeMethod(Functions.selectAnnotation,
        <String, dynamic>{Parameters.annotation: jsonEncode(annotation)});
  }

  /// Sets flags for specified annotations in the current document.
  static Future<void> setFlagsForAnnotations(
      List<AnnotWithFlag> annotationWithFlagsList) {
    return _channel.invokeMethod(
        Functions.setFlagsForAnnotations, <String, dynamic>{
      Parameters.annotationsWithFlags: jsonEncode(annotationWithFlagsList)
    });
  }

  /// Sets properties for specified annotation in the current document.
  static Future<void> setPropertiesForAnnotation(
      Annot annotation, AnnotProperty property) {
    return _channel
        .invokeMethod(Functions.setPropertiesForAnnotation, <String, dynamic>{
      Parameters.annotation: jsonEncode(annotation),
      Parameters.annotationProperties: jsonEncode(property),
    });
  }

  static Future<void> groupAnnotations(Annot primaryAnnotation, List<Annot> subAnnotations) {
    return _channel.invokeMethod(Functions.groupAnnotations,
        <String, dynamic>{
        Parameters.annotation: jsonEncode(primaryAnnotation),
        Parameters.annotations: jsonEncode(subAnnotations)
        });
  }

  static Future<void> ungroupAnnotations(List<Annot> annotations) {
    return _channel.invokeMethod(Functions.ungroupAnnotations,
        <String, dynamic>{
        Parameters.annotations: jsonEncode(annotations)
        });
  }

  /// Imports remote annotation command to local document.
  ///
  /// The XFDF needs to be in a valid command format with `<add>`
  /// `<modify>` `<delete>` tags.
  static Future<void> importAnnotationCommand(String xfdfCommand) {
    return _channel.invokeMethod(Functions.importAnnotationCommand,
        <String, dynamic>{Parameters.xfdfCommand: xfdfCommand});
  }

  /// Imports user bookmarks into the document.
  ///
  /// The input needs to be in valid bookmark JSON format, for
  /// example {"0": "Page 1"}. Page numbers are 1-indexed.
  static Future<void> importBookmarkJson(String bookmarkJson) {
    return _channel.invokeMethod(Functions.importBookmarkJson,
        <String, dynamic>{Parameters.bookmarkJson: bookmarkJson});
  }

  /// Creates a new bookmark with the given title and page number.
  ///
  /// [pageNumber] is 1-indexed
  static Future<void> addBookmark(String title, int pageNumber) {
    return _channel.invokeMethod(Functions.addBookmark, <String, dynamic>{
      Parameters.title: title,
      Parameters.pageNumber: pageNumber
    });
  }

  /// Saves the currently opened document in the viewer.
  ///
  /// Also gets the absolute path to the document. Must only
  /// be called when the document is opened in the viewer.
  static Future<String?> saveDocument() {
    return _channel.invokeMethod(Functions.saveDocument);
  }

  /// Commits the current tool.
  ///
  /// Returns true for multi-stroke ink ([Tools.annotationCreateFreeHand]) and
  /// poly-shape ([Tools.annotationCreatePolygon]).
  static Future<bool?> commitTool() {
    return _channel.invokeMethod(Functions.commitTool);
  }

  /// Gets the total number of pages in the currently displayed document.
  static Future<int?> getPageCount() {
    return _channel.invokeMethod(Functions.getPageCount);
  }


  /// Handles the back button in search mode.
  ///
  /// Android only.
  static Future<bool?> handleBackButton() {
    return _channel.invokeMethod(Functions.handleBackButton);
  }

  static Future<void> undo() {
    return _channel.invokeMethod(Functions.undo);
  }

  static Future<void> redo() {
    return _channel.invokeMethod(Functions.redo);
  }

  static Future<bool> canUndo() {
    return _channel.invokeMethod(Functions.canUndo);
  }

  static Future<bool> canRedo() {
    return _channel.invokeMethod(Functions.canRedo);
  }

  /// Gets a map object of the crop box for the specified page.
  ///
  /// [pageNumber] is 1-indexed.
  static Future<Rect> getPageCropBox(int pageNumber) async {
    String cropBoxString = await _channel.invokeMethod(Functions.getPageCropBox,
        <String, dynamic>{Parameters.pageNumber: pageNumber});
    return Rect.fromJson(jsonDecode(cropBoxString));
  }

  /// Gets the rotation value of the specified page in the current document.
  ///
  /// [pageNumber] is 1-indexed.
  static Future<int> getPageRotation(int pageNumber) async {
    int pageRotation = await _channel.invokeMethod(Functions.getPageRotation,
        <String, dynamic>{Parameters.pageNumber: pageNumber});
    return pageRotation;
  }

  static Future<void> rotateClockwise() {
    return _channel.invokeMethod(Functions.rotateClockwise);
  }

  static Future<void> rotateCounterClockwise() {
    return _channel.invokeMethod(Functions.rotateCounterClockwise);
  }

  /// Sets current page of the document.
  ///
  /// [pageNumber] is 1-indexed.
  static Future<bool> setCurrentPage(int pageNumber) {
    return _channel.invokeMethod(Functions.setCurrentPage,
        <String, dynamic>{Parameters.pageNumber: pageNumber});
  }

  /// Returns the path of the current document.
  static Future<String?> getDocumentPath() {
    return _channel.invokeMethod(Functions.getDocumentPath);
  }

  /// Sets the current tool mode.
  ///
  /// Takes a [Tools] string constant representing the tool mode to set.
  static Future<void> setToolMode(String toolMode) {
    return _channel.invokeMethod(Functions.setToolMode,
        <String, dynamic>{Parameters.toolMode: toolMode});
  }

  /// Sets a field flag value on one or more form fields.
  ///
  /// The [flag] is one of the constants from [FieldFlags].
  static Future<void> setFlagForFields(
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
  static Future<void> setValuesForFields(List<Field> fields) {
    return _channel.invokeMethod(Functions.setValuesForFields,
        <String, dynamic>{Parameters.fields: jsonEncode(fields)});
  }

  /// Sets the file name of the icon to be used for the leading navigation button.
  ///
  /// The button will use the specified icon if [Config.showLeadingNavButton] (which by
  /// default is true) is true in the config. To add the image file to your
  /// application, please follow the steps in the
  /// [API page](https://github.com/PDFTron/pdftron-flutter/blob/publish-prep-nullsafe/doc/api/API.md#viewer-ui-configuration).
  static Future<void> setLeadingNavButtonIcon(String path) {
    return _channel.invokeMethod(Functions.setLeadingNavButtonIcon,
        <String, dynamic>{Parameters.leadingNavButtonIcon: path});
  }

  /// Closes all documents that are currently opened in a multiTab environment.
  ///
  /// A multiTab environment exists when [Config.multiTabEnabled]
  /// is true in the config.
  static Future<void> closeAllTabs() {
    return _channel.invokeMethod(Functions.closeAllTabs);
  }

  /// Deletes all annotations in the current document, excluding links and widgets.
  static Future<void> deleteAllAnnotations() {
    return _channel.invokeMethod(Functions.deleteAllAnnotations);
  }

  static Future<String> exportAsImage(int pageNumber, int dpi, String exportFormat) {
    return _channel.invokeMethod(Functions.exportAsImage, <String, dynamic>{
      Parameters.pageNumber: pageNumber,
      Parameters.dpi: dpi,
      Parameters.exportFormat: exportFormat
    });
  }

  static Future<String> exportAsImageFromFilePath(int pageNumber, int dpi, String exportFormat, String filePath) {
    return _channel.invokeMethod(Functions.exportAsImageFromFilePath, <String, dynamic>{
      Parameters.pageNumber: pageNumber,
      Parameters.dpi: dpi,
      Parameters.exportFormat: exportFormat,
      Parameters.path: filePath
    });
  }

  /// Displays the annotation tab of the existing list container.
  ///
  /// If this tab has been disabled, the method does nothing.
  static Future<void> openAnnotationList() {
    return _channel.invokeMethod(Functions.openAnnotationList);
  }

  /// Displays the bookmark tab of the existing list container.
  ///
  /// If this tab has been disabled, the method does nothing.
  static Future<void> openBookmarkList() {
    return _channel.invokeMethod(Functions.openBookmarkList);
  }

  /// Displays the outline tab of the existing list container.
  ///
  /// If this tab has been disabled, the method does nothing.
  static Future<void> openOutlineList() {
    return _channel.invokeMethod(Functions.openOutlineList);
  }

  /// On Android it displays the layers dialog while on iOS it displays the layers tab of the existing list container.
  ///
  /// If this tab has been disabled or there are no layers in the document, the method does nothing.
  static Future<void> openLayersList() {
    return _channel.invokeMethod(Functions.openLayersList);
  }

  static Future<void> openThumbnailsView() {
    return _channel.invokeMethod(Functions.openThumbnailsView);
  }

  static Future<void> openRotateDialog() {
    return _channel.invokeMethod(Functions.openRotateDialog);
  }

  static Future<void> openAddPagesView(Map<String, double> sourceRect) {
    return _channel.invokeMethod(Functions.openAddPagesView,
        <String, dynamic>{Parameters.sourceRect: sourceRect});
  }

  static Future<void> openViewSettings(Map<String, double> sourceRect) {
    return _channel.invokeMethod(Functions.openViewSettings,
        <String, dynamic>{Parameters.sourceRect: sourceRect});
  }

  static Future<void> openCrop() {
    return _channel.invokeMethod(Functions.openCrop);
  }

  static Future<void> openManualCrop() {
    return _channel.invokeMethod(Functions.openManualCrop);
  }

  static Future<void> openSearch() {
    return _channel.invokeMethod(Functions.openSearch);
  }

  static Future<void> openTabSwitcher() {
    return _channel.invokeMethod(Functions.openTabSwitcher);
  }

  static Future<void> openGoToPageView() {
    return _channel.invokeMethod(Functions.openGoToPageView);
  }

  /// Displays the existing list container.
  ///
  /// Its current tab will be the one last opened.
  static Future<void> openNavigationLists() {
    return _channel.invokeMethod(Functions.openNavigationLists);
  }

  /// Changes the orientation of this activity
  ///
  /// Android only. For more information on the native API,
  /// see the [Android API reference](https://developer.android.com/reference/android/app/Activity#setRequestedOrientation(int)).
  static Future<void> setRequestedOrientation(int requestedOrientation) {
    return _channel.invokeMethod(
        Functions.setRequestedOrientation, <String, dynamic>{
      Parameters.requestedOrientation: requestedOrientation
    });
  }

  /// Go to the previous page of the document.
  ///
  /// If on first page, it will stay on first page.
  static Future<bool?> gotoPreviousPage() {
    return _channel.invokeMethod(Functions.gotoPreviousPage);
  }

  /// Go to the next page of the document.
  ///
  /// If on last page, it will stay on last page.
  static Future<bool?> gotoNextPage() {
    return _channel.invokeMethod(Functions.gotoNextPage);
  }

  /// Go to the first page of the document.
  static Future<bool?> gotoFirstPage() {
    return _channel.invokeMethod(Functions.gotoFirstPage);
  }

  /// Go to the last page of the document.
  static Future<bool?> gotoLastPage() {
    return _channel.invokeMethod(Functions.gotoLastPage);
  }

  /// Gets the current page of the document.
  ///
  /// The page numbers returned are 1-indexed.
  static Future<int?> getCurrentPage() {
    return _channel.invokeMethod(Functions.getCurrentPage);
  }
}
