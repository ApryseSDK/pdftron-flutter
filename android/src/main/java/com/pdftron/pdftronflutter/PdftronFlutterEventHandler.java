package com.pdftron.pdftronflutter;

import io.flutter.plugin.common.EventChannel;

public class PdftronFlutterEventHandler implements EventChannel.StreamHandler {

    @Override
    public void onListen(Object arguments, EventChannel.EventSink emitter) {
        FlutterDocumentActivity.setFlutterEventEmitter(emitter);
    }

    @Override
    public void onCancel(Object arguments) {
        FlutterDocumentActivity.setFlutterEventEmitter(null);
    }
}
