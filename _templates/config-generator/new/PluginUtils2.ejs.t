---
to: android/src/main/java/com/pdftron/pdftronflutter/helpers/PluginUtils.java
after: Hygen Generated Configs
inject: true
---
                if (!configJson.isNull(KEY_CONFIG_<%= h.javaConstants(name) %>)) {
                    <%= h.getJavaConfigValue(config) %>  = configJson.get<%= h.getJavaConfigValue(h.changeCase.pascalCase(name)) %>(KEY_CONFIG_<%= h.javaConstants(name) %>)  
                }