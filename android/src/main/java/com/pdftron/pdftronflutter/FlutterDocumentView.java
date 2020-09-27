package com.pdftron.pdftronflutter;

import android.content.Context;
import android.net.Uri;
import android.view.View;

import com.pdftron.pdf.config.ToolManagerBuilder;
import com.pdftron.pdf.config.ViewerBuilder;
import com.pdftron.pdf.config.ViewerConfig;
import com.pdftron.pdf.tools.ToolManager;
import com.pdftron.pdftronflutter.views.DocumentView;

import org.json.JSONArray;
import org.json.JSONObject;

import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentManager;

import java.util.ArrayList;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

import static com.pdftron.pdftronflutter.PluginUtils.*;

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
                .openUrlCachePath(documentView.getContext().getCacheDir().getAbsolutePath());

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
