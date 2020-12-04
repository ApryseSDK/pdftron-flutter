package com.pdftron.pdftronflutter;

import android.content.Context;
import android.net.Uri;
import android.view.View;

import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentManager;

import com.pdftron.pdf.config.ToolManagerBuilder;
import com.pdftron.pdf.config.ViewerBuilder;
import com.pdftron.pdf.config.ViewerConfig;
import com.pdftron.pdf.tools.ToolManager;
import com.pdftron.pdftronflutter.helpers.PluginUtils;
import com.pdftron.pdftronflutter.views.DocumentView;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

import static com.pdftron.pdftronflutter.helpers.PluginUtils.EVENT_ANNOTATIONS_SELECTED;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.EVENT_ANNOTATION_CHANGED;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.EVENT_DOCUMENT_ERROR;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.EVENT_DOCUMENT_LOADED;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.EVENT_EXPORT_ANNOTATION_COMMAND;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.EVENT_EXPORT_BOOKMARK;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.EVENT_FORM_FIELD_VALUE_CHANGED;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.EVENT_LEADING_NAV_BUTTON_PRESSED;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.EVENT_PAGE_CHANGED;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.EVENT_ZOOM_CHANGED;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.FUNCTION_OPEN_DOCUMENT;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.KEY_CONFIG_CUSTOM_HEADERS;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.KEY_CONFIG_DISABLED_ELEMENTS;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.KEY_CONFIG_DISABLED_TOOLS;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.KEY_CONFIG_MULTI_TAB_ENABLED;

public class FlutterDocumentView implements PlatformView, MethodChannel.MethodCallHandler {

    private final DocumentView documentView;
    private ArrayList<ToolManager.ToolMode> mDisabledTools = new ArrayList<>();

    private final MethodChannel methodChannel;

    public FlutterDocumentView(Context context, Context activityContext, BinaryMessenger messenger, int id) {
        documentView = new DocumentView(context);

        FragmentManager manager = null;
        if (activityContext instanceof FragmentActivity) {
            manager = ((FragmentActivity) activityContext).getSupportFragmentManager();
        }

        documentView.setSupportFragmentManager(manager);

        methodChannel = new MethodChannel(messenger, "pdftron_flutter/documentview_" + id);
        methodChannel.setMethodCallHandler(this);

        registerWith(messenger);
    }

    public void registerWith(BinaryMessenger messenger) {

        final EventChannel annotEventChannel = new EventChannel(messenger, EVENT_EXPORT_ANNOTATION_COMMAND);
        annotEventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink emitter) {
                documentView.setExportAnnotationCommandEventEmitter(emitter);
            }

