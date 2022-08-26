---
to: android/src/main/java/com/pdftron/pdftronflutter/FlutterDocumentView.java
after: Hygen Generated Event Listeners \(2\)
inject: true
---
        final EventChannel <%= name %>EventChannel = new EventChannel(messenger, EVENT_<%= h.changeCase.constantCase(name) %>);
        <%= name %>EventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink emitter) {
                documentView.set<%= h.changeCase.pascalCase(name) %>EventEmitter(emitter);
            }

            @Override
            public void onCancel(Object arguments) {
                documentView.set<%= h.changeCase.pascalCase(name) %>EventEmitter(null);
            }
        });
