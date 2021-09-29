package com.pdftron.pdftronflutter;

import android.content.Context;

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

    private PlatformViewRegistry mRegistry;
    private BinaryMessenger mMessenger;

    public PdftronFlutterPlugin() {
    }

    @Override
    public void onAttachedToEngine(FlutterPluginBinding binding) {
        mMessenger = binding.getBinaryMessenger();
        mRegistry = binding.getPlatformViewRegistry();
        registerPlugin(mMessenger, binding.getApplicationContext());
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
        mRegistry = null;
        mMessenger = null;
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        mRegistry.registerViewFactory("pdftron_flutter/documentview", new DocumentViewFactory(mMessenger, binding.getActivity()));
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
        mRegistry.registerViewFactory("pdftron_flutter/documentview", new DocumentViewFactory(mMessenger, binding.getActivity()));
    }

    @Override
    public void onDetachedFromActivity() {
    }

    /**
     * Plugin registration using Android embedding v1.
     */
    public static void registerWith(Registrar registrar) {
        registerPlugin(registrar.messenger(), registrar.activeContext());
        registrar.platformViewRegistry().registerViewFactory("pdftron_flutter/documentview", new DocumentViewFactory(
                registrar.messenger(), registrar.activeContext()));
    }

    public static void registerPlugin(BinaryMessenger messenger, Context context) {
        MethodChannel mChannel = new MethodChannel(messenger, "pdftron_flutter");
        mChannel.setMethodCallHandler(new PluginMethodCallHandler(messenger, context));
    }
}
