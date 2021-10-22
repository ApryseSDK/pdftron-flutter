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

    private static final String viewTypeId = "pdftron_flutter/documentview";

    private PlatformViewRegistry mRegistry;
    private BinaryMessenger mMessenger;
    private MethodChannel mMethodChannel;

    public PdftronFlutterPlugin() { }

    @Override
    public void onAttachedToEngine(FlutterPluginBinding binding) {
        mMessenger = binding.getBinaryMessenger();
        mRegistry = binding.getPlatformViewRegistry();
        mMethodChannel = new MethodChannel(mMessenger, "pdftron_flutter");
        mMethodChannel.setMethodCallHandler(new PluginMethodCallHandler(mMessenger, binding.getApplicationContext()));
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
        mRegistry = null;
        mMessenger = null;
        mMethodChannel.setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        mRegistry.registerViewFactory(viewTypeId, new DocumentViewFactory(mMessenger, binding.getActivity()));
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() { }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
        mRegistry.registerViewFactory(viewTypeId, new DocumentViewFactory(mMessenger, binding.getActivity()));
    }

    @Override
    public void onDetachedFromActivity() { }

    /**
     * Plugin registration using Android embedding v1.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel methodChannel = new MethodChannel(registrar.messenger(), "pdftron_flutter");
        methodChannel.setMethodCallHandler(new PluginMethodCallHandler(registrar.messenger(), registrar.activeContext()));
        registrar
                .platformViewRegistry()
                .registerViewFactory(viewTypeId,
                        new DocumentViewFactory(registrar.messenger(), registrar.activeContext()));
    }
}
