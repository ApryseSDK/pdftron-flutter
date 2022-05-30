---
to: android/src/main/java/com/pdftron/pdftronflutter/helpers/PluginUtils.java
after: Hygen Generated Configs
inject: true
---
                if (!configJson.isNull(KEY_CONFIG_<%= h.changeCase.constantCase(name) %>)) {
                    <%= h.getJavaConfigValue(type) %> <%= name %> = configJson.get<%= h.changeCase.upperCaseFirst(h.getJavaConfigValue(type)) %>(KEY_CONFIG_<%= h.changeCase.constantCase(name) %>);
                    // Needs Implementation
                }<% -%>
