import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdftron_flutter/pdftron_flutter.dart';

void main() {
  runApp(MaterialApp(
    title: 'Example',
    home: FirstRoute(),
  ));
}

class FirstRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Route'),
      ),
      body: Center(
          child: Column(
              children: [
                ElevatedButton(
                  child: Text('Open PDFTronWidget'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Viewer(key: UniqueKey())),
                    );
                  },
                ),
              ]
          )
      ),
    );
  }
}

class Viewer extends StatefulWidget {

  Viewer({Key key}) : super(key: key);

  @override
  _ViewerState createState() => _ViewerState();
}

class _ViewerState extends State<Viewer> {
  String _version = 'Unknown';
  String _document = "http://www.africau.edu/images/default/sample.pdf";
  bool _showViewer = true;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String version;
    try {
      PdftronFlutter.initialize("your_pdftron_license_key");
      version = await PdftronFlutter.version;
    } on PlatformException {
      version = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      _version = version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PdfTron'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: _showViewer ? DocumentView(
          onCreated: _onDocumentViewCreated,
        ): Container(),
      ),
    );
  }

  void _onDocumentViewCreated(DocumentViewController controller) async {
    var leadingNavCancel = startLeadingNavButtonPressedListener(() {
      Navigator.pop(context);
    });
    controller.openDocument(_document);
  }

}
