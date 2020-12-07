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
import com.pdftron.pdf.Field;
import com.pdftron.pdf.PDFDoc;
import com.pdftron.pdf.PDFViewCtrl;
import com.pdftron.pdf.Page;
import com.pdftron.pdf.Rect;
import com.pdftron.pdf.ViewChangeCollection;
import com.pdftron.pdf.config.PDFViewCtrlConfig;
import com.pdftron.pdf.config.ToolManagerBuilder;
import com.pdftron.pdf.config.ViewerConfig;
import com.pdftron.pdf.controls.PdfViewCtrlTabFragment;
import com.pdftron.pdf.controls.PdfViewCtrlTabHostFragment;
import com.pdftron.pdf.controls.ThumbnailsViewFragment;
import com.pdftron.pdf.dialog.ViewModePickerDialogFragment;
import com.pdftron.pdf.tools.AdvancedShapeCreate;
import com.pdftron.pdf.tools.FreehandCreate;
import com.pdftron.pdf.tools.Tool;
import com.pdftron.pdf.tools.ToolManager;
import com.pdftron.pdf.utils.BookmarkManager;
import com.pdftron.pdf.utils.PdfViewCtrlSettingsManager;
import com.pdftron.pdf.utils.Utils;
import com.pdftron.pdf.utils.ViewerUtils;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
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
    public static final String KEY_TOOL_MODE = "toolMode";
    public static final String KEY_FIELD_NAMES = "fieldNames";
    public static final String KEY_FLAG = "flag";
    public static final String KEY_FLAG_VALUE = "flagValue";
    public static final String KEY_FIELDS = "fields";
    public static final String KEY_ANNOTATION_LIST = "annotations";
    public static final String KEY_ANNOTATION = "annotation";
    public static final String KEY_FORMS_ONLY = "formsOnly";
    public static final String KEY_ANNOTATIONS_WITH_FLAGS = "annotationsWithFlags";
    public static final String KEY_LEADING_NAV_BUTTON_ICON = "leadingNavButtonIcon";

    public static final String KEY_CONFIG_DISABLED_ELEMENTS = "disabledElements";
    public static final String KEY_CONFIG_DISABLED_TOOLS = "disabledTools";
    public static final String KEY_CONFIG_MULTI_TAB_ENABLED = "multiTabEnabled";
    public static final String KEY_CONFIG_CUSTOM_HEADERS = "customHeaders";
    public static final String KEY_CONFIG_HIDE_THUMBNAIL_FILTER_MODES = "hideThumbnailFilterModes";
    public static final String KEY_CONFIG_SHOW_LEADING_NAV_BUTTON = "showLeadingNavButton";
    public static final String KEY_CONFIG_READ_ONLY = "readOnly";
    public static final String KEY_CONFIG_THUMBNAIL_VIEW_EDITING_ENABLED = "thumbnailViewEditingEnabled";
    public static final String KEY_CONFIG_ANNOTATION_AUTHOR = "annotationAuthor";
    public static final String KEY_CONFIG_CONTINUOUS_ANNOTATION_EDITING = "continuousAnnotationEditing";

    public static final String KEY_X1 = "x1";
    public static final String KEY_Y1 = "y1";
    public static final String KEY_X2 = "x2";
    public static final String KEY_Y2 = "y2";
    public static final String KEY_WIDTH = "width";
    public static final String KEY_HEIGHT = "height";
    public static final String KEY_RECT = "rect";

    public static final String KEY_FIELD_NAME = "fieldName";
    public static final String KEY_FIELD_VALUE = "fieldValue";

    public static final String KEY_PREVIOUS_PAGE_NUMBER = "previousPageNumber";

    public static final String KEY_ANNOTATION_ID = "id";

    public static final String KEY_ACTION_ADD = "add";
    public static final String KEY_ACTION_MODIFY = "modify";
    public static final String KEY_ACTION_DELETE = "delete";
    public static final String KEY_ACTION = "action";

    public static final String KEY_ANNOTATION_FLAG_LISTS = "flags";
    public static final String KEY_ANNOTATION_FLAG = "flag";
    public static final String KEY_ANNOTATION_FLAG_VALUE = "flagValue";

    public static final String EVENT_EXPORT_ANNOTATION_COMMAND = "export_annotation_command_event";
    public static final String EVENT_EXPORT_BOOKMARK = "export_bookmark_event";
    public static final String EVENT_DOCUMENT_LOADED = "document_loaded_event";
    public static final String EVENT_DOCUMENT_ERROR = "document_error_event";
    public static final String EVENT_ANNOTATION_CHANGED = "annotation_changed_event";
    public static final String EVENT_ANNOTATIONS_SELECTED = "annotations_selected_event";
    public static final String EVENT_FORM_FIELD_VALUE_CHANGED = "form_field_value_changed_event";
    public static final String EVENT_LEADING_NAV_BUTTON_PRESSED = "leading_nav_button_pressed_event";
    public static final String EVENT_PAGE_CHANGED = "page_changed_event";
    public static final String EVENT_ZOOM_CHANGED = "zoom_changed_event";

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
    public static final String FUNCTION_SET_TOOL_MODE = "setToolMode";
    public static final String FUNCTION_SET_FLAG_FOR_FIELDS = "setFlagForFields";
    public static final String FUNCTION_SET_VALUES_FOR_FIELDS = "setValuesForFields";
    public static final String FUNCTION_IMPORT_ANNOTATIONS = "importAnnotations";
    public static final String FUNCTION_EXPORT_ANNOTATIONS = "exportAnnotations";
    public static final String FUNCTION_FLATTEN_ANNOTATIONS = "flattenAnnotations";
    public static final String FUNCTION_DELETE_ANNOTATIONS = "deleteAnnotations";
    public static final String FUNCTION_SELECT_ANNOTATION = "selectAnnotation";
    public static final String FUNCTION_SET_FLAGS_FOR_ANNOTATIONS = "setFlagsForAnnotations";
    public static final String FUNCTION_SET_LEADING_NAV_BUTTON_ICON = "setLeadingNavButtonIcon";

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
    public static final String BUTTON_CLOSE = "closeButton";
    public static final String BUTTON_OUTLINE_LIST = "outlineListButton";
    public static final String BUTTON_ANNOTATION_LIST = "annotationListButton";
    public static final String BUTTON_USER_BOOKMARK_LIST = "userBookmarkListButton";
    public static final String BUTTON_EDIT_MENU = "editMenuButton";
    public static final String BUTTON_CROP_PAGE = "cropPageButton";
    public static final String BUTTON_MORE_ITEMS = "moreItemsButton";

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
    public static final String TOOL_ANNOTATION_CREATE_FILE_ATTACHMENT = "AnnotationCreateFileAttachment";
    public static final String TOOL_ANNOTATION_CREATE_REDACTION = "AnnotationCreateRedaction";
    public static final String TOOL_ANNOTATION_CREATE_REDACTION_TEXT = "AnnotationCreateRedactionText";
    public static final String TOOL_ANNOTATION_CREATE_LINK = "AnnotationCreateLink";
    public static final String TOOL_ANNOTATION_CREATE_LINK_TEXT = "AnnotationCreateLinkText";
    public static final String TOOL_FORM_CREATE_TEXT_FIELD = "FormCreateTextField";
    public static final String TOOL_FORM_CREATE_CHECKBOX_FIELD = "FormCreateCheckboxField";
    public static final String TOOL_FORM_CREATE_SIGNATURE_FIELD = "FormCreateSignatureField";
    public static final String TOOL_FORM_CREATE_RADIO_FIELD = "FormCreateRadioField";
    public static final String TOOL_FORM_CREATE_COMBO_BOX_FIELD = "FormCreateComboBoxField";
    public static final String TOOL_FORM_CREATE_LIST_BOX_FIELD = "FormCreateListBoxField";

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

    public static final String THUMBNAIL_FILTER_MODE_ANNOTATED = "annotated";
    public static final String THUMBNAIL_FILTER_MODE_BOOKMARKED = "bookmarked";

    public static class ConfigInfo {
        private JSONObject customHeaderJson;
        private Uri fileUri;
        private boolean showLeadingNavButton;

        public ConfigInfo() {
            this.customHeaderJson = null;
            this.fileUri = null;
            this.showLeadingNavButton = true;
        }

        public void setCustomHeaderJson(JSONObject customHeaderJson) {
            this.customHeaderJson = customHeaderJson;
        }

        public void setFileUri(Uri fileUri) {
            this.fileUri = fileUri;
        }

        public void setShowLeadingNavButton(boolean showLeadingNavButton) {
            this.showLeadingNavButton = showLeadingNavButton;
        }

        public JSONObject getCustomHeaderJson() {
            return customHeaderJson;
        }

        public Uri getFileUri() {
            return fileUri;
        }

        public boolean isShowLeadingNavButton() {
            return showLeadingNavButton;
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
                if (!configJson.isNull(KEY_CONFIG_HIDE_THUMBNAIL_FILTER_MODES)) {
                    JSONArray array = configJson.getJSONArray(KEY_CONFIG_HIDE_THUMBNAIL_FILTER_MODES);
                    ArrayList<ThumbnailsViewFragment.FilterModes> hideList = new ArrayList<>();

                    for (int i = 0; i < array.length(); i++) {
                        String filterModeString = array.getString(i);
                        if (filterModeString.equals(THUMBNAIL_FILTER_MODE_ANNOTATED)) {
                            hideList.add(ThumbnailsViewFragment.FilterModes.ANNOTATED);
                        } else if (filterModeString.equals(THUMBNAIL_FILTER_MODE_BOOKMARKED)) {
                            hideList.add(ThumbnailsViewFragment.FilterModes.BOOKMARKED);
                        }
                    }

                    builder.hideThumbnailFilterModes(hideList.toArray(new ThumbnailsViewFragment.FilterModes[0]));
                }
                if (!configJson.isNull(KEY_CONFIG_SHOW_LEADING_NAV_BUTTON)) {
                    boolean showLeadingNavButton = configJson.getBoolean(KEY_CONFIG_SHOW_LEADING_NAV_BUTTON);
                    configInfo.setShowLeadingNavButton(showLeadingNavButton);
                }
                if (!configJson.isNull(KEY_CONFIG_READ_ONLY)) {
                    boolean readOnly = configJson.getBoolean(KEY_CONFIG_READ_ONLY);
                    builder.documentEditingEnabled(!readOnly);
                }
                if (!configJson.isNull(KEY_CONFIG_THUMBNAIL_VIEW_EDITING_ENABLED)) {
                    boolean thumbnailViewEditingEnabled = configJson.getBoolean(KEY_CONFIG_THUMBNAIL_VIEW_EDITING_ENABLED);
                    builder.thumbnailViewEditingEnabled(thumbnailViewEditingEnabled);
                }
                if (!configJson.isNull(KEY_CONFIG_ANNOTATION_AUTHOR)) {
                    String annotationAuthor = configJson.getString(KEY_CONFIG_ANNOTATION_AUTHOR);
                    if (!annotationAuthor.isEmpty()) {
                        PdfViewCtrlSettingsManager.updateAuthorName(context, annotationAuthor);
                        PdfViewCtrlSettingsManager.setAnnotListShowAuthor(context, true);
                    }
                }
                if (!configJson.isNull(KEY_CONFIG_CONTINUOUS_ANNOTATION_EDITING)) {
                    boolean continuousAnnotationEditing = configJson.getBoolean(KEY_CONFIG_CONTINUOUS_ANNOTATION_EDITING);
                    PdfViewCtrlSettingsManager.setContinuousAnnotationEdit(context, continuousAnnotationEditing);
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

        ArrayList<ViewModePickerDialogFragment.ViewModePickerItems> viewModePickerItems = new ArrayList<>();

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
                viewModePickerItems.add(ViewModePickerDialogFragment.ViewModePickerItems.ITEM_ID_REFLOW);
            } else if (BUTTON_CLOSE.equals(item)) {
                builder = builder.showCloseTabOption(false);
            } else if (BUTTON_OUTLINE_LIST.equals(item)) {
                builder = builder.showOutlineList(false);
            } else if (BUTTON_ANNOTATION_LIST.equals(item)) {
                builder = builder.showAnnotationsList(false);
            } else if (BUTTON_USER_BOOKMARK_LIST.equals(item)) {
                builder = builder.showUserBookmarksList(false);
            } else if (BUTTON_EDIT_MENU.equals(item)) {
                builder = builder.showEditMenuOption(false);
            } else if (BUTTON_CROP_PAGE.equals(item)) {
                viewModePickerItems.add(ViewModePickerDialogFragment.ViewModePickerItems.ITEM_ID_USERCROP);
            } else if (BUTTON_MORE_ITEMS.equals(item)) {
                builder = builder
                        .showEditPagesOption(false)
                        .showPrintOption(false)
                        .showCloseTabOption(false)
                        .showSaveCopyOption(false)
                        .showFormToolbarOption(false)
                        .showFillAndSignToolbarOption(false)
                        .showEditMenuOption(false)
                        .showReflowOption(false);
            }
        }

        builder.hideViewModeItems(viewModePickerItems.toArray(new ViewModePickerDialogFragment.ViewModePickerItems[0]));
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
        } else if (TOOL_ANNOTATION_CREATE_FILE_ATTACHMENT.equals(item)) {
            mode = ToolManager.ToolMode.FILE_ATTACHMENT_CREATE;
        } else if (TOOL_ANNOTATION_CREATE_REDACTION.equals(item)) {
            mode = ToolManager.ToolMode.RECT_REDACTION;
        } else if (TOOL_ANNOTATION_CREATE_LINK.equals(item)) {
            mode = ToolManager.ToolMode.RECT_LINK;
        } else if (TOOL_ANNOTATION_CREATE_REDACTION_TEXT.equals(item)) {
            mode = ToolManager.ToolMode.TEXT_REDACTION;
        } else if (TOOL_ANNOTATION_CREATE_LINK_TEXT.equals(item)) {
            mode = ToolManager.ToolMode.TEXT_LINK_CREATE;
        } else if (TOOL_FORM_CREATE_TEXT_FIELD.equals(item)) {
            mode = ToolManager.ToolMode.FORM_TEXT_FIELD_CREATE;
        } else if (TOOL_FORM_CREATE_CHECKBOX_FIELD.equals(item)) {
            mode = ToolManager.ToolMode.FORM_CHECKBOX_CREATE;
        } else if (TOOL_FORM_CREATE_SIGNATURE_FIELD.equals(item)) {
            mode = ToolManager.ToolMode.FORM_SIGNATURE_CREATE;
        } else if (TOOL_FORM_CREATE_RADIO_FIELD.equals(item)) {
            mode = ToolManager.ToolMode.FORM_RADIO_GROUP_CREATE;
        } else if (TOOL_FORM_CREATE_COMBO_BOX_FIELD.equals(item)) {
            mode = ToolManager.ToolMode.FORM_COMBO_BOX_CREATE;
        } else if (TOOL_FORM_CREATE_LIST_BOX_FIELD.equals(item)) {
            mode = ToolManager.ToolMode.FORM_LIST_BOX_CREATE;
        }
        return mode;
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
            case FUNCTION_SET_TOOL_MODE: {
                checkFunctionPrecondition(component);
                String toolModeString = call.argument(KEY_TOOL_MODE);
                setToolMode(toolModeString, result, component);
                break;
            }
            case FUNCTION_SET_FLAG_FOR_FIELDS: {
                checkFunctionPrecondition(component);
                ArrayList<String> fieldNames = call.argument(KEY_FIELD_NAMES);
                Integer flag = call.argument(KEY_FLAG);
                Boolean flagValue = call.argument(KEY_FLAG_VALUE);
                if (fieldNames != null && flag != null && flagValue != null) {
                    try {
                        setFlagForFields(fieldNames, flag, flagValue, result, component);
                    } catch (PDFNetException ex) {
                        ex.printStackTrace();
                        result.error(Long.toString(ex.getErrorCode()), "PDFTronException Error: " + ex, null);
                    }
                }
                break;
            }
            case FUNCTION_SET_VALUES_FOR_FIELDS: {
                checkFunctionPrecondition(component);
                String fieldsString = call.argument(KEY_FIELDS);
                if (fieldsString != null) {
                    try {
                        setValuesForFields(fieldsString, result, component);
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

    private static void setFlagForFields(ArrayList<String> fieldNames, int flag, boolean flagValue, MethodChannel.Result result, ViewerComponent component) throws PDFNetException {
        PDFViewCtrl pdfViewCtrl = component.getPdfViewCtrl();
        PDFDoc pdfdoc = component.getPdfDoc();
        if (null == pdfViewCtrl || null == pdfdoc) {
            result.error("InvalidState", "Activity not attached", null);
            return;
        }

        boolean shouldUnlock = false;
        try {
            pdfViewCtrl.docLock(true);
            shouldUnlock = true;

            for (String fieldName : fieldNames) {
                Field field = pdfdoc.getField(fieldName);
                if (field != null && field.isValid()) {
                    field.setFlag(flag, flagValue);
                    pdfViewCtrl.update(field);
                }
            }
        } finally {
            if (shouldUnlock) {
                pdfViewCtrl.docUnlock();
            }
        }
        result.success(null);
    }

    private static void setValuesForFields(String fieldsString, MethodChannel.Result result, ViewerComponent component) throws PDFNetException, JSONException {
        PDFViewCtrl pdfViewCtrl = component.getPdfViewCtrl();
        PDFDoc pdfDoc = component.getPdfDoc();
        if (null == pdfViewCtrl || null == pdfDoc) {
            result.error("InvalidState", "Activity not attached", null);
            return;
        }

        JSONArray fieldsArray = new JSONArray(fieldsString);

        boolean shouldUnlock = false;
        try {
            pdfViewCtrl.docLock(true);
            shouldUnlock = true;

            for (int i = 0; i < fieldsArray.length(); i++) {
                JSONObject fieldObject = fieldsArray.getJSONObject(i);

                String fieldName = fieldObject.getString(KEY_FIELD_NAME);

                Field field = pdfDoc.getField(fieldName);
                if (field != null && field.isValid()) {
                    setFieldValue(pdfViewCtrl, field, fieldObject.get(KEY_FIELD_VALUE));
                }
            }

        } finally {
            if (shouldUnlock) {
                pdfViewCtrl.docUnlock();
            }
        }
        result.success(null);
    }

    // write lock required around this method
    private static void setFieldValue(PDFViewCtrl pdfViewCtrl, Field field, Object value) throws PDFNetException, JSONException {
        int fieldType = field.getType();

        if (value instanceof Boolean) {
            if (Field.e_check == fieldType) {
                ViewChangeCollection view_change = field.setValue((boolean) value);
                pdfViewCtrl.refreshAndUpdate(view_change);
            }
        } else if (value instanceof String) {
            if (Field.e_text == fieldType || Field.e_radio == fieldType || Field.e_choice == fieldType) {
                ViewChangeCollection view_change = field.setValue((String) value);
                pdfViewCtrl.refreshAndUpdate(view_change);
            }
        } else if (value instanceof Integer || value instanceof Double || value instanceof Long || value instanceof Float) {
            if (Field.e_text == fieldType) {
                ViewChangeCollection view_change = field.setValue(String.valueOf(value));
                pdfViewCtrl.refreshAndUpdate(view_change);
            }
        }
    }

    private static void setToolMode(String toolModeString, MethodChannel.Result result, ViewerComponent component) {
        ToolManager toolManager = component.getToolManager();
        Context context = component.getPdfViewCtrl() != null ? component.getPdfViewCtrl().getContext() : null;
        if (toolManager == null || context == null) {
            result.error("InvalidState", "PDFViewCtrl not found", null);
            return;
        }

        ToolManager.ToolMode mode = convStringToToolMode(toolModeString);
        Tool tool = (Tool) toolManager.createTool(mode, null);
        boolean continuousAnnot = PdfViewCtrlSettingsManager.getContinuousAnnotationEdit(context);
        tool.setForceSameNextToolMode(continuousAnnot);
        toolManager.setTool(tool);
        result.success(null);
    }

    private static void setLeadingNavButtonIcon(String leadingNavButtonIcon, MethodChannel.Result result, ViewerComponent component) {
        PdfViewCtrlTabHostFragment pdfViewCtrlTabHostFragment = component.getPdfViewCtrlTabHostFragment();
        if (pdfViewCtrlTabHostFragment == null) {
            result.error("InvalidState", "PDFViewCtrl not found", null);
            return;
        }
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

        PDFViewCtrl pdfViewCtrl = component.getPdfViewCtrl();
        if (pdfViewCtrl != null) {
            component.getImpl().removeListeners(pdfViewCtrl);
        }
    }

    public static void handleLeadingNavButtonPressed(ViewerComponent component) {
        EventChannel.EventSink leadingNavButtonPressedEventSink = component.getLeadingNavButtonPressedEventEmitter();
        if (leadingNavButtonPressedEventSink != null) {
            leadingNavButtonPressedEventSink.success(null);
        }
    }

    private static void addListeners(ViewerComponent component) {
        ToolManager toolManager = component.getToolManager();

        if (toolManager != null) {
            component.getImpl().addListeners(toolManager);
        }

        PDFViewCtrl pdfViewCtrl = component.getPdfViewCtrl();
        if (pdfViewCtrl != null) {
            component.getImpl().addListeners(pdfViewCtrl);
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

    private static JSONArray getAnnotationsData(ViewerComponent component) throws JSONException {
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

    private static boolean hasAnnotationsSelected(ViewerComponent component) {
        return component.getSelectedAnnots() != null && !component.getSelectedAnnots().isEmpty();
    }

    private static JSONArray getJSONArrayFromJSONObject(JSONObject jsonObject, String key) throws JSONException {
        String jsonArrayString = jsonObject.getString(key);
        return new JSONArray(jsonArrayString);
    }

    private static JSONObject getJSONObjectFromJSONObject(JSONObject jsonObject, String key) throws JSONException {
        String jsonObjectString = jsonObject.getString(key);
        return new JSONObject(jsonObjectString);
    }
}
