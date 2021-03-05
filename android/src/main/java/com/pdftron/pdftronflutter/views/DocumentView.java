package com.pdftron.pdftronflutter.views;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.FragmentManager;

import com.pdftron.pdf.Annot;
import com.pdftron.pdf.PDFDoc;
import com.pdftron.pdf.PDFViewCtrl;
import com.pdftron.pdf.config.PDFViewCtrlConfig;
import com.pdftron.pdf.config.ToolManagerBuilder;
import com.pdftron.pdf.config.ViewerBuilder2;
import com.pdftron.pdf.config.ViewerConfig;
import com.pdftron.pdf.controls.PdfViewCtrlTabFragment2;
import com.pdftron.pdf.controls.PdfViewCtrlTabHostFragment2;
import com.pdftron.pdf.tools.ToolManager;
import com.pdftron.pdf.utils.PdfViewCtrlSettingsManager;
import com.pdftron.pdf.utils.Utils;
import com.pdftron.pdftronflutter.helpers.PluginUtils;
import com.pdftron.pdftronflutter.helpers.ViewerComponent;
import com.pdftron.pdftronflutter.helpers.ViewerImpl;

import java.util.ArrayList;
import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

import static com.pdftron.pdftronflutter.helpers.PluginUtils.handleDocumentLoaded;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.handleLeadingNavButtonPressed;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.handleOnDetach;
import static com.pdftron.pdftronflutter.helpers.PluginUtils.handleOpenDocError;

public class DocumentView extends com.pdftron.pdf.controls.DocumentView2 implements ViewerComponent {
    private ViewerImpl mImpl = new ViewerImpl(this);

    private ToolManagerBuilder mToolManagerBuilder;
    private PDFViewCtrlConfig mPDFViewCtrlConfig;
    private ViewerConfig.Builder mBuilder;
    private String mCacheDir;

    private ArrayList<String> mLongPressMenuItems;
    private ArrayList<String> mLongPressMenuOverrideItems;
    private ArrayList<String> mHideAnnotationMenuTools;
    private ArrayList<String> mAnnotationMenuItems;
    private ArrayList<String> mAnnotationMenuOverrideItems;
    private boolean mAutoSaveEnabled;
    private boolean mUseStylusAsPen;
    private boolean mSignSignatureFieldWithStamps;

    private EventChannel.EventSink sExportAnnotationCommandEventEmitter;
    private EventChannel.EventSink sExportBookmarkEventEmitter;
    private EventChannel.EventSink sDocumentLoadedEventEmitter;
    private EventChannel.EventSink sDocumentErrorEventEmitter;
    private EventChannel.EventSink sAnnotationChangedEventEmitter;
    private EventChannel.EventSink sAnnotationsSelectedEventEmitter;
    private EventChannel.EventSink sFormFieldValueChangedEventEmitter;
    private EventChannel.EventSink sLongPressMenuPressedEventEmitter;
    private EventChannel.EventSink sAnnotationMenuPressedEventEmitter;
    private EventChannel.EventSink sLeadingNavButtonPressedEventEmitter;
    private EventChannel.EventSink sPageChangedEventEmitter;
    private EventChannel.EventSink sZoomChangedEventEmitter;

    private MethodChannel.Result sFlutterLoadResult;

    private HashMap<Annot, Integer> mSelectedAnnots;

    private int mId = 0;
    private FragmentManager mFragmentManager;

    private String mTabTitle;

    private boolean mFromAttach;
    private boolean mDetached;

    public DocumentView(@NonNull Context context) {
        this(context, null);
    }

    public DocumentView(@NonNull Context context, @Nullable AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public DocumentView(@NonNull Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);

        init(context);
    }

