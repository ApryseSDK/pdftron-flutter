package com.pdftron.pdftronflutter.nativeviews;

import android.content.Context;
import android.os.Bundle;
import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatDelegate;
import androidx.fragment.app.FragmentActivity;

import com.pdftron.pdf.controls.PdfViewCtrlTabHostFragment2;
import com.pdftron.pdf.utils.PdfViewCtrlSettingsManager;
import com.pdftron.pdf.utils.Utils;

import static com.pdftron.pdf.utils.Utils.isDeviceNightMode;

public class FlutterPdfViewCtrlTabHostFragment extends PdfViewCtrlTabHostFragment2 {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        final FragmentActivity activity = getActivity();
        applyDayNight(activity, AppCompatDelegate.create(activity, null));
    }

    @Override
    protected boolean canRecreateActivity() {
        return true;
    }

    public static boolean applyDayNight(@NonNull Context context, @NonNull AppCompatDelegate delegate) {
        boolean isDarkMode = PdfViewCtrlSettingsManager.isDarkMode(context);
        if (isDeviceNightMode(context) != isDarkMode) {
            int mode = isDarkMode
                    ? AppCompatDelegate.MODE_NIGHT_YES
                    : AppCompatDelegate.MODE_NIGHT_NO;
            if (Utils.isPie()) {
                boolean followSystem = PdfViewCtrlSettingsManager.getFollowSystemDarkMode(context);
                if (followSystem) {
                    mode = AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM;
                }
            }

            delegate.setLocalNightMode(mode);
            return delegate.applyDayNight();
        }
        return false;
    }
}
