package com.pdftron.pdftronflutter.nativeviews;

import android.view.MotionEvent;

import static com.pdftron.pdftronflutter.helpers.PluginUtils.REFLOW_ORIENTATION_HORIZONTAL;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.REFLOW_ORIENTATION_VERTICAL;

import androidx.annotation.NonNull;

import com.pdftron.pdf.controls.PdfViewCtrlTabFragment2;
import com.pdftron.pdftronflutter.helpers.PluginUtils;
import com.pdftron.pdftronflutter.helpers.ViewerComponent;

import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.plugin.common.EventChannel;

public class FlutterPdfViewCtrlTabFragment extends PdfViewCtrlTabFragment2 {

    private ViewerComponent mViewerComponent;

    public void setViewerComponent(@NonNull ViewerComponent component) {
        mViewerComponent = component;
    }

    @Override
    public void onScrollChanged(int l, int t, int oldl, int oldt) {
        JSONObject jsonObject = new JSONObject();

        try {
            jsonObject.put(REFLOW_ORIENTATION_HORIZONTAL,  l);
            jsonObject.put(REFLOW_ORIENTATION_VERTICAL, t);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        if (mViewerComponent != null) {
            EventChannel.EventSink eventSink = mViewerComponent.getScrollChangedEventEmitter();
            if (eventSink != null) {
                eventSink.success(jsonObject.toString());
            }
        }
    }

    @Override
    public boolean onSingleTapConfirmed(MotionEvent e) {
        PluginUtils.createStickyNote(e.getX(), e.getY(), mViewerComponent);
        return true;
    }
}
