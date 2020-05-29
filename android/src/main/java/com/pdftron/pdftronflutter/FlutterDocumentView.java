package com.pdftron.pdftronflutter;

import android.content.Context;
import android.net.Uri;
import android.view.View;

import com.pdftron.pdf.config.ViewerBuilder;
import com.pdftron.pdf.config.ViewerConfig;
import com.pdftron.pdftronflutter.views.DocumentView;

import org.json.JSONArray;
import org.json.JSONObject;

import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentManager;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

import static com.pdftron.pdftronflutter.PluginUtils.disabledElements;
import static com.pdftron.pdftronflutter.PluginUtils.disabledTools;

public class FlutterDocumentView implements PlatformView, MethodChannel.MethodCallHandler {

    private final DocumentView documentView;

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
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        switch (methodCall.method) {
            case "openDocument":
                String document = methodCall.argument("document");
                String password = methodCall.argument("password");
                String config = methodCall.argument("config");
                openDocument(document, password, config);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void openDocument(String document, String password, String configStr) {
        if (null == documentView) {
            return;
        }
        ViewerConfig.Builder configBuilder = new ViewerConfig.Builder()
                .multiTabEnabled(false)
                .openUrlCachePath(documentView.getContext().getCacheDir().getAbsolutePath());

        if (configStr != null && !configStr.equals("null")) {
            try {
                JSONObject configJson = new JSONObject(configStr);
                if (configJson.has(disabledElements)) {
                    JSONArray array = configJson.getJSONArray(disabledElements);
                    configBuilder = PluginUtils.disableElements(configBuilder, array);
                }
                if (configJson.has(disabledTools)) {
                    JSONArray array = configJson.getJSONArray(disabledTools);
                    configBuilder = PluginUtils.disableTools(configBuilder, array);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }

        final Uri fileLink = Uri.parse(document);

        documentView.setDocumentUri(fileLink);
        documentView.setPassword(password);
        documentView.setViewerConfig(configBuilder.build());

        ViewerBuilder viewerBuilder = ViewerBuilder.withUri(fileLink, password)
                .usingConfig(configBuilder.build());
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
    }

    @Override
    public View getView() {
        return documentView;
    }

    @Override
    public void dispose() {
    }
}
