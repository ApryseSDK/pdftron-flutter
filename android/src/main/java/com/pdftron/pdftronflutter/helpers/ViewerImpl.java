package com.pdftron.pdftronflutter.helpers;

import android.os.Bundle;

import androidx.annotation.NonNull;

import com.pdftron.pdf.Action;
import com.pdftron.pdf.ActionParameter;
import com.pdftron.pdf.Annot;
import com.pdftron.pdf.Field;
import com.pdftron.pdf.PDFViewCtrl;
import com.pdftron.pdf.annots.Widget;
import com.pdftron.pdf.tools.ToolManager;
import com.pdftron.pdf.utils.ActionUtils;
import com.pdftron.sdf.Obj;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;

import static com.pdftron.pdftronflutter.helpers.PluginUtils.BEHAVIOR_LINK_PRESS;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.KEY_ACTION;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.KEY_DATA;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.KEY_LINK_BEHAVIOR_DATA;

public class ViewerImpl {

    private ViewerComponent mViewerComponent;

    public ViewerImpl(@NonNull ViewerComponent component) {
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

    public void setActionInterceptCallback() {
        ActionUtils.getInstance().setActionInterceptCallback(mActionInterceptCallback);
    }

    private ToolManager.AnnotationModificationListener mAnnotationModificationListener = new ToolManager.AnnotationModificationListener() {
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

    private ActionUtils.ActionInterceptCallback mActionInterceptCallback = new ActionUtils.ActionInterceptCallback() {
        @Override
        public boolean onInterceptExecuteAction(ActionParameter actionParameter, PDFViewCtrl pdfViewCtrl) {
            ArrayList<String> actionOverrideItems = mViewerComponent.getActionOverrideItems();
            if (actionOverrideItems == null || !actionOverrideItems.contains(BEHAVIOR_LINK_PRESS)) {
                return false;
            }

            String url = null;
            boolean shouldUnlockRead = false;
            try {
                pdfViewCtrl.docLockRead();
                shouldUnlockRead = true;

                Action action = actionParameter.getAction();
                int action_type = action.getType();
                if (action_type == Action.e_URI) {
                    Obj o = action.getSDFObj();
                    o = o.findObj("URI");
                    if (o != null) {
                        url = o.getAsPDFText();
                    }
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            } finally {
                if (shouldUnlockRead) {
                    pdfViewCtrl.docUnlockRead();
                }
            }
            if (url != null) {
                try {
                    JSONObject behaviorObject = new JSONObject();

                    behaviorObject.put(KEY_ACTION, BEHAVIOR_LINK_PRESS);

                    JSONObject dataObject = new JSONObject();
                    dataObject.put(KEY_LINK_BEHAVIOR_DATA, url);

                    behaviorObject.put(KEY_DATA, dataObject);

                    EventChannel.EventSink eventSink = mViewerComponent.getBehaviorActivatedEventEmitter();
                    if (eventSink != null) {
                        eventSink.success(behaviorObject.toString());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
                return true;
            }
            return false;
        }
    };
}
