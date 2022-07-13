---
to: lib/constants.dart
after: Hygen Generated Method Parameters
inject: true
---
<% args = ''
   if (params !== '') {
     params
       .replace(/(?<=<)(.*?)(?=>)/g, '') /* removing type params to get rid of any commas that can hinder splitting */
       .split(',')
       .forEach(param => {
         argName = param.trim().split(' ')[1]
         args += '  static const ' + argName + ' = "' + argName + '";\n'
       })
     args = args.substring(0, args.length - 1)
   }
-%>
<%- args %><% -%>
