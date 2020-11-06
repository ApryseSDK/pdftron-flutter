package com.pdftron.pdftronflutter.helpers;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.pdftron.pdf.Annot;
import com.pdftron.pdf.PDFDoc;
import com.pdftron.pdf.PDFViewCtrl;
import com.pdftron.pdf.controls.PdfViewCtrlTabFragment;
import com.pdftron.pdf.controls.PdfViewCtrlTabHostFragment;
import com.pdftron.pdf.tools.ToolManager;

import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public interface ViewerComponent {

    boolean isAutoSaveEnabled();

    boolean isUseStylusAsPen();

    boolean isSignSignatureFieldWithStamps();

    void setSelectedAnnots(HashMap<Annot, Integer> selectedAnnots);

    EventChannel.EventSink getExportAnnotationCommandEventEmitter();

    EventChannel.EventSink getExportBookmarkEventEmitter();

    EventChannel.EventSink getDocumentLoadedEventEmitter();

    EventChannel.EventSink getDocumentErrorEventEmitter();

    EventChannel.EventSink getAnnotationChangedEventEmitter();

    EventChannel.EventSink getAnnotationsSelectedEventEmitter();

    EventChannel.EventSink getFormFieldValueChangedEventEmitter();

    MethodChannel.Result getFlutterLoadResult();

    HashMap<Annot, Integer> getSelectedAnnots();

    // Convenience
    @Nullable
    PdfViewCtrlTabHostFragment getPdfViewCtrlTabHostFragment();

    @Nullable
    PdfViewCtrlTabFragment getPdfViewCtrlTabFragment();

    @Nullable
    PDFViewCtrl getPdfViewCtrl();

    @Nullable
    ToolManager getToolManager();

    @Nullable
    PDFDoc getPdfDoc();

    @NonNull
    ViewerImpl getImpl();
}
