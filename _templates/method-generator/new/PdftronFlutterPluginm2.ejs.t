---
to: ios/Classes/PdftronFlutterPlugin.m
after: Hygen Generated Methods
inject: true
---
<%# template, implementation to be added onto by user -%>
- (void)<%= name %>:(FlutterResult)result<%- params === '' ? '' : ' call:(FlutterMethodCall*)call' %>
{
    PTDocumentController *documentController = [self getDocumentController];

    flutterResult(nil);
}
