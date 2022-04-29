---
to: ios/Classes/PdftronFlutterPlugin.m
after: Hygen Generated Configs
inject: true
---
                else if([key isEqualToString:PT<%= h.changeCase.pascalCase(name) %>Key])
                {
                    <%= h.getIOSConfigValue(config) %>* <%= name %> = [PdftronFlutterPlugin getConfigValue:configPairs configKey:PT<%= h.changeCase.pascalCase(name) %>Key class:[<%= h.getIOSConfigValue(config) %> class] error:&error];

                    if (!error && <%= name %>) {
                        <# Needs Implementation #>
                    }
                }