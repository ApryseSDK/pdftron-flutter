---
to: android/src/main/java/com/pdftron/pdftronflutter/helpers/PluginUtils.java
after: Hygen Generated Config Constants
inject: true
---
    public static final String KEY_CONFIG_<%= h.changeCase.constantCase(name) %> = "<%= name %>";<% -%>
