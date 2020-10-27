package com.pdftron.pdftronflutter;

import android.content.Context;
import android.net.Uri;

import com.pdftron.common.PDFNetException;
import com.pdftron.pdf.PDFNet;
import com.pdftron.pdf.config.ToolManagerBuilder;
import com.pdftron.pdf.config.ViewerConfig;
import com.pdftron.pdf.tools.ToolManager;
import com.pdftron.pdf.utils.PdfViewCtrlSettingsManager;
import com.pdftron.pdf.utils.Utils;
import com.pdftron.pdftronflutter.factories.DocumentViewFactory;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import static com.pdftron.pdftronflutter.PluginUtils.*;

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
            case FUNCTION_INITALIZE:
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

        boolean showLeadingNavButton = true;
        int navButtonResId = 0;

        boolean readOnly = false;
        boolean thumbnailViewEditingEnabled = true;

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
                if (!configJson.isNull(KEY_CONFIG_SHOW_LEADING_NAV_BUTTON)) {
                    showLeadingNavButton = configJson.getBoolean(KEY_CONFIG_SHOW_LEADING_NAV_BUTTON);
                }
                if (!configJson.isNull(KEY_CONFIG_LEADING_NAV_BUTTON_ICON)) {
                    String navButtonIconPath = configJson.getString(KEY_CONFIG_LEADING_NAV_BUTTON_ICON);
                    navButtonResId = Utils.getResourceDrawable(mContext, navButtonIconPath);
                }
                if (!configJson.isNull(KEY_CONFIG_READ_ONLY)) {
                    readOnly = configJson.getBoolean(KEY_CONFIG_READ_ONLY);
                }
                if (!configJson.isNull(KEY_CONFIG_THUMBNAIL_VIEW_EDITING_ENABLED)) {
                    thumbnailViewEditingEnabled = configJson.getBoolean(KEY_CONFIG_THUMBNAIL_VIEW_EDITING_ENABLED);
                }
                if (!configJson.isNull(KEY_CONFIG_ANNOTATION_AUTHOR)) {
                    String annotationAuthor = configJson.getString(KEY_CONFIG_ANNOTATION_AUTHOR);
                    if (!Utils.isNullOrEmpty(annotationAuthor)) {
                        PdfViewCtrlSettingsManager.updateAuthorName(mContext, annotationAuthor);
                        PdfViewCtrlSettingsManager.setAnnotListShowAuthor(mContext, true);
                    }
                }
                if (!configJson.isNull(KEY_CONFIG_CONTINUOUS_ANNOTATION_EDITING)) {
                    boolean continuousAnnotationEditing = configJson.getBoolean(KEY_CONFIG_CONTINUOUS_ANNOTATION_EDITING);
                    PdfViewCtrlSettingsManager.setContinuousAnnotationEdit(mContext, continuousAnnotationEditing);
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

        builder = builder.toolManagerBuilder(toolManagerBuilder)
                .documentEditingEnabled(!readOnly)
                .thumbnailViewEditingEnabled(thumbnailViewEditingEnabled);

        final Uri fileLink = Uri.parse(document);

        FlutterDocumentActivity.openDocument(mContext, fileLink, password, customHeaderJson, builder.build(), navButtonResId, showLeadingNavButton);
    }
}
