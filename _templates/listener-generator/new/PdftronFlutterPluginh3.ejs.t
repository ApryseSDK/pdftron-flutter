---
to: ios/Classes/PdftronFlutterPlugin.h
after: Hygen Generated Event Listeners \(3\)
inject: true
---
- (void)documentController:(PTDocumentController *)docVC <%= name %>:(<%= params === '' ? 'nullable ' : '' %>NSString *)<%= name %>String;<% -%>
