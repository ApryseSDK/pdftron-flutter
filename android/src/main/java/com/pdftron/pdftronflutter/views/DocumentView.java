package com.pdftron.pdftronflutter.views;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;

import com.pdftron.pdf.PDFDoc;
import com.pdftron.pdf.PDFViewCtrl;
import com.pdftron.pdf.config.PDFViewCtrlConfig;
import com.pdftron.pdf.config.ToolManagerBuilder;
import com.pdftron.pdf.config.ViewerBuilder;
import com.pdftron.pdf.config.ViewerConfig;
import com.pdftron.pdf.controls.PdfViewCtrlTabFragment;
import com.pdftron.pdf.controls.PdfViewCtrlTabHostFragment;
import com.pdftron.pdf.tools.ToolManager;
import com.pdftron.pdf.utils.ActionUtils;
import com.pdftron.pdftronflutter.PluginUtils;
import com.pdftron.pdftronflutter.ViewActivityComponent;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.io.File;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

import static com.pdftron.pdftronflutter.PluginUtils.*;

public class DocumentView extends com.pdftron.pdf.controls.DocumentView implements ViewActivityComponent {

    private ToolManagerBuilder mToolManagerBuilder;
    private PDFViewCtrlConfig mPDFViewCtrlConfig;
    private ViewerConfig.Builder mBuilder;

    private String mCacheDir;

    private int mInitialPageNumber;

    private boolean mIsBase64;
    private File mTempFile;

    private EventChannel.EventSink sExportAnnotationCommandEventEmitter;
    private EventChannel.EventSink sExportBookmarkEventEmitter;
    private EventChannel.EventSink sDocumentLoadedEventEmitter;

    private MethodChannel.Result sFlutterLoadResult;

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

    public void openDocument(String document, String password, String configStr, MethodChannel.Result result) {

       ConfigInfo configInfo = PluginUtils.handleOpenDocument(mBuilder, mToolManagerBuilder, mPDFViewCtrlConfig, document, getContext(), configStr);

       mInitialPageNumber = configInfo.getInitialPageNumber();
       mIsBase64 = configInfo.isBase64();
       mCacheDir = configInfo.getCacheDir();
       mTempFile = configInfo.getTempFile();
       setDocumentUri(configInfo.getFileUri());
       setPassword(password);
       setCustomHeaders(configInfo.getCustomHeaderJson());
       setViewerConfig(mBuilder.build());
       setFlutterLoadResult(result);

        ViewerBuilder viewerBuilder = ViewerBuilder.withUri(configInfo.getFileUri(), password)
                .usingCustomHeaders(configInfo.getCustomHeaderJson())
                .usingConfig(mBuilder.build())
                .usingNavIcon(mShowNavIcon ? mNavIconRes : 0);
        if (mPdfViewCtrlTabHostFragment != null) {
            mPdfViewCtrlTabHostFragment.onOpenAddNewTab(viewerBuilder.createBundle(getContext()));
        } else {
            mPdfViewCtrlTabHostFragment = viewerBuilder.build(getContext());
            if (mFragmentManager != null) {
                mFragmentManager.beginTransaction().add(mPdfViewCtrlTabHostFragment, "document_view").commitNow();
                View fragmentView = mPdfViewCtrlTabHostFragment.getView();
                if (fragmentView != null) {
                    addView(fragmentView, -1, -1);
                }
            }
        }
        attachListeners();
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

        mPDFViewCtrlConfig = PDFViewCtrlConfig.getDefaultConfig(context);
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
            mBuilder.openUrlCachePath(mCacheDir)
            .saveCopyExportPath(mCacheDir);
        }
        return mBuilder
                .pdfViewCtrlConfig(mPDFViewCtrlConfig)
                .toolManagerBuilder(mToolManagerBuilder)
                .build();
    }

    @Override
    protected void onAttachedToWindow() {
        setViewerConfig(getConfig());
        super.onAttachedToWindow();
    }

    @Override
    protected void onDetachedFromWindow() {

        ActionUtils.getInstance().setActionInterceptCallback(null);

        super.onDetachedFromWindow();

        // TODO: move this into PluginUtils - handleDetach, after events are merged into master
        if (mTempFile != null && mTempFile.exists()) {
            mTempFile.delete();
        }
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

    public int getInitialPageNumber() {
        return mInitialPageNumber;
    }

    public boolean isBase64() {
        return mIsBase64;
    }

    public File getTempFile() {
        return mTempFile;
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

    public void setFlutterLoadResult(MethodChannel.Result result) {
        sFlutterLoadResult = result;
    }

    public EventChannel.EventSink getExportAnnotationCommandEventEmitter() {
        return sExportAnnotationCommandEventEmitter;
    }

    public EventChannel.EventSink getExportBookmarkEventEmitter() {
        return sExportBookmarkEventEmitter;
    }

    public EventChannel.EventSink getDocumentLoadedEventEmitter() {
        return sDocumentLoadedEventEmitter;
    }

    public MethodChannel.Result getFlutterLoadResult() {
        MethodChannel.Result result = sFlutterLoadResult;
        sFlutterLoadResult = null;
        return result;
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
