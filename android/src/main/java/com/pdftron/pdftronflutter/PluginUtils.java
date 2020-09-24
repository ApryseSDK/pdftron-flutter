package com.pdftron.pdftronflutter;

import com.pdftron.pdf.config.ViewerConfig;
import com.pdftron.pdf.tools.ToolManager;

import org.json.JSONArray;
import org.json.JSONException;

import java.util.ArrayList;

public class PluginUtils {

    public static final String disabledElements = "disabledElements";
    public static final String disabledTools = "disabledTools";
    public static final String multiTabEnabled = "multiTabEnabled";
    public static final String customHeaders = "customHeaders";

    public static final String KEY_X1 = "x1";
    public static final String KEY_Y1 = "y1";
    public static final String KEY_X2 = "x2";
    public static final String KEY_Y2 = "y2";
    public static final String KEY_WIDTH = "width";
    public static final String KEY_HEIGHT = "height";



    public static ArrayList<ToolManager.ToolMode> disableElements(ViewerConfig.Builder builder, JSONArray args) throws JSONException {
        for (int i = 0; i < args.length(); i++) {
            String item = args.getString(i);
            if ("toolsButton".equals(item)) {
                builder = builder.showAnnotationToolbarOption(false);
            } else if ("searchButton".equals(item)) {
                builder = builder.showSearchView(false);
            } else if ("shareButton".equals(item)) {
                builder = builder.showShareOption(false);
            } else if ("viewControlsButton".equals(item)) {
                builder = builder.showDocumentSettingsOption(false);
            } else if ("thumbnailsButton".equals(item)) {
                builder = builder.showThumbnailView(false);
            } else if ("listsButton".equals(item)) {
                builder = builder
                        .showAnnotationsList(false)
                        .showOutlineList(false)
                        .showUserBookmarksList(false);
            } else if ("thumbnailSlider".equals(item)) {
                builder = builder.showBottomNavBar(false);
            } else if ("saveCopyButton".equals(item)) {
                builder = builder.showSaveCopyOption(false);
            } else if ("editPagesButton".equals(item)) {
                builder = builder.showEditPagesOption(false);
            } else if ("printButton".equals(item)) {
                builder = builder.showPrintOption(false);
            } else if ("fillAndSignButton".equals(item)) {
                builder = builder.showFillAndSignToolbarOption(false);
            } else if ("prepareFormButton".equals(item)) {
                builder = builder.showFormToolbarOption(false);
            } else if ("reflowModeButton".equals(item)) {
                builder = builder.showReflowOption(false);
            }
        }
        return disableTools(args);
    }

    public static ArrayList<ToolManager.ToolMode> disableTools(JSONArray args) throws JSONException {
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

    public static ToolManager.ToolMode convStringToToolMode(String item) {
        ToolManager.ToolMode mode = null;
        if ("freeHandToolButton".equals(item) || "AnnotationCreateFreeHand".equals(item)) {
            mode = ToolManager.ToolMode.INK_CREATE;
        } else if ("highlightToolButton".equals(item) || "AnnotationCreateTextHighlight".equals(item)) {
            mode = ToolManager.ToolMode.TEXT_HIGHLIGHT;
        } else if ("underlineToolButton".equals(item) || "AnnotationCreateTextUnderline".equals(item)) {
            mode = ToolManager.ToolMode.TEXT_UNDERLINE;
        } else if ("squigglyToolButton".equals(item) || "AnnotationCreateTextSquiggly".equals(item)) {
            mode = ToolManager.ToolMode.TEXT_SQUIGGLY;
        } else if ("strikeoutToolButton".equals(item) || "AnnotationCreateTextStrikeout".equals(item)) {
            mode = ToolManager.ToolMode.TEXT_STRIKEOUT;
        } else if ("rectangleToolButton".equals(item) || "AnnotationCreateRectangle".equals(item)) {
            mode = ToolManager.ToolMode.RECT_CREATE;
        } else if ("ellipseToolButton".equals(item) || "AnnotationCreateEllipse".equals(item)) {
            mode = ToolManager.ToolMode.OVAL_CREATE;
        } else if ("lineToolButton".equals(item) || "AnnotationCreateLine".equals(item)) {
            mode = ToolManager.ToolMode.LINE_CREATE;
        } else if ("arrowToolButton".equals(item) || "AnnotationCreateArrow".equals(item)) {
            mode = ToolManager.ToolMode.ARROW_CREATE;
        } else if ("polylineToolButton".equals(item) || "AnnotationCreatePolyline".equals(item)) {
            mode = ToolManager.ToolMode.POLYLINE_CREATE;
        } else if ("polygonToolButton".equals(item) || "AnnotationCreatePolygon".equals(item)) {
            mode = ToolManager.ToolMode.POLYGON_CREATE;
        } else if ("cloudToolButton".equals(item) || "AnnotationCreatePolygonCloud".equals(item)) {
            mode = ToolManager.ToolMode.CLOUD_CREATE;
        } else if ("signatureToolButton".equals(item) || "AnnotationCreateSignature".equals(item)) {
            mode = ToolManager.ToolMode.SIGNATURE;
        } else if ("freeTextToolButton".equals(item) || "AnnotationCreateFreeText".equals(item)) {
            mode = ToolManager.ToolMode.TEXT_CREATE;
        } else if ("stickyToolButton".equals(item) || "AnnotationCreateSticky".equals(item)) {
            mode = ToolManager.ToolMode.TEXT_ANNOT_CREATE;
        } else if ("calloutToolButton".equals(item) || "AnnotationCreateCallout".equals(item)) {
            mode = ToolManager.ToolMode.CALLOUT_CREATE;
        } else if ("stampToolButton".equals(item) || "AnnotationCreateStamp".equals(item)) {
            mode = ToolManager.ToolMode.STAMPER;
        } else if ("AnnotationCreateDistanceMeasurement".equals(item)) {
            mode = ToolManager.ToolMode.RULER_CREATE;
        } else if ("AnnotationCreatePerimeterMeasurement".equals(item)) {
            mode = ToolManager.ToolMode.PERIMETER_MEASURE_CREATE;
        } else if ("AnnotationCreateAreaMeasurement".equals(item)) {
            mode = ToolManager.ToolMode.AREA_MEASURE_CREATE;
        } else if ("TextSelect".equals(item)) {
            mode = ToolManager.ToolMode.TEXT_SELECT;
        } else if ("AnnotationEdit".equals(item)) {
            mode = ToolManager.ToolMode.ANNOT_EDIT_RECT_GROUP;
        } else if ("AnnotationCreateSound".equals(item)) {
            mode = ToolManager.ToolMode.SOUND_CREATE;
        } else if ("AnnotationCreateFreeHighlighter".equals(item)) {
            mode = ToolManager.ToolMode.FREE_HIGHLIGHTER;
        } else if ("AnnotationCreateRubberStamp".equals(item)) {
            mode = ToolManager.ToolMode.RUBBER_STAMPER;
        } else if ("Eraser".equals(item)) {
            mode = ToolManager.ToolMode.INK_ERASER;
        }
        return mode;
    }
}
