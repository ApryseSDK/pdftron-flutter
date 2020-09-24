part of pdftron;

typedef void DocumentViewCreatedCallback(DocumentViewController controller);

class DocumentView extends StatefulWidget {
  const DocumentView({Key key, this.onCreated}) : super(key: key);

  final DocumentViewCreatedCallback onCreated;

  @override
  State<StatefulWidget> createState() => _DocumentViewState();
}

class _DocumentViewState extends State<DocumentView> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return AndroidView(
        viewType: 'pdftron_flutter/documentview',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    } else if (Platform.isIOS) {
      return UiKitView(
        viewType: 'pdftron_flutter/documentview',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
    return Text('coming soon');
  }

  void _onPlatformViewCreated(int id) {
    if (widget.onCreated == null) {
      return;
    }
    widget.onCreated(new DocumentViewController._(id));
  }
}

class DocumentViewController {
  DocumentViewController._(int id)
      : _channel = new MethodChannel('pdftron_flutter/documentview_$id');

  final MethodChannel _channel;

  Future<void> openDocument(String document, {String password, Config config}) {
    return _channel.invokeMethod('openDocument', <String, dynamic>{
      'document': document,
      'password': password,
      'config': jsonEncode(config)
    });
  }

  Future<void> importAnnotationCommand(String xfdfCommand) {
    return _channel.invokeMethod('importAnnotationCommand',
        <String, dynamic>{'xfdfCommand': xfdfCommand});
  }

  Future<void> importBookmarkJson(String bookmarkJson) {
    return _channel.invokeMethod(
        'importBookmarkJson', <String, dynamic>{'bookmarkJson': bookmarkJson});
  }

  Future<String> saveDocument() async {
    return _channel.invokeMethod('saveDocument');
  }

  Future<dynamic> getPageCropBox(int pageNumber) {
    return _channel.invokeMethod('getPageCropBox', <String, dynamic>{
      'pageNumber': pageNumber
    }).then((value) => jsonDecode(value));
  }
}
