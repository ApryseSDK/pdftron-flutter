import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdftron_flutter/pdftron_flutter.dart';
import 'package:pdftron_flutter_example/viewer.dart';
// Uncomment this if you are using local files
// import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _version = 'Unknown';
  String _annotListString;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Future<void> launchWithPermission() async {
  //  PermissionStatus permission = await Permission.storage.request();
  //  if (permission.isGranted) {
  //    showViewer();
  //  }
  // }

  // Platform messages are asynchronous, so initialize in an async method.
  Future<void> initPlatformState() async {
    // Initializes the PDFTron SDK, it must be called before you can use any functionality.
    PdftronFlutter.initialize("your_pdftron_license_key");

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, you want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child:
            Container(
              child: Center (
                child: TextButton (
                  child: Text("Open Document Viewer"),
                  onPressed: () async => {
                    _annotListString = await Navigator.push(context, 
                      MaterialPageRoute(
                        builder: (context) => new DocViewer(_annotListString)
                      )
                    )
                  },
                )
              ),
            ),
      ),
    );
  }

}