---
to: lib/pdftron_flutter.dart
after: Hygen Generated Methods
inject: true
---
static Future< <%= flutterReturnType %>> <%= name %>() {
    return _channel.invokeMethod(Functions.<%= name %>);
  }