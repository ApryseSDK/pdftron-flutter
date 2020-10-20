library pdftron;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'options.dart';
part 'document_view.dart';
part 'events.dart';
part 'config.dart';

class PdftronFlutter {
  static const MethodChannel _channel = const MethodChannel('pdftron_flutter');

  static Future<String> get platformVersion async {
    final String version =
        await _channel.invokeMethod(Functions.getPlatformVersion);
    return version;
  }

  static Future<String> get version async {
    final String version = await _channel.invokeMethod(Functions.getVersion);
    return version;
  }

  static Future<void> initialize(String licenseKey) {
    return _channel.invokeMethod(Functions.initialize,
        <String, dynamic>{Parameters.licenseKey: licenseKey});
  }

  static Future<void> openDocument(String document,
      {String password, Config config}) {
    return _channel.invokeMethod(Functions.openDocument, <String, dynamic>{
      Parameters.document: document,
      Parameters.password: password,
      Parameters.config: jsonEncode(config)
    });
  }

  static Future<void> importAnnotations(String xfdfCommand) {
    return _channel.invokeMethod(Functions.importAnnotations,
        <String, dynamic>{Parameters.xfdfCommand: xfdfCommand});
  }

  static Future<String> exportAnnotations(List<PTAnnot> annotationList) async {
    if (annotationList == null) {
      return _channel.invokeMethod(Functions.exportAnnotations);
    } else {
      return _channel.invokeMethod(
          Functions.exportAnnotations, <String, dynamic>{
        Parameters.annotations: jsonEncode(annotationList)
      });
    }
  }

  static Future<void> flattenAnnotations(bool formsOnly) {
    return _channel.invokeMethod(Functions.flattenAnnotations,
        <String, dynamic>{Parameters.formsOnly: formsOnly});
  }

  static Future<void> deleteAnnotations(List<PTAnnot> annotationList) {
    return _channel.invokeMethod(Functions.deleteAnnotations,
        <String, dynamic>{Parameters.annotations: jsonEncode(annotationList)});
  }

  static Future<void> selectAnnotation(PTAnnot annotation) {
    return _channel.invokeMethod(Functions.selectAnnotation,
        <String, dynamic>{Parameters.annotation: jsonEncode(annotation)});
  }

  static Future<void> setFlagForAnnotations(
      List<PTAnnotWithFlag> annotationWithFlagsList) {
    return _channel.invokeMethod(
        Functions.setFlagForAnnotations, <String, dynamic>{
      Parameters.annotationsWithFlags: jsonEncode(annotationWithFlagsList)
    });
  }

  static Future<void> importAnnotationCommand(String xfdfCommand) {
    return _channel.invokeMethod(Functions.importAnnotationCommand,
        <String, dynamic>{Parameters.xfdfCommand: xfdfCommand});
  }

  static Future<void> importBookmarkJson(String bookmarkJson) {
    return _channel.invokeMethod(Functions.importBookmarkJson,
        <String, dynamic>{Parameters.bookmarkJson: bookmarkJson});
  }

  static Future<String> saveDocument() {
    return _channel.invokeMethod(Functions.saveDocument);
  }

  static Future<bool> commitTool() {
    return _channel.invokeMethod(Functions.commitTool);
  }

  static Future<int> getPageCount() {
    return _channel.invokeMethod(Functions.getPageCount);
  }

  static Future<bool> handleBackButton() {
    return _channel.invokeMethod(Functions.handleBackButton);
  }

  static Future<PTRect> getPageCropBox(int pageNumber) async {
    String cropBoxString = await _channel.invokeMethod(Functions.getPageCropBox,
        <String, dynamic>{Parameters.pageNumber: pageNumber});
    return PTRect.fromJson(jsonDecode(cropBoxString));
  }
}
