---
to: lib/constants.dart
after: Hygen Generated Method Parameters
inject: true
---
<% args = ''
   if (params !== '') {
     params
       .replace(/(?<=<)(.*?)(?=>)/g, '')
       .split(',')
       .forEach(param => {
         name = param.substring(param.indexOf(' ') + 1).trim()
         args += '\n  static const ' + name + ' = "' + name + '";'
       })
   }
-%>
  <%- args %><%- %>
