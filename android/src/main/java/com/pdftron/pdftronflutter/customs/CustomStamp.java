package com.pdftron.pdftronflutter.customs;

import android.net.Uri;
import android.view.MotionEvent;

import androidx.annotation.NonNull;

import com.pdftron.pdf.Annot;
import com.pdftron.pdf.PDFViewCtrl;
import com.pdftron.pdf.tools.Stamper;
import com.pdftron.pdf.tools.ToolManager;
import com.pdftron.pdf.utils.Utils;
import com.pdftron.pdftronflutter.R;

import java.io.File;

public class CustomStamp extends Stamper {

    public static ToolManager.ToolModeBase MODE =
            ToolManager.ToolMode.addNewMode(Annot.e_Stamp);

    public CustomStamp(@NonNull PDFViewCtrl ctrl) {
        super(ctrl);
    }

    @Override
    public ToolManager.ToolModeBase getToolMode() {
        return MODE;
    }

    @Override
    protected void addStamp() {
        File resource = Utils.copyResourceToLocal(mPdfViewCtrl.getContext(), R.drawable.ic_link_to_plan, "PDFTronLogo", "png");
        createImageStamp(Uri.fromFile(resource), 0, null);
    }

    @Override
    public boolean onSingleTapUp(MotionEvent e) {
        return false;
    }

    @Override
    public boolean onSingleTapConfirmed(MotionEvent e) {
        return false;
    }
}
