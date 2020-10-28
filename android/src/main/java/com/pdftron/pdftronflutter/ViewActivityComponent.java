package com.pdftron.pdftronflutter;

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

public interface ViewActivityComponent {

    void setSelectedAnnots(HashMap<Annot, Integer> selectedAnnots);

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

    ToolManager.AnnotationModificationListener getAnnotationModificationListener();

    ToolManager.PdfDocModificationListener getPdfDocModificationListener();

    ToolManager.AnnotationsSelectionListener getAnnotationsSelectionListener();

    PDFViewCtrl.PageChangeListener getPageChangeListener();

    PDFViewCtrl.OnCanvasSizeChangeListener getOnCanvasSizeChangeListener();

    void setAnnotationModificationListener(ToolManager.AnnotationModificationListener listener);

    void setPdfDocModificationListener(ToolManager.PdfDocModificationListener listener);

    void setAnnotationsSelectionListener(ToolManager.AnnotationsSelectionListener listener);

    void setPageChangeListener(PDFViewCtrl.PageChangeListener listener);

    void setOnCanvasSizeChangeListener(PDFViewCtrl.OnCanvasSizeChangeListener listener);
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
}
