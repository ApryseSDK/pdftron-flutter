part of pdftron;

const _exportAnnotationCommandChannel = const EventChannel('export_annotation_command_event');

typedef void ExportAnnotationCommandListener(dynamic xfdfCommand);
typedef void CancelListener();

int nextListenerId = 1;

CancelListener startExportAnnotationCommandListener(ExportAnnotationCommandListener listener) {
  var subscription = _exportAnnotationCommandChannel.receiveBroadcastStream(nextListenerId++).listen(listener, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}