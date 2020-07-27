package com.pdftron.pdftronflutter;

import android.content.Context;
import android.net.Uri;

import com.pdftron.common.PDFNetException;
import com.pdftron.pdf.PDFNet;
import com.pdftron.pdf.config.ToolManagerBuilder;
import com.pdftron.pdf.config.ViewerConfig;
import com.pdftron.pdf.tools.ToolManager;
import com.pdftron.pdftronflutter.factories.DocumentViewFactory;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Objects;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import static com.pdftron.pdftronflutter.PluginUtils.customHeaders;
import static com.pdftron.pdftronflutter.PluginUtils.disabledElements;
import static com.pdftron.pdftronflutter.PluginUtils.disabledTools;
import static com.pdftron.pdftronflutter.PluginUtils.multiTabEnabled;

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

        final EventChannel annotEventChannel = new EventChannel(registrar.messenger(), "export_annotation_command_event");
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

        final EventChannel bookmarkEventChannel = new EventChannel(registrar.messenger(), "export_bookmark_event");
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

        registrar.platformViewRegistry().registerViewFactory("pdftron_flutter/documentview", new DocumentViewFactory(registrar.messenger(), registrar.activeContext()));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch (call.method) {
            case "getPlatformVersion":
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;
            case "getVersion":
                try {
                    String pdftronVersion = Double.toString(PDFNet.getVersion());
                    result.success(pdftronVersion);
                } catch (PDFNetException e) {
                    e.printStackTrace();
                    result.error(Long.toString(e.getErrorCode()), "PDFTronException Error: " + e, null);
                }
                break;
            case "initialize":
                try {
                    String licenseKey = call.argument("licenseKey");
                    com.pdftron.pdf.utils.AppUtils.initializePDFNetApplication(mContext.getApplicationContext(), licenseKey);
                    result.success(null);
                } catch (PDFNetException e) {
                    e.printStackTrace();
                    result.error(Long.toString(e.getErrorCode()), "PDFTronException Error: " + e, null);
                }
                break;
            case "openDocument":
                String document = call.argument("document");
                String password = call.argument("password");
                String config = call.argument("config");
                FlutterDocumentActivity.setFlutterLoadResult(result);
                openDocument(document, password, config);
                break;
            case "importAnnotationCommand": {
                FlutterDocumentActivity flutterDocumentActivity = FlutterDocumentActivity.getCurrentActivity();
                Objects.requireNonNull(flutterDocumentActivity);
                Objects.requireNonNull(flutterDocumentActivity.getPdfDoc());
                String xfdfCommand = call.argument("xfdfCommand");
                try {
                    flutterDocumentActivity.importAnnotationCommand(xfdfCommand, result);
                } catch (PDFNetException ex) {
                    ex.printStackTrace();
                    result.error(Long.toString(ex.getErrorCode()), "PDFTronException Error: " + ex, null);
                }
                break;
            }
            case "importBookmarkJson": {
                FlutterDocumentActivity flutterDocumentActivity = FlutterDocumentActivity.getCurrentActivity();
                Objects.requireNonNull(flutterDocumentActivity);
                Objects.requireNonNull(flutterDocumentActivity.getPdfDoc());
                String bookmarkJson = call.argument("bookmarkJson");
                try {
                    flutterDocumentActivity.importBookmarkJson(bookmarkJson, result);
                } catch (JSONException ex) {
                    ex.printStackTrace();
                    result.error(Integer.toString(ex.hashCode()), "JSONException Error: " + ex, null);
                }
                break;
            }
            case "saveDocument": {
                FlutterDocumentActivity flutterDocumentActivity = FlutterDocumentActivity.getCurrentActivity();
                Objects.requireNonNull(flutterDocumentActivity);
                Objects.requireNonNull(flutterDocumentActivity.getPdfDoc());
                flutterDocumentActivity.saveDocument(result);
                break;
            }
            default:
                result.notImplemented();
                break;
        }
    }

    private void openDocument(String document, String password, String configStr) {
        ViewerConfig.Builder builder = new ViewerConfig.Builder()
                .multiTabEnabled(false)
                .openUrlCachePath(mContext.getCacheDir().getAbsolutePath());

        ToolManagerBuilder toolManagerBuilder = ToolManagerBuilder.from();

        JSONObject customHeaderJson = null;
        if (configStr != null && !configStr.equals("null")) {
            try {
                JSONObject configJson = new JSONObject(configStr);
                if (!configJson.isNull(disabledElements)) {
                    JSONArray array = configJson.getJSONArray(disabledElements);
                    mDisabledTools.addAll(PluginUtils.disableElements(builder, array));
                }
                if (!configJson.isNull(disabledTools)) {
                    JSONArray array = configJson.getJSONArray(disabledTools);
                    mDisabledTools.addAll(PluginUtils.disableTools(array));
                }
                if (!configJson.isNull(multiTabEnabled)) {
                    boolean val = configJson.getBoolean(multiTabEnabled);
                    builder = builder.multiTabEnabled(val);
                }
                if (!configJson.isNull(customHeaders)) {
                    customHeaderJson = configJson.getJSONObject(customHeaders);
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
