---
to: android/src/main/java/com/pdftron/pdftronflutter/FlutterDocumentView.java
after: Hygen Generated Event Listeners \(1\)
inject: true
---
import static com.pdftron.pdftronflutter.helpers.PluginUtils.EVENT_<%= h.changeCase.constantCase(name) %>;<% -%>
