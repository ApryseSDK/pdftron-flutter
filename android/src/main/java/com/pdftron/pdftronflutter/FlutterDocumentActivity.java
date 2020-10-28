package com.pdftron.pdftronflutter;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import androidx.annotation.DrawableRes;
import androidx.annotation.Nullable;

import com.pdftron.pdf.Annot;
import com.pdftron.pdf.PDFDoc;
import com.pdftron.pdf.PDFViewCtrl;
import com.pdftron.pdf.config.ViewerConfig;
import com.pdftron.pdf.controls.DocumentActivity;
import com.pdftron.pdf.controls.PdfViewCtrlTabFragment;
import com.pdftron.pdf.controls.PdfViewCtrlTabHostFragment;
import com.pdftron.pdf.tools.ToolManager;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.concurrent.atomic.AtomicReference;

import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.MethodChannel.Result;

import static com.pdftron.pdftronflutter.PluginUtils.*;

public class FlutterDocumentActivity extends DocumentActivity implements ViewActivityComponent {

    private static FlutterDocumentActivity sCurrentActivity;
    private static AtomicReference<Result> sFlutterLoadResult = new AtomicReference<>();

    private static AtomicReference<EventSink> sExportAnnotationCommandEventEmitter = new AtomicReference<>();
    private static AtomicReference<EventSink> sExportBookmarkEventEmitter = new AtomicReference<>();
    private static AtomicReference<EventSink> sDocumentLoadedEventEmitter = new AtomicReference<>();
    private static AtomicReference<EventSink> sDocumentErrorEventEmitter = new AtomicReference<>();
    private static AtomicReference<EventSink> sAnnotationChangedEventEmitter = new AtomicReference<>();
    private static AtomicReference<EventSink> sAnnotationsSelectedEventEmitter = new AtomicReference<>();
    private static AtomicReference<EventSink> sFormFieldChangedEventEmitter = new AtomicReference<>();
    private static AtomicReference<EventSink> sLeadingNavButtonPressedEventEmitter = new AtomicReference<>();
    private static AtomicReference<EventSink> sPageChangedEventEmitter = new AtomicReference<>();
    private static AtomicReference<EventSink> sZoomChangedEventEmitter = new AtomicReference<>();

    private static AtomicReference<ToolManager.AnnotationModificationListener> sAnnotationModificationListener = new AtomicReference<>();
    private static AtomicReference<ToolManager.PdfDocModificationListener> sPdfDocModificationListener = new AtomicReference<>();
    private static AtomicReference<ToolManager.AnnotationsSelectionListener> sAnnotationsSelectionListener = new AtomicReference<>();
    private static AtomicReference<PDFViewCtrl.PageChangeListener> sPageChangeListener = new AtomicReference<>();
    private static AtomicReference<PDFViewCtrl.OnCanvasSizeChangeListener> sOnCanvasSizeChangeListener = new AtomicReference<>();

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

    public static void setAnnotationsSelectedEventEmitter(EventSink emitter) {
        sAnnotationsSelectedEventEmitter.set(emitter);
    }

    public static void setFormFieldValueChangedEventEmitter(EventSink emitter) {
        sFormFieldChangedEventEmitter.set(emitter);
    }

    public static void setLeadingNavButtonPressedEventEmitter(EventSink emitter) {
        sLeadingNavButtonPressedEventEmitter.set(emitter);
    }

    public static void setPageChangedEventEmitter(EventSink emitter) {
        sPageChangedEventEmitter.set(emitter);
    }

    public static void setZoomChangedEventEmitter(EventSink emitter) {
        sZoomChangedEventEmitter.set(emitter);
    }

    public static void setFlutterLoadResult(Result result) {
        sFlutterLoadResult.set(result);
    }

    public ToolManager.AnnotationModificationListener getAnnotationModificationListener() {
        return sAnnotationModificationListener.get();
    }

    public ToolManager.PdfDocModificationListener getPdfDocModificationListener() {
        return sPdfDocModificationListener.get();
    }

    public ToolManager.AnnotationsSelectionListener getAnnotationsSelectionListener() {
        return sAnnotationsSelectionListener.get();
    }

    public PDFViewCtrl.PageChangeListener getPageChangeListener() {
        return sPageChangeListener.get();
    }

    public PDFViewCtrl.OnCanvasSizeChangeListener getOnCanvasSizeChangeListener() {
        return sOnCanvasSizeChangeListener.get();
    }

    public void setAnnotationModificationListener(ToolManager.AnnotationModificationListener listener) {
        sAnnotationModificationListener.set(listener);
    }

    public void setPdfDocModificationListener(ToolManager.PdfDocModificationListener listener) {
        sPdfDocModificationListener.set(listener);
    }

    public void setAnnotationsSelectionListener(ToolManager.AnnotationsSelectionListener listener) {
        sAnnotationsSelectionListener.set(listener);
    }

    public void setPageChangeListener(PDFViewCtrl.PageChangeListener listener) {
        sPageChangeListener.set(listener);
    }

    public void setOnCanvasSizeChangeListener(PDFViewCtrl.OnCanvasSizeChangeListener listener) {
        sOnCanvasSizeChangeListener.set(listener);
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
        return sAnnotationsSelectedEventEmitter.get();
    }

    @Override
    public EventSink getFormFieldValueChangedEventEmitter() {
        return sFormFieldChangedEventEmitter.get();
    }

    @Override
    public EventSink getLeadingNavButtonPressedEventEmitter() {
        return sLeadingNavButtonPressedEventEmitter.get();
    }

    @Override
    public EventSink getPageChangedEventEmitter() {
        return sPageChangedEventEmitter.get();
    }

    @Override
    public EventSink getZoomChangedEventEmitter() {
        return sZoomChangedEventEmitter.get();
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
        super.onDestroy();

        handleOnDetach(this);

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

    @Override
    public void onNavButtonPressed() {
        super.onNavButtonPressed();

        handleNavButtonPressed(this);
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
}
