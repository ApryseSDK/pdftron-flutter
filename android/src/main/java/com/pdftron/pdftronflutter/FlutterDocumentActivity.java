package com.pdftron.pdftronflutter;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import androidx.annotation.DrawableRes;
import androidx.annotation.Nullable;

import com.pdftron.common.PDFNetException;
import com.pdftron.fdf.FDFDoc;
import com.pdftron.pdf.Annot;
import com.pdftron.pdf.PDFDoc;
import com.pdftron.pdf.PDFViewCtrl;
import com.pdftron.pdf.config.ViewerConfig;
import com.pdftron.pdf.controls.DocumentActivity;
import com.pdftron.pdf.controls.PdfViewCtrlTabFragment;
import com.pdftron.pdf.controls.PdfViewCtrlTabHostFragment;
import com.pdftron.pdf.tools.ToolManager;
import com.pdftron.pdf.utils.BookmarkManager;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicReference;

import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.MethodChannel.Result;

public class FlutterDocumentActivity extends DocumentActivity {

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
        packageContext.startActivity(intent);
    }

    public static void setFlutterLoadResult(Result result) {
        sFlutterLoadResult.set(result);
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

        handleAnnotationModifications();

        Result result = sFlutterLoadResult.getAndSet(null);
        if (result != null) {
            result.success(true);
        }

        if (getPdfViewCtrlTabFragment() != null) {
            EventSink documentLoadedEventSink = sDocumentLoadedEventEmitter.get();
            if (documentLoadedEventSink != null) {
                documentLoadedEventSink.success(getPdfViewCtrlTabFragment().getFilePath());
            }
        }
    }

    @Override
    public boolean onOpenDocError() {
        super.onOpenDocError();

        Result result = sFlutterLoadResult.getAndSet(null);
        if (result != null) {
            result.success(false);
        }
        return false;
    }

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

    // events
    public void handleAnnotationModifications() {
        ToolManager toolManager = getToolManager();
        if (toolManager != null) {
            toolManager.addAnnotationModificationListener(new ToolManager.AnnotationModificationListener() {
                @Override
                public void onAnnotationsAdded(Map<Annot, Integer> map) {
                    ArrayList<Annot> annots = new ArrayList<>(map.keySet());
                    String xfdfCommand = null;
                    try {
                        xfdfCommand = generateXfdfCommand(annots, null, null);
                    } catch (PDFNetException e) {
                        e.printStackTrace();
                    }

                    EventSink eventSink = sExportAnnotationCommandEventEmitter.get();
                    if (eventSink != null) {
                        eventSink.success(xfdfCommand);
                    }
                }

                @Override
                public void onAnnotationsPreModify(Map<Annot, Integer> map) {
                }

                @Override
                public void onAnnotationsModified(Map<Annot, Integer> map, Bundle bundle) {
                    ArrayList<Annot> annots = new ArrayList<>(map.keySet());
                    String xfdfCommand = null;
                    try {
                        xfdfCommand = generateXfdfCommand(null, annots, null);
                    } catch (PDFNetException e) {
                        e.printStackTrace();
                    }

                    EventSink eventSink = sExportAnnotationCommandEventEmitter.get();
                    if (eventSink != null) {
                        eventSink.success(xfdfCommand);
                    }
                }

                @Override
                public void onAnnotationsPreRemove(Map<Annot, Integer> map) {
                    ArrayList<Annot> annots = new ArrayList<>(map.keySet());
                    String xfdfCommand = null;
                    try {
                        xfdfCommand = generateXfdfCommand(null, null, annots);
                    } catch (PDFNetException e) {
                        e.printStackTrace();
                    }

                    EventSink eventSink = sExportAnnotationCommandEventEmitter.get();
                    if (eventSink != null) {
                        eventSink.success(xfdfCommand);
                    }
                }

                @Override
                public void onAnnotationsRemoved(Map<Annot, Integer> map) {

                }

                @Override
                public void onAnnotationsRemovedOnPage(int i) {

                }

                @Override
                public void annotationsCouldNotBeAdded(String s) {

                }
            });
            toolManager.addPdfDocModificationListener(new ToolManager.PdfDocModificationListener() {
                @Override
                public void onBookmarkModified() {
                    String bookmarkJson = null;
                    try {
                        bookmarkJson = generateBookmarkJson();
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                    EventSink eventSink = sExportBookmarkEventEmitter.get();
                    if (eventSink != null) {
                        eventSink.success(bookmarkJson);
                    }
                }

                @Override
                public void onPagesCropped() {

                }

                @Override
                public void onPagesAdded(List<Integer> list) {

                }

                @Override
                public void onPagesDeleted(List<Integer> list) {

                }

                @Override
                public void onPagesRotated(List<Integer> list) {

                }

                @Override
                public void onPageMoved(int i, int i1) {

                }

                @Override
                public void onPageLabelsChanged() {

                }

                @Override
                public void onAllAnnotationsRemoved() {

                }

                @Override
                public void onAnnotationAction() {

                }
            });
        }
    }

    // methods
    public void importAnnotationCommand(String xfdfCommand, Result result) throws PDFNetException {
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

    public void importBookmarkJson(String bookmarkJson, Result result) throws JSONException {
        PDFViewCtrl pdfViewCtrl = getPdfViewCtrl();
        if (null == pdfViewCtrl || null == bookmarkJson) {
            result.error("InvalidState", "Activity not attached", null);
            return;
        }
        BookmarkManager.importPdfBookmarks(pdfViewCtrl, bookmarkJson);
        result.success(null);
    }

    public void saveDocument(Result result) {
        if (getPdfViewCtrlTabFragment() != null) {
            getPdfViewCtrlTabFragment().setSavingEnabled(true);
            getPdfViewCtrlTabFragment().save(false, true, true);
            // TODO if add auto save flag: getPdfViewCtrlTabFragment().setSavingEnabled(mAutoSaveEnabled);
            result.success(getPdfViewCtrlTabFragment().getFilePath());
            return;
        }
        result.error("InvalidState", "Activity not attached", null);
    }

    // helper
    @Nullable
    private String generateXfdfCommand(ArrayList<Annot> added, ArrayList<Annot> modified, ArrayList<Annot> removed) throws PDFNetException {
        PDFDoc pdfDoc = getPdfDoc();
        if (pdfDoc != null) {
            FDFDoc fdfDoc = pdfDoc.fdfExtract(added, modified, removed);
            return fdfDoc.saveAsXFDF();
        }
        return null;
    }

    @Nullable
    private String generateBookmarkJson() throws JSONException {
        PDFDoc pdfDoc = getPdfDoc();
        if (pdfDoc != null) {
            return BookmarkManager.exportPdfBookmarks(pdfDoc);
        }
        return null;
    }
}
