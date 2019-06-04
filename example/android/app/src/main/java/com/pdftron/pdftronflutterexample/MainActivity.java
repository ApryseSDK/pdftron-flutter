package com.pdftron.pdftronflutterexample;

import android.os.Bundle;

import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterAppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
    }
}
