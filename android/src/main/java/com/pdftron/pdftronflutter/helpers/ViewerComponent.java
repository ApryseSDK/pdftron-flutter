package com.pdftron.pdftronflutter.helpers;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.pdftron.pdf.Annot;
import com.pdftron.pdf.PDFDoc;
import com.pdftron.pdf.PDFViewCtrl;
import com.pdftron.pdf.controls.PdfViewCtrlTabFragment2;
import com.pdftron.pdf.controls.PdfViewCtrlTabHostFragment2;
import com.pdftron.pdf.tools.ToolManager;

import java.io.File;
import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public interface ViewerComponent {

    void setSelectedAnnots(HashMap<Annot, Integer> selectedAnnots);

    int getInitialPageNumber();

    boolean isBase64();

    File getTempFile();

    EventChannel.EventSink getExportAnnotationCommandEventEmitter();

    EventChannel.EventSink getExportBookmarkEventEmitter();

    EventChannel.EventSink getDocumentLoadedEventEmitter();

    EventChannel.EventSink getDocumentErrorEventEmitter();

    EventChannel.EventSink getAnnotationChangedEventEmitter();

    EventChannel.EventSink getAnnotationsSelectedEventEmitter();

    EventChannel.EventSink getFormFieldValueChangedEventEmitter();

    EventChannel.EventSink getLeadingNavButtonPressedEventEmitter();

    EventChannel.EventSink getPageChangedEventEmitter();

    EventChannel.EventSink getZoomChangedEventEmitter();

    MethodChannel.Result getFlutterLoadResult();

    HashMap<Annot, Integer> getSelectedAnnots();

    // Convenience
    @Nullable
    PdfViewCtrlTabHostFragment2 getPdfViewCtrlTabHostFragment();

    @Nullable
    PdfViewCtrlTabFragment2 getPdfViewCtrlTabFragment();

    @Nullable
    PDFViewCtrl getPdfViewCtrl();

    @Nullable
    ToolManager getToolManager();

    @Nullable
    PDFDoc getPdfDoc();

    @NonNull
    ViewerImpl getImpl();
}
