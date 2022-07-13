---
to: ios/Classes/PdftronFlutterPlugin.h
after: Hygen Generated Event Listeners \(1\)
inject: true
---
static NSString * const PT<%= h.changeCase.pascalCase(name) %>EventKey = @"<%= h.changeCase.snakeCase(name) %>_event";<% -%>
