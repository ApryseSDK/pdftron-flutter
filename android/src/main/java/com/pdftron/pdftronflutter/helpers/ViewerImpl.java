package com.pdftron.pdftronflutter.helpers;

import android.os.Bundle;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.pdftron.pdf.Annot;
import com.pdftron.pdf.Field;
import com.pdftron.pdf.annots.Widget;
import com.pdftron.pdf.controls.PdfViewCtrlTabFragment;
import com.pdftron.pdf.tools.QuickMenu;
import com.pdftron.pdf.tools.QuickMenuItem;
import com.pdftron.pdf.tools.ToolManager;
import com.pdftron.pdf.utils.AnnotUtils;
import com.pdftron.pdf.utils.ViewerUtils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;

import static com.pdftron.pdftronflutter.helpers.PluginUtils.KEY_ANNOTATION_LIST;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.KEY_ANNOTATION_MENU_ITEM;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.KEY_LONG_PRESS_MENU_ITEM;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.KEY_LONG_PRESS_TEXT;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.checkQuickMenu;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.convStringToAnnotType;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.getAnnotationsData;

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

    public void addListeners(@NonNull PdfViewCtrlTabFragment pdfViewCtrlTabFragment) {
        pdfViewCtrlTabFragment.addQuickMenuListener(mQuickMenuListener);
    }

    public void removeListeners(@NonNull ToolManager toolManager) {
        toolManager.removeAnnotationModificationListener(mAnnotationModificationListener);
        toolManager.removeAnnotationsSelectionListener(mAnnotationsSelectionListener);
        toolManager.removePdfDocModificationListener(mPdfDocModificationListener);
    }

    public void removeListeners(@NonNull PdfViewCtrlTabFragment pdfViewCtrlTabFragment) {
        pdfViewCtrlTabFragment.removeQuickMenuListener(mQuickMenuListener);
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

    private ToolManager.QuickMenuListener mQuickMenuListener = new ToolManager.QuickMenuListener() {
        @Override
        public boolean onQuickMenuClicked(QuickMenuItem quickMenuItem) {
            String menuStr = PluginUtils.convQuickMenuIdToString(quickMenuItem.getItemId());

            // check if this is an override menu
            boolean result = false;

            if (mViewerComponent.getPdfViewCtrl() != null && mViewerComponent.getToolManager() != null) {

                // If annotations are selected - annotationMenu; Or: - longPressMenu
                if (PluginUtils.hasAnnotationsSelected(mViewerComponent)) {
                    if (mViewerComponent.getAnnotationMenuOverrideItems() != null) {
                        result = mViewerComponent.getAnnotationMenuOverrideItems().contains(menuStr);
                    }

                    try {
                        JSONObject annotationMenuObject = new JSONObject();
                        annotationMenuObject.put(KEY_ANNOTATION_MENU_ITEM, menuStr);
                        annotationMenuObject.put(KEY_ANNOTATION_LIST, getAnnotationsData(mViewerComponent));

                        EventChannel.EventSink eventSink = mViewerComponent.getAnnotationMenuPressedEventEmitter();
                        if (eventSink != null) {
                            eventSink.success(annotationMenuObject.toString());
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                } else {
                    if (mViewerComponent.getLongPressMenuOverrideItems() != null) {
                        result = mViewerComponent.getLongPressMenuOverrideItems().contains(menuStr);
                    }

                    try {
                        JSONObject longPressMenuObject = new JSONObject();
                        longPressMenuObject.put(KEY_LONG_PRESS_MENU_ITEM, menuStr);
                        longPressMenuObject.put(KEY_LONG_PRESS_TEXT, ViewerUtils.getSelectedString(mViewerComponent.getPdfViewCtrl()));

                        EventChannel.EventSink eventSink = mViewerComponent.getLongPressMenuPressedEventEmitter();
                        if (eventSink != null) {
                            eventSink.success(longPressMenuObject.toString());
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }

            return result;
        }

        @Override
        public boolean onShowQuickMenu(QuickMenu quickMenu, @Nullable Annot annot) {
            if (mViewerComponent.getHideAnnotationMenuTools() != null && annot != null && mViewerComponent.getPdfViewCtrl() != null) {
                for (String tool : mViewerComponent.getHideAnnotationMenuTools()) {
                    int type = convStringToAnnotType(tool);
                    boolean shouldUnlockRead = false;
                    try {
                        mViewerComponent.getPdfViewCtrl().docLockRead();
                        shouldUnlockRead = true;

                        int annotType = AnnotUtils.getAnnotType(annot);
                        if (annotType == type) {
                            mViewerComponent.getPdfViewCtrl().docUnlockRead();
                            return true;
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (shouldUnlockRead) {
                            mViewerComponent.getPdfViewCtrl().docUnlockRead();
                        }
                    }
                }
            }

            // remove unwanted items
            if (mViewerComponent.getAnnotationMenuItems() != null && annot != null) {
                List<QuickMenuItem> removeList = new ArrayList<>();
                checkQuickMenu(quickMenu.getFirstRowMenuItems(), mViewerComponent.getAnnotationMenuItems(), removeList);
                checkQuickMenu(quickMenu.getSecondRowMenuItems(), mViewerComponent.getAnnotationMenuItems(), removeList);
                checkQuickMenu(quickMenu.getOverflowMenuItems(), mViewerComponent.getAnnotationMenuItems(), removeList);
                quickMenu.removeMenuEntries(removeList);

                if (quickMenu.getFirstRowMenuItems().size() == 0) {
                    quickMenu.setDividerVisibility(View.GONE);
                }
            }
            if (mViewerComponent.getLongPressMenuItems() != null && null == annot) {
                List<QuickMenuItem> removeList = new ArrayList<>();
                checkQuickMenu(quickMenu.getFirstRowMenuItems(), mViewerComponent.getLongPressMenuItems(), removeList);
                checkQuickMenu(quickMenu.getSecondRowMenuItems(), mViewerComponent.getLongPressMenuItems(), removeList);
                checkQuickMenu(quickMenu.getOverflowMenuItems(), mViewerComponent.getLongPressMenuItems(), removeList);
                quickMenu.removeMenuEntries(removeList);

                if (quickMenu.getFirstRowMenuItems().size() == 0) {
                    quickMenu.setDividerVisibility(View.GONE);
                }
            }
            return false;
        }

        @Override
        public void onQuickMenuShown() {

        }

        @Override
        public void onQuickMenuDismissed() {

        }
    };
}
