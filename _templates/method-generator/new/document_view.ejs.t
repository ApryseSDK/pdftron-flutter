---
to: lib/document_view.dart
after: Hygen Generated Methods
inject: true
---
<% args = ''
   if (params !== '') {
     args += ', <String, dynamic>{'
     params
       .replace(/(?<=<)(.*?)(?=>)/g, '')
       .split(',')
       .forEach(param => {
         argName = param.trim().split(' ')[1]
         args += '\n      Parameters.' + argName + ': ' + argName + ','
       })
     args = args.substring(0, args.length - 1) + '\n    '
   }
-%>
  Future<<%= returnType %>> <%= name %>(<%- params %>) {
    return _channel.invokeMethod(Functions.<%= name %><%- args %>);
  }
