package com.pdftron.pdftronflutter.customs;

import android.graphics.PointF;
import android.view.MotionEvent;

import androidx.annotation.NonNull;

import com.pdftron.pdf.Annot;
import com.pdftron.pdf.PDFViewCtrl;
import com.pdftron.pdf.tools.StickyNoteCreate;
import com.pdftron.pdf.tools.ToolManager;

public class CustomSticky extends StickyNoteCreate {

    public static ToolManager.ToolModeBase MODE = ToolManager.ToolMode.TEXT_ANNOT_CREATE;

    public CustomSticky(@NonNull PDFViewCtrl ctrl) {
        super(ctrl);
    }

    @Override
    public ToolManager.ToolModeBase getToolMode() {
        return MODE;
    }

    @Override
    protected void createStickyNote() {
        super.createStickyNote();
    }

    @Override
    public void setTargetPoint(PointF point) {
//        super.setTargetPoint(point);
        super.mPt1.x = point.x + (float)super.mPdfViewCtrl.getScrollX();
        super.mPt1.y = point.y + (float)super.mPdfViewCtrl.getScrollY();
        super.mDownPageNum = super.mPdfViewCtrl.getPageNumberFromScreenPt((double)point.x, (double)point.y);
        super.createStickyNote();
        // TODO: call the own pop-up
    }

//    @Override
//    public boolean onSingleTapConfirmed(MotionEvent e) {
//        mNextToolMode = safeSetNextToolMode(ToolManager.ToolMode.TEXT_HIGHLIGHT);
//        return false;
//    }
//
//    @Override
//    public boolean onSingleTapUp(MotionEvent e) {
//        return false;
//    }
}
