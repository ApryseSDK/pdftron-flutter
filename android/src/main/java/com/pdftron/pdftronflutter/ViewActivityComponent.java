package com.pdftron.pdftronflutter;

import androidx.annotation.Nullable;

import com.pdftron.pdf.PDFDoc;
import com.pdftron.pdf.PDFViewCtrl;
import com.pdftron.pdf.controls.PdfViewCtrlTabFragment2;
import com.pdftron.pdf.controls.PdfViewCtrlTabHostFragment2;
import com.pdftron.pdf.tools.ToolManager;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public interface ViewActivityComponent {

    EventChannel.EventSink getExportAnnotationCommandEventEmitter();

    EventChannel.EventSink getExportBookmarkEventEmitter();

    EventChannel.EventSink getDocumentLoadedEventEmitter();

    MethodChannel.Result getFlutterLoadResult();

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
}
