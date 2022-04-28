---
to: ios/Classes/PdftronFlutterPlugin.m
after: Hygen Generated Cases
inject: true
---
    else if ([call.method isEqualToString:PT<%= h.changeCase.pascalCase(name) %>Key]) {
        [self <%= name %>:result];
    } 