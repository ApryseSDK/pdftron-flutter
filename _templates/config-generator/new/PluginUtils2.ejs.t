---
to: android/src/main/java/com/pdftron/pdftronflutter/helpers/PluginUtils.java
after: Hygen Generated Configs
inject: true
---
                if (!configJson.isNull(KEY_CONFIG_<%= h.changeCase.constantCase(name) %>)) {
                    <%= h.getJavaConfigValue(config) %> <%= name %> = configJson.get<%= h.changeCase.pascalCase(h.getJavaConfigValue(config)) %>(KEY_CONFIG_<%= h.changeCase.constantCase(name) %>);
                    <# Needs Implementation #>
                }
