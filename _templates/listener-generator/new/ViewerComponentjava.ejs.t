---
to: android/src/main/java/com/pdftron/pdftronflutter/helpers/ViewerComponent.java
after: Hygen Generated Event Listeners
inject: true
---
    EventChannel.EventSink get<%= h.changeCase.pascalCase(name) %>EventEmitter();
