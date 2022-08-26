---
to: android/src/main/java/com/pdftron/pdftronflutter/views/DocumentView.java
after: Hygen Generated Event Listeners \(1\)
inject: true
---
    private EventChannel.EventSink s<%= h.changeCase.pascalCase(name) %>EventEmitter;<% -%>
