import 'package:flutter/material.dart';
import 'package:pdftron_flutter/pdftron_flutter.dart';

class PdfDocumentView extends StatelessWidget {
  const PdfDocumentView(this._onViewCreated);
  final Function(DocumentViewController contoller) _onViewCreated;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:
      Container(
          width: double.infinity,
          height: double.infinity,
          child: DocumentView(
            onCreated: _onViewCreated,
          )
      ),
    );
  }
}