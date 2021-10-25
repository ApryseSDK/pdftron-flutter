import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdftron_flutter/pdftron_flutter.dart';

class DocViewer extends StatefulWidget {
  DocViewer(this.annotListString);

  final String annotListString;

  @override
  _DocViewerState createState() => _DocViewerState();
}

class _DocViewerState extends State<DocViewer> {
  String _version = 'Unknown';
  String _document =
      "https://pdftron.s3.amazonaws.com/downloads/pl/PDFTRON_mobile_about.pdf";

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    showViewer();
  }

  void printXfdf(String xfdf) {
    // Dart limits how many characters are printed onto the console. 
    // The code below ensures that all of the XFDF command is printed.
    if (xfdf.length > 1024) {
      int start = 0;
      int end = 1023;
      while (end < xfdf.length) {
        print(xfdf.substring(start, end) + "\n");
        start += 1024;
        end += 1024;
      }
      print(xfdf.substring(start));
    } else {
      print(xfdf);
    }
  }

  void showViewer() async {
    // opening without a config file will have all functionality enabled.
    // await PdftronFlutter.openDocument(_document);

    var config = Config();
    // How to disable functionality:
    //      config.disabledElements = [Buttons.shareButton, Buttons.searchButton];
    //      config.disabledTools = [Tools.annotationCreateLine, Tools.annotationCreateRectangle];
    //      config.multiTabEnabled = true;
    //      config.customHeaders = {'headerName': 'headerValue'};

    try {
      // The imported command is in XFDF format and tells whether to add, modify or delete annotations in the current document.
      await PdftronFlutter.importAnnotations(
          "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
              "    <xfdf xmlns=\"http://ns.adobe.com/xfdf/\" xml:space=\"preserve\">\n" +
              "      <add>\n" +
              "        <square style=\"solid\" width=\"5\" color=\"#E44234\" opacity=\"1\" creationdate=\"D:20200619203211Z\" flags=\"print\" date=\"D:20200619203211Z\" name=\"c684da06-12d2-4ccd-9361-0a1bf2e089e3\" page=\"1\" rect=\"113.312,277.056,235.43,350.173\" title=\"\" />\n" +
              "      </add>\n" +
              "      <modify />\n" +
              "      <delete />\n" +
              "      <pdf-info import-version=\"3\" version=\"2\" xmlns=\"http://www.pdftron.com/pdfinfo\" />\n" +
              "    </xfdf>");
    } on PlatformException catch (e) {
      print("Failed to importAnnotationCommand '${e.message}'.");
    }

    await PdftronFlutter.openDocument(_document, config: config);

    // var documentCancel = startDocumentLoadedListener((path) async {
      String contents = widget.annotListString;
      if (contents != null) {
        await _showMyDialog();
        printXfdf(contents);
        await PdftronFlutter.importAnnotations(contents);
      }
    // });

    // An event listener for when local annotation changes are committed to the document.
    // xfdfCommand is the XFDF Command of the annotation that was last changed.
    var annotCancel = startExportAnnotationCommandListener((xfdfCommand) async {
      String command = xfdfCommand;
      print("flutter xfdfCommand:\n");
      printXfdf(command);
    });

    var annotChangedCancel = startAnnotationChangedListener((action, annotations) {
      print("Action: $action");
      for (Annot annot in annotations) {
        print("ID: ${annot.id} \n Page Number: ${annot.pageNumber}");
      }
    });

    var leadingNavButtonCancel = startLeadingNavButtonPressedListener(() async {
      String annotString = await PdftronFlutter.exportAnnotations(null);
      print("To be save locally");
      // printXfdf(annotString);
      await PdftronFlutter.deleteAllAnnotations();
      Navigator.pop(context, annotString);
    });

  }

  Future<void> _showMyDialog() async {
    print('hello');
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('AlertDialog'),
          content: SingleChildScrollView(
            child: Text('Annotations have been imported'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child:
            Container()
      ),
    );
  }
}