---
to: ios/Classes/PdftronFlutterPlugin.m
after: Hygen Generated Event Listeners \(4\)
inject: true
---
        case <%= name %>Id:
            self.<%= name %>EventSink = nil;
            break;<% -%>
