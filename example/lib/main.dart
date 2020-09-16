import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdftron_flutter/pdftron_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _version = 'Unknown';
  String _document = "https://pdftron.s3.amazonaws.com/downloads/pl/PDFTRON_mobile_about.pdf";

  @override
  void initState() {
    super.initState();
    initPlatformState();

    // showViewer();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String version;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      PdftronFlutter.initialize("your_pdftron_license_key");
      version = await PdftronFlutter.version;
    } on PlatformException {
      version = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _version = version;
    });
  }


  void showViewer() {
    // shows how to disale functionality
//      var disabledElements = [Buttons.shareButton, Buttons.searchButton];
//      var disabledTools = [Tools.annotationCreateLine, Tools.annotationCreateRectangle];
     var config = Config();
//      config.disabledElements = disabledElements;
//      config.disabledTools = disabledTools;
//      config.multiTabEnabled = true;
//      config.customHeaders = {'headerName': 'headerValue'};
//      PdftronFlutter.openDocument(_document, config: config);

    // opening without a config file will have all functionality enabled.
    // PdftronFlutter.openDocument(_document);
  }

  DocumentViewController _controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: new Container(
          child: new Center(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Column (
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget> [
                    new FloatingActionButton(
                      onPressed: loadDoc,
                      child: new Icon(Icons.file_upload, color: Colors.black,),
                      backgroundColor: Colors.white,),

                    new FloatingActionButton(
                      onPressed: loadDoc2,
                      child: new Icon(Icons.file_download, color: Colors.black,),
                      backgroundColor: Colors.white,),
                  ],
                ),

                Container(
                  width: 300,
                  height: 500,
                  child: DocumentView(
                    onCreated: _onDocumentViewCreated,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loadDoc() {
    _document = "https://pdftron.s3.amazonaws.com/downloads/pl/PDFTRON_mobile_about.pdf";
    _controller.openDocument(_document);
  }

  void loadDoc2() {
    _document = "http://pdftron.s3.amazonaws.com/downloads/pl/form.pdf";
    _controller.openDocument(_document);
  }

  void _onDocumentViewCreated(DocumentViewController controller) {
    _controller = controller;
  }
}