---
to: android/src/main/java/com/pdftron/pdftronflutter/helpers/PluginUtils.java
after: Hygen Generated Method Parameters
inject: true
---
<% args = ''
   if (params !== '') {
     params
       .replace(/(?<=<)(.*?)(?=>)/g, '')
       .split(',')
       .forEach(param => {
         argName = param.trim().split(' ')[1]
         args += '    public static final String KEY_' + h.changeCase.constantCase(argName) + ' = "' + argName + '";\n'
       })
     args = args.substring(0, args.length - 1)
   }
-%>
<%- args %>
