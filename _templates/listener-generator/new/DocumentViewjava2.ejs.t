---
to: android/src/main/java/com/pdftron/pdftronflutter/views/DocumentView.java
after: Hygen Generated Event Listeners \(2\)
inject: true
---
    public void set<%= h.changeCase.pascalCase(name) %>EventEmitter(EventChannel.EventSink emitter) {
        s<%= h.changeCase.pascalCase(name) %>EventEmitter = emitter;
    }
