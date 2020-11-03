package com.pdftron.pdftronflutter;

import androidx.annotation.Nullable;

import com.pdftron.pdf.PDFDoc;
import com.pdftron.pdf.PDFViewCtrl;
import com.pdftron.pdf.controls.PdfViewCtrlTabFragment;
import com.pdftron.pdf.controls.PdfViewCtrlTabHostFragment;
import com.pdftron.pdf.tools.ToolManager;

import java.io.File;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public interface ViewActivityComponent {

    int getInitialPageNumber();

    boolean isBase64();

    File getTempFile();

    EventChannel.EventSink getExportAnnotationCommandEventEmitter();

    EventChannel.EventSink getExportBookmarkEventEmitter();

    EventChannel.EventSink getDocumentLoadedEventEmitter();

    MethodChannel.Result getFlutterLoadResult();

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
