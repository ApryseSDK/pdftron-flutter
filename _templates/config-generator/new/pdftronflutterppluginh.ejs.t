---
to: ios/Classes/PdftronFlutterPlugin.h
after: Hygen generated Config Constants
inject: true
---
static NSString * const PT<%= h.changeCase.pascalCase(name) %>Key = @"<%= name %>";