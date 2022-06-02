---
to: lib/events.dart
after: Hygen Generated Event Listeners \(2\)
inject: true
---
<%# appending dynamic type keyword in front of param names -%>
<% args = ''
   if (params !== '') {
     params.split(',').forEach(param => {
       args += 'dynamic ' + param.trim() + ', '
     })
     args = args.substring(0, args.length - 2)
   }
-%>
typedef void <%= h.changeCase.pascalCase(name) %>Listener(<%= args %>);<% -%>
