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

  static Future<void> importAnnotationCommand(String xfdfCommand) {
    return _channel.invokeMethod(Functions.importAnnotationCommand,
        <String, dynamic>{Parameters.xfdfCommand: xfdfCommand});
  }

  static Future<void> importBookmarkJson(String bookmarkJson) {
    return _channel.invokeMethod(Functions.importBookmarkJson,
        <String, dynamic>{Parameters.bookmarkJson: bookmarkJson});
  }

  static Future<String> saveDocument() async {
    return _channel.invokeMethod(Functions.saveDocument);
  }

  static Future<PTRect> getPageCropBox(int pageNumber) {
    return _channel.invokeMethod(Functions.getPageCropBox, <String, dynamic>{
      Parameters.pageNumber: pageNumber
    }).then((value) => PTRect.fromJson(jsonDecode(value)));
  }

  static Future<void> setToolMode(String toolMode) {
    return _channel.invokeMethod(Functions.setToolMode,
        <String, dynamic>{Parameters.toolMode: toolMode});
  }

  static Future<void> setFlagForFields(
      List<String> fieldNames, int flag, bool flagValue) {
    return _channel.invokeMethod(Functions.setFlagForFields, <String, dynamic>{
      Parameters.fieldNames: fieldNames,
      Parameters.flag: flag,
      Parameters.flagValue: flagValue
    });
  }

  static Future<void> setValueForFields(List<Field> fields) {
    return _channel.invokeMethod(Functions.setValueForFields,
        <String, dynamic>{Parameters.fields: jsonEncode(fields)});
  }
}
