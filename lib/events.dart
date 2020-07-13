part of pdftron;

const _exportAnnotationCommandChannel = const EventChannel('export_annotation_command_event');
const _exportBookmarkChannel = const EventChannel('export_bookmark_event');

typedef void ExportAnnotationCommandListener(dynamic xfdfCommand);
typedef void ExportBookmarkListener(dynamic bookmarkJson);
typedef void CancelListener();

const int exportAnnotationId = 1;
const int exportBookmarkId = 2;

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