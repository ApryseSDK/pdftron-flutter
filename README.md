# PDFTron Flutter Wrapper

- [Prerequisites](#Prerequisites)
- [Preview](#preview)
- [Installation](#installation)
- [Usage](#usage)
- [APIs](#apis)
- [License](#license)

## Prerequisites
- No license key is requird for trial. However, a valid commercial license key is required after trial.
- PDFTron SDK >= 6.9.0
- Flutter >= 1.0.0

## Preview

**Android** |  **iOS**
:--:|:--:
![demo](./flutter-pdftron-demo-android.gif) | ![demo](./flutter-pdftron-demo-ios.gif)

## Installation

The complete installation and API guides can be found at https://www.pdftron.com/documentation/android/flutter

### Android
1. First follow the Flutter getting started guides to [install](https://flutter.io/docs/get-started/install), [set up an editor](https://flutter.io/docs/get-started/editor), and [create a Flutter Project](https://flutter.io/docs/get-started/test-drive?tab=terminal#create-app). The rest of this guide assumes your project is created by running `flutter create myapp`.
2. Add the following dependency to your Flutter project in `myapp/pubspec.yaml`:
	```diff
	dependencies:
	   flutter:
	     sdk: flutter
	+  pdftron_flutter:
	+    git:
	+      url: git://github.com/PDFTron/pdftron-flutter.git
	+  permission_handler: '3.0.1'

	```
3. Now add the following items in your `myapp/android/app/build.gradle` file:
	```diff
	android {
	    compileSdkVersion 29

	    lintOptions {
		disable 'InvalidPackage'
	    }

	    defaultConfig {
		applicationId "com.example.myapp"
	-       minSdkVersion 16
	+       minSdkVersion 21
		targetSdkVersion 29
	+       multiDexEnabled true
	+       manifestPlaceholders = [pdftronLicenseKey:PDFTRON_LICENSE_KEY]
		versionCode flutterVersionCode.toInteger()
		versionName flutterVersionName
		testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
	    }
		...
	}
	```

4. In your `myapp/android/gradle.properties` file. Add the following line to it:
    ``` diff
    # Add the PDFTRON_LICENSE_KEY variable here. 
    # For trial purposes leave it blank.
    # For production add a valid commercial license key.
    PDFTRON_LICENSE_KEY=
    ```
    
5. In your `myapp\android\app\src\main\AndroidManifest.xml` file, add the following lines to the `<application>` tag:
	```diff
	...
	<application
		android:name="io.flutter.app.FlutterApplication"
		android:label="myapp"
		android:icon="@mipmap/ic_launcher"
	+	android:largeHeap="true"
	+	android:usesCleartextTraffic="true">
	
	    	<!-- Add license key in meta-data tag here. This should be inside the application tag. -->
	+	<meta-data
	+		android:name="pdftron_license_key"
	+		android:value="${pdftronLicenseKey}"/>
	...
	```
	
	Additionally, add the required permissions for your app in the `<manifest>` tag:
	```diff
		...
	+	<uses-permission android:name="android.permission.INTERNET" />
		<!-- Required to read and write documents from device storage -->
	+	<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
		<!-- Required if you want to record audio annotations -->
	+	<uses-permission android:name="android.permission.RECORD_AUDIO" />
		...
	```

5a. (Optional, required if using `DocumentView` widget) In your `MainActivity` file (either kotlin or java), change the parent class to `FlutterFragmentActivity`:
```
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

6. Replace `lib/main.dart` with what is shown [here](#usage)
7. Check that your Android device is running by running the command `flutter devices`. If none are available, follow the device set up instructions in the [Install](https://flutter.io/docs/get-started/install) guides for your platform.
8. Run the app with the command `flutter run`.

### iOS

1. First, follow the official getting started guide on [installation](https://flutter.io/docs/get-started/install/macos), [setting up an editor](https://flutter.io/docs/get-started/editor), and [create a Flutter project](https://flutter.io/docs/get-started/test-drive?tab=terminal#create-app), the following steps will assume your app is created through `flutter create myapp`

2. Open `myapp` folder in a text editor. Then open `myapp/pubspec.yaml` file, add:
	```diff
	dependencies:
	   flutter:
	     sdk: flutter
	+  pdftron_flutter:
	+    git:
	+      url: git://github.com/PDFTron/pdftron-flutter.git
	+  permission_handler: '3.0.1'
	```

3. Run `flutter packages get`
4. Open `myapp/ios/Podfile`, add:
	```diff
	 # Uncomment this line to define a global platform for your project
	-# platform :ios, '9.0'
	+platform :ios, '10.0'
	...
	 target 'Runner' do
	   ...
	+  # PDFTron Pods
	+  use_frameworks!
	+  pod 'PDFNet', podspec: 'https://www.pdftron.com/downloads/ios/cocoapods/pdfnet/latest.podspec'
	 end
	```
6. Run `flutter build ios --no-codesign` to ensure integration process is sucessful
7. Replace `lib/main.dart` with what is shown [here](#usage)
8. Run `flutter emulators --launch apple_ios_simulator`
9. Run `flutter run`

## Usage

Open `lib/main.dart`, replace the entire file with the following:

```dart
import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdftron_flutter/pdftron_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _version = 'Unknown';
  String _document = "https://pdftron.s3.amazonaws.com/downloads/pl/PDFTRON_mobile_about.pdf";

  @override
  void initState() {
    super.initState();
    initPlatformState();

    if (Platform.isIOS) {
      // Open the document for iOS, no need for permission
      showViewer();

    } else {
      // Request for permissions for android before opening document
      launchWithPermission();
    }
  }

  Future<void> launchWithPermission() async {
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    if (granted(permissions[PermissionGroup.storage])) {
      showViewer();
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String version;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      PdftronFlutter.initialize("Insert commercial license key here after purchase");
      version = await PdftronFlutter.version;
    } on PlatformException {
      version = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _version = version;
    });
  }


  void showViewer() {
    // Shows how to disable functionality. Uncomment to configure your viewer with a Config object.
    //  var disabledElements = [Buttons.shareButton, Buttons.searchButton];
    //  var disabledTools = [Tools.annotationCreateLine, Tools.annotationCreateRectangle];
    //  var config = Config();
    //  config.disabledElements = disabledElements;
    //  config.disabledTools = disabledTools;
    // config.customHeaders = {'headerName': 'headerValue'};
    //  PdftronFlutter.openDocument(_document, config: config);

    // Open document without a config file which will have all functionality enabled.
    PdftronFlutter.openDocument(_document);
  }

  bool granted(PermissionStatus status) {
    return status == PermissionStatus.granted;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PDFTron flutter app'),
        ),
        body: Center(
          child: Text('Running on: $_version\n'),
        ),
      ),
    );
  }
}
```

## APIs

### PdftronFlutter.version

Obtain PDFTron SDK version

**Returns:** String

### PdftronFlutter.initialize(String)

Initializes PDFTron SDK

#### Params

##### key
Your PDFTron license key

Type | Required | Default
--- | --- | ---
String | true | 

### PdftronFlutter.openDocument(String)

Opens a document in the viewer

#### Params

##### path
Path to the document

Type | Required | Default
--- | --- | ---
String | true | 

### PdftronFlutter.openDocument(String, password: String, config: Config)

Opens a document in the viewer with options to remove buttons and disable tools

Optional parameters:
- `password`: String, password to an encrypted document
- `config`: Config, viewer configuration options

```dart
var disabledElements = [Buttons.shareButton, Buttons.searchButton];
var disabledTools = [Tools.annotationCreateLine, Tools.annotationCreateRectangle];
var config = Config();
config.disabledElements = disabledElements;
config.disabledTools = disabledTools;
config.customHeaders = {'headerName': 'headerValue'};
PdftronFlutter.openDocument(_document, config: config);
```

### PdftronFlutter.importAnnotationCommand(String)

Imports XFDF command string to the document.
The XFDF needs to be a valid command format with `<add>` `<modify>` `<delete>` tags.

### PdftronFlutter.importBookmarkJson(String)

Imports user bookmarks to the document.
The input needs to be a valid bookmark JSON format, for example `{"0":"Page 1"}`.

### PdftronFlutter.saveDocument()

Saves the currently opened document in the viewer and returns the absolute path to the file. Must only be called when the document is opened in the viewer.

```dart
var path = await PdftronFlutter.saveDocument();
```

### PdftronFlutter.commitTool()

Commits the annotation being created by the tool to the PDF.

Only available for multi-stroke ink and poly-shape, and will return false for all other tools.

```dart
var committed = await PdftronFlutter.commitTool();
print("Tool committed: $committed");
```

### PdftronFlutter.getPageCount()

Returns the total number of pages in the currently displayed document.

```dart
var pageCount = await PdftronFlutter.getPageCount();
print("The current doc has $pageCount pages");
```

### PdftronFlutter.handleBackButton()

Handles back button (Android only).

```dart
var handled = await PdftronFlutter.handleBackButton();
print("Back button handled: $handled");
```

### PdftronFlutter.getPageCropBox()

Return a map object with values for position (bottom-left: `x1`, `y1`; top-right: `x2`, `y2`) and size (`width`, `height`) of the crop box for specified page. Values all have type `double`.

```dart
var cropBox = await PdftronFlutter.getPageCropBox(1);
print('The width of crop box for page 1 is: ' + cropBox.width.toString());
```

### PdftronFlutter.setToolMode(String)

To set the current tool mode (`Tools` constants in `lib/option.dart`).

```dart
 PdftronFlutter.setToolMode(Tools.annotationCreateEllipse);
```

### PdftronFlutter.setFlagForFields(List<`String`>, flag: int, flagValue: bool)

Set a field flag value on one or more form fields.

Params
Name | Type | Description
--- | ---| ---
fieldNames | List<`String`> | A list of field names to be set
flag | int | The flag to be set, one of the constants from `FieldFlags` in `lib/options.dart`
flagValue | bool | To turn on/off the flag for the fields

```dart
 PdftronFlutter.setFlagForFields(['First Name', 'Last Name'], FieldFlags.Required, true);
```

### PdftronFlutter.setValueForFields(List<`Field`>)

Set field values on one or more form fields of different types. Field values to be set could be in type number, bool or string.

For more details about `Field`, please check `lib/options.dart` file.

```dart
PdftronFlutter.setValueForFields([
      new Field('textField1', "Pdftron"),
      new Field('textField2', 12.34),
      new Field('checkboxField1', true),
      new Field('checkboxField2', false),
      new Field('radioField', 'Yes'),
      new Field('choiceField', 'No')
    ]);
```

## Events

### startExportAnnotationCommandListener

Event is raised when local annotation changes committed to the document.

```dart
var annotCancel = startExportAnnotationCommandListener((xfdfCommand) {
  // local annotation changed
  // upload XFDF command to server here
  print("flutter xfdfCommand: $xfdfCommand");
});
```

### startExportBookmarkListener

Event is raised when user bookmark changes committed to the document.

```dart
var bookmarkCancel = startExportBookmarkListener((bookmarkJson) {
  print("flutter bookmark: ${bookmarkJson}");
});
```

## Contributing
See [Contributing](./CONTRIBUTING.md)

## License
See [License](./LICENSE)
![](https://onepixel.pdftron.com/pdftron-flutter)
