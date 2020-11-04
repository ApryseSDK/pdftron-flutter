package com.pdftron.pdftronflutter.views;

import android.content.Context;
import android.util.AttributeSet;
import android.view.ViewGroup;

import com.pdftron.pdf.Annot;
import com.pdftron.pdf.PDFDoc;
import com.pdftron.pdf.PDFViewCtrl;
import com.pdftron.pdf.config.ToolManagerBuilder;
import com.pdftron.pdf.config.ViewerConfig;
import com.pdftron.pdf.controls.PdfViewCtrlTabFragment;
import com.pdftron.pdf.controls.PdfViewCtrlTabHostFragment;
import com.pdftron.pdf.tools.ToolManager;
import com.pdftron.pdftronflutter.ViewActivityComponent;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

import static com.pdftron.pdftronflutter.PluginUtils.*;

public class DocumentView extends com.pdftron.pdf.controls.DocumentView implements ViewActivityComponent {

    private ToolManagerBuilder mToolManagerBuilder;
    private ViewerConfig.Builder mBuilder;
    private String mCacheDir;

    private EventChannel.EventSink sExportAnnotationCommandEventEmitter;
    private EventChannel.EventSink sExportBookmarkEventEmitter;
    private EventChannel.EventSink sDocumentLoadedEventEmitter;
    private EventChannel.EventSink sDocumentErrorEventEmitter;
    private EventChannel.EventSink sAnnotationChangedEventEmitter;
    private EventChannel.EventSink sAnnotationsSelectedEventEmitter;
    private EventChannel.EventSink sFormFieldValueChangedEventEmitter;
    private MethodChannel.Result sFlutterLoadResult;

    private HashMap<Annot, Integer> mSelectedAnnots;

    private ToolManager.AnnotationModificationListener sAnnotationModificationListener;
    private ToolManager.PdfDocModificationListener sPdfDocModificationListener;
    private ToolManager.AnnotationsSelectionListener sAnnotationsSelectionListener;

    public DocumentView(@NonNull Context context) {
        this(context, null);
    }

    public DocumentView(@NonNull Context context, @Nullable AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public DocumentView(@NonNull Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);

        init(context);
    }

    private void init(Context context) {
        int width = ViewGroup.LayoutParams.MATCH_PARENT;
        int height = ViewGroup.LayoutParams.MATCH_PARENT;
        ViewGroup.LayoutParams params = new ViewGroup.LayoutParams(width, height);
        setLayoutParams(params);

        mCacheDir = context.getCacheDir().getAbsolutePath();
        mToolManagerBuilder = ToolManagerBuilder.from();
        mBuilder = new ViewerConfig.Builder();
        mBuilder
                .fullscreenModeEnabled(false)
                .multiTabEnabled(false)
                .showCloseTabOption(false)
                .useSupportActionBar(false);
    }

    public void attachListeners() {
        if (this.mPdfViewCtrlTabHostFragment != null) {
            this.mPdfViewCtrlTabHostFragment.addHostListener(this);
            if (this.mTabHostListener != null) {
                this.mPdfViewCtrlTabHostFragment.addHostListener(this.mTabHostListener);
            }
        }
    }

    private ViewerConfig getConfig() {
        if (mCacheDir != null) {
            mBuilder.openUrlCachePath(mCacheDir);
        }
        return mBuilder
                .toolManagerBuilder(mToolManagerBuilder)
                .build();
    }

    @Override
    protected void onAttachedToWindow() {
        setViewerConfig(getConfig());
        super.onAttachedToWindow();
    }

    @Override
    public boolean canShowFileCloseSnackbar() {
        return false;
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
    public void onDetachedFromWindow() {
        handleOnDetach(this);

        super.onDetachedFromWindow();
    }

    public void setExportAnnotationCommandEventEmitter(EventChannel.EventSink emitter) {
        sExportAnnotationCommandEventEmitter = emitter;
    }

    public void setExportBookmarkEventEmitter(EventChannel.EventSink emitter) {
        sExportBookmarkEventEmitter = emitter;
    }

    public void setDocumentLoadedEventEmitter(EventChannel.EventSink emitter) {
        sDocumentLoadedEventEmitter = emitter;
    }

    public void setDocumentErrorEventEmitter(EventChannel.EventSink emitter) {
        sDocumentErrorEventEmitter = emitter;
    }

    public void setAnnotationChangedEventEmitter(EventChannel.EventSink emitter) {
        sAnnotationChangedEventEmitter = emitter;
    }

    public void setAnnotationsSelectedEventEmitter(EventChannel.EventSink emitter) {
        sAnnotationsSelectedEventEmitter = emitter;
    }

    public void setFormFieldValueChangedEventEmitter(EventChannel.EventSink emitter) {
        sFormFieldValueChangedEventEmitter = emitter;
    }

    public void setFlutterLoadResult(MethodChannel.Result result) {
        sFlutterLoadResult = result;
    }

    public ToolManager.AnnotationModificationListener getAnnotationModificationListener() {
        return sAnnotationModificationListener;
    }

    public ToolManager.PdfDocModificationListener getPdfDocModificationListener() {
        return sPdfDocModificationListener;
    }

    public ToolManager.AnnotationsSelectionListener getAnnotationsSelectionListener() {
        return sAnnotationsSelectionListener;
    }

    public void setAnnotationModificationListener(ToolManager.AnnotationModificationListener listener) {
        sAnnotationModificationListener = listener;
    }

    public void setPdfDocModificationListener(ToolManager.PdfDocModificationListener listener) {
        sPdfDocModificationListener = listener;
    }

    public void setAnnotationsSelectionListener(ToolManager.AnnotationsSelectionListener listener) {
        sAnnotationsSelectionListener = listener;
    }

    public void setSelectedAnnots(HashMap<Annot, Integer> selectedAnnots) {
        mSelectedAnnots = selectedAnnots;
    }

    @Override
    public EventChannel.EventSink getExportAnnotationCommandEventEmitter() {
        return sExportAnnotationCommandEventEmitter;
    }

    @Override
    public EventChannel.EventSink getExportBookmarkEventEmitter() {
        return sExportBookmarkEventEmitter;
    }

    @Override
    public EventChannel.EventSink getDocumentLoadedEventEmitter() {
        return sDocumentLoadedEventEmitter;
    }

    @Override
    public EventChannel.EventSink getDocumentErrorEventEmitter() {
        return sDocumentErrorEventEmitter;
    }

    @Override
    public EventChannel.EventSink getAnnotationChangedEventEmitter() {
        return sAnnotationChangedEventEmitter;
    }

    @Override
    public EventChannel.EventSink getAnnotationsSelectedEventEmitter() {
        return sAnnotationsSelectedEventEmitter;
    }

    @Override
    public EventChannel.EventSink getFormFieldValueChangedEventEmitter() {
        return sFormFieldValueChangedEventEmitter;
    }

    @Override
    public MethodChannel.Result getFlutterLoadResult() {
        MethodChannel.Result result = sFlutterLoadResult;
        sFlutterLoadResult = null;
        return result;
    }

    @Override
    public HashMap<Annot, Integer> getSelectedAnnots() {
        return mSelectedAnnots;
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
