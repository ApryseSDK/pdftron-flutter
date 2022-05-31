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
         name = param.substring(param.indexOf(' ') + 1).trim()
         args += '    public static final String KEY_' + h.changeCase.constantCase(name) + ' = "' + name + '";\n'
       })
     args = args.substring(0, args.length - 1)
   }
-%>
    <%- args %>
