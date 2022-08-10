---
to: ios/Classes/PdftronFlutterPlugin.m
after: Hygen Generated Event Listeners \(2\)
inject: true
---
    FlutterEventChannel* <%= name %>EventChannel = [FlutterEventChannel eventChannelWithName:PT<%= h.changeCase.pascalCase(name) %>EventKey binaryMessenger:messenger];

    [<%= name %>EventChannel setStreamHandler:self];
