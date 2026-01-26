## About PDFTron Flutter Wrapper

> [!IMPORTANT]
> This repository serves as a wrapper around the native SDKs. It exposes only a limited set of APIs intended for basic viewing, annotating and removing components from the out‑of‑box UI. Any advanced customization or access to lower‑level functionality should be performed directly through the native SDKs rather than this wrapper.

- [API](https://pub.dev/documentation/pdftron_flutter/latest/pdftron/pdftron-library.html)
- [Prerequisites](#prerequisites)
- [Null Safety](#Null-safety)
- [Legacy UI](#legacy-ui)
- [Installation](#installation)
- [Widget or Plugin](#widget-or-plugin)
- [Usage](#usage)
- [Changelog](#changelog)
- [Contributing](#contributing)
- [License](#license)

## Preview

**Android**|**iOS**
:--:|:--:
<img src="https://pdftron.s3.amazonaws.com/custom/websitefiles/flutter/flutter-pdftron-demo-android.gif" alt="A gif showcasing the UI and some features on Android"/>|<img src="https://pdftron.s3.amazonaws.com/custom/websitefiles/flutter/flutter-pdftron-demo-ios.gif" alt="A gif showcasing the UI and some features on iOS"/>

## Prerequisites
- No license key is required for trial. However, a valid commercial license key is required after trial.
- PDFTron SDK >= 6.9.0
- Flutter >= 2.0.0

## Null Safety
Dart now supports [sound null safety](https://dart.dev/null-safety), which is available starting from Dart 2.12.0 and Flutter 2.0.0. Here is a guide to migrate to [null safety](https://dart.dev/null-safety/migration-guide)

If you would like to use our null safe SDK, it is available in the following places:
- [GitHub](https://github.com/ApryseSDK/pdftron-flutter)
- [pub.dev](https://pub.dev/packages/pdftron_flutter)

The rest of this README.md contains documentation, installation instructions, and information for the null safe version of our SDK.

## Legacy UI

Version `0.0.6` is the last stable release for the legacy UI.

The release can be found here: https://github.com/ApryseSDK/pdftron-flutter/releases/tag/legacy-ui.

## Installation

1. First follow the Flutter getting started guides to [install](https://flutter.io/docs/get-started/install), [set up an editor](https://flutter.io/docs/get-started/editor), and [create a Flutter Project](https://flutter.io/docs/get-started/test-drive?tab=terminal#create-app). The rest of this guide assumes your project is created by running `flutter create myapp`.

2. Add the following dependency to your Flutter project in `myapp/pubspec.yaml` file:

  - If you want to use our null safe package from pub.dev: 
    ```diff
    dependencies:
        flutter:
          sdk: flutter
    +   pdftron_flutter:
    ```
  - If you want to use our null safe package from GitHub:
    ```diff
    dependencies:
        flutter:
          sdk: flutter
    +   pdftron_flutter:
    +     git:
    +       url: git://github.com/ApryseSDK/pdftron-flutter.git
    ```

3. In the `myapp` directory, run `flutter packages get`.

### Android

The following instructions are only applicable to Android development; click here for the [iOS counterpart](#ios).

4. Now add the following items in your `myapp/android/app/build.gradle` file:
	```diff
	defaultConfig {
	    applicationId "com.example.myapp"
	    targetSdkVersion flutter.targetSdkVersion
	    versionCode flutterVersionCode.toInteger()
	    versionName flutterVersionName

	+   resValue("string", "PDFTRON_LICENSE_KEY", "\"LICENSE_KEY_GOES_HERE\"")
	}
	```
    
5. In your `myapp/android/app/src/main/AndroidManifest.xml` file, add the following lines:
	```diff
	<manifest xmlns:android="http://schemas.android.com/apk/res/android"
      package="com.example.myapp">
 
	  <!-- Required if you want to work with online documents -->
	+ <uses-permission android:name="android.permission.INTERNET" />
	  <!-- Required if you want to record audio annotations -->
	+ <uses-permission android:name="android.permission.RECORD_AUDIO" />
 
	  <application
	    ...
	+   android:largeHeap="true">
	
	    <!-- Add license key in meta-data tag here. This should be inside the application tag. -->
	+   <meta-data
	+     android:name="pdftron_license_key"
	+     android:value="@string/PDFTRON_LICENSE_KEY" />
	    ...
      <activity
	      ...
	-     android:windowSoftInputMode="adjustResize"
	+     android:windowSoftInputMode="adjustPan">
      </activity>
	```

    If you are using the `DocumentView` widget, change the parent class of your `MainActivity` file (either Kotlin or Java) to `FlutterFragmentActivity`:
    ```kotlin
    import androidx.annotation.NonNull
    import io.flutter.embedding.android.FlutterFragmentActivity
    import io.flutter.embedding.engine.FlutterEngine
    import io.flutter.plugins.GeneratedPluginRegistrant

    class MainActivity : FlutterFragmentActivity() {
        override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
            GeneratedPluginRegistrant.registerWith(flutterEngine);
        }
    }
    ```

6. Follow the instructions outlined [in the Usage section](#usage).
7. Check that your Android device is running by running the command `flutter devices`. If none are available, follow the device set up instructions in the [Install](https://flutter.io/docs/get-started/install) guides for your platform.
8. Run the app with the command `flutter run`.

### iOS

The following instructions are only applicable to iOS development; click here for the [Android counterpart](#android).

> [!IMPORTANT]
> As of March 2025, use of the `PDFTron` and `PDFTronTools` podspecs distributed specifically for the PDFTron Flutter wrapper (`https://pdftron.com/downloads/ios/flutter/pdftron/latest.podspec` and `https://pdftron.com/downloads/ios/flutter/pdftron-tools/latest.podspec`, respectively) is deprecated and no longer maintained.
> 
> Please update to the latest podspecs provided for the wrapper as soon as possible (`https://www.pdftron.com/downloads/ios/cocoapods/xcframeworks/pdftron/latest.podspec`) and (`https://www.pdftron.com/downloads/ios/cocoapods/xcframeworks/pdftron-tools/latest.podspec`)
>
> See more information here: [Apryse iOS SDK CocoaPods](https://docs.apryse.com/ios/guides/get-started/integration?tab=cocoapods)

4. Open `myapp/ios/Podfile` file and add:
	```diff
	  # Uncomment this line to define a global platform for your project
	- # platform :ios, '9.0'
	+ platform :ios, '10.0'
	  ...
	  target 'Runner' do
	    ...
	+   # PDFTron Pods
	+   pod 'PDFTron', podspec: 'https://www.pdftron.com/downloads/ios/cocoapods/xcframeworks/pdftron/latest.podspec'
	+   pod 'PDFTronTools', podspec: 'https://www.pdftron.com/downloads/ios/cocoapods/xcframeworks/pdftron-tools/latest.podspec'
	  end
	```
5. To ensure integration process is successful, run `flutter build ios --no-codesign` 
6. Follow the instructions outlined [in the Usage section](#usage).
7. Run `flutter emulators --launch apple_ios_simulator`
8. Run `flutter run`

## Widget or Plugin

There are 2 different ways to use PDFTron Flutter API:  
* Present a document via a plugin. 
* Show a PDFTron document view via a Widget.

You must choose either the widget or plugin, and use it for all APIs. Mixing widget and plugin APIs will not function correctly. Whether you choose the widget or plugin is personal preference.

If you pick the Android widget, you will need to add padding for operating system intrusions like the status bar at the top of the device. One way is to set the enabled system UI, and then wrap the widget in a [`SafeArea`](https://api.flutter.dev/flutter/widgets/SafeArea-class.html) or use an [`AppBar`](https://api.flutter.dev/flutter/material/AppBar-class.html):
```
// If using Flutter v2.3.0-17.0.pre or earlier.
SystemChrome.setEnabledSystemUIOverlays(
  SystemUiOverlay.values
);
// If using later Flutter versions.
SystemChrome.setEnabledSystemUIMode(
  SystemUiMode.edgeToEdge,
);

// If using SafeArea:
return SafeArea (
  child: DocumentView(
    onCreated: _onDocumentViewCreated,
  ));

// If using AppBar:
return Scaffold(
  appBar: AppBar( toolbarHeight: 0 ),
  body: DocumentView(
    onCreated: _onDocumentViewCreated,
  ));
```

## Usage

1. If you want to use local files on Android, add the following dependency to `myapp/pubspec.yaml`:

  ```yaml
    permission_handler: ^11.3.1
  ```

2. Open `lib/main.dart`, replace the entire file with the following:

  ```dart
  import 'dart:async';
  import 'dart:io' show Platform;

  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
  import 'package:pdftron_flutter/pdftron_flutter.dart';
  // Uncomment this if you are using local files
  // import 'package:permission_handler/permission_handler.dart';

  void main() => runApp(MyApp());

  class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: Viewer(),
      );
    }
  }

  class Viewer extends StatefulWidget {
    @override
    _ViewerState createState() => _ViewerState();
  }

  class _ViewerState extends State<Viewer> {
    String _version = 'Unknown';
    String _document =
        "https://pdftron.s3.amazonaws.com/downloads/pl/PDFTRON_mobile_about.pdf";
    bool _showViewer = true;

    @override
    void initState() {
      super.initState();
      initPlatformState();

      showViewer();

      // If you are using local files delete the line above, change the _document field
      // appropriately and uncomment the section below.
      // if (Platform.isIOS) {
        // // Open the document for iOS, no need for permission.
        // showViewer();
      // } else {
        // // Request permission for Android before opening document.
        // launchWithPermission();
      // }
    }

    // Future<void> launchWithPermission() async {
    //  PermissionStatus permission = await Permission.storage.request();
    //  if (permission.isGranted) {
    //    showViewer();
    //  }
    // }

    // Platform messages are asynchronous, so initialize in an async method.
    Future<void> initPlatformState() async {
      String version;
      // Platform messages may fail, so use a try/catch PlatformException.
      try {
        // Initializes the PDFTron SDK, it must be called before you can use any functionality.
        PdftronFlutter.initialize("your_pdftron_license_key");

        version = await PdftronFlutter.version;
      } on PlatformException {
        version = 'Failed to get platform version.';
      }

      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, you want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      if (!mounted) return;

      setState(() {
        _version = version;
      });
    }

    void showViewer() async {
      // opening without a config file will have all functionality enabled.
      // await PdftronFlutter.openDocument(_document);

      var config = Config();
      // How to disable functionality:
      //      config.disabledElements = [Buttons.shareButton, Buttons.searchButton];
      //      config.disabledTools = [Tools.annotationCreateLine, Tools.annotationCreateRectangle];
      // Other viewer configurations:
      //      config.multiTabEnabled = true;
      //      config.customHeaders = {'headerName': 'headerValue'};

      // An event listener for document loading
      var documentLoadedCancel = startDocumentLoadedListener((filePath) {
        print("document loaded: $filePath");
      });

      await PdftronFlutter.openDocument(_document, config: config);

      try {
        // The imported command is in XFDF format and tells whether to add, modify or delete annotations in the current document.
        PdftronFlutter.importAnnotationCommand(
            "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
                "    <xfdf xmlns=\"http://ns.adobe.com/xfdf/\" xml:space=\"preserve\">\n" +
                "      <add>\n" +
                "        <square style=\"solid\" width=\"5\" color=\"#E44234\" opacity=\"1\" creationdate=\"D:20200619203211Z\" flags=\"print\" date=\"D:20200619203211Z\" name=\"c684da06-12d2-4ccd-9361-0a1bf2e089e3\" page=\"1\" rect=\"113.312,277.056,235.43,350.173\" title=\"\" />\n" +
                "      </add>\n" +
                "      <modify />\n" +
                "      <delete />\n" +
                "      <pdf-info import-version=\"3\" version=\"2\" xmlns=\"http://www.pdftron.com/pdfinfo\" />\n" +
                "    </xfdf>");
      } on PlatformException catch (e) {
        print("Failed to importAnnotationCommand '${e.message}'.");
      }

      try {
        // Adds a bookmark into the document.
        PdftronFlutter.importBookmarkJson('{"0":"Page 1"}');
      } on PlatformException catch (e) {
        print("Failed to importBookmarkJson '${e.message}'.");
      }

      // An event listener for when local annotation changes are committed to the document.
      // xfdfCommand is the XFDF Command of the annotation that was last changed.
      var annotCancel = startExportAnnotationCommandListener((xfdfCommand) {
        String command = xfdfCommand;
        print("flutter xfdfCommand:\n");
        // Dart limits how many characters are printed onto the console. 
        // The code below ensures that all of the XFDF command is printed.
        if (command.length > 1024) {
          int start = 0;
          int end = 1023;
          while (end < command.length) {
            print(command.substring(start, end) + "\n");
            start += 1024;
            end += 1024;
          }
          print(command.substring(start));
        } else {
          print("flutter xfdfCommand:\n $command");
        }
      });

      // An event listener for when local bookmark changes are committed to the document.
      // bookmarkJson is JSON string containing all the bookmarks that exist when the change was made.
      var bookmarkCancel = startExportBookmarkListener((bookmarkJson) {
        print("flutter bookmark: $bookmarkJson");
      });

      var path = await PdftronFlutter.saveDocument();
      print("flutter save: $path");

      // To cancel event:
      // annotCancel();
      // bookmarkCancel();
      // documentLoadedCancel();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child:
              // Uncomment this to use Widget version of the viewer.
              // _showViewer
              // ? DocumentView(
              //     onCreated: _onDocumentViewCreated,
              //   ):
              Container(),
        ),
      );
    }

    // This function is used to control the DocumentView widget after it has been created.
    // The widget will not work without a void Function(DocumentViewController controller) being passed to it.
    void _onDocumentViewCreated(DocumentViewController controller) async {
      Config config = new Config();

      var leadingNavCancel = startLeadingNavButtonPressedListener(() {
        // Uncomment this to quit the viewer when leading navigation button is pressed.
        // this.setState(() {
        //   _showViewer = !_showViewer;
        // });

        // Show a dialog when leading navigation button is pressed.
        _showMyDialog();
      });

      controller.openDocument(_document, config: config);
    }

    Future<void> _showMyDialog() async {
      print('hello');
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // User must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('AlertDialog'),
            content: SingleChildScrollView(
              child: Text('Leading navigation button has been pressed.'),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
  ```

## Changelog
See [Changelog](https://github.com/ApryseSDK/pdftron-flutter/blob/publish-prep-nullsafe/CHANGELOG.md)

## Contributing
See [Contributing](https://github.com/ApryseSDK/pdftron-flutter/blob/publish-prep-nullsafe/CONTRIBUTING.md)

## License
See [License](https://github.com/ApryseSDK/pdftron-flutter/blob/publish-prep-nullsafe/LICENSE)
![](https://onepixel.pdftron.com/pdftron-flutter)
