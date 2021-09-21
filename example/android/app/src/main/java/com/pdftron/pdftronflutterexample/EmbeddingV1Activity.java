package com.pdftron.pdftronflutterexample;

import android.os.Bundle;

import com.baseflow.permissionhandler.PermissionHandlerPlugin;
import com.pdftron.pdftronflutter.PdftronFlutterPlugin;

import io.flutter.app.FlutterFragmentActivity;

public class EmbeddingV1Activity extends FlutterFragmentActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        PdftronFlutterPlugin.registerWith(registrarFor("com.pdftron.pdftronflutter.PdftronFlutterPlugin"));
        PermissionHandlerPlugin.registerWith(registrarFor("com.baseflow.permissionhandler.PermissionHandlerPlugin"));
    }
}
