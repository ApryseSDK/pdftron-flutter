package com.pdftron.pdftronflutter;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import androidx.annotation.DrawableRes;
import androidx.annotation.Nullable;

import com.pdftron.pdf.PDFDoc;
import com.pdftron.pdf.PDFViewCtrl;
import com.pdftron.pdf.config.ViewerConfig;
import com.pdftron.pdf.controls.DocumentActivity;
import com.pdftron.pdf.controls.PdfViewCtrlTabFragment;
import com.pdftron.pdf.controls.PdfViewCtrlTabHostFragment;

import org.json.JSONObject;

import java.util.concurrent.atomic.AtomicReference;

import io.flutter.plugin.common.MethodChannel.Result;

public class FlutterDocumentActivity extends DocumentActivity {

    private static FlutterDocumentActivity sCurrentActivity;
    private static AtomicReference<Result> sFlutterResult = new AtomicReference<>();

    public static void openDocument(Context packageContext, Uri fileUri, String password, @Nullable JSONObject customHeaders, @Nullable ViewerConfig config) {
        openDocument(packageContext, fileUri, password, customHeaders, config, DEFAULT_NAV_ICON_ID);
    }

    public static void openDocument(Context packageContext, Uri fileUri, String password, @Nullable JSONObject customHeaders, @Nullable ViewerConfig config, @DrawableRes int navIconId) {
        Intent intent = new Intent(packageContext, FlutterDocumentActivity.class);
        if (null != fileUri) {
            intent.putExtra("extra_file_uri", fileUri);
        }

        if (null != password) {
            intent.putExtra("extra_file_password", password);
        }

        if (null != customHeaders) {
            intent.putExtra("extra_custom_headers", customHeaders.toString());
        }

        intent.putExtra("extra_nav_icon", navIconId);
        intent.putExtra("extra_config", config);
        packageContext.startActivity(intent);
    }

    public static void setFlutterResult(Result result) {
        sFlutterResult.set(result);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        attachActivity();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();

        detachActivity();
    }

    @Override
    public void onTabDocumentLoaded(String tag) {
        super.onTabDocumentLoaded(tag);

        Log.d("pdfnet", "documentloaded");

        Result result = sFlutterResult.getAndSet(null);
        if (result != null) {
            result.success(true);
        }
    }

    @Override
    public void onOpenDocError() {
        super.onOpenDocError();

        Result result = sFlutterResult.getAndSet(null);
        if (result != null) {
            result.success(false);
        }
    }

    @Nullable
    public PdfViewCtrlTabHostFragment getPdfViewCtrlTabHostFragment() {
        return mPdfViewCtrlTabHostFragment;
    }

    @Nullable
    public PdfViewCtrlTabFragment getPdfViewCtrlTabFragment() {
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
    public PDFDoc getPdfDoc() {
        if (getPdfViewCtrlTabFragment() != null) {
            return getPdfViewCtrlTabFragment().getPdfDoc();
        }
        return null;
    }

    private void attachActivity() {
        sCurrentActivity = this;
    }

    private void detachActivity() {
        Result result = sFlutterResult.getAndSet(null);
        if (result != null) {
            result.success(false);
        }
        sCurrentActivity = null;
    }

    public static FlutterDocumentActivity getCurrentActivity() {
        return sCurrentActivity;
    }
}
