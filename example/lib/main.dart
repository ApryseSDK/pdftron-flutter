import 'package:flutter/material.dart';
import 'package:pdftron_flutter/pdftron_flutter.dart';
import 'package:pdftron_flutter_example/pdf_document_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Viewer(),
    );
  }
}

class Viewer extends StatefulWidget {
  @override
  _ViewerState createState() => _ViewerState();
}

class _ViewerState extends State<Viewer> {
  String _document =
      "https://pdftron.s3.amazonaws.com/downloads/pl/PDFTRON_mobile_about.pdf";
  bool _showViewer = true;

  @override
  void initState() {
    super.initState();
    PdftronFlutter.initialize("your_pdftron_license_key");
  }


  @override
  Widget build(BuildContext context) {
    final documentView = PdfDocumentView((DocumentViewController controller) {
      _onDocumentViewCreated(controller, context);
    });
    return Scaffold(
        body: Center(
          child: SizedBox(
            height: 100,
            width: 200,
            child: RaisedButton(
              color: Colors.red,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => documentView),
                );
              },
              child: Text('Push Document', style: TextStyle(fontSize: 20),),
            ),
          ),
          // ),
        ));
  }

  void _onDocumentViewCreated(DocumentViewController controller, BuildContext context) async {
    Config config = new Config();

    var leadingNavCancel = startLeadingNavButtonPressedListener(() {
      Navigator.of(context).pop();
    });

    controller.openDocument(_document, config: config);
  }
}


// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Viewer(),
//     );
//   }
// }
//
// class Viewer extends StatefulWidget {
//   @override
//   _ViewerState createState() => _ViewerState();
// }
//
// class _ViewerState extends State<Viewer> {
//   String _document =
//       "https://pdftron.s3.amazonaws.com/downloads/pl/PDFTRON_mobile_about.pdf";
//   bool _showViewer = false;
//
//   @override
//   void initState() {
//     super.initState();
//     PdftronFlutter.initialize("your_pdftron_license_key");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//       child: Container(
//         height: double.infinity,
//         width: double.infinity,
//         child: _showViewer
//             ? DocumentView(onCreated: _onDocumentViewCreated)
//             : RaisedButton(
//                 color: Colors.red,
//                 onPressed: () {
//                   _showDocumentView(true);
//                 },
//                 child: Text(
//                   'Push Document',
//                   style: TextStyle(fontSize: 20),
//                 ),
//               ),
//       ),
//       // ),
//     ));
//   }
//
//   void _onDocumentViewCreated(DocumentViewController controller) async {
//     Config config = new Config();
//
//     var leadingNavCancel = startLeadingNavButtonPressedListener(() {
//       _showDocumentView(false);
//     });
//
//     controller.openDocument(_document, config: config);
//   }
//
//   void _showDocumentView(bool shouldShowDocumentView) {
//     setState(() {
//       _showViewer = shouldShowDocumentView;
//     });
//   }
// }
