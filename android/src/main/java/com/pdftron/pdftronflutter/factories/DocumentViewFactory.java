package com.pdftron.pdftronflutter.factories;

import android.content.Context;

import com.pdftron.pdftronflutter.FlutterDocumentView;

import java.lang.ref.WeakReference;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class DocumentViewFactory extends PlatformViewFactory {

    private final BinaryMessenger messenger;
    private final WeakReference<Context> mContextRef;

    public DocumentViewFactory(BinaryMessenger messenger, Context activityContext) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
        mContextRef = new WeakReference<>(activityContext);
    }

    @Override
    public PlatformView create(Context context, int id, Object o) {
        return new FlutterDocumentView(context, mContextRef.get(), this.messenger, id);
    }
}
