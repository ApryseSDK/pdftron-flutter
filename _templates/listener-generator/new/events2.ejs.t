---
to: lib/events.dart
after: Hygen Generated Event Listeners \(2\)
inject: true
---
<%# appending dynamic type keyword in front of param names -%>
<% args = ''
   if (params !== '') {
     params.split(',').forEach(param => {
       args += 'dynamic ' + param.trim()
     })
   }
-%>
typedef void <%= h.changeCase.pascalCase(name) %>Listener(<%= args %>);<% -%>