    public void openDocument(String document, String password, String configStr, MethodChannel.Result result) {

        PluginUtils.ConfigInfo configInfo = PluginUtils.handleOpenDocument(mBuilder, mToolManagerBuilder, mPDFViewCtrlConfig, document, getContext(), configStr);

        setDocumentUri(configInfo.getFileUri());
        setPassword(password);
        setCustomHeaders(configInfo.getCustomHeaderJson());

        mLongPressMenuItems = configInfo.getLongPressMenuItems();
        mLongPressMenuOverrideItems = configInfo.getLongPressMenuOverrideItems();
        mHideAnnotationMenuTools = configInfo.getHideAnnotationMenuTools();
        mAnnotationMenuItems = configInfo.getAnnotationMenuItems();
        mAnnotationMenuOverrideItems = configInfo.getAnnotationMenuOverrideItems();

        setShowNavIcon(configInfo.isShowLeadingNavButton());
        setViewerConfig(getConfig());
        setFlutterLoadResult(result);

        mAutoSaveEnabled = configInfo.isAutoSaveEnabled();
        mUseStylusAsPen = configInfo.isUseStylusAsPen();
        mSignSignatureFieldWithStamps = configInfo.isSignSignatureFieldWithStamps();
        mTabTitle = configInfo.getTabTitle();

        mFromAttach = false;
        mDetached = false;
        prepView();
        attachListeners();
    }

    @Override
    protected void buildViewer() {
        mViewerBuilder = ViewerBuilder2.withUri(mDocumentUri, mPassword)
                .usingConfig(mViewerConfig)
                .usingNavIcon(mShowNavIcon ? mNavIconRes : 0)
                .usingCustomHeaders(mCustomHeaders)
                .usingTabTitle(mTabTitle);
    }

    @Override
    protected void prepView() {
        if (mFromAttach && !mDetached) {
            // here we only want to attach the viewer from open document
            // unless it is not attached yet
            return;
        }
        super.prepView();
    }

    @Override
    public void setSupportFragmentManager(FragmentManager fragmentManager) {
        super.setSupportFragmentManager(fragmentManager);
        mFragmentManager = fragmentManager;
    }

    @Override
    public int getId() {
        if (mId == 0) {
            mId = View.generateViewId();
        }
        return mId;
    }

    public void setLeadingNavButtonIcon(String leadingNavButtonIcon) {
        PdfViewCtrlTabHostFragment2 pdfViewCtrlTabHostFragment = getPdfViewCtrlTabHostFragment();
        if (mShowNavIcon && pdfViewCtrlTabHostFragment != null
                && pdfViewCtrlTabHostFragment.getToolbar() != null) {
            int res = Utils.getResourceDrawable(getContext(), leadingNavButtonIcon);
            if (res != 0) {
                pdfViewCtrlTabHostFragment.getToolbar().setNavigationIcon(res);
            }
        }
    }

    private void init(Context context) {
        int width = ViewGroup.LayoutParams.MATCH_PARENT;
        int height = ViewGroup.LayoutParams.MATCH_PARENT;
        ViewGroup.LayoutParams params = new ViewGroup.LayoutParams(width, height);
        setLayoutParams(params);

        PdfViewCtrlSettingsManager.setFullScreenMode(context, false);

        mCacheDir = context.getCacheDir().getAbsolutePath();
        mToolManagerBuilder = ToolManagerBuilder.from();
        mBuilder = new ViewerConfig.Builder();
        mBuilder
                .fullscreenModeEnabled(false)
                .multiTabEnabled(false)
                .showCloseTabOption(false)
                .useSupportActionBar(false);

        mPDFViewCtrlConfig = PDFViewCtrlConfig.getDefaultConfig(context);
    }

    public void attachListeners() {
        if (this.mPdfViewCtrlTabHostFragment != null) {
            this.mPdfViewCtrlTabHostFragment.addHostListener(this);
            if (this.mTabHostListener != null) {
                this.mPdfViewCtrlTabHostFragment.addHostListener(this.mTabHostListener);
            }
        }
    }

