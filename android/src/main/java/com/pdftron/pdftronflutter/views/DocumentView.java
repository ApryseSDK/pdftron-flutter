package com.pdftron.pdftronflutter.views;

import android.content.Context;
import android.util.AttributeSet;
import android.view.ViewGroup;

import com.pdftron.common.PDFNetException;
import com.pdftron.fdf.FDFDoc;
import com.pdftron.pdf.PDFDoc;
import com.pdftron.pdf.PDFViewCtrl;
import com.pdftron.pdf.config.ToolManagerBuilder;
import com.pdftron.pdf.config.ViewerConfig;
import com.pdftron.pdf.controls.PdfViewCtrlTabFragment;
import com.pdftron.pdf.utils.BookmarkManager;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import org.json.JSONException;

import io.flutter.plugin.common.MethodChannel;

public class DocumentView extends com.pdftron.pdf.controls.DocumentView {

    private ToolManagerBuilder mToolManagerBuilder;
    private ViewerConfig.Builder mBuilder;
    private String mCacheDir;

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

    public void importAnnotationCommand(String xfdfCommand, MethodChannel.Result result) throws PDFNetException {
        PDFViewCtrl pdfViewCtrl = getPdfViewCtrl();
        PDFDoc pdfDoc = getPdfDoc();
        if (null == pdfViewCtrl || null == pdfDoc || null == xfdfCommand) {
            result.error("InvalidState", "Activity not attached", null);
            return;
        }
        boolean shouldUnlockRead = false;
        try {
            pdfViewCtrl.docLockRead();
            shouldUnlockRead = true;

            if (pdfDoc.hasDownloader()) {
                // still downloading file, let's wait for next call
                result.error("InvalidState", "Document download in progress, try again later", null);
                return;
            }
        } finally {
            if (shouldUnlockRead) {
                pdfViewCtrl.docUnlockRead();
            }
        }

        boolean shouldUnlock = false;
        try {
            pdfViewCtrl.docLock(true);
            shouldUnlock = true;

            FDFDoc fdfDoc = pdfDoc.fdfExtract(PDFDoc.e_both);
            fdfDoc.mergeAnnots(xfdfCommand);

            pdfDoc.fdfUpdate(fdfDoc);
            pdfViewCtrl.update(true);
            result.success(null);
        } finally {
            if (shouldUnlock) {
                pdfViewCtrl.docUnlock();
            }
        }
    }

    public void importBookmarkJson(String bookmarkJson, MethodChannel.Result result) throws JSONException {
        PDFViewCtrl pdfViewCtrl = getPdfViewCtrl();
        if (null == pdfViewCtrl || null == bookmarkJson) {
            result.error("InvalidState", "Activity not attached", null);
            return;
        }
        BookmarkManager.importPdfBookmarks(pdfViewCtrl, bookmarkJson);
        result.success(null);
    }

    public void saveDocument(MethodChannel.Result result) {
        if (getPdfViewCtrlTabFragment() != null) {
            getPdfViewCtrlTabFragment().setSavingEnabled(true);
            getPdfViewCtrlTabFragment().save(false, true, true);
            // TODO if add auto save flag: getPdfViewCtrlTabFragment().setSavingEnabled(mAutoSaveEnabled);
            result.success(getPdfViewCtrlTabFragment().getFilePath());
            return;
        }
        result.error("InvalidState", "Activity not attached", null);
    }

    public PdfViewCtrlTabFragment getPdfViewCtrlTabFragment() {
        if (mPdfViewCtrlTabHostFragment != null) {
            return mPdfViewCtrlTabHostFragment.getCurrentPdfViewCtrlFragment();
        }
        return null;
    }

    public PDFViewCtrl getPdfViewCtrl() {
        if (getPdfViewCtrlTabFragment() != null) {
            return getPdfViewCtrlTabFragment().getPDFViewCtrl();
        }
        return null;
    }

    public PDFDoc getPdfDoc() {
        if (getPdfViewCtrlTabFragment() != null) {
            return getPdfViewCtrlTabFragment().getPdfDoc();
        }
        return null;
    }
}
