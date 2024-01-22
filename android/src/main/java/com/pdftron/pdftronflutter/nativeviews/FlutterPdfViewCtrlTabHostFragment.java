package com.pdftron.pdftronflutter.nativeviews;

import com.pdftron.pdf.controls.PdfViewCtrlTabHostFragment2;

public class FlutterPdfViewCtrlTabHostFragment extends PdfViewCtrlTabHostFragment2 {

    @Override
    protected boolean canRecreateActivity() {
        return true;
    }
}
