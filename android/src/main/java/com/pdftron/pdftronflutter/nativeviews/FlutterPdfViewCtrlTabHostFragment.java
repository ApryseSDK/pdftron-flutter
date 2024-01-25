package com.pdftron.pdftronflutter.nativeviews;

import com.pdftron.pdf.controls.PdfViewCtrlTabHostFragment2;

public class FlutterPdfViewCtrlTabHostFragment extends PdfViewCtrlTabHostFragment2 {
    @Override
    protected void updateFullScreenModeLayout() {
        if (isInFullScreenMode()) {
            super.updateFullScreenModeLayout();
        }
        // do nothing if not in full screen mode
    }
}
