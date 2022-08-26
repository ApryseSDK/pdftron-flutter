---
to: android/src/main/java/com/pdftron/pdftronflutter/FlutterDocumentActivity.java
after: Hygen Generated Event Listeners \(3\)
inject: true
---
    @Override
    public EventSink get<%= h.changeCase.pascalCase(name) %>EventEmitter() {
        return s<%= h.changeCase.pascalCase(name) %>EventEmitter.get();
    }
