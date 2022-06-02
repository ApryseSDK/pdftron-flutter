---
to: lib/events.dart
after: Hygen Generated Event Listeners \(4\)
inject: true
---
CancelListener start<%= h.changeCase.pascalCase(name) %>Listener(<%= h.changeCase.pascalCase(name) %>Listener listener) {
  var subscription = _<%= name %>Channel
      .receiveBroadcastStream(eventSinkId.<%= name %>Id.index)
      .listen(listener, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}
