---
to: lib/constants.dart
after: Hygen Generated Event Listeners
inject: true
---
<%# declaring a constant for each param -%>
<% args = ''
   if (params !== '') {
     params.split(',').forEach(param => {
       argName = param.trim()
       args += '  static const ' + argName + ' = "' + argName + '";\n'
     })
     args = args.substring(0, args.length - 1)
   }
-%>
<%- args %><% -%>
