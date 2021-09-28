package com.pdftron.pdftronflutter;

import android.content.Context;

import com.pdftron.pdftronflutter.factories.DocumentViewFactory;
import com.pdftron.pdftronflutter.helpers.PluginMethodCallHandler;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
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
        System.out.println("Attached to Engine");
        mMessenger = binding.getBinaryMessenger();
        mRegistry = binding.getPlatformViewRegistry();
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
        System.out.println("Detached from Engine");
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        System.out.println("Attached to Activity");
        registerPlugin(mMessenger, binding.getActivity(), mRegistry);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        System.out.println("Detached from activity due to config changes");
    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
        System.out.println("Reattached to Activity");
    }

    @Override
    public void onDetachedFromActivity() {
        System.out.println("Detached from activity");
    }

    /**
     * Plugin registration using Android embedding v1.
     */
    public static void registerWith(Registrar registrar) {
        registerPlugin(registrar.messenger(), registrar.activeContext(), registrar.platformViewRegistry());
    }

    public static void registerPlugin(BinaryMessenger messenger, Context context, PlatformViewRegistry registry) {
        MethodChannel mChannel = new MethodChannel(messenger, "pdftron_flutter");
        mChannel.setMethodCallHandler(new PluginMethodCallHandler(messenger, context));
        registry.registerViewFactory("pdftron_flutter/documentview", new DocumentViewFactory(messenger, context));
    }
}
