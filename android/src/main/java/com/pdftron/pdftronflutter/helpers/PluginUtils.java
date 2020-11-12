package com.pdftron.pdftronflutter.helpers;

import android.content.ContentResolver;
import android.content.Context;
import android.net.Uri;
import android.util.Base64;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.pdftron.common.PDFNetException;
import com.pdftron.fdf.FDFDoc;
import com.pdftron.pdf.Annot;
import com.pdftron.pdf.PDFDoc;
import com.pdftron.pdf.PDFViewCtrl;
import com.pdftron.pdf.Page;
import com.pdftron.pdf.Rect;
import com.pdftron.pdf.config.PDFViewCtrlConfig;
import com.pdftron.pdf.config.ToolConfig;
import com.pdftron.pdf.config.ToolManagerBuilder;
import com.pdftron.pdf.config.ViewerConfig;
import com.pdftron.pdf.controls.PdfViewCtrlTabFragment;
import com.pdftron.pdf.controls.PdfViewCtrlTabHostFragment;
import com.pdftron.pdf.model.AnnotStyle;
import com.pdftron.pdf.tools.AdvancedShapeCreate;
import com.pdftron.pdf.tools.FreehandCreate;
import com.pdftron.pdf.tools.QuickMenuItem;
import com.pdftron.pdf.tools.Tool;
import com.pdftron.pdf.tools.ToolManager;
import com.pdftron.pdf.utils.BookmarkManager;
import com.pdftron.pdf.utils.Utils;
import com.pdftron.pdf.utils.ViewerUtils;
import com.pdftron.pdftronflutter.R;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class PluginUtils {

    public static final String KEY_LICENSE_KEY = "licenseKey";
    public static final String KEY_DOCUMENT = "document";
    public static final String KEY_PASSWORD = "password";
    public static final String KEY_CONFIG = "config";
    public static final String KEY_XFDF_COMMAND = "xfdfCommand";
    public static final String KEY_XFDF = "xfdf";
    public static final String KEY_BOOKMARK_JSON = "bookmarkJson";
    public static final String KEY_PAGE_NUMBER = "pageNumber";
    public static final String KEY_ANNOTATION_LIST = "annotations";
    public static final String KEY_ANNOTATION = "annotation";
    public static final String KEY_FORMS_ONLY = "formsOnly";
    public static final String KEY_ANNOTATIONS_WITH_FLAGS = "annotationsWithFlags";

    public static final String KEY_CONFIG_DISABLED_ELEMENTS = "disabledElements";
    public static final String KEY_CONFIG_DISABLED_TOOLS = "disabledTools";
    public static final String KEY_CONFIG_MULTI_TAB_ENABLED = "multiTabEnabled";
    public static final String KEY_CONFIG_CUSTOM_HEADERS = "customHeaders";
    public static final String KEY_CONFIG_LONG_PRESS_MENU_ENABLED = "longPressMenuEnabled";
    public static final String KEY_CONFIG_LONG_PRESS_MENU_ITEMS = "longPressMenuItems";
    public static final String KEY_CONFIG_OVERRIDE_LONG_PRESS_MENU_BEHAVIOR = "overrideLongPressMenuBehavior";
    public static final String KEY_CONFIG_HIDE_ANNOTATION_MENU = "hideAnnotationMenu";
    public static final String KEY_CONFIG_ANNOTATION_MENU_ITEMS = "annotationMenuItems";
    public static final String KEY_CONFIG_OVERRIDE_ANNOTATION_MENU_BEHAVIOR = "overrideAnnotationMenuBehavior";

    public static final String KEY_X1 = "x1";
    public static final String KEY_Y1 = "y1";
    public static final String KEY_X2 = "x2";
    public static final String KEY_Y2 = "y2";
    public static final String KEY_WIDTH = "width";
    public static final String KEY_HEIGHT = "height";
    public static final String KEY_RECT = "rect";

    public static final String KEY_FIELD_NAME = "fieldName";
    public static final String KEY_FIELD_VALUE = "fieldValue";

    public static final String KEY_ANNOTATION_ID = "id";

    public static final String KEY_ACTION_ADD = "add";
    public static final String KEY_ACTION_MODIFY = "modify";
    public static final String KEY_ACTION_DELETE = "delete";
    public static final String KEY_ACTION = "action";

    public static final String KEY_ANNOTATION_FLAG_LISTS = "flags";
    public static final String KEY_ANNOTATION_FLAG = "flag";
    public static final String KEY_ANNOTATION_FLAG_VALUE = "flagValue";

    public static final String KEY_ANNOTATION_MENU_ITEM = "annotationMenuItem";

    public static final String KEY_LONG_PRESS_MENU_ITEM = "longPressMenuItem";
    public static final String KEY_LONG_PRESS_TEXT = "longPressText";

    public static final String EVENT_EXPORT_ANNOTATION_COMMAND = "export_annotation_command_event";
    public static final String EVENT_EXPORT_BOOKMARK = "export_bookmark_event";
    public static final String EVENT_DOCUMENT_LOADED = "document_loaded_event";
    public static final String EVENT_DOCUMENT_ERROR = "document_error_event";
    public static final String EVENT_ANNOTATION_CHANGED = "annotation_changed_event";
    public static final String EVENT_ANNOTATIONS_SELECTED = "annotations_selected_event";
    public static final String EVENT_FORM_FIELD_VALUE_CHANGED = "form_field_value_changed_event";
    public static final String EVENT_LONG_PRESS_MENU_PRESSED = "long_press_menu_pressed_event";
    public static final String EVENT_ANNOTATION_MENU_PRESSED = "annotation_menu_pressed_event";

    public static final String FUNCTION_GET_PLATFORM_VERSION = "getPlatformVersion";
    public static final String FUNCTION_GET_VERSION = "getVersion";
    public static final String FUNCTION_INITIALIZE = "initialize";
    public static final String FUNCTION_OPEN_DOCUMENT = "openDocument";
    public static final String FUNCTION_IMPORT_ANNOTATION_COMMAND = "importAnnotationCommand";
    public static final String FUNCTION_IMPORT_BOOKMARK_JSON = "importBookmarkJson";
    public static final String FUNCTION_SAVE_DOCUMENT = "saveDocument";
    public static final String FUNCTION_COMMIT_TOOL = "commitTool";
    public static final String FUNCTION_GET_PAGE_COUNT = "getPageCount";
    public static final String FUNCTION_HANDLE_BACK_BUTTON = "handleBackButton";
    public static final String FUNCTION_GET_PAGE_CROP_BOX = "getPageCropBox";
    public static final String FUNCTION_IMPORT_ANNOTATIONS = "importAnnotations";
    public static final String FUNCTION_EXPORT_ANNOTATIONS = "exportAnnotations";
    public static final String FUNCTION_FLATTEN_ANNOTATIONS = "flattenAnnotations";
    public static final String FUNCTION_DELETE_ANNOTATIONS = "deleteAnnotations";
    public static final String FUNCTION_SELECT_ANNOTATION = "selectAnnotation";
    public static final String FUNCTION_SET_FLAGS_FOR_ANNOTATIONS = "setFlagsForAnnotations";

    public static final String BUTTON_TOOLS = "toolsButton";
    public static final String BUTTON_SEARCH = "searchButton";
    public static final String BUTTON_SHARE = "shareButton";
    public static final String BUTTON_VIEW_CONTROLS = "viewControlsButton";
    public static final String BUTTON_THUMBNAILS = "thumbnailsButton";
    public static final String BUTTON_LISTS = "listsButton";
    public static final String BUTTON_THUMBNAIL_SLIDER = "thumbnailSlider";
    public static final String BUTTON_SAVE_COPY = "saveCopyButton";
    public static final String BUTTON_EDIT_PAGES = "editPagesButton";
    public static final String BUTTON_PRINT = "printButton";
    public static final String BUTTON_FILL_AND_SIGN = "fillAndSignButton";
    public static final String BUTTON_PREPARE_FORM = "prepareFormButton";
    public static final String BUTTON_REFLOW_MODE = "reflowModeButton";

    public static final String TOOL_BUTTON_FREE_HAND = "freeHandToolButton";
    public static final String TOOL_BUTTON_HIGHLIGHT = "highlightToolButton";
    public static final String TOOL_BUTTON_UNDERLINE = "underlineToolButton";
    public static final String TOOL_BUTTON_SQUIGGLY = "squigglyToolButton";
    public static final String TOOL_BUTTON_STRIKEOUT = "strikeoutToolButton";
    public static final String TOOL_BUTTON_RECTANGLE = "rectangleToolButton";
    public static final String TOOL_BUTTON_ELLIPSE = "ellipseToolButton";
    public static final String TOOL_BUTTON_LINE = "lineToolButton";
    public static final String TOOL_BUTTON_ARROW = "arrowToolButton";
    public static final String TOOL_BUTTON_POLYLINE = "polylineToolButton";
    public static final String TOOL_BUTTON_POLYGON = "polygonToolButton";
    public static final String TOOL_BUTTON_CLOUD = "cloudToolButton";
    public static final String TOOL_BUTTON_SIGNATURE = "signatureToolButton";
    public static final String TOOL_BUTTON_FREE_TEXT = "freeTextToolButton";
    public static final String TOOL_BUTTON_STICKY = "stickyToolButton";
    public static final String TOOL_BUTTON_CALLOUT = "calloutToolButton";
    public static final String TOOL_BUTTON_STAMP = "stampToolButton";

    public static final String TOOL_ANNOTATION_CREATE_FREE_HAND = "AnnotationCreateFreeHand";
    public static final String TOOL_ANNOTATION_CREATE_TEXT_HIGHLIGHT = "AnnotationCreateTextHighlight";
    public static final String TOOL_ANNOTATION_CREATE_TEXT_UNDERLINE = "AnnotationCreateTextUnderline";
    public static final String TOOL_ANNOTATION_CREATE_TEXT_SQUIGGLY = "AnnotationCreateTextSquiggly";
    public static final String TOOL_ANNOTATION_CREATE_TEXT_STRIKEOUT = "AnnotationCreateTextStrikeout";
    public static final String TOOL_ANNOTATION_CREATE_RECTANGLE = "AnnotationCreateRectangle";
    public static final String TOOL_ANNOTATION_CREATE_ELLIPSE = "AnnotationCreateEllipse";
    public static final String TOOL_ANNOTATION_CREATE_LINE = "AnnotationCreateLine";
    public static final String TOOL_ANNOTATION_CREATE_ARROW = "AnnotationCreateArrow";
    public static final String TOOL_ANNOTATION_CREATE_POLYLINE = "AnnotationCreatePolyline";
    public static final String TOOL_ANNOTATION_CREATE_POLYGON = "AnnotationCreatePolygon";
    public static final String TOOL_ANNOTATION_CREATE_POLYGON_CLOUD = "AnnotationCreatePolygonCloud";
    public static final String TOOL_ANNOTATION_CREATE_SIGNATURE = "AnnotationCreateSignature";
    public static final String TOOL_ANNOTATION_CREATE_FREE_TEXT = "AnnotationCreateFreeText";
    public static final String TOOL_ANNOTATION_CREATE_STICKY = "AnnotationCreateSticky";
    public static final String TOOL_ANNOTATION_CREATE_CALLOUT = "AnnotationCreateCallout";
    public static final String TOOL_ANNOTATION_CREATE_STAMP = "AnnotationCreateStamp";
    public static final String TOOL_ANNOTATION_CREATE_DISTANCE_MEASUREMENT = "AnnotationCreateDistanceMeasurement";
    public static final String TOOL_ANNOTATION_CREATE_PERIMETER_MEASUREMENT = "AnnotationCreatePerimeterMeasurement";
    public static final String TOOL_ANNOTATION_CREATE_AREA_MEASUREMENT = "AnnotationCreateAreaMeasurement";
    public static final String TOOL_TEXT_SELECT = "TextSelect";
    public static final String TOOL_ANNOTATION_EDIT = "AnnotationEdit";
    public static final String TOOL_ANNOTATION_CREATE_SOUND = "AnnotationCreateSound";
    public static final String TOOL_ANNOTATION_CREATE_FREE_HIGHLIGHTER = "AnnotationCreateFreeHighlighter";
    public static final String TOOL_ANNOTATION_CREATE_RUBBER_STAMP = "AnnotationCreateRubberStamp";
    public static final String TOOL_ERASER = "Eraser";
    public static final String TOOL_ANNOTATION_CREATE_FILE_ATTACHMENT = "annotationCreateFileAttachment";
    public static final String TOOL_ANNOTATION_CREATE_REDACTION = "AnnotationCreateRedaction";
    public static final String TOOL_ANNOTATION_CREATE_REDACTION_TEXT = "AnnotationCreateRedactionText";
    public static final String TOOL_ANNOTATION_CREATE_LINK = "AnnotationCreateLink";
    public static final String TOOL_ANNOTATION_CREATE_LINK_TEXT = "AnnotationCreateLinkText";
    public static final String TOOL_FORM_CREATE_TEXT_FIELD = "FormCreateTextField";
    public static final String TOOL_FORM_CREATE_CHECKBOX_FIELD = "FormCreateCheckboxField";
    public static final String TOOL_FORM_CREATE_SIGNATURE_FIELD = "FormCreateSignatureField";
    public static final String TOOL_FORM_CREATE_RADIO_FIELD = "FormCreateRadioField";
    public static final String TOOL_FORM_CREATE_COMBO_BOX_FIELD = "FormCreateComboBoxField";
    public static final String TOOL_FORM_CREATE_TOOL_BOX_FIELD = "FormCreateToolBoxField";

    public static final String ANNOTATION_FLAG_HIDDEN = "hidden";
    public static final String ANNOTATION_FLAG_INVISIBLE = "invisible";
    public static final String ANNOTATION_FLAG_LOCKED = "locked";
    public static final String ANNOTATION_FLAG_LOCKED_CONTENTS = "lockedContents";
    public static final String ANNOTATION_FLAG_NO_ROTATE = "noRotate";
    public static final String ANNOTATION_FLAG_NO_VIEW = "noView";
    public static final String ANNOTATION_FLAG_NO_ZOOM = "noZoom";
    public static final String ANNOTATION_FLAG_PRINT = "print";
    public static final String ANNOTATION_FLAG_READ_ONLY = "readOnly";
    public static final String ANNOTATION_FLAG_TOGGLE_NO_VIEW = "toggleNoView";

    public static final String MENU_ID_STRING_STYLE = "style";
    public static final String MENU_ID_STRING_NOTE = "note";
    public static final String MENU_ID_STRING_COPY = "copy";
    public static final String MENU_ID_STRING_DELETE = "delete";
    public static final String MENU_ID_STRING_FLATTEN = "flatten";
    public static final String MENU_ID_STRING_TEXT = "text";
    public static final String MENU_ID_STRING_EDIT_INK = "editInk";
    public static final String MENU_ID_STRING_SEARCH = "search";
    public static final String MENU_ID_STRING_SHARE = "share";
    public static final String MENU_ID_STRING_MARKUP_TYPE = "markupType";
    public static final String MENU_ID_STRING_SCREEN_CAPTURE = "screenCapture";
    public static final String MENU_ID_STRING_PLAY_SOUND = "playSound";
    public static final String MENU_ID_STRING_OPEN_ATTACHMENT = "openAttachment";
    public static final String MENU_ID_STRING_READ = "read";
    public static final String MENU_ID_STRING_CALIBRATE = "calibrate";
    public static final String MENU_ID_STRING_REDACT = "redact";
    public static final String MENU_ID_STRING_REDACTION = "redaction";
    public static final String MENU_ID_STRING_UNDERLINE = "underline";
    public static final String MENU_ID_STRING_STRIKEOUT = "strikeout";
    public static final String MENU_ID_STRING_SQUIGGLY = "squiggly";
    public static final String MENU_ID_STRING_LINK = "link";
    public static final String MENU_ID_STRING_HIGHLIGHT = "highlight";
    public static final String MENU_ID_STRING_SIGNATURE = "signature";
    public static final String MENU_ID_STRING_RECTANGLE = "rectangle";
    public static final String MENU_ID_STRING_LINE = "line";
    public static final String MENU_ID_STRING_FREE_HAND = "freeHand";
    public static final String MENU_ID_STRING_IMAGE = "image";
    public static final String MENU_ID_STRING_FORM_TEXT = "formText";
    public static final String MENU_ID_STRING_STICKY_NOTE = "stickyNote";
    public static final String MENU_ID_STRING_OVERFLOW = "overflow";
    public static final String MENU_ID_STRING_ERASER = "eraser";
    public static final String MENU_ID_STRING_STAMP = "rubberStamp";
    public static final String MENU_ID_STRING_PAGE_REDACTION = "pageRedaction";
    public static final String MENU_ID_STRING_RECT_REDACTION = "rectRedaction";
    public static final String MENU_ID_STRING_SEARCH_REDACTION = "searchRedaction";
    public static final String MENU_ID_STRING_SHAPE = "shape";
    public static final String MENU_ID_STRING_CLOUD = "cloud";
    public static final String MENU_ID_STRING_POLYGON = "polygon";
    public static final String MENU_ID_STRING_POLYLINE = "polyline";
    public static final String MENU_ID_STRING_FREE_HIGHLIGHTER = "freeHighlighter";
    public static final String MENU_ID_STRING_ARROW = "arrow";
    public static final String MENU_ID_STRING_OVAL = "oval";
    public static final String MENU_ID_STRING_CALLOUT = "callout";
    public static final String MENU_ID_STRING_MEASUREMENT = "measurement";
    public static final String MENU_ID_STRING_AREA_MEASUREMENT = "areaMeasurement";
    public static final String MENU_ID_STRING_PERIMETER_MEASUREMENT = "perimeterMeasurement";
    public static final String MENU_ID_STRING_RECT_AREA_MEASUREMENT = "rectAreaMeasurement";
    public static final String MENU_ID_STRING_RULER = "ruler";
    public static final String MENU_ID_STRING_FORM = "form";
    public static final String MENU_ID_STRING_FORM_COMBO_BOX = "formComboBox";
    public static final String MENU_ID_STRING_FORM_LIST_BOX = "formListBox";
    public static final String MENU_ID_STRING_FORM_CHECK_BOX = "formCheckBox";
    public static final String MENU_ID_STRING_FORM_SIGNATURE = "formSignature";
    public static final String MENU_ID_STRING_FORM_RADIO_GROUP = "formRadioGroup";
    public static final String MENU_ID_STRING_ATTACH = "attach";
    public static final String MENU_ID_STRING_FILE_ATTACHMENT = "fileAttachment";
    public static final String MENU_ID_STRING_SOUND = "sound";
    public static final String MENU_ID_STRING_FREE_TEXT = "freeText";
    public static final String MENU_ID_STRING_CROP = "crop";
    public static final String MENU_ID_STRING_CROP_OK = "crossOK";
    public static final String MENU_ID_STRING_CROP_CANCEL = "crossCancel";
    public static final String MENU_ID_STRING_DEFINE = "define";
    public static final String MENU_ID_STRING_FIELD_SIGNED = "fieldSigned";
    public static final String MENU_ID_STRING_FIRST_ROW_GROUP = "firstRowGroup";
    public static final String MENU_ID_STRING_SECOND_ROW_GROUP = "secondRowGroup";
    public static final String MENU_ID_STRING_GROUP = "group";
    public static final String MENU_ID_STRING_PASTE = "paste";
    public static final String MENU_ID_STRING_RECT_GROUP_SELECT = "rectGroupSelect";
    public static final String MENU_ID_STRING_SIGN_AND_SAVE = "signAndSave";
    public static final String MENU_ID_STRING_THICKNESS = "thickness";
    public static final String MENU_ID_STRING_TRANSLATE = "translate";
    public static final String MENU_ID_STRING_TYPE = "type";
    public static final String MENU_ID_STRING_UNGROUP = "ungroup";

    public static class ConfigInfo {
        private JSONObject customHeaderJson;
        private Uri fileUri;
        private ArrayList<String> longPressMenuItems;
        private ArrayList<String> longPressMenuOverrideItems;
        private ArrayList<String> hideAnnotationMenuTools;
        private ArrayList<String> annotationMenuItems;
        private ArrayList<String> annotationMenuOverrideItems;

        public ConfigInfo() {
            this.customHeaderJson = null;
            this.fileUri = null;
            this.longPressMenuItems = null;
            this.longPressMenuOverrideItems = null;
            this.hideAnnotationMenuTools = null;
            this.annotationMenuItems = null;
            this.annotationMenuOverrideItems = null;
        }

        public void setCustomHeaderJson(JSONObject customHeaderJson) {
            this.customHeaderJson = customHeaderJson;
        }

        public void setFileUri(Uri fileUri) {
            this.fileUri = fileUri;
        }

        public void setLongPressMenuItems(ArrayList<String> longPressMenuItems) {
            this.longPressMenuItems = longPressMenuItems;
        }

        public void setLongPressMenuOverrideItems(ArrayList<String> longPressMenuOverrideItems) {
            this.longPressMenuOverrideItems = longPressMenuOverrideItems;
        }

        public void setHideAnnotationMenuTools(ArrayList<String> hideAnnotationMenuTools) {
            this.hideAnnotationMenuTools = hideAnnotationMenuTools;
        }

        public void setAnnotationMenuItems(ArrayList<String> annotationMenuItems) {
            this.annotationMenuItems = annotationMenuItems;
        }

        public void setAnnotationMenuOverrideItems(ArrayList<String> annotationMenuOverrideItems) {
            this.annotationMenuOverrideItems = annotationMenuOverrideItems;
        }

        public JSONObject getCustomHeaderJson() {
            return customHeaderJson;
        }

        public Uri getFileUri() {
            return fileUri;
        }

        public ArrayList<String> getLongPressMenuItems() {
            return longPressMenuItems;
        }

        public ArrayList<String> getLongPressMenuOverrideItems() {
            return longPressMenuOverrideItems;
        }

        public ArrayList<String> getHideAnnotationMenuTools() {
            return hideAnnotationMenuTools;
        }

        public ArrayList<String> getAnnotationMenuItems() {
            return annotationMenuItems;
        }

        public ArrayList<String> getAnnotationMenuOverrideItems() {
            return annotationMenuOverrideItems;
        }
    }

    public static ConfigInfo handleOpenDocument(@NonNull ViewerConfig.Builder builder, @NonNull ToolManagerBuilder toolManagerBuilder,
                                                @NonNull PDFViewCtrlConfig pdfViewCtrlConfig, @NonNull String document, @NonNull Context context,
                                                String configStr) {

        ConfigInfo configInfo = new ConfigInfo();

        toolManagerBuilder.setOpenToolbar(true);
        ArrayList<ToolManager.ToolMode> disabledTools = new ArrayList<>();

        boolean isBase64 = false;
        String cacheDir = context.getCacheDir().getAbsolutePath();

        if (configStr != null && !configStr.equals("null")) {
            try {
                JSONObject configJson = new JSONObject(configStr);
                if (!configJson.isNull(KEY_CONFIG_DISABLED_ELEMENTS)) {
                    JSONArray array = configJson.getJSONArray(KEY_CONFIG_DISABLED_ELEMENTS);
                    disabledTools.addAll(disableElements(builder, array));
                }
                if (!configJson.isNull(KEY_CONFIG_DISABLED_TOOLS)) {
                    JSONArray array = configJson.getJSONArray(KEY_CONFIG_DISABLED_TOOLS);
                    disabledTools.addAll(disableTools(array));
                }
                if (!configJson.isNull(KEY_CONFIG_MULTI_TAB_ENABLED)) {
                    boolean val = configJson.getBoolean(KEY_CONFIG_MULTI_TAB_ENABLED);
                    builder.multiTabEnabled(val);
                }
                if (!configJson.isNull(KEY_CONFIG_CUSTOM_HEADERS)) {
                    JSONObject customHeaderJson = configJson.getJSONObject(KEY_CONFIG_CUSTOM_HEADERS);
                    configInfo.setCustomHeaderJson(customHeaderJson);
                }
                if (!configJson.isNull(KEY_CONFIG_LONG_PRESS_MENU_ENABLED)) {
                    boolean longPressMenuEnabled = configJson.getBoolean(KEY_CONFIG_LONG_PRESS_MENU_ENABLED);
                    toolManagerBuilder = toolManagerBuilder.setDisableQuickMenu(!longPressMenuEnabled);
                }
                if (!configJson.isNull(KEY_CONFIG_LONG_PRESS_MENU_ITEMS)) {
                    JSONArray array = configJson.getJSONArray(KEY_CONFIG_LONG_PRESS_MENU_ITEMS);
                    ArrayList<String> longPressMenuItems = convertJSONArrayToArrayList(array);
                    configInfo.setLongPressMenuItems(longPressMenuItems);
                }
                if (!configJson.isNull(KEY_CONFIG_OVERRIDE_LONG_PRESS_MENU_BEHAVIOR)) {
                    JSONArray array = configJson.getJSONArray(KEY_CONFIG_OVERRIDE_LONG_PRESS_MENU_BEHAVIOR);
                    ArrayList<String> longPressMenuOverrideItems = convertJSONArrayToArrayList(array);
                    configInfo.setLongPressMenuOverrideItems(longPressMenuOverrideItems);
                }
                if (!configJson.isNull(KEY_CONFIG_HIDE_ANNOTATION_MENU)) {
                    JSONArray array = configJson.getJSONArray(KEY_CONFIG_HIDE_ANNOTATION_MENU);
                    ArrayList<String> hideAnnotationMenuTools = convertJSONArrayToArrayList(array);
                    configInfo.setHideAnnotationMenuTools(hideAnnotationMenuTools);
                }
                if (!configJson.isNull(KEY_CONFIG_ANNOTATION_MENU_ITEMS)) {
                    JSONArray array = configJson.getJSONArray(KEY_CONFIG_ANNOTATION_MENU_ITEMS);
                    ArrayList<String> annotationMenuItems = convertJSONArrayToArrayList(array);
                    configInfo.setAnnotationMenuItems(annotationMenuItems);
                }
                if (!configJson.isNull(KEY_CONFIG_OVERRIDE_ANNOTATION_MENU_BEHAVIOR)) {
                    JSONArray array = configJson.getJSONArray(KEY_CONFIG_OVERRIDE_ANNOTATION_MENU_BEHAVIOR);
                    ArrayList<String> annotationMenuOverrideItems = convertJSONArrayToArrayList(array);
                    configInfo.setAnnotationMenuOverrideItems(annotationMenuOverrideItems);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }

        final Uri fileUri = getUri(context, document, isBase64);
        configInfo.setFileUri(fileUri);

        if (fileUri != null) {
            builder.openUrlCachePath(cacheDir)
                    .saveCopyExportPath(cacheDir);
            if (disabledTools.size() > 0) {
                ToolManager.ToolMode[] modes = disabledTools.toArray(new ToolManager.ToolMode[0]);
                if (modes.length > 0) {
                    toolManagerBuilder.disableToolModes(modes);
                }
            }

//        TODO: ViewModePickerItems
//        if (mViewModePickerItems.size() > 0) {
//            builder = builder.hideViewModeItems(mViewModePickerItems.toArray(new ViewModePickerDialogFragment.ViewModePickerItems[0]));
//        }
        }

        builder.pdfViewCtrlConfig(pdfViewCtrlConfig)
                .toolManagerBuilder(toolManagerBuilder);

        return configInfo;
    }

    private static Uri getUri(Context context, String path, boolean isBase64) {
        if (context == null || path == null) {
            return null;
        }
        try {
            if (isBase64) {
                byte[] data = Base64.decode(path, Base64.DEFAULT);
                File tempFile = File.createTempFile("tmp", ".pdf");
                FileOutputStream fos = null;
                try {
                    fos = new FileOutputStream(tempFile);
                    IOUtils.write(data, fos);
                    return Uri.fromFile(tempFile);
                } finally {
                    IOUtils.closeQuietly(fos);
                }
            }
            Uri fileUri = Uri.parse(path);
            if (ContentResolver.SCHEME_ANDROID_RESOURCE.equals(fileUri.getScheme())) {
                String resNameWithExtension = fileUri.getLastPathSegment();
                String extension = FilenameUtils.getExtension(resNameWithExtension);
                String resName = FilenameUtils.removeExtension(resNameWithExtension);
                int resId = Utils.getResourceRaw(context, resName);
                if (resId != 0) {
                    File file = Utils.copyResourceToLocal(context, resId,
                            resName, "." + extension);
                    if (null != file && file.exists()) {
                        fileUri = Uri.fromFile(file);
                    }
                }
            } else if (ContentResolver.SCHEME_FILE.equals(fileUri.getScheme())) {
                File file = new File(fileUri.getPath());
                fileUri = Uri.fromFile(file);
            }
            return fileUri;
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
    }

    private static ArrayList<ToolManager.ToolMode> disableElements(ViewerConfig.Builder builder, JSONArray args) throws JSONException {
        for (int i = 0; i < args.length(); i++) {
            String item = args.getString(i);
            if (BUTTON_TOOLS.equals(item)) {
                builder = builder.showAnnotationToolbarOption(false);
            } else if (BUTTON_SEARCH.equals(item)) {
                builder = builder.showSearchView(false);
            } else if (BUTTON_SHARE.equals(item)) {
                builder = builder.showShareOption(false);
            } else if (BUTTON_VIEW_CONTROLS.equals(item)) {
                builder = builder.showDocumentSettingsOption(false);
            } else if (BUTTON_THUMBNAILS.equals(item)) {
                builder = builder.showThumbnailView(false);
            } else if (BUTTON_LISTS.equals(item)) {
                builder = builder
                        .showAnnotationsList(false)
                        .showOutlineList(false)
                        .showUserBookmarksList(false);
            } else if (BUTTON_THUMBNAIL_SLIDER.equals(item)) {
                builder = builder.showBottomNavBar(false);
            } else if (BUTTON_SAVE_COPY.equals(item)) {
                builder = builder.showSaveCopyOption(false);
            } else if (BUTTON_EDIT_PAGES.equals(item)) {
                builder = builder.showEditPagesOption(false);
            } else if (BUTTON_PRINT.equals(item)) {
                builder = builder.showPrintOption(false);
            } else if (BUTTON_FILL_AND_SIGN.equals(item)) {
                builder = builder.showFillAndSignToolbarOption(false);
            } else if (BUTTON_PREPARE_FORM.equals(item)) {
                builder = builder.showFormToolbarOption(false);
            } else if (BUTTON_REFLOW_MODE.equals(item)) {
                builder = builder.showReflowOption(false);
            }
        }
        return disableTools(args);
    }

    private static ArrayList<ToolManager.ToolMode> disableTools(JSONArray args) throws JSONException {
        ArrayList<ToolManager.ToolMode> tools = new ArrayList<>();
        for (int i = 0; i < args.length(); i++) {
            String item = args.getString(i);
            ToolManager.ToolMode mode = convStringToToolMode(item);
            if (mode != null) {
                tools.add(mode);
            }
        }
        return tools;
    }

    private static ToolManager.ToolMode convStringToToolMode(String item) {
        ToolManager.ToolMode mode = null;
        if (TOOL_BUTTON_FREE_HAND.equals(item) || TOOL_ANNOTATION_CREATE_FREE_HAND.equals(item)) {
            mode = ToolManager.ToolMode.INK_CREATE;
        } else if (TOOL_BUTTON_HIGHLIGHT.equals(item) || TOOL_ANNOTATION_CREATE_TEXT_HIGHLIGHT.equals(item)) {
            mode = ToolManager.ToolMode.TEXT_HIGHLIGHT;
        } else if (TOOL_BUTTON_UNDERLINE.equals(item) || TOOL_ANNOTATION_CREATE_TEXT_UNDERLINE.equals(item)) {
            mode = ToolManager.ToolMode.TEXT_UNDERLINE;
        } else if (TOOL_BUTTON_SQUIGGLY.equals(item) || TOOL_ANNOTATION_CREATE_TEXT_SQUIGGLY.equals(item)) {
            mode = ToolManager.ToolMode.TEXT_SQUIGGLY;
        } else if (TOOL_BUTTON_STRIKEOUT.equals(item) || TOOL_ANNOTATION_CREATE_TEXT_STRIKEOUT.equals(item)) {
            mode = ToolManager.ToolMode.TEXT_STRIKEOUT;
        } else if (TOOL_BUTTON_RECTANGLE.equals(item) || TOOL_ANNOTATION_CREATE_RECTANGLE.equals(item)) {
            mode = ToolManager.ToolMode.RECT_CREATE;
        } else if (TOOL_BUTTON_ELLIPSE.equals(item) || TOOL_ANNOTATION_CREATE_ELLIPSE.equals(item)) {
            mode = ToolManager.ToolMode.OVAL_CREATE;
        } else if (TOOL_BUTTON_LINE.equals(item) || TOOL_ANNOTATION_CREATE_LINE.equals(item)) {
            mode = ToolManager.ToolMode.LINE_CREATE;
        } else if (TOOL_BUTTON_ARROW.equals(item) || TOOL_ANNOTATION_CREATE_ARROW.equals(item)) {
            mode = ToolManager.ToolMode.ARROW_CREATE;
        } else if (TOOL_BUTTON_POLYLINE.equals(item) || TOOL_ANNOTATION_CREATE_POLYLINE.equals(item)) {
            mode = ToolManager.ToolMode.POLYLINE_CREATE;
        } else if (TOOL_BUTTON_POLYGON.equals(item) || TOOL_ANNOTATION_CREATE_POLYGON.equals(item)) {
            mode = ToolManager.ToolMode.POLYGON_CREATE;
        } else if (TOOL_BUTTON_CLOUD.equals(item) || TOOL_ANNOTATION_CREATE_POLYGON_CLOUD.equals(item)) {
            mode = ToolManager.ToolMode.CLOUD_CREATE;
        } else if (TOOL_BUTTON_SIGNATURE.equals(item) || TOOL_ANNOTATION_CREATE_SIGNATURE.equals(item)) {
            mode = ToolManager.ToolMode.SIGNATURE;
        } else if (TOOL_BUTTON_FREE_TEXT.equals(item) || TOOL_ANNOTATION_CREATE_FREE_TEXT.equals(item)) {
            mode = ToolManager.ToolMode.TEXT_CREATE;
        } else if (TOOL_BUTTON_STICKY.equals(item) || TOOL_ANNOTATION_CREATE_STICKY.equals(item)) {
            mode = ToolManager.ToolMode.TEXT_ANNOT_CREATE;
        } else if (TOOL_BUTTON_CALLOUT.equals(item) || TOOL_ANNOTATION_CREATE_CALLOUT.equals(item)) {
            mode = ToolManager.ToolMode.CALLOUT_CREATE;
        } else if (TOOL_BUTTON_STAMP.equals(item) || TOOL_ANNOTATION_CREATE_STAMP.equals(item)) {
            mode = ToolManager.ToolMode.STAMPER;
        } else if (TOOL_ANNOTATION_CREATE_DISTANCE_MEASUREMENT.equals(item)) {
            mode = ToolManager.ToolMode.RULER_CREATE;
        } else if (TOOL_ANNOTATION_CREATE_PERIMETER_MEASUREMENT.equals(item)) {
            mode = ToolManager.ToolMode.PERIMETER_MEASURE_CREATE;
        } else if (TOOL_ANNOTATION_CREATE_AREA_MEASUREMENT.equals(item)) {
            mode = ToolManager.ToolMode.AREA_MEASURE_CREATE;
        } else if (TOOL_TEXT_SELECT.equals(item)) {
            mode = ToolManager.ToolMode.TEXT_SELECT;
        } else if (TOOL_ANNOTATION_EDIT.equals(item)) {
            mode = ToolManager.ToolMode.ANNOT_EDIT_RECT_GROUP;
        } else if (TOOL_ANNOTATION_CREATE_SOUND.equals(item)) {
            mode = ToolManager.ToolMode.SOUND_CREATE;
        } else if (TOOL_ANNOTATION_CREATE_FREE_HIGHLIGHTER.equals(item)) {
            mode = ToolManager.ToolMode.FREE_HIGHLIGHTER;
        } else if (TOOL_ANNOTATION_CREATE_RUBBER_STAMP.equals(item)) {
            mode = ToolManager.ToolMode.RUBBER_STAMPER;
        } else if (TOOL_ERASER.equals(item)) {
            mode = ToolManager.ToolMode.INK_ERASER;
        }
        return mode;
    }

    @Nullable
    public static int convStringToAnnotType(String item) {
        int annotType = Annot.e_Unknown;
        if (TOOL_BUTTON_FREE_HAND.equals(item) || TOOL_ANNOTATION_CREATE_FREE_HAND.equals(item)) {
            annotType = Annot.e_Ink;
        } else if (TOOL_BUTTON_HIGHLIGHT.equals(item) || TOOL_ANNOTATION_CREATE_TEXT_HIGHLIGHT.equals(item)) {
            annotType = Annot.e_Highlight;
        } else if (TOOL_BUTTON_UNDERLINE.equals(item) || TOOL_ANNOTATION_CREATE_TEXT_UNDERLINE.equals(item)) {
            annotType = Annot.e_Underline;
        } else if (TOOL_BUTTON_SQUIGGLY.equals(item) || TOOL_ANNOTATION_CREATE_TEXT_SQUIGGLY.equals(item)) {
            annotType = Annot.e_Squiggly;
        } else if (TOOL_BUTTON_STRIKEOUT.equals(item) || TOOL_ANNOTATION_CREATE_TEXT_STRIKEOUT.equals(item)) {
            annotType = Annot.e_StrikeOut;
        } else if (TOOL_BUTTON_RECTANGLE.equals(item) || TOOL_ANNOTATION_CREATE_RECTANGLE.equals(item)) {
            annotType = Annot.e_Square;
        } else if (TOOL_BUTTON_ELLIPSE.equals(item) || TOOL_ANNOTATION_CREATE_ELLIPSE.equals(item)) {
            annotType = Annot.e_Circle;
        } else if (TOOL_BUTTON_LINE.equals(item) || TOOL_ANNOTATION_CREATE_LINE.equals(item)) {
            annotType = Annot.e_Line;
        } else if (TOOL_BUTTON_ARROW.equals(item) || TOOL_ANNOTATION_CREATE_ARROW.equals(item)) {
            annotType = AnnotStyle.CUSTOM_ANNOT_TYPE_ARROW;
        } else if (TOOL_BUTTON_POLYLINE.equals(item) || TOOL_ANNOTATION_CREATE_POLYLINE.equals(item)) {
            annotType = Annot.e_Polyline;
        } else if (TOOL_BUTTON_POLYGON.equals(item) || TOOL_ANNOTATION_CREATE_POLYGON.equals(item)) {
            annotType = Annot.e_Polygon;
        } else if (TOOL_BUTTON_CLOUD.equals(item) || TOOL_ANNOTATION_CREATE_POLYGON_CLOUD.equals(item)) {
            annotType = AnnotStyle.CUSTOM_ANNOT_TYPE_CLOUD;
        } else if (TOOL_BUTTON_SIGNATURE.equals(item) || TOOL_ANNOTATION_CREATE_SIGNATURE.equals(item)) {
            annotType = AnnotStyle.CUSTOM_ANNOT_TYPE_SIGNATURE;
        } else if (TOOL_BUTTON_FREE_TEXT.equals(item) || TOOL_ANNOTATION_CREATE_FREE_TEXT.equals(item)) {
            annotType = Annot.e_FreeText;
        } else if (TOOL_BUTTON_STICKY.equals(item) || TOOL_ANNOTATION_CREATE_STICKY.equals(item)) {
            annotType = Annot.e_Text;
        } else if (TOOL_BUTTON_CALLOUT.equals(item) || TOOL_ANNOTATION_CREATE_CALLOUT.equals(item)) {
            annotType = AnnotStyle.CUSTOM_ANNOT_TYPE_CALLOUT;
        } else if (TOOL_BUTTON_STAMP.equals(item) || TOOL_ANNOTATION_CREATE_STAMP.equals(item)) {
            annotType = Annot.e_Stamp;
        } else if (TOOL_ANNOTATION_CREATE_DISTANCE_MEASUREMENT.equals(item)) {
            annotType = AnnotStyle.CUSTOM_ANNOT_TYPE_RULER;
        } else if (TOOL_ANNOTATION_CREATE_PERIMETER_MEASUREMENT.equals(item)) {
            annotType = AnnotStyle.CUSTOM_ANNOT_TYPE_PERIMETER_MEASURE;
        } else if (TOOL_ANNOTATION_CREATE_AREA_MEASUREMENT.equals(item)) {
            annotType = AnnotStyle.CUSTOM_ANNOT_TYPE_AREA_MEASURE;
        } else if (TOOL_ANNOTATION_CREATE_FILE_ATTACHMENT.equals(item)) {
            annotType = Annot.e_FileAttachment;
        } else if (TOOL_ANNOTATION_CREATE_SOUND.equals(item)) {
            annotType = Annot.e_Sound;
        } else if (TOOL_ANNOTATION_CREATE_REDACTION.equals(item) || TOOL_ANNOTATION_CREATE_REDACTION_TEXT.equals(item)) {
            annotType = Annot.e_Redact;
        } else if (TOOL_ANNOTATION_CREATE_LINK.equals(item) || TOOL_ANNOTATION_CREATE_LINK_TEXT.equals(item)) {
            annotType = Annot.e_Link;
        } else if (TOOL_FORM_CREATE_TEXT_FIELD.equals(item)) {
            annotType = Annot.e_Widget;
        } else if (TOOL_FORM_CREATE_CHECKBOX_FIELD.equals(item)) {
            annotType = Annot.e_Widget;
        } else if (TOOL_FORM_CREATE_SIGNATURE_FIELD.equals(item)) {
            annotType = Annot.e_Widget;
        } else if (TOOL_FORM_CREATE_RADIO_FIELD.equals(item)) {
            annotType = Annot.e_Widget;
        } else if (TOOL_FORM_CREATE_COMBO_BOX_FIELD.equals(item)) {
            annotType = Annot.e_Widget;
        } else if (TOOL_FORM_CREATE_TOOL_BOX_FIELD.equals(item)) {
            annotType = Annot.e_Widget;
        }
        return annotType;
    }

    @Nullable
    public static String convQuickMenuIdToString(int id) {
        String menuStr = null;
        if (id == R.id.qm_appearance) {
            menuStr = MENU_ID_STRING_STYLE;
        } else if (id == R.id.qm_note) {
            menuStr = MENU_ID_STRING_NOTE;
        } else if (id == R.id.qm_copy) {
            menuStr = MENU_ID_STRING_COPY;
        } else if (id == R.id.qm_delete) {
            menuStr = MENU_ID_STRING_DELETE;
        } else if (id == R.id.qm_flatten) {
            menuStr = MENU_ID_STRING_FLATTEN;
        } else if (id == R.id.qm_text) {
            menuStr = MENU_ID_STRING_TEXT;
        } else if (id == R.id.qm_edit) {
            menuStr = MENU_ID_STRING_EDIT_INK;
        } else if (id == R.id.qm_search) {
            menuStr = MENU_ID_STRING_SEARCH;
        } else if (id == R.id.qm_share) {
            menuStr = MENU_ID_STRING_SHARE;
        } else if (id == R.id.qm_type) {
            menuStr = MENU_ID_STRING_MARKUP_TYPE;
        } else if (id == R.id.qm_screencap_create) {
            menuStr = MENU_ID_STRING_SCREEN_CAPTURE;
        } else if (id == R.id.qm_play_sound) {
            menuStr = MENU_ID_STRING_PLAY_SOUND;
        } else if (id == R.id.qm_open_attachment) {
            menuStr = MENU_ID_STRING_OPEN_ATTACHMENT;
        } else if (id == R.id.qm_tts) {
            menuStr = MENU_ID_STRING_READ;
        } else if (id == R.id.qm_calibrate) {
            menuStr = MENU_ID_STRING_CALIBRATE;
        } else if (id == R.id.qm_underline) {
            menuStr = MENU_ID_STRING_UNDERLINE;
        } else if (id == R.id.qm_redact) {
            menuStr = MENU_ID_STRING_REDACT;
        } else if (id == R.id.qm_redaction) {
            menuStr = MENU_ID_STRING_REDACTION;
        } else if (id == R.id.qm_strikeout) {
            menuStr = MENU_ID_STRING_STRIKEOUT;
        } else if (id == R.id.qm_squiggly) {
            menuStr = MENU_ID_STRING_SQUIGGLY;
        } else if (id == R.id.qm_link) {
            menuStr = MENU_ID_STRING_LINK;
        } else if (id == R.id.qm_highlight) {
            menuStr = MENU_ID_STRING_HIGHLIGHT;
        } else if (id == R.id.qm_floating_sig) {
            menuStr = MENU_ID_STRING_SIGNATURE;
        } else if (id == R.id.qm_rectangle) {
            menuStr = MENU_ID_STRING_RECTANGLE;
        } else if (id == R.id.qm_line) {
            menuStr = MENU_ID_STRING_LINE;
        } else if (id == R.id.qm_free_hand) {
            menuStr = MENU_ID_STRING_FREE_HAND;
        } else if (id == R.id.qm_image_stamper) {
            menuStr = MENU_ID_STRING_IMAGE;
        } else if (id == R.id.qm_form_text) {
            menuStr = MENU_ID_STRING_FORM_TEXT;
        } else if (id == R.id.qm_sticky_note) {
            menuStr = MENU_ID_STRING_STICKY_NOTE;
        } else if (id == R.id.qm_overflow) {
            menuStr = MENU_ID_STRING_OVERFLOW;
        } else if (id == R.id.qm_ink_eraser) {
            menuStr = MENU_ID_STRING_ERASER;
        } else if (id == R.id.qm_rubber_stamper) {
            menuStr = MENU_ID_STRING_STAMP;
        } else if (id == R.id.qm_page_redaction) {
            menuStr = MENU_ID_STRING_PAGE_REDACTION;
        } else if (id == R.id.qm_rect_redaction) {
            menuStr = MENU_ID_STRING_RECT_REDACTION;
        } else if (id == R.id.qm_search_redaction) {
            menuStr = MENU_ID_STRING_SEARCH_REDACTION;
        } else if (id == R.id.qm_shape) {
            menuStr = MENU_ID_STRING_SHAPE;
        } else if (id == R.id.qm_cloud) {
            menuStr = MENU_ID_STRING_CLOUD;
        } else if (id == R.id.qm_polygon) {
            menuStr = MENU_ID_STRING_POLYGON;
        } else if (id == R.id.qm_polyline) {
            menuStr = MENU_ID_STRING_POLYLINE;
        } else if (id == R.id.qm_free_highlighter) {
            menuStr = MENU_ID_STRING_FREE_HIGHLIGHTER;
        } else if (id == R.id.qm_arrow) {
            menuStr = MENU_ID_STRING_ARROW;
        } else if (id == R.id.qm_oval) {
            menuStr = MENU_ID_STRING_OVAL;
        } else if (id == R.id.qm_callout) {
            menuStr = MENU_ID_STRING_CALLOUT;
        } else if (id == R.id.qm_measurement) {
            menuStr = MENU_ID_STRING_MEASUREMENT;
        } else if (id == R.id.qm_area_measure) {
            menuStr = MENU_ID_STRING_AREA_MEASUREMENT;
        } else if (id == R.id.qm_perimeter_measure) {
            menuStr = MENU_ID_STRING_PERIMETER_MEASUREMENT;
        } else if (id == R.id.qm_rect_area_measure) {
            menuStr = MENU_ID_STRING_RECT_AREA_MEASUREMENT;
        } else if (id == R.id.qm_ruler) {
            menuStr = MENU_ID_STRING_RULER;
        } else if (id == R.id.qm_form) {
            menuStr = MENU_ID_STRING_FORM;
        } else if (id == R.id.qm_form_combo_box) {
            menuStr = MENU_ID_STRING_FORM_COMBO_BOX;
        } else if (id == R.id.qm_form_list_box) {
            menuStr = MENU_ID_STRING_FORM_LIST_BOX;
        } else if (id == R.id.qm_form_check_box) {
            menuStr = MENU_ID_STRING_FORM_CHECK_BOX;
        } else if (id == R.id.qm_form_signature) {
            menuStr = MENU_ID_STRING_FORM_SIGNATURE;
        } else if (id == R.id.qm_form_radio_group) {
            menuStr = MENU_ID_STRING_FORM_RADIO_GROUP;
        } else if (id == R.id.qm_attach) {
            menuStr = MENU_ID_STRING_ATTACH;
        } else if (id == R.id.qm_file_attachment) {
            menuStr = MENU_ID_STRING_FILE_ATTACHMENT;
        } else if (id == R.id.qm_sound) {
            menuStr = MENU_ID_STRING_SOUND;
        } else if (id == R.id.qm_free_text) {
            menuStr = MENU_ID_STRING_FREE_TEXT;
        } else if (id == R.id.qm_crop) {
            menuStr = MENU_ID_STRING_CROP;
        } else if (id == R.id.qm_crop_ok) {
            menuStr = MENU_ID_STRING_CROP_OK;
        } else if (id == R.id.qm_crop_cancel) {
            menuStr = MENU_ID_STRING_CROP_CANCEL;
        } else if (id == R.id.qm_define) {
            menuStr = MENU_ID_STRING_DEFINE;
        } else if (id == R.id.qm_field_signed) {
            menuStr = MENU_ID_STRING_FIELD_SIGNED;
        } else if (id == R.id.qm_first_row_group) {
            menuStr = MENU_ID_STRING_FIRST_ROW_GROUP;
        } else if (id == R.id.qm_second_row_group) {
            menuStr = MENU_ID_STRING_SECOND_ROW_GROUP;
        } else if (id == R.id.qm_group) {
            menuStr = MENU_ID_STRING_GROUP;
        } else if (id == R.id.qm_paste) {
            menuStr = MENU_ID_STRING_PASTE;
        } else if (id == R.id.qm_rect_group_select) {
            menuStr = MENU_ID_STRING_RECT_GROUP_SELECT;
        } else if (id == R.id.qm_sign_and_save) {
            menuStr = MENU_ID_STRING_SIGN_AND_SAVE;
        } else if (id == R.id.qm_thickness) {
            menuStr = MENU_ID_STRING_THICKNESS;
        } else if (id == R.id.qm_translate) {
            menuStr = MENU_ID_STRING_TRANSLATE;
        } else if (id == R.id.qm_type) {
            menuStr = MENU_ID_STRING_TYPE;
        } else if (id == R.id.qm_ungroup) {
            menuStr = MENU_ID_STRING_UNGROUP;
        }

        return menuStr;
    }

    public static void onMethodCall(MethodCall call, MethodChannel.Result result, ViewerComponent component) {
        switch (call.method) {
            case FUNCTION_IMPORT_ANNOTATIONS: {
                checkFunctionPrecondition(component);
                String xfdf = call.argument(KEY_XFDF);
                try {
                    importAnnotations(xfdf, result, component);
                } catch (PDFNetException ex) {
                    ex.printStackTrace();
                    result.error(Long.toString(ex.getErrorCode()), "PDFTronException Error: " + ex, null);
                }
                break;
            }
            case FUNCTION_EXPORT_ANNOTATIONS: {
                checkFunctionPrecondition(component);
                String annotationList = call.argument(KEY_ANNOTATION_LIST);
                try {
                    exportAnnotations(annotationList, result, component);
                } catch (JSONException ex) {
                    ex.printStackTrace();
                    result.error(Integer.toString(ex.hashCode()), "JSONException Error: " + ex, null);
                } catch (PDFNetException ex) {
                    ex.printStackTrace();
                    result.error(Long.toString(ex.getErrorCode()), "PDFTronException Error: " + ex, null);
                }
                break;
            }
            case FUNCTION_FLATTEN_ANNOTATIONS: {
                checkFunctionPrecondition(component);
                Boolean formsOnly = call.argument(KEY_FORMS_ONLY);
                if (formsOnly != null) {
                    try {
                        flattenAnnotations(formsOnly, result, component);
                    } catch (PDFNetException ex) {
                        ex.printStackTrace();
                        result.error(Long.toString(ex.getErrorCode()), "PDFTronException Error: " + ex, null);
                    }
                }
                break;
            }
            case FUNCTION_DELETE_ANNOTATIONS: {
                checkFunctionPrecondition(component);
                String annotationList = call.argument(KEY_ANNOTATION_LIST);
                try {
                    deleteAnnotations(annotationList, result, component);
                } catch (JSONException ex) {
                    ex.printStackTrace();
                    result.error(Integer.toString(ex.hashCode()), "JSONException Error: " + ex, null);
                } catch (PDFNetException ex) {
                    ex.printStackTrace();
                    result.error(Long.toString(ex.getErrorCode()), "PDFTronException Error: " + ex, null);
                }
                break;
            }
            case FUNCTION_SELECT_ANNOTATION: {
                checkFunctionPrecondition(component);
                String annotation = call.argument(KEY_ANNOTATION);
                try {
                    selectAnnotation(annotation, result, component);
                } catch (JSONException ex) {
                    ex.printStackTrace();
                    result.error(Integer.toString(ex.hashCode()), "JSONException Error: " + ex, null);
                } catch (PDFNetException ex) {
                    ex.printStackTrace();
                    result.error(Long.toString(ex.getErrorCode()), "PDFTronException Error: " + ex, null);
                }
                break;
            }
            case FUNCTION_SET_FLAGS_FOR_ANNOTATIONS: {
                checkFunctionPrecondition(component);
                String annotationsWithFlags = call.argument(KEY_ANNOTATIONS_WITH_FLAGS);
                try {
                    setFlagsForAnnotations(annotationsWithFlags, result, component);
                } catch (JSONException ex) {
                    ex.printStackTrace();
                    result.error(Integer.toString(ex.hashCode()), "JSONException Error: " + ex, null);
                } catch (PDFNetException ex) {
                    ex.printStackTrace();
                    result.error(Long.toString(ex.getErrorCode()), "PDFTronException Error: " + ex, null);
                }
                break;
            }
            case FUNCTION_IMPORT_ANNOTATION_COMMAND: {
                checkFunctionPrecondition(component);
                String xfdfCommand = call.argument(KEY_XFDF_COMMAND);
                try {
                    importAnnotationCommand(xfdfCommand, result, component);
                } catch (PDFNetException ex) {
                    ex.printStackTrace();
                    result.error(Long.toString(ex.getErrorCode()), "PDFTronException Error: " + ex, null);
                }
                break;
            }
            case FUNCTION_IMPORT_BOOKMARK_JSON: {
                checkFunctionPrecondition(component);
                String bookmarkJson = call.argument(KEY_BOOKMARK_JSON);
                try {
                    importBookmarkJson(bookmarkJson, result, component);
                } catch (JSONException ex) {
                    ex.printStackTrace();
                    result.error(Integer.toString(ex.hashCode()), "JSONException Error: " + ex, null);
                }
                break;
            }
            case FUNCTION_SAVE_DOCUMENT: {
                checkFunctionPrecondition(component);
                saveDocument(result, component);
                break;
            }
            case FUNCTION_COMMIT_TOOL: {
                checkFunctionPrecondition(component);
                commitTool(result, component);
                break;
            }
            case FUNCTION_GET_PAGE_COUNT: {
                checkFunctionPrecondition(component);
                try {
                    getPageCount(result, component);
                } catch (PDFNetException ex) {
                    ex.printStackTrace();
                    result.error(Long.toString(ex.getErrorCode()), "PDFTronException Error: " + ex, null);
                }
                break;
            }
            case FUNCTION_HANDLE_BACK_BUTTON: {
                checkFunctionPrecondition(component);
                handleBackButton(result, component);
                break;
            }
            case FUNCTION_GET_PAGE_CROP_BOX: {
                checkFunctionPrecondition(component);
                Integer pageNumber = call.argument(KEY_PAGE_NUMBER);
                if (pageNumber != null) {
                    try {
                        getPageCropBox(pageNumber, result, component);
                    } catch (JSONException ex) {
                        ex.printStackTrace();
                        result.error(Integer.toString(ex.hashCode()), "JSONException Error: " + ex, null);
                    } catch (PDFNetException ex) {
                        ex.printStackTrace();
                        result.error(Long.toString(ex.getErrorCode()), "PDFTronException Error: " + ex, null);
                    }
                }
                break;
            }
            default:
                result.notImplemented();
                break;
        }
    }

    // Methods

    private static void importAnnotations(String xfdf, MethodChannel.Result result, ViewerComponent component) throws PDFNetException {
        PDFViewCtrl pdfViewCtrl = component.getPdfViewCtrl();
        PDFDoc pdfDoc = component.getPdfDoc();
        if (null == pdfViewCtrl || null == pdfDoc || null == xfdf) {
            result.error("InvalidState", "Activity not attached", null);
            return;
        }
        boolean shouldUnlockRead = false;
        try {
            pdfViewCtrl.docLockRead();
            shouldUnlockRead = true;

            if (pdfDoc.hasDownloader()) {
                // still downloading file, let's wait for next call
                result.error("InvalidState", "Document download in progress, try again later", null);
                return;
            }
        } finally {
            if (shouldUnlockRead) {
                pdfViewCtrl.docUnlockRead();
            }
        }

        boolean shouldUnlock = false;
        try {
            pdfViewCtrl.docLock(true);
            shouldUnlock = true;

            FDFDoc fdfDoc = FDFDoc.createFromXFDF(xfdf);

            pdfDoc.fdfUpdate(fdfDoc);
            pdfViewCtrl.update(true);

            result.success(null);
        } finally {
            if (shouldUnlock) {
                pdfViewCtrl.docUnlock();
            }
        }
    }

    private static void exportAnnotations(String annotationList, MethodChannel.Result result, ViewerComponent component) throws PDFNetException, JSONException {
        PDFViewCtrl pdfViewCtrl = component.getPdfViewCtrl();

        if (null == pdfViewCtrl) {
            result.error("InvalidState", "Activity not attached", null);
            return;
        }

        boolean shouldUnlockRead = false;
        try {
            pdfViewCtrl.docLockRead();
            shouldUnlockRead = true;

            PDFDoc pdfDoc = pdfViewCtrl.getDoc();
            if (null == annotationList) {
                FDFDoc fdfDoc = pdfDoc.fdfExtract(PDFDoc.e_both);
                result.success(fdfDoc.saveAsXFDF());
            } else {
                JSONArray annotationJsonArray = new JSONArray(annotationList);
                ArrayList<Annot> validAnnotationList = new ArrayList<>(annotationJsonArray.length());
                for (int i = 0; i < annotationJsonArray.length(); i++) {
                    JSONObject currAnnot = annotationJsonArray.getJSONObject(i);
                    if (currAnnot != null) {
                        String currAnnotId = currAnnot.getString(KEY_ANNOTATION_ID);
                        int currAnnotPageNumber = currAnnot.getInt(KEY_PAGE_NUMBER);
                        if (!Utils.isNullOrEmpty(currAnnotId)) {
                            Annot validAnnotation = ViewerUtils.getAnnotById(pdfViewCtrl, currAnnotId, currAnnotPageNumber);
                            if (validAnnotation != null && validAnnotation.isValid()) {
                                validAnnotationList.add(validAnnotation);
                            }
                        }
                    }
                }

                if (validAnnotationList.size() > 0) {
                    FDFDoc fdfDoc = pdfDoc.fdfExtract(validAnnotationList);
                    result.success(fdfDoc.saveAsXFDF());
                } else {
                    result.success("");
                }
            }
        } finally {
            if (shouldUnlockRead) {
                pdfViewCtrl.docUnlockRead();
            }
        }
    }

    private static void flattenAnnotations(boolean formsOnly, MethodChannel.Result result, ViewerComponent component) throws PDFNetException {
        PDFViewCtrl pdfViewCtrl = component.getPdfViewCtrl();
        PDFDoc pdfDoc = component.getPdfDoc();
        if (null == pdfViewCtrl || null == pdfDoc) {
            result.error("InvalidState", "Activity not attached", null);
            return;
        }
        if (pdfViewCtrl.getToolManager() instanceof ToolManager) {
            ToolManager toolManager = (ToolManager) pdfViewCtrl.getToolManager();
            toolManager.setTool(toolManager.createTool(ToolManager.ToolMode.PAN, toolManager.getTool()));
        }

        boolean shouldUnlock = false;
        try {
            pdfViewCtrl.docLock(true);
            shouldUnlock = true;

            pdfDoc.flattenAnnotations(formsOnly);
        } finally {
            if (shouldUnlock) {
                pdfViewCtrl.docUnlock();
            }
            result.success(null);
        }
    }

    private static void deleteAnnotations(String annotationList, MethodChannel.Result result, ViewerComponent component) throws PDFNetException, JSONException {
        PDFViewCtrl pdfViewCtrl = component.getPdfViewCtrl();
        PDFDoc pdfDoc = component.getPdfDoc();

        if (null == pdfViewCtrl || null == pdfDoc) {
            result.error("InvalidState", "Activity not attached", null);
            return;
        }

        ToolManager toolManager = (ToolManager) pdfViewCtrl.getToolManager();

        JSONArray annotationJsonArray = new JSONArray(annotationList);

        for (int i = 0; i < annotationJsonArray.length(); i++) {
            JSONObject currAnnot = annotationJsonArray.getJSONObject(i);

            if (currAnnot != null) {
                String currAnnotId = currAnnot.getString(KEY_ANNOTATION_ID);
                int currAnnotPageNumber = currAnnot.getInt(KEY_PAGE_NUMBER);

                if (!Utils.isNullOrEmpty(currAnnotId)) {
                    Annot validAnnotation = ViewerUtils.getAnnotById(pdfViewCtrl, currAnnotId, currAnnotPageNumber);

                    if (validAnnotation != null && validAnnotation.isValid()) {
                        boolean shouldUnlock = false;

                        try {
                            pdfViewCtrl.docLock(true);
                            shouldUnlock = true;
                            HashMap<Annot, Integer> map = new HashMap<>(1);
                            map.put(validAnnotation, currAnnotPageNumber);
                            toolManager.raiseAnnotationsPreRemoveEvent(map);

                            Page page = pdfViewCtrl.getDoc().getPage(currAnnotPageNumber);
                            page.annotRemove(validAnnotation);
                            pdfViewCtrl.update(validAnnotation, currAnnotPageNumber);

                            toolManager.raiseAnnotationsRemovedEvent(map);
                        } finally {
                            if (shouldUnlock) {
                                pdfViewCtrl.docUnlock();
                            }
                        }
                        toolManager.deselectAll();
                    }
                }
            }
        }
    }

    private static void selectAnnotation(String annotation, MethodChannel.Result result, ViewerComponent component) throws PDFNetException, JSONException {
        PDFViewCtrl pdfViewCtrl = component.getPdfViewCtrl();
        PDFDoc pdfDoc = component.getPdfDoc();

        if (null == pdfViewCtrl || null == pdfDoc) {
            result.error("InvalidState", "Activity not attached", null);
            return;
        }

        JSONObject annotationJson = new JSONObject(annotation);

        ToolManager toolManager = (ToolManager) pdfViewCtrl.getToolManager();

        String annotationId = annotationJson.getString(KEY_ANNOTATION_ID);
        int annotationPageNumber = annotationJson.getInt(KEY_PAGE_NUMBER);

        if (!Utils.isNullOrEmpty(annotationId)) {
            toolManager.selectAnnot(annotationId, annotationPageNumber);
        }
    }

    private static void setFlagsForAnnotations(String annotationsWithFlags, MethodChannel.Result result, ViewerComponent component) throws PDFNetException, JSONException {
        PDFViewCtrl pdfViewCtrl = component.getPdfViewCtrl();
        PDFDoc pdfDoc = component.getPdfDoc();
        ToolManager toolManager = component.getToolManager();

        if (null == pdfViewCtrl || null == pdfDoc || null == toolManager) {
            result.error("InvalidState", "Activity not attached", null);
            return;
        }

        JSONArray annotationWithFlagsArray = new JSONArray(annotationsWithFlags);

        boolean shouldUnlock = false;
        try {
            pdfViewCtrl.docLock(true);
            shouldUnlock = true;

            // for each annotation
            for (int i = 0; i < annotationWithFlagsArray.length(); i++) {
                JSONObject currentAnnotationWithFlags = annotationWithFlagsArray.getJSONObject(i);

                JSONObject currentAnnotation = getJSONObjectFromJSONObject(currentAnnotationWithFlags, KEY_ANNOTATION);
                String currentAnnotationId = currentAnnotation.getString(KEY_ANNOTATION_ID);
                int currentAnnotationPageNumber = currentAnnotation.getInt(KEY_PAGE_NUMBER);

                if (!Utils.isNullOrEmpty(currentAnnotationId)) {
                    Annot validAnnotation = ViewerUtils.getAnnotById(pdfViewCtrl, currentAnnotationId, currentAnnotationPageNumber);

                    if (validAnnotation == null || !validAnnotation.isValid()) {
                        continue;
                    }

                    JSONArray currentFlagArray = getJSONArrayFromJSONObject(currentAnnotationWithFlags, KEY_ANNOTATION_FLAG_LISTS);

                    // for each flag
                    for (int j = 0; j < currentFlagArray.length(); j++) {
                        JSONObject currentFlagObject = currentFlagArray.getJSONObject(j);
                        String currentFlag = currentFlagObject.getString(KEY_ANNOTATION_FLAG);
                        boolean currentFlagValue = currentFlagObject.getBoolean(KEY_ANNOTATION_FLAG_VALUE);

                        if (currentFlag == null) {
                            continue;
                        }

                        int flagNumber = -1;
                        switch (currentFlag) {
                            case ANNOTATION_FLAG_HIDDEN:
                                flagNumber = Annot.e_hidden;
                                break;
                            case ANNOTATION_FLAG_INVISIBLE:
                                flagNumber = Annot.e_invisible;
                                break;
                            case ANNOTATION_FLAG_LOCKED:
                                flagNumber = Annot.e_locked;
                                break;
                            case ANNOTATION_FLAG_LOCKED_CONTENTS:
                                flagNumber = Annot.e_locked_contents;
                                break;
                            case ANNOTATION_FLAG_NO_ROTATE:
                                flagNumber = Annot.e_no_rotate;
                                break;
                            case ANNOTATION_FLAG_NO_VIEW:
                                flagNumber = Annot.e_no_view;
                                break;
                            case ANNOTATION_FLAG_NO_ZOOM:
                                flagNumber = Annot.e_no_zoom;
                                break;
                            case ANNOTATION_FLAG_PRINT:
                                flagNumber = Annot.e_print;
                                break;
                            case ANNOTATION_FLAG_READ_ONLY:
                                flagNumber = Annot.e_read_only;
                                break;
                            case ANNOTATION_FLAG_TOGGLE_NO_VIEW:
                                flagNumber = Annot.e_toggle_no_view;
                                break;
                        }
                        if (flagNumber != -1) {

                            HashMap<Annot, Integer> map = new HashMap<>(1);
                            map.put(validAnnotation, currentAnnotationPageNumber);
                            toolManager.raiseAnnotationsPreModifyEvent(map);

                            validAnnotation.setFlag(flagNumber, currentFlagValue);
                            pdfViewCtrl.update(validAnnotation, currentAnnotationPageNumber);

                            toolManager.raiseAnnotationsModifiedEvent(map, Tool.getAnnotationModificationBundle(null));
                        }
                    }
                }
            }
        } finally {
            if (shouldUnlock) {
                pdfViewCtrl.docUnlock();
            }
        }
    }

    private static void importAnnotationCommand(String xfdfCommand, MethodChannel.Result result, ViewerComponent component) throws PDFNetException {
        PDFViewCtrl pdfViewCtrl = component.getPdfViewCtrl();
        PDFDoc pdfDoc = component.getPdfDoc();
        if (null == pdfViewCtrl || null == pdfDoc || null == xfdfCommand) {
            result.error("InvalidState", "Activity not attached", null);
            return;
        }
        boolean shouldUnlockRead = false;
        try {
            pdfViewCtrl.docLockRead();
            shouldUnlockRead = true;

            if (pdfDoc.hasDownloader()) {
                // still downloading file, let's wait for next call
                result.error("InvalidState", "Document download in progress, try again later", null);
                return;
            }
        } finally {
            if (shouldUnlockRead) {
                pdfViewCtrl.docUnlockRead();
            }
        }

        boolean shouldUnlock = false;
        try {
            pdfViewCtrl.docLock(true);
            shouldUnlock = true;

            FDFDoc fdfDoc = pdfDoc.fdfExtract(PDFDoc.e_both);
            fdfDoc.mergeAnnots(xfdfCommand);

            pdfDoc.fdfUpdate(fdfDoc);
            pdfViewCtrl.update(true);
            result.success(null);
        } finally {
            if (shouldUnlock) {
                pdfViewCtrl.docUnlock();
            }
        }
    }

    private static void importBookmarkJson(String bookmarkJson, MethodChannel.Result result, ViewerComponent component) throws JSONException {
        PDFViewCtrl pdfViewCtrl = component.getPdfViewCtrl();
        if (null == pdfViewCtrl || null == bookmarkJson) {
            result.error("InvalidState", "Activity not attached", null);
            return;
        }
        BookmarkManager.importPdfBookmarks(pdfViewCtrl, bookmarkJson);
        result.success(null);
    }

    private static void saveDocument(MethodChannel.Result result, ViewerComponent component) {
        PdfViewCtrlTabFragment pdfViewCtrlTabFragment = component.getPdfViewCtrlTabFragment();
        if (pdfViewCtrlTabFragment != null) {
            pdfViewCtrlTabFragment.setSavingEnabled(true);
            pdfViewCtrlTabFragment.save(false, true, true);
            // TODO if add auto save flag: getPdfViewCtrlTabFragment().setSavingEnabled(mAutoSaveEnabled);
            result.success(pdfViewCtrlTabFragment.getFilePath());
            return;
        }
        result.error("InvalidState", "Activity not attached", null);
    }

    private static void commitTool(MethodChannel.Result result, ViewerComponent component) {
        ToolManager toolManager = component.getToolManager();
        if (toolManager != null) {
            ToolManager.Tool currentTool = toolManager.getTool();
            if (currentTool instanceof FreehandCreate) {
                ((FreehandCreate) currentTool).commitAnnotation();
                toolManager.setTool(toolManager.createTool(ToolManager.ToolMode.PAN, null));
                result.success(true);
            } else if (currentTool instanceof AdvancedShapeCreate) {
                ((AdvancedShapeCreate) currentTool).commit();
                toolManager.setTool(toolManager.createTool(ToolManager.ToolMode.PAN, null));
                result.success(true);
            }
            result.success(false);
            return;
        }
        result.error("InvalidState", "Tool manager not found", null);
    }

    private static void getPageCount(MethodChannel.Result result, ViewerComponent component) throws PDFNetException {
        PDFDoc pdfDoc = component.getPdfDoc();
        if (pdfDoc == null) {
            result.error("InvalidState", "Activity not attached", null);
            return;
        }
        result.success(pdfDoc.getPageCount());
    }

    private static void handleBackButton(MethodChannel.Result result, ViewerComponent component) {
        PdfViewCtrlTabHostFragment pdfViewCtrlTabHostFragment = component.getPdfViewCtrlTabHostFragment();
        if (pdfViewCtrlTabHostFragment == null) {
            result.error("InvalidState", "Activity not attached", null);
            return;
        }

        result.success(pdfViewCtrlTabHostFragment.handleBackPressed());
    }

    private static void getPageCropBox(int pageNumber, MethodChannel.Result result, ViewerComponent component) throws PDFNetException, JSONException {
        JSONObject jsonObject = new JSONObject();
        PDFDoc pdfDoc = component.getPdfDoc();
        if (pdfDoc == null) {
            result.error("InvalidState", "Activity not attached", null);
            return;
        }
        Rect rect = pdfDoc.getPage(pageNumber).getCropBox();
        jsonObject.put(KEY_X1, rect.getX1());
        jsonObject.put(KEY_Y1, rect.getY1());
        jsonObject.put(KEY_X2, rect.getX2());
        jsonObject.put(KEY_Y2, rect.getY2());
        jsonObject.put(KEY_WIDTH, rect.getWidth());
        jsonObject.put(KEY_HEIGHT, rect.getHeight());
        result.success(jsonObject.toString());
    }

    // Events

    public static void handleDocumentLoaded(ViewerComponent component) {
        addListeners(component);

        MethodChannel.Result result = component.getFlutterLoadResult();
        if (result != null) {
            result.success(true);
        }

        if (component.getPdfViewCtrlTabFragment() != null) {
            EventChannel.EventSink documentLoadedEventSink = component.getDocumentLoadedEventEmitter();
            if (documentLoadedEventSink != null) {
                documentLoadedEventSink.success(component.getPdfViewCtrlTabFragment().getFilePath());
            }
        }
    }

    public static boolean handleOpenDocError(ViewerComponent component) {
        MethodChannel.Result result = component.getFlutterLoadResult();
        if (result != null) {
            result.success(false);
        }

        if (component.getPdfViewCtrlTabFragment() != null) {
            EventChannel.EventSink documentErrorEventSink = component.getDocumentErrorEventEmitter();
            if (documentErrorEventSink != null) {
                documentErrorEventSink.success(null);
            }
        }

        return false;
    }

    public static void handleOnDetach(ViewerComponent component) {
        MethodChannel.Result result = component.getFlutterLoadResult();
        if (result != null) {
            result.success(false);
        }

        ToolManager toolManager = component.getToolManager();
        if (toolManager != null) {
            component.getImpl().removeListeners(toolManager);
        }

        PdfViewCtrlTabFragment pdfViewCtrlTabFragment = component.getPdfViewCtrlTabFragment();
        if (pdfViewCtrlTabFragment != null) {
            component.getImpl().removeListeners(pdfViewCtrlTabFragment);
        }
    }

    private static void addListeners(ViewerComponent component) {
        ToolManager toolManager = component.getToolManager();
        if (toolManager != null) {
            component.getImpl().addListeners(toolManager);
        }

        PdfViewCtrlTabFragment pdfViewCtrlTabFragment = component.getPdfViewCtrlTabFragment();
        if (pdfViewCtrlTabFragment != null) {
            component.getImpl().addListeners(pdfViewCtrlTabFragment);
        }
    }

    public static void emitAnnotationChangedEvent(String action, Map<Annot, Integer> map, ViewerComponent component) {

        EventChannel.EventSink eventSink = component.getAnnotationChangedEventEmitter();
        if (eventSink != null) {
            JSONObject resultObject = new JSONObject();
            try {
                resultObject.put(KEY_ACTION, action);
                JSONArray annotArray = new JSONArray();
                for (Annot annot : map.keySet()) {
                    String uid = null;
                    try {
                        uid = annot.getUniqueID() != null ? annot.getUniqueID().getAsPDFText() : null;
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    if (uid != null) {
                        Integer pageNumber = map.get(annot);
                        JSONObject annotObject = new JSONObject();
                        annotObject.put(KEY_ANNOTATION_ID, uid);
                        annotObject.put(KEY_PAGE_NUMBER, pageNumber);
                        annotArray.put(annotObject);
                    }
                }
                resultObject.put(KEY_ANNOTATION_LIST, annotArray);
            } catch (JSONException e) {
                e.printStackTrace();
            }
            eventSink.success(resultObject.toString());
        }
    }

    public static void emitExportAnnotationCommandEvent(String action, Map<Annot, Integer> map, ViewerComponent component) {
        // TODO: when collabManager is null
        ArrayList<Annot> annots = new ArrayList<>(map.keySet());
        String xfdfCommand = null;
        try {
            if (action.equals(KEY_ACTION_ADD)) {
                xfdfCommand = generateXfdfCommand(annots, null, null, component);
            } else if (action.equals(KEY_ACTION_MODIFY)) {
                xfdfCommand = generateXfdfCommand(null, annots, null, component);
            } else {
                xfdfCommand = generateXfdfCommand(null, null, annots, component);
            }
        } catch (PDFNetException e) {
            e.printStackTrace();
        }

        EventChannel.EventSink eventSink = component.getExportAnnotationCommandEventEmitter();
        if (eventSink != null) {
            eventSink.success(xfdfCommand);
        }
    }

    public static void emitAnnotationsSelectedEvent(Map<Annot, Integer> map, ViewerComponent component) {

        component.setSelectedAnnots(new HashMap<>(map));

        if (hasAnnotationsSelected(component)) {
            EventChannel.EventSink eventSink = component.getAnnotationsSelectedEventEmitter();
            if (eventSink != null) {
                JSONArray resultArray = null;
                try {
                    resultArray = getAnnotationsData(component);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                eventSink.success(resultArray == null ? "[]" : resultArray.toString());
            }
        }
    }

    // Helpers

    private static void checkFunctionPrecondition(ViewerComponent component) {
        Objects.requireNonNull(component);
        Objects.requireNonNull(component.getPdfDoc());
    }

    @Nullable
    private static String generateXfdfCommand(ArrayList<Annot> added, ArrayList<Annot> modified, ArrayList<Annot> removed, ViewerComponent component) throws PDFNetException {
        PDFDoc pdfDoc = component.getPdfDoc();
        if (pdfDoc != null) {
            FDFDoc fdfDoc = pdfDoc.fdfExtract(added, modified, removed);
            return fdfDoc.saveAsXFDF();
        }
        return null;
    }

    @Nullable
    public static String generateBookmarkJson(ViewerComponent component) throws JSONException {
        PDFDoc pdfDoc = component.getPdfDoc();
        if (pdfDoc != null) {
            return BookmarkManager.exportPdfBookmarks(pdfDoc);
        }
        return null;
    }

    private static JSONObject getAnnotationData(Annot annot, int pageNumber, ViewerComponent component) throws JSONException {

        // try to obtain id
        String uid = null;
        try {
            uid = annot.getUniqueID() != null ? annot.getUniqueID().getAsPDFText() : null;
        } catch (Exception e) {
            e.printStackTrace();
        }
        if (uid != null && component.getPdfViewCtrl() != null) {

            JSONObject annotPair = new JSONObject();
            annotPair.put(KEY_ANNOTATION_ID, uid);
            annotPair.put(KEY_PAGE_NUMBER, pageNumber);
            // try to obtain bbox
            try {
                com.pdftron.pdf.Rect bbox = component.getPdfViewCtrl().getScreenRectForAnnot(annot, pageNumber);
                JSONObject bboxMap = new JSONObject();
                bboxMap.put(KEY_X1, bbox.getX1());
                bboxMap.put(KEY_Y1, bbox.getY1());
                bboxMap.put(KEY_X2, bbox.getX2());
                bboxMap.put(KEY_Y2, bbox.getY2());
                bboxMap.put(KEY_WIDTH, bbox.getWidth());
                bboxMap.put(KEY_HEIGHT, bbox.getHeight());
                annotPair.put(KEY_RECT, bboxMap);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            return annotPair;
        }

        return null;
    }

    public static JSONArray getAnnotationsData(ViewerComponent component) throws JSONException {
        JSONArray annots = new JSONArray();

        for (Map.Entry<Annot, Integer> entry : component.getSelectedAnnots().entrySet()) {
            Annot key = entry.getKey();
            Integer value = entry.getValue();

            JSONObject annotData = getAnnotationData(key, value, component);
            if (annotData != null) {
                annots.put(annotData);
            }
        }
        return annots;
    }

    public static boolean hasAnnotationsSelected(ViewerComponent component) {
        return component.getSelectedAnnots() != null && !component.getSelectedAnnots().isEmpty();
    }

    public static void checkQuickMenu(List<QuickMenuItem> menuItems, ArrayList<String> keepList, List<QuickMenuItem> removeList) {
        for (QuickMenuItem item : menuItems) {
            int menuId = item.getItemId();
            if (ToolConfig.getInstance().getToolModeByQMItemId(menuId) != null) {
                // skip real annotation tools
                return;
            }
            String menuStr = convQuickMenuIdToString(menuId);
            if (!keepList.contains(menuStr)) {
                removeList.add(item);
            }
        }
    }

    private static JSONArray getJSONArrayFromJSONObject(JSONObject jsonObject, String key) throws JSONException {
        String jsonArrayString = jsonObject.getString(key);
        return new JSONArray(jsonArrayString);
    }

    private static JSONObject getJSONObjectFromJSONObject(JSONObject jsonObject, String key) throws JSONException {
        String jsonObjectString = jsonObject.getString(key);
        return new JSONObject(jsonObjectString);
    }

    private static ArrayList<String> convertJSONArrayToArrayList(JSONArray jsonArray) throws JSONException {
        ArrayList<String> arrayList = new ArrayList<>();
        for (int i = 0; i < jsonArray.length(); i++) {
            arrayList.add(jsonArray.getString(i));
        }
        return arrayList;
    }
}
