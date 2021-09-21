package com.pdftron.pdftronflutter.helpers;

import android.content.Context;

import com.pdftron.common.PDFNetException;
import com.pdftron.pdf.PDFNet;
import com.pdftron.pdftronflutter.FlutterDocumentActivity;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import static com.pdftron.pdftronflutter.helpers.PluginUtils.FUNCTION_GET_PLATFORM_VERSION;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.FUNCTION_GET_VERSION;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.FUNCTION_INITIALIZE;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.FUNCTION_OPEN_DOCUMENT;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.FUNCTION_SET_LEADING_NAV_BUTTON_ICON;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.FUNCTION_SET_REQUESTED_ORIENTATION;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.KEY_CONFIG;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.KEY_DOCUMENT;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.KEY_LEADING_NAV_BUTTON_ICON;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.KEY_LICENSE_KEY;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.KEY_PASSWORD;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.KEY_REQUESTED_ORIENTATION;

public class PluginMethodCallHandler implements MethodCallHandler {

    private final Context mContext;

    public PluginMethodCallHandler(Context context) {
        mContext = context;
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
                FlutterDocumentActivity.openDocument(mContext, document, password, config);
                break;
            case FUNCTION_SET_LEADING_NAV_BUTTON_ICON: {
                String leadingNavButtonIcon = call.argument(KEY_LEADING_NAV_BUTTON_ICON);
                FlutterDocumentActivity.setLeadingNavButtonIcon(leadingNavButtonIcon);
                break;
            }
            case FUNCTION_SET_REQUESTED_ORIENTATION: {
                int requestedOrientation = call.argument(KEY_REQUESTED_ORIENTATION);
                FlutterDocumentActivity.setOrientation(requestedOrientation);
                break;
            }
            default:
                PluginUtils.onMethodCall(call, result, FlutterDocumentActivity.getCurrentActivity());
                break;
        }
    }
}
