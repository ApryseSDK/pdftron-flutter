package com.pdftron.pdftronflutter.helpers;

import android.os.Bundle;
import androidx.annotation.NonNull;

import com.pdftron.pdf.Annot;
import com.pdftron.pdf.Field;
import com.pdftron.pdf.annots.Widget;
import com.pdftron.pdf.tools.ToolManager;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;

public class ViewerImpl {

    ViewerComponent mViewerComponent;

    public ViewerImpl(ViewerComponent component) {
        mViewerComponent = component;
    }

    public void addListeners(@NonNull ToolManager toolManager) {
        toolManager.addAnnotationModificationListener(mAnnotationModificationListener);
        toolManager.addAnnotationsSelectionListener(mAnnotationsSelectionListener);
        toolManager.addPdfDocModificationListener(mPdfDocModificationListener);
    }

    public void removeListeners(@NonNull ToolManager toolManager) {
        toolManager.removeAnnotationModificationListener(mAnnotationModificationListener);
        toolManager.removeAnnotationsSelectionListener(mAnnotationsSelectionListener);
        toolManager.removePdfDocModificationListener(mPdfDocModificationListener);
    }

    ToolManager.AnnotationModificationListener mAnnotationModificationListener = new ToolManager.AnnotationModificationListener() {
        @Override
        public void onAnnotationsAdded(Map<Annot, Integer> map) {
            PluginUtils.emitAnnotationChangedEvent(PluginUtils.KEY_ACTION_ADD, map, mViewerComponent);

            PluginUtils.emitExportAnnotationCommandEvent(PluginUtils.KEY_ACTION_ADD, map, mViewerComponent);
        }

        @Override
        public void onAnnotationsPreModify(Map<Annot, Integer> map) {
        }

        @Override
        public void onAnnotationsModified(Map<Annot, Integer> map, Bundle bundle) {
            PluginUtils.emitAnnotationChangedEvent(PluginUtils.KEY_ACTION_MODIFY, map, mViewerComponent);

            PluginUtils.emitExportAnnotationCommandEvent(PluginUtils.KEY_ACTION_MODIFY, map, mViewerComponent);

            JSONArray fieldsArray = new JSONArray();

            for (Annot annot : map.keySet()) {
                try {
                    if (annot != null && annot.isValid() && annot.getType() == Annot.e_Widget) {

                        String fieldName = null, fieldValue = null;

                        Widget widget = new Widget(annot);
                        Field field = widget.getField();
                        if (field != null) {
                            fieldName = field.getName();
                            fieldValue = field.getValueAsString();
                        }

                        if (fieldName != null && fieldValue != null) {
                            JSONObject fieldObject = new JSONObject();
                            fieldObject.put(PluginUtils.KEY_FIELD_NAME, fieldName);
                            fieldObject.put(PluginUtils.KEY_FIELD_VALUE, fieldValue);
                            fieldsArray.put(fieldObject);
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            EventChannel.EventSink eventSink = mViewerComponent.getFormFieldValueChangedEventEmitter();
            if (eventSink != null) {
                eventSink.success(fieldsArray.toString());
            }
        }

        @Override
        public void onAnnotationsPreRemove(Map<Annot, Integer> map) {
            PluginUtils.emitAnnotationChangedEvent(PluginUtils.KEY_ACTION_DELETE, map, mViewerComponent);

            PluginUtils.emitExportAnnotationCommandEvent(PluginUtils.KEY_ACTION_DELETE, map, mViewerComponent);
        }

        @Override
        public void onAnnotationsRemoved(Map<Annot, Integer> map) {

        }

        @Override
        public void onAnnotationsRemovedOnPage(int i) {

        }

        @Override
        public void annotationsCouldNotBeAdded(String s) {

        }
    };

    private ToolManager.AnnotationsSelectionListener mAnnotationsSelectionListener = new ToolManager.AnnotationsSelectionListener() {
        @Override
        public void onAnnotationsSelectionChanged(HashMap<Annot, Integer> hashMap) {
            PluginUtils.emitAnnotationsSelectedEvent(hashMap, mViewerComponent);
        }
    };

    private ToolManager.PdfDocModificationListener mPdfDocModificationListener = new ToolManager.PdfDocModificationListener() {
        @Override
        public void onBookmarkModified() {
            String bookmarkJson = null;
            try {
                bookmarkJson = PluginUtils.generateBookmarkJson(mViewerComponent);
            } catch (JSONException e) {
                e.printStackTrace();
            }

            EventChannel.EventSink eventSink = mViewerComponent.getExportBookmarkEventEmitter();
            if (eventSink != null) {
                eventSink.success(bookmarkJson);
            }
        }

        @Override
        public void onPagesCropped() {

        }

        @Override
        public void onPagesAdded(List<Integer> list) {

        }

        @Override
        public void onPagesDeleted(List<Integer> list) {

        }

        @Override
        public void onPagesRotated(List<Integer> list) {

        }

        @Override
        public void onPageMoved(int i, int i1) {

        }

        @Override
        public void onPageLabelsChanged() {

        }

        @Override
        public void onAllAnnotationsRemoved() {

        }

        @Override
        public void onAnnotationAction() {

        }
    };
}
