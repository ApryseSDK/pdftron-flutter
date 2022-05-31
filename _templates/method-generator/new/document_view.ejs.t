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
         name = param.substring(param.indexOf(' ') + 1).trim()
         args += '\n      Parameters.' + name + ': ' + name + ','
       })
     args = args.substring(0, args.length - 1) + '\n    '
   }
-%>
  Future<<%= returnType %>> <%= name %>(<%- params %>) {
    return _channel.invokeMethod(Functions.<%= name %><%- args %>);
  }
