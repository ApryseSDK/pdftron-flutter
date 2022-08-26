---
to: ios/Classes/PdftronFlutterPlugin.h
after: Hygen Generated Methods
inject: true
---
static NSString * const PT<%= h.changeCase.pascalCase(name) %>Key = @"<%= name %>";<% -%>
