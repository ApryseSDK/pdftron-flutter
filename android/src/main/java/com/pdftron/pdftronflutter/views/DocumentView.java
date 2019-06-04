package com.pdftron.pdftronflutter.views;

import android.content.Context;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.util.AttributeSet;
import android.view.ViewGroup;

import com.pdftron.pdf.config.ToolManagerBuilder;
import com.pdftron.pdf.config.ViewerConfig;

public class DocumentView extends com.pdftron.pdf.controls.DocumentView {

    private String mDocumentPath;

    private ToolManagerBuilder mToolManagerBuilder;
    private ViewerConfig.Builder mBuilder;
    private String mCacheDir;

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

    private void init(Context context) {
        int width = ViewGroup.LayoutParams.MATCH_PARENT;
        int height = ViewGroup.LayoutParams.MATCH_PARENT;
        ViewGroup.LayoutParams params = new ViewGroup.LayoutParams(width, height);
        setLayoutParams(params);

        mCacheDir = context.getCacheDir().getAbsolutePath();
        mToolManagerBuilder = ToolManagerBuilder.from();
        mBuilder = new ViewerConfig.Builder();
        mBuilder
                .fullscreenModeEnabled(false)
                .multiTabEnabled(false)
                .showCloseTabOption(false)
                .useSupportActionBar(false);
    }

    private ViewerConfig getConfig() {
        if (mCacheDir != null) {
            mBuilder.openUrlCachePath(mCacheDir);
        }
        return mBuilder
                .toolManagerBuilder(mToolManagerBuilder)
                .build();
    }

    @Override
    protected void onAttachedToWindow() {
        setViewerConfig(getConfig());
        super.onAttachedToWindow();
    }

    @Override
    public boolean canShowFileCloseSnackbar() {
        return false;
    }
}
