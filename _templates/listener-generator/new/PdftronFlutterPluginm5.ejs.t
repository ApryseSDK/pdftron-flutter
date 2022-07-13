---
to: ios/Classes/PdftronFlutterPlugin.m
after: Hygen Generated Event Listeners \(5\)
inject: true
---
- (void)documentController:(PTDocumentController *)docVC <%= name %>:(NSString *)<%= name %>String
{
    if (self.<%= name %>EventSink != nil)
    {
        self.<%= name %>EventSink(<%= name %>String);
    }
}
