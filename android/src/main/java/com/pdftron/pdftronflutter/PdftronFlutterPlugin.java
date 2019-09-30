package com.pdftron.pdftronflutter;

import android.content.Context;
import android.net.Uri;

import com.pdftron.common.PDFNetException;
import com.pdftron.pdf.PDFNet;
import com.pdftron.pdf.config.ViewerConfig;
import com.pdftron.pdf.controls.DocumentActivity;
import com.pdftron.pdftronflutter.factories.DocumentViewFactory;

import org.json.JSONArray;
import org.json.JSONObject;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import static com.pdftron.pdftronflutter.PluginUtils.disabledElements;
import static com.pdftron.pdftronflutter.PluginUtils.disabledTools;

/**
 * PdftronFlutterPlugin
 */
public class PdftronFlutterPlugin implements MethodCallHandler {
    private final Context mContext;

    public PdftronFlutterPlugin(Context context) {
        mContext = context;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "pdftron_flutter");
        channel.setMethodCallHandler(new PdftronFlutterPlugin(registrar.activeContext()));


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
                } catch (PDFNetException e) {
                    e.printStackTrace();
                    result.error(Long.toString(e.getErrorCode()), "PDFTronException Error: " + e, null);
                }
                break;
            case "openDocument":
                String document = call.argument("document");
                String password = call.argument("password");
                String config = call.argument("config");
                openDocument(document, password, config);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void openDocument(String document, String password, String configStr) {
        ViewerConfig.Builder builder = new ViewerConfig.Builder()
                .multiTabEnabled(false)
                .openUrlCachePath(mContext.getCacheDir().getAbsolutePath());

        if (configStr != null && !configStr.equals("null")) {
            try {
                JSONObject configJson = new JSONObject(configStr);
                if (configJson.has(disabledElements)) {
                    JSONArray array = configJson.getJSONArray(disabledElements);
                    builder = PluginUtils.disableElements(builder, array);
                }
                if (configJson.has(disabledTools)) {
                    JSONArray array = configJson.getJSONArray(disabledTools);
                    builder = PluginUtils.disableTools(builder, array);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }

        final Uri fileLink = Uri.parse(document);
        DocumentActivity.openDocument(mContext, fileLink, password, builder.build());
    }
}
