package com.pdftron.pdftronflutter;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import androidx.annotation.DrawableRes;
import androidx.annotation.Nullable;

import com.pdftron.pdf.PDFDoc;
import com.pdftron.pdf.PDFViewCtrl;
import com.pdftron.pdf.config.ViewerConfig;
import com.pdftron.pdf.controls.DocumentActivity;
import com.pdftron.pdf.controls.PdfViewCtrlTabFragment2;
import com.pdftron.pdf.controls.PdfViewCtrlTabHostFragment2;
import com.pdftron.pdf.tools.ToolManager;

import org.json.JSONObject;

import java.util.concurrent.atomic.AtomicReference;

import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.MethodChannel.Result;

import static com.pdftron.pdftronflutter.PluginUtils.handleDocumentLoaded;
import static com.pdftron.pdftronflutter.PluginUtils.handleOpenDocError;

public class FlutterDocumentActivity extends DocumentActivity implements ViewActivityComponent {

    private static FlutterDocumentActivity sCurrentActivity;
    private static AtomicReference<Result> sFlutterLoadResult = new AtomicReference<>();

    private static AtomicReference<EventSink> sExportAnnotationCommandEventEmitter = new AtomicReference<>();
    private static AtomicReference<EventSink> sExportBookmarkEventEmitter = new AtomicReference<>();
    private static AtomicReference<EventSink> sDocumentLoadedEventEmitter = new AtomicReference<>();

    public static void openDocument(Context packageContext, Uri fileUri, String password, @Nullable JSONObject customHeaders, @Nullable ViewerConfig config) {
        openDocument(packageContext, fileUri, password, customHeaders, config, DEFAULT_NAV_ICON_ID);
    }

    public static void openDocument(Context packageContext, Uri fileUri, String password, @Nullable JSONObject customHeaders, @Nullable ViewerConfig config, @DrawableRes int navIconId) {
        Intent intent = new Intent(packageContext, FlutterDocumentActivity.class);
        if (null != fileUri) {
            intent.putExtra("extra_file_uri", fileUri);
        }

        if (null != password) {
            intent.putExtra("extra_file_password", password);
        }

        if (null != customHeaders) {
            intent.putExtra("extra_custom_headers", customHeaders.toString());
        }

        intent.putExtra("extra_nav_icon", navIconId);
        intent.putExtra("extra_config", config);
        intent.putExtra(EXTRA_NEW_UI, true);
        packageContext.startActivity(intent);
    }

    public static void setExportAnnotationCommandEventEmitter(EventSink emitter) {
        sExportAnnotationCommandEventEmitter.set(emitter);
    }

    public static void setExportBookmarkEventEmitter(EventSink emitter) {
        sExportBookmarkEventEmitter.set(emitter);
    }

    public static void setDocumentLoadedEventEmitter(EventSink emitter) {
        sDocumentLoadedEventEmitter.set(emitter);
    }

    public static void setFlutterLoadResult(Result result) {
        sFlutterLoadResult.set(result);
    }

    public EventSink getExportAnnotationCommandEventEmitter() {
        return sExportAnnotationCommandEventEmitter.get();
    }

    public EventSink getExportBookmarkEventEmitter() {
        return sExportBookmarkEventEmitter.get();
    }

    public EventSink getDocumentLoadedEventEmitter() {
        return sDocumentLoadedEventEmitter.get();
    }

    public Result getFlutterLoadResult() {
        return sFlutterLoadResult.getAndSet(null);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        attachActivity();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();

        detachActivity();
    }

    @Override
    public void onTabDocumentLoaded(String tag) {
        super.onTabDocumentLoaded(tag);

        handleDocumentLoaded(this);
    }

    @Override
    public boolean onOpenDocError() {
        super.onOpenDocError();

        return handleOpenDocError(this);
    }

    private void attachActivity() {
        sCurrentActivity = this;
    }

    private void detachActivity() {
        Result result = sFlutterLoadResult.getAndSet(null);
        if (result != null) {
            result.success(false);
        }
        sCurrentActivity = null;
    }

    public static FlutterDocumentActivity getCurrentActivity() {
        return sCurrentActivity;
    }

    // Convenience

    @Nullable
    public PdfViewCtrlTabHostFragment2 getPdfViewCtrlTabHostFragment() {
        return mPdfViewCtrlTabHostFragment2;
    }

    @Nullable
    public PdfViewCtrlTabFragment2 getPdfViewCtrlTabFragment() {
        if (mPdfViewCtrlTabHostFragment2 != null) {
            return mPdfViewCtrlTabHostFragment2.getCurrentPdfViewCtrlFragment();
        }
        return null;
    }

    @Nullable
    public PDFViewCtrl getPdfViewCtrl() {
        if (getPdfViewCtrlTabFragment() != null) {
            return getPdfViewCtrlTabFragment().getPDFViewCtrl();
        }
        return null;
    }

    @Nullable
    public ToolManager getToolManager() {
        if (getPdfViewCtrlTabFragment() != null) {
            return getPdfViewCtrlTabFragment().getToolManager();
        }
        return null;
    }

    @Nullable
    public PDFDoc getPdfDoc() {
        if (getPdfViewCtrlTabFragment() != null) {
            return getPdfViewCtrlTabFragment().getPdfDoc();
        }
        return null;
    }
}
