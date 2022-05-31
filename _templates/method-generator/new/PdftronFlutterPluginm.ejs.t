---
to: ios/Classes/PdftronFlutterPlugin.m
after: Hygen Generated Method Call Cases
inject: true
---
    else if ([call.method isEqualToString:PT<%= h.changeCase.pascalCase(name) %>Key]) {
        [self <%= name %>:result<%- params === '' ? '' : ' call:call' %>];
    }<% -%>
