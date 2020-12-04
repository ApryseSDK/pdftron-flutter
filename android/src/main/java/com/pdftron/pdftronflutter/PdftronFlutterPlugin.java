package com.pdftron.pdftronflutter;

import android.content.Context;
import android.net.Uri;

import com.pdftron.common.PDFNetException;
import com.pdftron.pdf.PDFNet;
import com.pdftron.pdf.config.ToolManagerBuilder;
import com.pdftron.pdf.config.ViewerConfig;
import com.pdftron.pdf.tools.ToolManager;
import com.pdftron.pdftronflutter.factories.DocumentViewFactory;
import com.pdftron.pdftronflutter.helpers.PluginUtils;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

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
import static com.pdftron.pdftronflutter.helpers.PluginUtils.FUNCTION_GET_PLATFORM_VERSION;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.FUNCTION_GET_VERSION;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.FUNCTION_INITIALIZE;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.FUNCTION_OPEN_DOCUMENT;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.KEY_CONFIG;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.KEY_CONFIG_CUSTOM_HEADERS;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.KEY_CONFIG_DISABLED_ELEMENTS;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.KEY_CONFIG_DISABLED_TOOLS;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.KEY_CONFIG_MULTI_TAB_ENABLED;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.KEY_DOCUMENT;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.KEY_LICENSE_KEY;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.KEY_PASSWORD;

/**
 * PdftronFlutterPlugin
 */
public class PdftronFlutterPlugin implements MethodCallHandler {

    private final Context mContext;

    private ArrayList<ToolManager.ToolMode> mDisabledTools = new ArrayList<>();

    public PdftronFlutterPlugin(Context context) {
        mContext = context;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel methodChannel = new MethodChannel(registrar.messenger(), "pdftron_flutter");
        methodChannel.setMethodCallHandler(new PdftronFlutterPlugin(registrar.activeContext()));

        final EventChannel annotEventChannel = new EventChannel(registrar.messenger(), EVENT_EXPORT_ANNOTATION_COMMAND);
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

        final EventChannel bookmarkEventChannel = new EventChannel(registrar.messenger(), EVENT_EXPORT_BOOKMARK);
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

        final EventChannel documentLoadedEventChannel = new EventChannel(registrar.messenger(), EVENT_DOCUMENT_LOADED);
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

        final EventChannel documentErrorEventChannel = new EventChannel(registrar.messenger(), EVENT_DOCUMENT_ERROR);
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

        final EventChannel annotationChangedEventChannel = new EventChannel(registrar.messenger(), EVENT_ANNOTATION_CHANGED);
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

        final EventChannel annotationSelectedEventChannel = new EventChannel(registrar.messenger(), EVENT_ANNOTATIONS_SELECTED);
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

        final EventChannel formFieldValueChangedEventChannel = new EventChannel(registrar.messenger(), EVENT_FORM_FIELD_VALUE_CHANGED);
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

        final EventChannel leadingNavButtonPressedEventChannel = new EventChannel(registrar.messenger(), EVENT_LEADING_NAV_BUTTON_PRESSED);
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

        final EventChannel pageChangedEventChannel = new EventChannel(registrar.messenger(), EVENT_PAGE_CHANGED);
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

        final EventChannel zoomChangedEventChannel = new EventChannel(registrar.messenger(), EVENT_ZOOM_CHANGED);
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

        registrar.platformViewRegistry().registerViewFactory("pdftron_flutter/documentview", new DocumentViewFactory(registrar.messenger(), registrar.activeContext()));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case FUNCTION_GET_PLATFORM_VERSION:
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;
            case FUNCTION_GET_VERSION:
                try {
                    String pdftronVersion = Double.toString(PDFNet.getVersion());
                    result.success(pdftronVersion);
                } catch (PDFNetException e) {
                    e.printStackTrace();
                    result.error(Long.toString(e.getErrorCode()), "PDFTronException Error: " + e, null);
                }
                break;
            case FUNCTION_INITIALIZE:
                try {
                    String licenseKey = call.argument(KEY_LICENSE_KEY);
                    com.pdftron.pdf.utils.AppUtils.initializePDFNetApplication(mContext.getApplicationContext(), licenseKey);
                    result.success(null);
                } catch (PDFNetException e) {
                    e.printStackTrace();
                    result.error(Long.toString(e.getErrorCode()), "PDFTronException Error: " + e, null);
                }
                break;
            case FUNCTION_OPEN_DOCUMENT:
                String document = call.argument(KEY_DOCUMENT);
                String password = call.argument(KEY_PASSWORD);
                String config = call.argument(KEY_CONFIG);
                FlutterDocumentActivity.setFlutterLoadResult(result);
                openDocument(document, password, config);
                break;
            default:
                PluginUtils.onMethodCall(call, result, FlutterDocumentActivity.getCurrentActivity());
                break;
        }
    }

    private void openDocument(String document, String password, String configStr) {
        ViewerConfig.Builder builder = new ViewerConfig.Builder()
                .multiTabEnabled(false)
                .saveCopyExportPath(mContext.getCacheDir().getAbsolutePath())
                .openUrlCachePath(mContext.getCacheDir().getAbsolutePath());

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
        FlutterDocumentActivity.openDocument(mContext, fileLink, password, customHeaderJson, builder.build());
    }
}
