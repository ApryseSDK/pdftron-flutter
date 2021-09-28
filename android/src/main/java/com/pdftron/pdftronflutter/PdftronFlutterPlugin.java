package com.pdftron.pdftronflutter;

import android.content.Context;

import androidx.annotation.NonNull;

import com.pdftron.pdftronflutter.factories.DocumentViewFactory;
import com.pdftron.pdftronflutter.helpers.PluginMethodCallHandler;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.platform.PlatformViewRegistry;

/**
 * PdftronFlutterPlugin
 */
public class PdftronFlutterPlugin implements FlutterPlugin, ActivityAware {

    private Context mContext;
    private BinaryMessenger mMessenger;
    private PlatformViewRegistry mRegistry;

    public PdftronFlutterPlugin(Context context) {
        mContext = context;
    }

    public PdftronFlutterPlugin() { }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        registerWithLogic(registrar.messenger(), registrar.activeContext());
        registrar
                .platformViewRegistry()
                .registerViewFactory("pdftron_flutter/documentview",
                        new DocumentViewFactory(registrar.messenger(), registrar.activeContext()));
    }

    private static void registerWithLogic(BinaryMessenger messenger, Context activeContext) {
        final MethodChannel methodChannel = new MethodChannel(messenger, "pdftron_flutter");
        methodChannel.setMethodCallHandler(new PluginMethodCallHandler(messenger, activeContext));
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        mContext = binding.getApplicationContext(); 
        mMessenger = binding.getBinaryMessenger();
        mRegistry = binding.getPlatformViewRegistry();
        registerWithLogic(mMessenger, mContext);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        mContext = null;
        mMessenger = null;
        mRegistry = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        mContext = binding.getActivity();
        mRegistry
                .registerViewFactory("pdftron_flutter/documentview",
                        new DocumentViewFactory(mMessenger, mContext));
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        mContext = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        mContext = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {
        mContext = null;
    }
}
