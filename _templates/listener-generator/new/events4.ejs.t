---
to: lib/src/events.dart
after: Hygen Generated Event Listeners \(4\)
inject: true
---
<%# injecting lines to decode JSON if there are parameters (template, may be changed or added onto by user) -%>
<% args = ''
   if (params !== '') {
      args += '\n        dynamic ' + name + 'Object = jsonDecode(' + name + 'String);'
      params.split(',').forEach(param => {
        argName = param.trim()
        args += '\n        dynamic ' + argName + ' = ' + name + 'Object[EventParameters.' + argName + '];'
      })
   }
-%>
CancelListener start<%= h.changeCase.pascalCase(name) %>Listener(<%= h.changeCase.pascalCase(name) %>Listener listener) {
  var subscription = _<%= name %>Channel
      .receiveBroadcastStream(eventSinkId.<%= name %>Id.index)
      .listen((<%= params === '' ? 'stub' : name + 'String' %>) {<%- args %>
        listener(<%= params %>);
      }, cancelOnError: true);

  return () {
    subscription.cancel();
  };
}
