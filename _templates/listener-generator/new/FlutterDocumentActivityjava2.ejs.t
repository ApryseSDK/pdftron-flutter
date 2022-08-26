---
to: android/src/main/java/com/pdftron/pdftronflutter/FlutterDocumentActivity.java
after: Hygen Generated Event Listeners \(2\)
inject: true
---
    public static void set<%= h.changeCase.pascalCase(name) %>EventEmitter(EventSink emitter) {
        s<%= h.changeCase.pascalCase(name) %>EventEmitter.set(emitter);
    }
