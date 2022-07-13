---
to: android/src/main/java/com/pdftron/pdftronflutter/helpers/PluginUtils.java
after: Hygen Generated Methods
inject: true
---
<%# template, implementation to be added onto by user -%>
    public static void <%= name %>(<%= params === '' ? '' : 'MethodCall call, ' %>MethodChannel.Result result, ViewerComponent component) {
        result.success(null);
    }
