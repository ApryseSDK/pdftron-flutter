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

import static com.pdftron.pdftronflutter.helpers.PluginUtils.EVENT_ANNOTATIONS_SELECTED;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.EVENT_ANNOTATION_CHANGED;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.EVENT_BEHAVIOR_ACTIVATED;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.EVENT_ANNOTATION_MENU_PRESSED;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.EVENT_DOCUMENT_ERROR;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.EVENT_DOCUMENT_LOADED;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.EVENT_EXPORT_ANNOTATION_COMMAND;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.EVENT_EXPORT_BOOKMARK;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.EVENT_FORM_FIELD_VALUE_CHANGED;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.EVENT_LEADING_NAV_BUTTON_PRESSED;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.EVENT_LONG_PRESS_MENU_PRESSED;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.EVENT_PAGE_CHANGED;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.EVENT_PAGE_MOVED;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.EVENT_ZOOM_CHANGED;

/**
 * PdftronFlutterPlugin
 */
public class PdftronFlutterPlugin implements FlutterPlugin, ActivityAware {

    private MethodChannel mChannel;
    private BinaryMessenger mBinaryMessenger;
    private PlatformViewRegistry mViewRegistry;

    public PdftronFlutterPlugin() {
    }

    @Override
    public void onAttachedToEngine(FlutterPluginBinding binding) {
        mBinaryMessenger = binding.getBinaryMessenger();
        mChannel = new MethodChannel(mBinaryMessenger, "pdftron_flutter");
        mViewRegistry = binding.getPlatformViewRegistry();
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {
        mChannel.setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        Context context = binding.getActivity().getApplicationContext();
        mChannel.setMethodCallHandler(new PluginMethodCallHandler(context));
        registerPlugin(mBinaryMessenger);
        mViewRegistry.registerViewFactory("pdftron_flutter/documentview", new DocumentViewFactory(mBinaryMessenger, context));
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
        onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {

    }

    /**
     * Plugin registration using Android embedding v1.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel methodChannel = new MethodChannel(registrar.messenger(), "pdftron_flutter");
        methodChannel.setMethodCallHandler(new PluginMethodCallHandler(registrar.activeContext()));
        registerPlugin(registrar.messenger());
        registrar.platformViewRegistry().registerViewFactory("pdftron_flutter/documentview", new DocumentViewFactory(registrar.messenger(), registrar.activeContext()));
    }

    public static void registerPlugin(BinaryMessenger messenger) {
        final EventChannel annotEventChannel = new EventChannel(messenger, EVENT_EXPORT_ANNOTATION_COMMAND);
        annotEventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink emitter) {
                FlutterDocumentActivity.setExportAnnotationCommandEventEmitter(emitter);
            }

            @Override
            public void onCancel(Object arguments) {
                FlutterDocumentActivity.setExportAnnotationCommandEventEmitter(null);
            }
        });

        final EventChannel bookmarkEventChannel = new EventChannel(messenger, EVENT_EXPORT_BOOKMARK);
        bookmarkEventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink emitter) {
                FlutterDocumentActivity.setExportBookmarkEventEmitter(emitter);
            }

            @Override
            public void onCancel(Object arguments) {
                FlutterDocumentActivity.setExportBookmarkEventEmitter(null);
            }
        });

        final EventChannel documentLoadedEventChannel = new EventChannel(messenger, EVENT_DOCUMENT_LOADED);
        documentLoadedEventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink emitter) {
                FlutterDocumentActivity.setDocumentLoadedEventEmitter(emitter);
            }

            @Override
            public void onCancel(Object arguments) {
                FlutterDocumentActivity.setDocumentLoadedEventEmitter(null);
            }
        });

        final EventChannel documentErrorEventChannel = new EventChannel(messenger, EVENT_DOCUMENT_ERROR);
        documentErrorEventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink emitter) {
                FlutterDocumentActivity.setDocumentErrorEventEmitter(emitter);
            }

            @Override
            public void onCancel(Object arguments) {
                FlutterDocumentActivity.setDocumentErrorEventEmitter(null);
            }
        });

        final EventChannel annotationChangedEventChannel = new EventChannel(messenger, EVENT_ANNOTATION_CHANGED);
        annotationChangedEventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink emitter) {
                FlutterDocumentActivity.setAnnotationChangedEventEmitter(emitter);
            }

            @Override
            public void onCancel(Object arguments) {
                FlutterDocumentActivity.setAnnotationChangedEventEmitter(null);
            }
        });

        final EventChannel annotationSelectedEventChannel = new EventChannel(messenger, EVENT_ANNOTATIONS_SELECTED);
        annotationSelectedEventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink emitter) {
                FlutterDocumentActivity.setAnnotationsSelectionEventEmitter(emitter);
            }

            @Override
            public void onCancel(Object arguments) {
                FlutterDocumentActivity.setAnnotationsSelectionEventEmitter(null);
            }
        });

        final EventChannel formFieldValueChangedEventChannel = new EventChannel(messenger, EVENT_FORM_FIELD_VALUE_CHANGED);
        formFieldValueChangedEventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink emitter) {
                FlutterDocumentActivity.setFormFieldValueChangedEventEmitter(emitter);
            }

            @Override
            public void onCancel(Object arguments) {
                FlutterDocumentActivity.setFormFieldValueChangedEventEmitter(null);
            }
        });

        final EventChannel behaviorActivatedEventChannel = new EventChannel(messenger, EVENT_BEHAVIOR_ACTIVATED);
        behaviorActivatedEventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink emitter) {
                FlutterDocumentActivity.setBehaviorActivatedEventEmitter(emitter);
            }

            @Override
            public void onCancel(Object arguments) {
                FlutterDocumentActivity.setBehaviorActivatedEventEmitter(null);
            }
        });

        final EventChannel longPressMenuPressedEventChannel = new EventChannel(messenger, EVENT_LONG_PRESS_MENU_PRESSED);
        longPressMenuPressedEventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink emitter) {
                FlutterDocumentActivity.setLongPressMenuPressedEventEmitter(emitter);
            }

            @Override
            public void onCancel(Object arguments) {
                FlutterDocumentActivity.setLongPressMenuPressedEventEmitter(null);
            }
        });

        final EventChannel leadingNavButtonPressedEventChannel = new EventChannel(messenger, EVENT_LEADING_NAV_BUTTON_PRESSED);
        leadingNavButtonPressedEventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink emitter) {
                FlutterDocumentActivity.setLeadingNavButtonPressedEventEmitter(emitter);
            }

            @Override
            public void onCancel(Object arguments) {
                FlutterDocumentActivity.setLeadingNavButtonPressedEventEmitter(null);
            }
        });

        final EventChannel annotationMenuPressedEventChannel = new EventChannel(messenger, EVENT_ANNOTATION_MENU_PRESSED);
        annotationMenuPressedEventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink emitter) {
                FlutterDocumentActivity.setAnnotationMenuPressedEventEmitter(emitter);
            }

            @Override
            public void onCancel(Object arguments) {
                FlutterDocumentActivity.setAnnotationMenuPressedEventEmitter(null);
            }
        });

        final EventChannel pageChangedEventChannel = new EventChannel(messenger, EVENT_PAGE_CHANGED);
        pageChangedEventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink emitter) {
                FlutterDocumentActivity.setPageChangedEventEmitter(emitter);
            }

            @Override
            public void onCancel(Object arguments) {
                FlutterDocumentActivity.setPageChangedEventEmitter(null);
            }
        });

        final EventChannel zoomChangedEventChannel = new EventChannel(messenger, EVENT_ZOOM_CHANGED);
        zoomChangedEventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink emitter) {
                FlutterDocumentActivity.setZoomChangedEventEmitter(emitter);
            }

            @Override
            public void onCancel(Object arguments) {
                FlutterDocumentActivity.setZoomChangedEventEmitter(null);
            }
        });

        final EventChannel pageMovedEventChanel = new EventChannel(messenger, EVENT_PAGE_MOVED);
        pageMovedEventChanel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink emitter) {
                FlutterDocumentActivity.setPageMovedEventEmitter(emitter);
            }

            @Override
            public void onCancel(Object arguments) {
                FlutterDocumentActivity.setPageMovedEventEmitter(null);
            }
        });
    }
}
