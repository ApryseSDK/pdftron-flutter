package com.pdftron.pdftronflutter;

import android.content.Context;
import android.net.Uri;
import android.view.View;

import com.pdftron.common.PDFNetException;
import com.pdftron.pdf.config.ToolManagerBuilder;
import com.pdftron.pdf.config.ViewerBuilder;
import com.pdftron.pdf.config.ViewerConfig;
import com.pdftron.pdf.tools.ToolManager;
import com.pdftron.pdftronflutter.views.DocumentView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentManager;

import java.util.ArrayList;
import java.util.Objects;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

import static com.pdftron.pdftronflutter.PluginUtils.customHeaders;
import static com.pdftron.pdftronflutter.PluginUtils.disabledElements;
import static com.pdftron.pdftronflutter.PluginUtils.disabledTools;
import static com.pdftron.pdftronflutter.PluginUtils.multiTabEnabled;

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
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            case "openDocument":
                String document = call.argument("document");
                String password = call.argument("password");
                String config = call.argument("config");
                openDocument(document, password, config, result);
                break;
            case "importAnnotationCommand": {
                Objects.requireNonNull(documentView);
                Objects.requireNonNull(documentView.getPdfDoc());
                String xfdfCommand = call.argument("xfdfCommand");
                try {
                    documentView.importAnnotationCommand(xfdfCommand, result);
                } catch (PDFNetException ex) {
                    ex.printStackTrace();
                    result.error(Long.toString(ex.getErrorCode()), "PDFTronException Error: " + ex, null);
                }
                break;
            }
            case "importBookmarkJson": {
                Objects.requireNonNull(documentView);
                Objects.requireNonNull(documentView.getPdfDoc());
                String bookmarkJson = call.argument("bookmarkJson");
                try {
                    documentView.importBookmarkJson(bookmarkJson, result);
                } catch (JSONException ex) {
                    ex.printStackTrace();
                    result.error(Integer.toString(ex.hashCode()), "JSONException Error: " + ex, null);
                }
                break;
            }
            case "saveDocument": {
                Objects.requireNonNull(documentView);
                Objects.requireNonNull(documentView.getPdfDoc());
                documentView.saveDocument(result);
                break;
            }
            case "getPageCropBox":
                Objects.requireNonNull(documentView);
                Objects.requireNonNull(documentView.getPdfDoc());

                Integer pageNumber = call.argument("pageNumber");
                if (pageNumber != null) {
                    try {
                        documentView.getPageCropBox(pageNumber, result);
                    } catch (JSONException ex) {
                        ex.printStackTrace();
                        result.error(Integer.toString(ex.hashCode()), "JSONException Error: " + ex, null);
                    } catch (PDFNetException ex) {
                        ex.printStackTrace();
                        result.error(Long.toString(ex.getErrorCode()), "PDFTronException Error: " + ex, null);
                    }
                }
                break;
            default:
                result.notImplemented();
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
