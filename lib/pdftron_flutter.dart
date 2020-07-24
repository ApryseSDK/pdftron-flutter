library pdftron;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'options.dart';
part 'document_view.dart';
part 'events.dart';

class PdftronFlutter {
  static const MethodChannel _channel = const MethodChannel('pdftron_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> get version async {
    final String version = await _channel.invokeMethod('getVersion');
    return version;
  }

  static Future<void> initialize(String licenseKey) {
    return _channel.invokeMethod(
        'initialize', <String, dynamic>{'licenseKey': licenseKey});
  }

  static Future<void> openDocument(String document,
      {String password, Config config}) {
    return _channel.invokeMethod('openDocument', <String, dynamic>{
      'document': document,
      'password': password,
      'config': jsonEncode(config)
    });
  }

  static Future<void> importAnnotationCommand(String xfdfCommand) {
    return _channel.invokeMethod('importAnnotationCommand', <String, dynamic>{'xfdfCommand': xfdfCommand});
  }

  static Future<void> importBookmarkJson(String bookmarkJson) {
    return _channel.invokeMethod('importBookmarkJson', <String, dynamic>{'bookmarkJson': bookmarkJson});
  }

  static Future<String> saveDocument() async {
    return _channel.invokeMethod('saveDocument');
  }
}
