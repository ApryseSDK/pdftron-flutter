package com.pdftron.pdftronflutter.nativeviews;

import android.os.Bundle;
import androidx.fragment.app.FragmentActivity;

import com.pdftron.pdf.controls.PdfViewCtrlTabHostFragment2;

public class FlutterPdfViewCtrlTabHostFragment extends PdfViewCtrlTabHostFragment2 {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        final FragmentActivity activity = getActivity();
        applyTheme(activity);
    }

        @Override
    protected void updateFullScreenModeLayout() {
        if (isInFullScreenMode()) {
            super.updateFullScreenModeLayout();
        }
        // do nothing if not in full screen mode
    }
}
