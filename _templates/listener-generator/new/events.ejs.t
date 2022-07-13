---
to: lib/events.dart
after: Hygen Generated Event Listeners \(1\)
inject: true
---
const _<%= name %>Channel = const EventChannel('<%= h.changeCase.snakeCase(name) %>_event');<% -%>
