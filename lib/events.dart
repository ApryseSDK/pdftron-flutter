part of pdftron;

const _exportAnnotationCommandChannel =
    const EventChannel('export_annotation_command_event');
const _exportBookmarkChannel = const EventChannel('export_bookmark_event');
const _documentLoadedChannel = const EventChannel('document_loaded_event');
const _documentErrorChannel = const EventChannel('document_error_event');
const _annotationChangedChannel =
    const EventChannel('annotation_changed_event');
const _annotationsSelectedChannel =
    const EventChannel('annotations_selected_event');
const _formFieldValueChangedChannel =
    const EventChannel('form_field_value_changed_event');

typedef void ExportAnnotationCommandListener(dynamic xfdfCommand);
typedef void ExportBookmarkListener(dynamic bookmarkJson);
typedef void DocumentLoadedListener(dynamic filePath);
typedef void DocumentErrorListener();
typedef void AnnotationChangedListener(dynamic action, dynamic annotations);
typedef void AnnotationsSelectedListener(dynamic annotationWithRects);
typedef void FormFieldValueChangedListener(dynamic fields);
typedef void CancelListener();

const int exportAnnotationId = 1;
const int exportBookmarkId = 2;
const int documentLoadedId = 3;
const int documentErrorId = 4;
const int annotationChangedId = 5;
const int annotationsSelectedId = 6;
const int formFieldValueChangedId = 7;

CancelListener startExportAnnotationCommandListener(
    ExportAnnotationCommandListener listener) {
  var subscription = _exportAnnotationCommandChannel
      .receiveBroadcastStream(exportAnnotationId)
      .listen(listener, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

CancelListener startExportBookmarkListener(ExportBookmarkListener listener) {
  var subscription = _exportBookmarkChannel
      .receiveBroadcastStream(exportBookmarkId)
      .listen(listener, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

CancelListener startDocumentLoadedListener(DocumentLoadedListener listener) {
  var subscription = _documentLoadedChannel
      .receiveBroadcastStream(documentLoadedId)
      .listen(listener, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

CancelListener startDocumentErrorListener(DocumentErrorListener listener) {
  var subscription = _documentErrorChannel
      .receiveBroadcastStream(documentErrorId)
      .listen((stub) {
    listener();
  }, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

CancelListener startAnnotationChangedListener(
    AnnotationChangedListener listener) {
  var subscription = _annotationChangedChannel
      .receiveBroadcastStream(annotationChangedId)
      .listen((annotationsWithActionString) {
    dynamic annotationsWithAction = jsonDecode(annotationsWithActionString);
    String action = annotationsWithAction[EventParameters.action];
    List<dynamic> annotations =
        annotationsWithAction[EventParameters.annotations];
    List<PTAnnot> annotList = new List<PTAnnot>();
    for (dynamic annotation in annotations) {
      annotList.add(new PTAnnot.fromJson(annotation));
    }
    listener(action, annotList);
  }, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

CancelListener startAnnotationsSelectedListener(
    AnnotationsSelectedListener listener) {
  var subscription = _annotationsSelectedChannel
      .receiveBroadcastStream(annotationsSelectedId)
      .listen((annotationWithRectsString) {
    List<dynamic> annotationWithRects = jsonDecode(annotationWithRectsString);
    List<PTAnnotWithRect> annotWithRectList = new List<PTAnnotWithRect>();
    for (dynamic annotationWithRect in annotationWithRects) {
      annotWithRectList.add(new PTAnnotWithRect.fromJson(annotationWithRect));
    }
    listener(annotWithRectList);
  }, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

CancelListener startFormFieldValueChangedListener(
    FormFieldValueChangedListener listener) {
  var subscription = _formFieldValueChangedChannel
      .receiveBroadcastStream(formFieldValueChangedId)
      .listen((fieldsString) {
    List<dynamic> fields = jsonDecode(fieldsString);
    List<PTField> fieldList = new List<PTField>();
    for (dynamic field in fields) {
      fieldList.add(new PTField.fromJson(field));
    }
    listener(fieldList);
  }, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}
