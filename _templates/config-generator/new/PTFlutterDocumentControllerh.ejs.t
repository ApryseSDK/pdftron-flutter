---
to: ios/Classes/PTFlutterDocumentController.h
after: Hygen Generated Configs
inject: true
---
<% varType = type
   if (varType === 'bool') {
     varType = '(nonatomic, assign) BOOL '
   } else if (varType === 'List') {
     varType = '(nonatomic, copy, nullable) NSArray<NSString *> *'
   } else if (varType.startsWith('Map')) {
     varType = '(nonatomic, copy, nullable) NSDictionary *'
   } else {
     varType = '(nonatomic, assign) ' + varType + ' '
   }
-%>
@property <%- varType %><%= name %>;