    private ViewerConfig getConfig() {
        if (mCacheDir != null) {
            mBuilder.openUrlCachePath(mCacheDir)
                    .saveCopyExportPath(mCacheDir);
        }
        return mBuilder
                .pdfViewCtrlConfig(mPDFViewCtrlConfig)
                .toolManagerBuilder(mToolManagerBuilder)
                .build();
    }

    @Override
    protected void onAttachedToWindow() {
        setSupportFragmentManager(mFragmentManager);
        mFromAttach = true;
        super.onAttachedToWindow();
    }

    @Override
    public boolean canShowFileCloseSnackbar() {
        return false;
    }

    @Override
    public void onTabDocumentLoaded(String tag) {
        super.onTabDocumentLoaded(tag);

        handleDocumentLoaded(this);
    }

    @Override
    public boolean onOpenDocError() {
        super.onOpenDocError();

        return handleOpenDocError(this);
    }

    @Override
    public void onDetachedFromWindow() {
        mDetached = true;
        handleOnDetach(this);

        // remove detached view
        if (mPdfViewCtrlTabHostFragment != null) {
            View fragmentView = this.mPdfViewCtrlTabHostFragment.getView();
            if (fragmentView != null) {
                this.removeView(fragmentView);
            }
        }

        super.onDetachedFromWindow();
    }

    public boolean isAutoSaveEnabled() {
        return mAutoSaveEnabled;
    }

    public boolean isUseStylusAsPen() {
        return mUseStylusAsPen;
    }

    public boolean isSignSignatureFieldWithStamps() {
        return mSignSignatureFieldWithStamps;
    }

    @Override
    public void onNavButtonPressed() {
        handleLeadingNavButtonPressed(this);
    }

    public void setExportAnnotationCommandEventEmitter(EventChannel.EventSink emitter) {
        sExportAnnotationCommandEventEmitter = emitter;
    }

    public void setExportBookmarkEventEmitter(EventChannel.EventSink emitter) {
        sExportBookmarkEventEmitter = emitter;
    }

    public void setDocumentLoadedEventEmitter(EventChannel.EventSink emitter) {
        sDocumentLoadedEventEmitter = emitter;
    }

    public void setDocumentErrorEventEmitter(EventChannel.EventSink emitter) {
        sDocumentErrorEventEmitter = emitter;
    }

    public void setAnnotationChangedEventEmitter(EventChannel.EventSink emitter) {
        sAnnotationChangedEventEmitter = emitter;
    }

    public void setAnnotationsSelectedEventEmitter(EventChannel.EventSink emitter) {
        sAnnotationsSelectedEventEmitter = emitter;
    }

    public void setFormFieldValueChangedEventEmitter(EventChannel.EventSink emitter) {
        sFormFieldValueChangedEventEmitter = emitter;
    }

    public void setLongPressMenuPressedEventEmitter(EventChannel.EventSink emitter) {
        sLongPressMenuPressedEventEmitter = emitter;
    }

    public void setAnnotationMenuPressedEventEmitter(EventChannel.EventSink emitter) {
        sAnnotationMenuPressedEventEmitter = emitter;
    }

    public void setLeadingNavButtonPressedEventEmitter(EventChannel.EventSink emitter) {
        sLeadingNavButtonPressedEventEmitter = emitter;
    }

    public void setPageChangedEventEmitter(EventChannel.EventSink emitter) {
        sPageChangedEventEmitter = emitter;
    }

    public void setZoomChangedEventEmitter(EventChannel.EventSink emitter) {
        sZoomChangedEventEmitter = emitter;
    }

    public void setFlutterLoadResult(MethodChannel.Result result) {
        sFlutterLoadResult = result;
    }

    public void setSelectedAnnots(HashMap<Annot, Integer> selectedAnnots) {
        mSelectedAnnots = selectedAnnots;
    }

    @Override
    public EventChannel.EventSink getExportAnnotationCommandEventEmitter() {
        return sExportAnnotationCommandEventEmitter;
    }