            @Override
            public void onCancel(Object arguments) {
                documentView.setExportAnnotationCommandEventEmitter(null);
            }
        });

        final EventChannel bookmarkEventChannel = new EventChannel(messenger, EVENT_EXPORT_BOOKMARK);
        bookmarkEventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink emitter) {
                documentView.setExportBookmarkEventEmitter(emitter);
            }

            @Override
            public void onCancel(Object arguments) {
                documentView.setExportBookmarkEventEmitter(null);
            }
        });

        final EventChannel documentLoadedEventChannel = new EventChannel(messenger, EVENT_DOCUMENT_LOADED);
        documentLoadedEventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink emitter) {
                documentView.setDocumentLoadedEventEmitter(emitter);
            }

            @Override
            public void onCancel(Object arguments) {
                documentView.setDocumentLoadedEventEmitter(null);
            }
        });

        final EventChannel documentErrorEventChannel = new EventChannel(messenger, EVENT_DOCUMENT_ERROR);
        documentErrorEventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink emitter) {
                documentView.setDocumentErrorEventEmitter(emitter);
            }

            @Override
            public void onCancel(Object arguments) {
                documentView.setDocumentErrorEventEmitter(null);
            }
        });

        final EventChannel annotationChangedEventChannel = new EventChannel(messenger, EVENT_ANNOTATION_CHANGED);
        annotationChangedEventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink emitter) {
                documentView.setAnnotationChangedEventEmitter(emitter);
            }

            @Override
            public void onCancel(Object arguments) {
                documentView.setAnnotationChangedEventEmitter(null);
            }
        });

        final EventChannel annotationSelectedEventChannel = new EventChannel(messenger, EVENT_ANNOTATIONS_SELECTED);
        annotationSelectedEventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink emitter) {
                documentView.setAnnotationsSelectedEventEmitter(emitter);
            }

            @Override
            public void onCancel(Object arguments) {
                documentView.setAnnotationsSelectedEventEmitter(null);
            }
        });

        final EventChannel formFieldValueChangedEventChannel = new EventChannel(messenger, EVENT_FORM_FIELD_VALUE_CHANGED);
        formFieldValueChangedEventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink emitter) {
                documentView.setFormFieldValueChangedEventEmitter(emitter);
            }

            @Override
            public void onCancel(Object arguments) {
                documentView.setFormFieldValueChangedEventEmitter(null);
            }
        });

        final EventChannel leadingNavButtonPressedEventChannel = new EventChannel(messenger, EVENT_LEADING_NAV_BUTTON_PRESSED);
        leadingNavButtonPressedEventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink emitter) {
                documentView.setLeadingNavButtonPressedEventEmitter(emitter);
            }

            @Override
            public void onCancel(Object arguments) {
                documentView.setLeadingNavButtonPressedEventEmitter(null);
            }
        });

        final EventChannel pageChangedEventChannel = new EventChannel(messenger, EVENT_PAGE_CHANGED);
        pageChangedEventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink emitter) {
                documentView.setPageChangedEventEmitter(emitter);
            }

            @Override
            public void onCancel(Object arguments) {
                documentView.setPageChangedEventEmitter(null);
            }
        });

        final EventChannel zoomChangedEventChannel = new EventChannel(messenger, EVENT_ZOOM_CHANGED);
        zoomChangedEventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink emitter) {
                documentView.setZoomChangedEventEmitter(emitter);
            }

            @Override
            public void onCancel(Object arguments) {
                documentView.setZoomChangedEventEmitter(null);
            }
        });
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            case FUNCTION_OPEN_DOCUMENT:
                String document = call.argument("document");
                String password = call.argument("password");
                String config = call.argument("config");
                openDocument(document, password, config, result);
                break;
            default:
                PluginUtils.onMethodCall(call, result, documentView);
                break;
        }
    }

    private void openDocument(String document, String password, String configStr, MethodChannel.Result result) {
        if (null == documentView) {
            return;
        }

        ViewerConfig.Builder builder = new ViewerConfig.Builder()
                .multiTabEnabled(false)
                .useSupportActionBar(false)
                .openUrlCachePath(documentView.getContext().getCacheDir().getAbsolutePath())
                .saveCopyExportPath(documentView.getContext().getCacheDir().getAbsolutePath());

        ToolManagerBuilder toolManagerBuilder = ToolManagerBuilder.from();

        JSONObject customHeaderJson = null;
        if (configStr != null && !configStr.equals("null")) {
            try {
                JSONObject configJson = new JSONObject(configStr);
                if (!configJson.isNull(KEY_CONFIG_DISABLED_ELEMENTS)) {
                    JSONArray array = configJson.getJSONArray(KEY_CONFIG_DISABLED_ELEMENTS);
                    mDisabledTools.addAll(PluginUtils.disableElements(builder, array));
                }
                if (!configJson.isNull(KEY_CONFIG_DISABLED_TOOLS)) {
                    JSONArray array = configJson.getJSONArray(KEY_CONFIG_DISABLED_TOOLS);
                    mDisabledTools.addAll(PluginUtils.disableTools(array));
                }
                if (!configJson.isNull(KEY_CONFIG_MULTI_TAB_ENABLED)) {
                    boolean val = configJson.getBoolean(KEY_CONFIG_MULTI_TAB_ENABLED);
                    builder = builder.multiTabEnabled(val);
                }
                if (!configJson.isNull(KEY_CONFIG_CUSTOM_HEADERS)) {
                    customHeaderJson = configJson.getJSONObject(KEY_CONFIG_CUSTOM_HEADERS);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }

        if (mDisabledTools.size() > 0) {
            ToolManager.ToolMode[] modes = mDisabledTools.toArray(new ToolManager.ToolMode[0]);
            if (modes.length > 0) {
                toolManagerBuilder = toolManagerBuilder.disableToolModes(modes);
            }
        }

        builder = builder.toolManagerBuilder(toolManagerBuilder);

        final Uri fileLink = Uri.parse(document);

        documentView.setDocumentUri(fileLink);
        documentView.setPassword(password);
        documentView.setCustomHeaders(customHeaderJson);
        documentView.setViewerConfig(builder.build());
        documentView.setFlutterLoadResult(result);

        ViewerBuilder viewerBuilder = ViewerBuilder.withUri(fileLink, password)
                .usingCustomHeaders(customHeaderJson)
                .usingConfig(builder.build());
        if (documentView.mPdfViewCtrlTabHostFragment != null) {
            documentView.mPdfViewCtrlTabHostFragment.onOpenAddNewTab(viewerBuilder.createBundle(documentView.getContext()));
        } else {
            documentView.mPdfViewCtrlTabHostFragment = viewerBuilder.build(documentView.getContext());
            if (documentView.mFragmentManager != null) {
                documentView.mFragmentManager.beginTransaction().add(documentView.mPdfViewCtrlTabHostFragment, "document_view").commitNow();
                View fragmentView = documentView.mPdfViewCtrlTabHostFragment.getView();
                if (fragmentView != null) {
                    documentView.addView(fragmentView, -1, -1);
                }
            }
        }
        documentView.attachListeners();
    }

    @Override
    public View getView() {
        return documentView;
    }

    @Override
    public void dispose() {
    }
}
