---
to: android/src/main/java/com/pdftron/pdftronflutter/helpers/PluginUtils.java
after: Hygen Generated Event Listeners
inject: true
---
    public static final String EVENT_<%= h.changeCase.constantCase(name) %> = "<%= h.changeCase.snakeCase(name) %>";<% -%>
