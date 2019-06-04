package com.pdftron.pdftronflutter;

import android.content.Context;
import android.net.Uri;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.view.View;
import android.widget.TextView;

import com.pdftron.pdf.PDFViewCtrl;
import com.pdftron.pdf.tools.ToolManager;
import com.pdftron.pdf.utils.AppUtils;
import com.pdftron.pdftronflutter.views.DocumentView;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class FlutterDocumentView implements PlatformView, MethodChannel.MethodCallHandler {

//    private final PDFViewCtrl pdfViewCtrl;
//    private final TextView textView;
    private final DocumentView documentView;

    private final MethodChannel methodChannel;

    public FlutterDocumentView(Context context, Context activityContext, BinaryMessenger messenger, int id) {
        documentView = new DocumentView(context);

        FragmentManager manager = null;
        if (activityContext instanceof FragmentActivity) {
            manager = ((FragmentActivity)activityContext).getSupportFragmentManager();
        }

        documentView.setSupportFragmentManager(manager);
        documentView.setDocumentUri(Uri.parse("https://pdftron.s3.amazonaws.com/downloads/pl/PDFTRON_mobile_about.pdf"));

//        textView = new TextView(context);
//        textView.setText("PDFTron Test");

//        pdfViewCtrl = new PDFViewCtrl(activityContext, null);
//        try {
//            AppUtils.setupPDFViewCtrl(pdfViewCtrl);
//            pdfViewCtrl.setToolManager(new ToolManager(pdfViewCtrl));
//            pdfViewCtrl.openPDFUri(Uri.parse("https://pdftron.s3.amazonaws.com/downloads/pl/PDFTRON_mobile_about.pdf"), "");
//        } catch (Exception ex) {
//            ex.printStackTrace();
//        }

        methodChannel = new MethodChannel(messenger, "pdftron_flutter/documentview_" + id);
        methodChannel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {

    }

    @Override
    public View getView() {
//        return textView;
//        return pdfViewCtrl;
        return documentView;
    }

    @Override
    public void dispose() {
//        pdfViewCtrl.destroy();
    }
}