    @Override
    public EventChannel.EventSink getExportBookmarkEventEmitter() {
        return sExportBookmarkEventEmitter;
    }

    @Override
    public EventChannel.EventSink getDocumentLoadedEventEmitter() {
        return sDocumentLoadedEventEmitter;
    }

    @Override
    public EventChannel.EventSink getDocumentErrorEventEmitter() {
        return sDocumentErrorEventEmitter;
    }

    @Override
    public EventChannel.EventSink getAnnotationChangedEventEmitter() {
        return sAnnotationChangedEventEmitter;
    }

    @Override
    public EventChannel.EventSink getAnnotationsSelectedEventEmitter() {
        return sAnnotationsSelectedEventEmitter;
    }

    @Override
    public EventChannel.EventSink getFormFieldValueChangedEventEmitter() {
        return sFormFieldValueChangedEventEmitter;
    }

    @Override
    public EventChannel.EventSink getLongPressMenuPressedEventEmitter() {
        return sLongPressMenuPressedEventEmitter;
    }

    @Override
    public EventChannel.EventSink getAnnotationMenuPressedEventEmitter() {
        return sAnnotationMenuPressedEventEmitter;
    }

    public EventChannel.EventSink getLeadingNavButtonPressedEventEmitter() {
        return sLeadingNavButtonPressedEventEmitter;
    }

    @Override
    public EventChannel.EventSink getPageChangedEventEmitter() {
        return sPageChangedEventEmitter;
    }

    @Override
    public EventChannel.EventSink getZoomChangedEventEmitter() {
        return sZoomChangedEventEmitter;
    }

    @Override
    public MethodChannel.Result getFlutterLoadResult() {
        MethodChannel.Result result = sFlutterLoadResult;
        sFlutterLoadResult = null;
        return result;
    }

    @Override
    public HashMap<Annot, Integer> getSelectedAnnots() {
        return mSelectedAnnots;
    }

    @Override
    public ArrayList<String> getLongPressMenuItems() {
        return mLongPressMenuItems;
    }

    @Override
    public ArrayList<String> getLongPressMenuOverrideItems() {
        return mLongPressMenuOverrideItems;
    }

    @Override
    public ArrayList<String> getHideAnnotationMenuTools() {
        return mHideAnnotationMenuTools;
    }

    @Override
    public ArrayList<String> getAnnotationMenuItems() {
        return mAnnotationMenuItems;
    }

    @Override
    public ArrayList<String> getAnnotationMenuOverrideItems() {
        return mAnnotationMenuOverrideItems;
    }

    // Convenience

    @Nullable
    public PdfViewCtrlTabHostFragment2 getPdfViewCtrlTabHostFragment() {
        return mPdfViewCtrlTabHostFragment;
    }

    @Nullable
    public PdfViewCtrlTabFragment2 getPdfViewCtrlTabFragment() {
        if (mPdfViewCtrlTabHostFragment != null) {
            return mPdfViewCtrlTabHostFragment.getCurrentPdfViewCtrlFragment();
        }
        return null;
    }

    @Nullable
    public PDFViewCtrl getPdfViewCtrl() {
        if (getPdfViewCtrlTabFragment() != null) {
            return getPdfViewCtrlTabFragment().getPDFViewCtrl();
        }
        return null;
    }

    @Nullable
    public ToolManager getToolManager() {
        if (getPdfViewCtrlTabFragment() != null) {
            return getPdfViewCtrlTabFragment().getToolManager();
        }
        return null;
    }

    @Nullable
    public PDFDoc getPdfDoc() {
        if (getPdfViewCtrlTabFragment() != null) {
            return getPdfViewCtrlTabFragment().getPdfDoc();
        }
        return null;
    }

    @NonNull
    @Override
    public ViewerImpl getImpl() {
        return mImpl;
    }
}
