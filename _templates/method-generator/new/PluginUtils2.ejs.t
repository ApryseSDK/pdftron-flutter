---
to: android/src/main/java/com/pdftron/pdftronflutter/helpers/PluginUtils.java
after: Hygen Generated Method Cases
inject: true
---
            case FUNCTION_<%= h.javaConstants(name) %>: {
                checkFunctionPrecondition(component);
                <%= name %>(call, result, component);
                break;
            }