---
to: ios/Classes/PdftronFlutterPlugin.m
after: Hygen Generated Event Listeners \(3\)
inject: true
---
        case <%= name %>Id:
            self.<%= name %>EventSink = events;
            break;<% -%>
