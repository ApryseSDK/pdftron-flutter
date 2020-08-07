part of pdftron;

const _exportAnnotationCommandChannel = const EventChannel('export_annotation_command_event');
const _exportBookmarkChannel = const EventChannel('export_bookmark_event');
const _documentLoadedChannel = const EventChannel('document_loaded_event');

typedef void ExportAnnotationCommandListener(dynamic xfdfCommand);
typedef void ExportBookmarkListener(dynamic bookmarkJson);
typedef void DocumentLoadedListener(dynamic filePath);
typedef void CancelListener();

const int exportAnnotationId = 1;
const int exportBookmarkId = 2;
const int documentLoadedId = 3;

CancelListener startExportAnnotationCommandListener(ExportAnnotationCommandListener listener) {
  var subscription = _exportAnnotationCommandChannel.receiveBroadcastStream(exportAnnotationId).listen(listener, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

CancelListener startExportBookmarkListener(ExportBookmarkListener listener) {
  var subscription = _exportBookmarkChannel.receiveBroadcastStream(exportBookmarkId).listen(listener, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

CancelListener startDocumentLoadedListener(DocumentLoadedListener listener) {
  var subscription = _documentLoadedChannel.receiveBroadcastStream(documentLoadedId).listen(listener, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}