package com.pdftron.pdftronflutter.kotlin

import android.content.Context
import android.widget.Toast

class MyToast {
    companion object {
        @JvmStatic
        fun show(context: Context) {
            Toast.makeText(context, "Kotlin API Called!!!", Toast.LENGTH_SHORT).show()
        }
    }
}