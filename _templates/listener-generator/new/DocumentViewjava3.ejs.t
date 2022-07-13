---
to: android/src/main/java/com/pdftron/pdftronflutter/views/DocumentView.java
after: Hygen Generated Event Listeners \(3\)
inject: true
---
    @Override
    public EventChannel.EventSink get<%= h.changeCase.pascalCase(name) %>EventEmitter() {
        return s<%= h.changeCase.pascalCase(name) %>;
    }
