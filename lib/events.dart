/// The functions are simply used to facilitate communication between
/// Flutter and the native implementations.

/// To acquire a deeper understanding of how events are handled, look at the
/// native implementations.
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
const _behaviorActivatedChannel =
    const EventChannel('behavior_activated_event');
const _longPressMenuPressedChannel =
    const EventChannel('long_press_menu_pressed_event');
const _annotationMenuPressedChannel =
    const EventChannel('annotation_menu_pressed_event');
const _leadingNavButtonPressedChannel =
    const EventChannel('leading_nav_button_pressed_event');
const _pageChangedChannel = const EventChannel('page_changed_event');
const _zoomChangedChannel = const EventChannel('zoom_changed_event');
const _pageMovedChannel = const EventChannel('page_moved_event');
const _annotationToolbarItemPressedChannel =
    const EventChannel('annotation_toolbar_item_pressed_event');
const _scrollChangedChannel = const EventChannel('scroll_changed_event');

/// A listener used as the argument for [startExportAnnotationCommandListener].
///
/// Gets the [xfdfCommand], the XFDF string for local annotation changes that
/// has been committed to the document.
typedef void ExportAnnotationCommandListener(dynamic xfdfCommand);

/// A listener used as the argument for [startExportBookmarkListener].
///
/// Gets the [bookmarkJson], the JSON string for user bookmark changes that has
/// been committed to the document.
typedef void ExportBookmarkListener(dynamic bookmarkJson);

/// A listener used as the argument for [startDocumentLoadedListener].
///
/// Gets the [filePath] to where the document is saved.
typedef void DocumentLoadedListener(dynamic filePath);

/// A listener used as the argument for [startDocumentErrorListener].
typedef void DocumentErrorListener();

/// A listener used as the argument for [startAnnotationChangedListener].
///
/// Gets the string for the [action] that has occurred (add, delete, or modify)
/// and the changed [annotations] as a list of [Annot] objects.
typedef void AnnotationChangedListener(dynamic action, dynamic annotations);

/// A listener used as the argument for [startAnnotationsSelectedListener].
///
/// Gets the selected [annotationWithRects] as a list of [AnnotWithRect] objects.
typedef void AnnotationsSelectedListener(dynamic annotationWithRects);

/// A listener used as the argument for [startFormFieldValueChangedListener].
///
/// Gets the changed [fields] as a list of [Field] objects.
typedef void FormFieldValueChangedListener(dynamic fields);

/// A listener used as the argument for [startBehaviorActivatedListener].
///
/// Gets the [action] that has been activated as one of the [Behaviors] constants,
/// and the [data] as a map containing detailed information regarding the behavior.
typedef void BehaviorActivatedListener(dynamic action, dynamic data);

/// A listener used as the argument for [startLongPressMenuPressedListener].
///
/// Gets the pressed [longPressMenuItem] as one of the [LongPressMenuItems]
/// constants, and the selected [longPressText] string if pressed on text; empty
/// string otherwise.
typedef void LongPressMenuPressedChannelListener(
    dynamic longPressMenuItem, dynamic longPressText);

/// A listener used as the argument for [startAnnotationMenuPressedListener].
///
/// Gets the pressed [annotationMenuItem] as one of the [AnnotationMenuItems]
/// constants, and the [annotations] associated with the menu as a list of
/// [Annot] objects.
typedef void AnnotationMenuPressedChannelListener(
    dynamic annotationMenuItem, dynamic annotations);

/// A listener used as the argument for [startLeadingNavButtonPressedListener].
typedef void LeadingNavbuttonPressedlistener();

/// A listener used as the argument for [startPageChangedListener].
///
/// Gets the [previousPageNumber] before it was changed and the current
/// [pageNumber].
typedef void PageChangedListener(
    dynamic previousPageNumber, dynamic pageNumber);

/// A listener used as the argument for [startZoomChangedListener].
///
/// Gets the [zoom] ratio in the current document viewer.
typedef void ZoomChangedListener(dynamic zoom);

/// A listener used as the argument for [startPageMovedListener].
///
/// Gets the [previousPageNumber] before it was moved and the current
/// [pageNumber].
typedef void PageMovedListener(dynamic previousPageNumber, dynamic pageNumber);

/// A listener used as the argument for [startAnnotationToolbarItemPressedListener].
///
/// Gets the unique [id] of the custom toolbar item that was pressed.
typedef void AnnotationToolbarItemPressedListener(dynamic id);

