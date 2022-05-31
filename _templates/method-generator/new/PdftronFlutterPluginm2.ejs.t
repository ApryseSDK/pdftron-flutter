---
to: ios/Classes/PdftronFlutterPlugin.m
after: Hygen Generated Methods
inject: true
---
- (void)<%= name %>:(FlutterResult)result<%- params === '' ? '' : ' call:(FlutterMethodCall*)call' %>
{
    PTDocumentController *documentController = [self getDocumentController];

    flutterResult(nil);
}
