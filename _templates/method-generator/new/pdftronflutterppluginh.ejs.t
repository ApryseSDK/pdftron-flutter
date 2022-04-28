---
to: ios/Classes/PdftronFlutterPlugin.h
after: Hygen generated constants
inject: true
---
static NSString * const PT<%= h.changeCase.pascalCase(name) %>Key = @"<%= name %>";