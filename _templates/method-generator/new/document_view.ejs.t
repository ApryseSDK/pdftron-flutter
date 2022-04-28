---
to: lib/document_view.dart
after: Hygen Generated Methods
inject: true
---
Future< <%= flutterReturnType %>> <%= name %>() {
    return _channel.invokeMethod(Functions.<%= name %>);
  }