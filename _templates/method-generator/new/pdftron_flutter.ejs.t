---
to: lib/pdftron_flutter.dart
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
         args += '\n      "' + name + '": ' + name + ','
       })
     args = args.substring(0, args.length - 1) + '\n    '
   }
-%>
  static Future<<%= returnType %>> <%= name %>(<%- params %>) {
    return _channel.invokeMethod(Functions.<%= name %><%- args %>);
  }
