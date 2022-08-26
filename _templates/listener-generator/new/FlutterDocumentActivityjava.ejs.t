---
to: android/src/main/java/com/pdftron/pdftronflutter/FlutterDocumentActivity.java
after: Hygen Generated Event Listeners \(1\)
inject: true
---
    private static AtomicReference<EventSink> s<%= h.changeCase.pascalCase(name) %>EventEmitter = new AtomicReference<>();<% -%>
