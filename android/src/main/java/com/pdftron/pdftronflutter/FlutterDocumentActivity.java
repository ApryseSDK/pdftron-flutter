package com.pdftron.pdftronflutter;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import androidx.annotation.DrawableRes;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.pdftron.pdf.Annot;
import com.pdftron.pdf.PDFDoc;
import com.pdftron.pdf.PDFViewCtrl;
import com.pdftron.pdf.config.ViewerConfig;
import com.pdftron.pdf.controls.DocumentActivity;
import com.pdftron.pdf.controls.PdfViewCtrlTabFragment;
import com.pdftron.pdf.controls.PdfViewCtrlTabHostFragment;
import com.pdftron.pdf.tools.ToolManager;
import com.pdftron.pdftronflutter.helpers.PluginUtils;
import com.pdftron.pdftronflutter.helpers.ViewerComponent;
import com.pdftron.pdftronflutter.helpers.ViewerImpl;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.concurrent.atomic.AtomicReference;

import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.MethodChannel.Result;

public class FlutterDocumentActivity extends DocumentActivity implements ViewerComponent {

    private ViewerImpl mImpl = new ViewerImpl(this);

    private static FlutterDocumentActivity sCurrentActivity;
    private static AtomicReference<Result> sFlutterLoadResult = new AtomicReference<>();

    private static AtomicReference<EventSink> sExportAnnotationCommandEventEmitter = new AtomicReference<>();
    private static AtomicReference<EventSink> sExportBookmarkEventEmitter = new AtomicReference<>();
    private static AtomicReference<EventSink> sDocumentLoadedEventEmitter = new AtomicReference<>();
    private static AtomicReference<EventSink> sDocumentErrorEventEmitter = new AtomicReference<>();
    private static AtomicReference<EventSink> sAnnotationChangedEventEmitter = new AtomicReference<>();
    private static AtomicReference<EventSink> sAnnotationsSelectionEventEmitter = new AtomicReference<>();
    private static AtomicReference<EventSink> sFormFieldChangedEventEmitter = new AtomicReference<>();

    private static HashMap<Annot, Integer> mSelectedAnnots;

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

    public static void setDocumentErrorEventEmitter(EventSink emitter) {
        sDocumentErrorEventEmitter.set(emitter);
    }

    public static void setAnnotationChangedEventEmitter(EventSink emitter) {
        sAnnotationChangedEventEmitter.set(emitter);
    }

    public static void setAnnotationsSelectionEventEmitter(EventSink emitter) {
        sAnnotationsSelectionEventEmitter.set(emitter);
    }

    public static void setFormFieldValueChangedEventEmitter(EventSink emitter) {
        sFormFieldChangedEventEmitter.set(emitter);
    }

    public static void setFlutterLoadResult(Result result) {
        sFlutterLoadResult.set(result);
    }

    public void setSelectedAnnots(HashMap<Annot, Integer> selectedAnnots) {
        mSelectedAnnots = selectedAnnots;
    }

    @Override
    public EventSink getExportAnnotationCommandEventEmitter() {
        return sExportAnnotationCommandEventEmitter.get();
    }

    @Override
    public EventSink getExportBookmarkEventEmitter() {
        return sExportBookmarkEventEmitter.get();
    }

    @Override
    public EventSink getDocumentLoadedEventEmitter() {
        return sDocumentLoadedEventEmitter.get();
    }

    @Override
    public EventSink getDocumentErrorEventEmitter() {
        return sDocumentErrorEventEmitter.get();
    }

    public EventSink getAnnotationChangedEventEmitter() {
        return sAnnotationChangedEventEmitter.get();
    }

    @Override
    public EventSink getAnnotationsSelectedEventEmitter() {
        return sAnnotationsSelectionEventEmitter.get();
    }

    @Override
    public EventSink getFormFieldValueChangedEventEmitter() {
        return sFormFieldChangedEventEmitter.get();
    }

    @Override
    public Result getFlutterLoadResult() {
        return sFlutterLoadResult.getAndSet(null);
    }

    @Override
    public HashMap<Annot, Integer> getSelectedAnnots() {
        return mSelectedAnnots;
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        attachActivity();
    }

    @Override
    protected void onDestroy() {
        PluginUtils.handleOnDetach(this);

        super.onDestroy();

        sExportAnnotationCommandEventEmitter.set(null);
        sExportBookmarkEventEmitter.set(null);
        sDocumentLoadedEventEmitter.set(null);
        sDocumentErrorEventEmitter.set(null);
        sAnnotationChangedEventEmitter.set(null);
        sAnnotationsSelectionEventEmitter.set(null);
        sFormFieldChangedEventEmitter.set(null);

        detachActivity();
    }

    @Override
    public void onTabDocumentLoaded(String tag) {
        super.onTabDocumentLoaded(tag);

        PluginUtils.handleDocumentLoaded(this);
    }

    @Override
    public boolean onOpenDocError() {
        super.onOpenDocError();

        return PluginUtils.handleOpenDocError(this);
    }

    private void attachActivity() {
        sCurrentActivity = this;
    }

    private void detachActivity() {
        sCurrentActivity = null;
    }

    public static FlutterDocumentActivity getCurrentActivity() {
        return sCurrentActivity;
    }

    // Convenience

    @Nullable
    public PdfViewCtrlTabHostFragment getPdfViewCtrlTabHostFragment() {
        return mPdfViewCtrlTabHostFragment;
    }

    @Nullable
    public PdfViewCtrlTabFragment getPdfViewCtrlTabFragment() {
        if (mPdfViewCtrlTabHostFragment != null) {
            return mPdfViewCtrlTabHostFragment.getCurrentPdfViewCtrlFragment();
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

    @NonNull
    @Override
    public ViewerImpl getImpl() {
        return mImpl;
    }
}
