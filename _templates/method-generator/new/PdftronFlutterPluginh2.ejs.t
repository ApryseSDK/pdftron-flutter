---
to: ios/Classes/PdftronFlutterPlugin.h
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
         args += 'static NSString * const PT' + h.changeCase.pascalCase(argName) + 'ArgumentKey = @"' + argName + '";\n'
       })
     args = args.substring(0, args.length - 1)
   }
-%>
<%- args %><% -%>