/// A listener used as the argument for [startScrollChangedListener].
///
/// Gets the current [horizontal] scroll position and the [vertical] scroll
/// position.
typedef void ScrollChangedListener(dynamic horizontal, dynamic vertical);

typedef void CancelListener();

/// Used to identify listeners for the EventChannel.
enum eventSinkId {
  exportAnnotationId,
  exportBookmarkId,
  documentLoadedId,
  documentErrorId,
  annotationChangedId,
  annotationsSelectedId,
  formFieldValueChangedId,
  behaviorActivatedId,
  longPressMenuPressedId,
  annotationMenuPressedId,
  leadingNavButtonPressedId,
  pageChangedId,
  zoomChangedId,
  pageMovedId,
  annotationToolbarItemPressedId,
  scrollChangedId,
}

/// Listens for when local annotation changes have been committed to the document.
///
/// ```dart
/// var annotCancel = startExportAnnotationCommandListener((xfdfCommand) {
///   print('flutter xfdfCommand: $xfdfCommand');
/// });
/// ```
///
/// Returns a function that can cancel the listener.
/// To also raise this event upon undo/redo, [Config.annotationManagerEnabled]
/// must be true, and [Config.userId] must not be null.
CancelListener startExportAnnotationCommandListener(
    ExportAnnotationCommandListener listener) {
  var subscription = _exportAnnotationCommandChannel
      .receiveBroadcastStream(eventSinkId.exportAnnotationId.index)
      .listen(listener, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

/// Listens for when user bookmark changes are committed to the document.
///
/// ```dart
/// var bookmarkCancel = startExportBookmarkListener((bookmarkJson) {
///   print('flutter bookmark: $bookmarkJson');
/// });
/// ```
///
/// Returns a function that can cancel the listener.
CancelListener startExportBookmarkListener(ExportBookmarkListener listener) {
  var subscription = _exportBookmarkChannel
      .receiveBroadcastStream(eventSinkId.exportBookmarkId.index)
      .listen(listener, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

/// Listens for when [PdftronFlutter.openDocument] or
/// [DocumentViewController.openDocument] has finished loading the file.
///
/// ```dart
/// var documentLoadedCancel = startDocumentLoadedListener((path) {
///   print('flutter document loaded: $path');
/// });
/// ```
///
/// Returns a function that can cancel the listener.
CancelListener startDocumentLoadedListener(DocumentLoadedListener listener) {
  var subscription = _documentLoadedChannel
      .receiveBroadcastStream(eventSinkId.documentLoadedId.index)
      .listen(listener, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

/// Listens for errors that could occur while [PdftronFlutter.openDocument] or
/// [DocumentViewController.openDocument] is loading the file.
///
/// ```dart
/// var documentErrorCancel = startDocumentErrorListener(() {
///   print('flutter document loaded unsuccessfully');
/// });
/// ```
///
/// Returns a function that can cancel the listener.
CancelListener startDocumentErrorListener(DocumentErrorListener listener) {
  var subscription = _documentErrorChannel
      .receiveBroadcastStream(eventSinkId.documentErrorId.index)
      .listen((stub) {
    listener();
  }, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

/// Listens for when there has been a change to annotations in the document.
///
/// ```dart
/// var annotChangedCancel = startAnnotationChangedListener((action, annotations) {
///   print('flutter annotation action: $action');
///   for (Annot annot in annotations) {
///     print('annotation has id: ${annot.id}');
///     print('annotation is in page: ${annot.pageNumber}');
///   }
/// });
/// ```
///
/// Returns a function that can cancel the listener.
CancelListener startAnnotationChangedListener(
    AnnotationChangedListener listener) {
  var subscription = _annotationChangedChannel
      .receiveBroadcastStream(eventSinkId.annotationChangedId.index)
      .listen((annotationsWithActionString) {
    dynamic annotationsWithAction = jsonDecode(annotationsWithActionString);
    String action = annotationsWithAction[EventParameters.action];
    List<dynamic> annotations = Platform.isIOS
        ? jsonDecode(annotationsWithAction[EventParameters.annotations])
        : annotationsWithAction[EventParameters.annotations];
    List<Annot> annotList = new List<Annot>.empty(growable: true);
    for (dynamic annotation in annotations) {
      annotList.add(new Annot.fromJson(annotation));
    }
    listener(action, annotList);
  }, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

/// Listens for when annotations are selected.
///
/// ```dart
/// var annotsSelectedCancel = startAnnotationsSelectedListener((annotationWithRects) {
///   for (AnnotWithRect annotWithRect in annotationWithRects) {
///     print('annotation has id: ${annotWithRect.id}');
///     print('annotation is in page: ${annotWithRect.pageNumber}');
///     print('annotation has width: ${annotWithRect.rect.width}');
///   }
/// });
/// ```
///
/// Returns a function that can cancel the listener.
CancelListener startAnnotationsSelectedListener(
    AnnotationsSelectedListener listener) {
  var subscription = _annotationsSelectedChannel
      .receiveBroadcastStream(eventSinkId.annotationsSelectedId.index)
      .listen((annotationWithRectsString) {
    List<dynamic> annotationWithRects = jsonDecode(annotationWithRectsString);
    List<AnnotWithRect> annotWithRectList =
        new List<AnnotWithRect>.empty(growable: true);
    for (dynamic annotationWithRect in annotationWithRects) {
      annotWithRectList.add(new AnnotWithRect.fromJson(annotationWithRect));
    }
    listener(annotWithRectList);
  }, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

/// Listens for changes to the value of form fields.
///
/// ```dart
/// var fieldChangedCancel = startFormFieldValueChangedListener((fields) {
///   for (Field field in fields) {
///     print('Field has name ${field.fieldName}');
///     print('Field has value ${field.fieldValue}');
///   }
/// });
/// ```
///
/// Returns a function that can cancel the listener.
CancelListener startFormFieldValueChangedListener(
    FormFieldValueChangedListener listener) {
  var subscription = _formFieldValueChangedChannel
      .receiveBroadcastStream(eventSinkId.formFieldValueChangedId.index)
      .listen((fieldsString) {
    List<dynamic> fields = jsonDecode(fieldsString);
    List<Field> fieldList = new List<Field>.empty(growable: true);
    for (dynamic field in fields) {
      fieldList.add(new Field.fromJson(field));
    }
    listener(fieldList);
  }, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

/// Listens for the start of behaviors that has been passed into
/// [Config.overrideBehavior].
///
/// ```dart
/// var behaviorActivatedCancel = startBehaviorActivatedListener((action, data) {
///   print('action is ' + action);
///   print('url is ' + data['url']);
/// });
/// ```
///
/// Returns a function that can cancel the listener.
CancelListener startBehaviorActivatedListener(
    BehaviorActivatedListener listener) {
  var subscription = _behaviorActivatedChannel
      .receiveBroadcastStream(eventSinkId.behaviorActivatedId.index)
      .listen((behaviorString) {
    dynamic behaviorObject = jsonDecode(behaviorString);
    dynamic action = behaviorObject[EventParameters.action];
    dynamic data = behaviorObject[EventParameters.data];
    listener(action, data);
  }, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

/// Listens for presses on long press menu items that has been passed into
/// [Config.overrideLongPressMenuBehavior].
///
/// ```dart
/// var longPressMenuPressedCancel = startLongPressMenuPressedListener((longPressMenuItem, longPressText) {
///   print('Long press menu item ' + longPressMenuItem + ' has been pressed');
///   if (longPressText.length > 0) {
///     print('The selected text is: ' + longPressText);
///   }
/// });
/// ```
///
/// Returns a function that can cancel the listener.
CancelListener startLongPressMenuPressedListener(
    LongPressMenuPressedChannelListener listener) {
  var subscription = _longPressMenuPressedChannel
      .receiveBroadcastStream(eventSinkId.longPressMenuPressedId.index)
      .listen((longPressString) {
    dynamic longPressObject = jsonDecode(longPressString);
    dynamic longPressMenuItem =
        longPressObject[EventParameters.longPressMenuItem];
    dynamic longPressText = longPressObject[EventParameters.longPressText];
    listener(longPressMenuItem, longPressText);
  }, cancelOnError: true);
  return () {
    subscription.cancel();
  };
}

/// Listens for presses on annotation menu items that has been passed into
/// [Config.overrideAnnotationMenuBehavior].
///
/// ```dart
/// var annotationMenuPressedCancel = startAnnotationMenuPressedListener((annotationMenuItem, annotations) {
///   print('Annotation menu item ' + annotationMenuItem + ' has been pressed');
///   for (Annot annotation in annotations) {
///     print('Annotation has id: ${annotation.id}');
///     print('Annotation is in page: ${annotation.pageNumber}');
///   }
/// });
/// ```
///
/// Returns a function that can cancel the listener.
CancelListener startAnnotationMenuPressedListener(
    AnnotationMenuPressedChannelListener listener) {
  var subscription = _annotationMenuPressedChannel
      .receiveBroadcastStream(eventSinkId.annotationMenuPressedId.index)
      .listen((annotationMenuString) {
    dynamic annotationMenuObject = jsonDecode(annotationMenuString);
    dynamic annotationMenuItem =
        annotationMenuObject[EventParameters.annotationMenuItem];
    dynamic annotations = annotationMenuObject[EventParameters.annotations];
    List<Annot> annotList = new List<Annot>.empty(growable: true);
    for (dynamic annotation in annotations) {
      annotList.add(Annot.fromJson(annotation));
    }
    listener(annotationMenuItem, annotList);
  }, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

/// Listens for when the leading navigation button is pressed.
///
/// ```dart
/// var navPressedCancel = startLeadingNavButtonPressedListener(() {
///   print('flutter nav button pressed');
/// });
/// ```
///
/// Returns a function that can cancel the listener.
CancelListener startLeadingNavButtonPressedListener(
    LeadingNavbuttonPressedlistener listener) {
  var subscription = _leadingNavButtonPressedChannel
      .receiveBroadcastStream(eventSinkId.leadingNavButtonPressedId.index)
      .listen((stub) {
    listener();
  }, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

/// Listens for when the current page is changed in the viewer.
///
/// ```dart
/// var pageChangedCancel = startPageChangedListener((previousPageNumber, pageNumber) {
///   print('flutter page changed. from $previousPageNumber to $pageNumber');
/// });
/// ```
///
/// Returns a function that can cancel the listener.
CancelListener startPageChangedListener(PageChangedListener listener) {
  var subscription = _pageChangedChannel
      .receiveBroadcastStream(eventSinkId.pageChangedId.index)
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

/// Listens for when the current document's zoom ratio is changed.
///
/// ```dart
/// var zoomChangedCancel = startZoomChangedListener((zoom) {
///   print('flutter zoom changed. Current zoom is: $zoom');
/// });
/// ```
///
/// Returns a function that can cancel the listener.
CancelListener startZoomChangedListener(ZoomChangedListener listener) {
  var subscription = _zoomChangedChannel
      .receiveBroadcastStream(eventSinkId.zoomChangedId.index)
      .listen(listener, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

/// Listens for when a page has been moved in the document.
///
/// ```dart
/// var pageMovedCancel = startPageMovedListener((previousPageNumber, pageNumber) {
///   print('flutter page moved from $previousPageNumber to $pageNumber');
/// });
/// ```
///
/// Returns a function that can cancel the listener.
CancelListener startPageMovedListener(PageMovedListener listener) {
  var subscription = _pageMovedChannel
      .receiveBroadcastStream(eventSinkId.pageMovedId.index)
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

/// Listens for when a custom annotation toolbar item has been pressed.
///
/// ```dart
/// var itemPressedCancel = startAnnotationToolbarItemPressedListener((id) {
///   print('flutter toolbar item $id pressed');
/// });
/// ```
///
/// Returns a function that can cancel the listener.
/// Custom toolbar items can be added using the [Config.annotationToolbars]
/// config. Android only.
CancelListener startAnnotationToolbarItemPressedListener(
    AnnotationToolbarItemPressedListener listener) {
  var subscription = _annotationToolbarItemPressedChannel
      .receiveBroadcastStream(eventSinkId.annotationToolbarItemPressedId.index)
      .listen(listener, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}

/// Listens for when the document's scroll position is changed.
///
/// ```dart
/// var scrollChangedCancel = startScrollChangedListener((horizontal, vertical) {
///   print('flutter scroll position: $horizontal, $vertical');
/// });
/// ```
///
/// Returns a function that can cancel the listener.
CancelListener startScrollChangedListener(ScrollChangedListener listener) {
  var subscription = _scrollChangedChannel
      .receiveBroadcastStream(eventSinkId.scrollChangedId.index)
      .listen((scrollString) {
    dynamic scrollObject = jsonDecode(scrollString);
    dynamic horizontal = scrollObject['horizontal'];
    dynamic vertical = scrollObject['vertical'];
    listener(horizontal, vertical);
  }, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}
