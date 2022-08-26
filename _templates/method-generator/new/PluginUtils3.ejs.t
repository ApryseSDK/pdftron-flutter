---
to: android/src/main/java/com/pdftron/pdftronflutter/helpers/PluginUtils.java
after: Hygen Generated Method Cases
inject: true
---
            case FUNCTION_<%= h.changeCase.constantCase(name) %>: {
                checkFunctionPrecondition(component);
                <%= name %>(<%= params === '' ? '' : 'call, ' %>result, component);
                break;
            }<% -%>
