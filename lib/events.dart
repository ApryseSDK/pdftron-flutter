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
const _leadingNavButtonPressedChannel =
    const EventChannel('leading_nav_button_pressed_event');
const _pageChangedChannel = const EventChannel('page_changed_event');
const _zoomChangedChannel = const EventChannel('zoom_changed_event');

typedef void ExportAnnotationCommandListener(dynamic xfdfCommand);
typedef void ExportBookmarkListener(dynamic bookmarkJson);
typedef void DocumentLoadedListener(dynamic filePath);
typedef void DocumentErrorListener();
typedef void AnnotationChangedListener(dynamic action, dynamic annotations);
typedef void AnnotationsSelectedListener(dynamic annotationWithRects);
typedef void FormFieldValueChangedListener(dynamic fields);
typedef void LeadingNavbuttonPressedlistener();
typedef void PageChangedListener(
    dynamic previousPageNumber, dynamic pageNumber);
typedef void ZoomChangedListener(dynamic zoom);
typedef void CancelListener();

const int exportAnnotationId = 1;
const int exportBookmarkId = 2;
const int documentLoadedId = 3;
const int documentErrorId = 4;
const int annotationChangedId = 5;
const int annotationsSelectedId = 6;
const int formFieldValueChangedId = 7;
const int leadingNavButtonPressedChannelId = 8;
const int pageChangedId = 9;
const int zoomChangedId = 10;

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
    List<Annot> annotList = new List<Annot>();
    for (dynamic annotation in annotations) {
      annotList.add(new Annot.fromJson(annotation));
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
    List<AnnotWithRect> annotWithRectList = new List<AnnotWithRect>();
    for (dynamic annotationWithRect in annotationWithRects) {
      annotWithRectList.add(new AnnotWithRect.fromJson(annotationWithRect));
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
    List<Field> fieldList = new List<Field>();
    for (dynamic field in fields) {
      fieldList.add(new Field.fromJson(field));
    }
    listener(fieldList);
  }, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

CancelListener startLeadingNavButtonPressedListener(
    LeadingNavbuttonPressedlistener listener) {
  var subscription = _leadingNavButtonPressedChannel
      .receiveBroadcastStream(leadingNavButtonPressedChannelId)
      .listen((stub) {
    listener();
  }, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

CancelListener startPageChangedListener(PageChangedListener listener) {
  var subscription = _pageChangedChannel
      .receiveBroadcastStream(pageChangedId)
      .listen((pagesString) {
    dynamic pagesObject = jsonDecode(pagesString);
    dynamic previousPageNumber =
        pagesObject[EventParameters.previousPageNumber];
    dynamic pageNumber = pagesObject[EventParameters.pageNumber];
    listener(previousPageNumber, pageNumber);
  }, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

CancelListener startZoomChangedListener(ZoomChangedListener listener) {
  var subscription = _zoomChangedChannel
      .receiveBroadcastStream(zoomChangedId)
      .listen(listener, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}
