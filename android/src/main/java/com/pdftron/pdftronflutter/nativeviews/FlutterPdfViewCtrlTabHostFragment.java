package com.pdftron.pdftronflutter.nativeviews;

import android.app.Activity;
import androidx.annotation.NonNull;

import com.pdftron.pdf.controls.PdfViewCtrlTabHostFragment2;

public class FlutterPdfViewCtrlTabHostFragment extends PdfViewCtrlTabHostFragment2 {

    private boolean themeApplied = false;

    @Override
    protected boolean canRecreateActivity() {
        return true;
    }

    @Override
    protected boolean applyTheme(@NonNull Activity activity) {
        if (themeApplied) {
            return false;
        } else {
            themeApplied = true;
            return super.applyTheme(activity);
        }
    }

    @Override
    protected void updateFullScreenModeLayout() {
        if (isInFullScreenMode()) {
            super.updateFullScreenModeLayout();
        }
        // do nothing if not in full screen mode
    }
}
