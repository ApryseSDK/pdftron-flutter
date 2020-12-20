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

## Legacy UI

Version `0.0.6` is the last stable release for the legacy UI.

The release can be found here: https://github.com/PDFTron/pdftron-flutter/releases/tag/legacy-ui.

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

## Function APIs

### Note 

For APIs that states "**PdftronFlutter only**", these would only be callable in a plugin fashion. Below is an example for [initialize](#PdftronFlutter.initialize);

```dart
PdftronFlutter.initialize('your_license_key');
```

But for those that are not specified, these would be callable in both plugin and widget versions. For example, openDocument is accessible in 2 ways:

Plugin:
```dart
void showViewer() async {
  PdftronFlutter.openDocument('sample.pdf');
}
```

Widget (DocumentViewController):
```dart
void _onDocumentViewCreated(DocumentViewController controller) {
    controller.openDocument('sample.pdf');
}
```

We suggest that you stick with either version for the APIs that are callable in both versions, to avoid unnecessary problems.

There are several custom classes used in these APIs: `Annot`, `AnnotWithRect`, `Field`, `Rect`, `AnnotFlag`,`AnnotWithFlag` and `CustomToolbar`. These classes together with constants that are used in the examples below are all listed [here](./lib/options.dart).

- [version](#version)
- [platformVersion](#version)
- [initialize](#initialize)
- [openDocument](#openDocument)
- [importAnnotations](#importAnnotations)
- [exportAnnotations](#exportAnnotations)
- [flattenAnnotations](#flattenAnnotations)
- [deleteAnnotations](#deleteAnnotations)
- [selectAnnotation](#selectAnnotation)
- [setFlagsForAnnotations](#setFlagsForAnnotations)
- [importBookmarkJson](#importBookmarkJson)
- [saveDocument](#saveDocument)
- [commitTool](#commitTool)
- [getPageCount](#getPageCount)
- [handleBackButton](#handleBackButton)
- [getPageCropBox](#getPageCropBox)
- [setToolMode](#setToolMode)
- [setFlagForFields](#setFlagForFields)
- [setValuesForFields](#setValuesForFields)
- [setLeadingNavButtonIcon](#setLeadingNavButtonIcon)
- [closeAllTabs](#closeAllTabs)

### version

To obtain PDFTron SDK version. **PdftronFlutter only**.

```dart
String version = PdftronFlutter.version;
print('Current PDFTron SDK version is: ' + version);
```

### platformVersion

To obtain the current platform version. **PdftronFlutter only**.

```dart
String platformVersion = PdftronFlutter.platformVersion;
print('App is currently running on: ' + platformVersion);
```

### initialize

To initialize PDFTron SDK. **PdftronFlutter only**.

Parameters:

Name | Type | Required | Description
--- | --- | --- | ---
key | String | true | your PDFTron license key

Return a Future.

```dart
PdftronFlutter.initialize('your_licensey_key');
```

### openDocument

Opens a document in the viewer with options to remove buttons and disable tools

Parameters:

Name | Type | Required | Description
--- | --- | --- | ---
document | String | true | path to the document
password | String | false | password to an encrypted document
config | Config | false | viewer configuration options

Return a Future that would resolve when document is loaded.

For configs (more info could be found [here](./lib/config.dart)):
- [disabledElements](#disabledElements)
- [disabledTools](#disabledTools)
- [multiTabEnabled](#multiTabEnabled)
- [customerHeaders](#customerHeaders)
- [annotationToolbars](#annotationToolbars)
- [hideDefaultAnnotationToolbars](#hideDefaultAnnotationToolbars)
- [hideAnnotationToolbarSwitcher](#hideAnnotationToolbarSwitcher)
- [hideTopToolbars](#hideTopToolbars)
- [hideTopAppNavBar](#hideTopAppNavBar)
- [showLeadingNavButton](#showLeadingNavButton)
- [readOnly](#readOnly)
- [thumbnailViewEditingEnabled](#thumbnailViewEditingEnabled)
- [annotationAuthor](#annotationAuthor)
- [continuousAnnotationEditing](#continuousAnnotationEditing)
- [tabTitle](#tabTitle)

#### disabledElements
array of `Buttons` constants, default to none.

Defines buttons to be disabled for the viewer.

```dart
var disabledElements = [Buttons.shareButton, Buttons.searchButton];
config.disabledElements = disabledElements;
```

#### disabledTools
array of `Tools` constants, default to none.

Defines tools to be disabled for the viewer.

```dart
var disabledTools = [Tools.annotationCreateLine, Tools.annotationCreateRectangle];
config.disabledTools = disabledTools;
```

#### multiTabEnabled
bool, default to false.

Defines whether viewer will show tabs for documents opened. Calling [openDocument](#openDocument) with this value being true will cause a new tab to be opened with the associated document.

```dart
config.multiTabEnabled = true;
```

#### customerHeaders
map<string, string>, default to empty.

Defines custom headers to use with HTTP/HTTPS requests.

```dart
config.customHeaders = {'headerName': 'headerValue'};
```

#### annotationToolbars
array of `CustomToolbar` objects or `DefaultToolbars` constants

Defines custom toolbars. If passed in, the set of default toolbars will no longer appear.

```dart
// Viewer will use a custom defined toolbar and a default annotate toolbar in this case
var customToolbar = new CustomToolbar('myToolbar', 'myToolbar', [Tools.annotationCreateArrow, Tools.annotationCreateCallout], ToolbarIcons.favorite);
var annotationToolbars = [DefaultToolbars.annotate, customToolbar];
```

#### hideDefaultAnnotationToolbars
array of `DefaultToolbars` constants, default to none

Defines which default annotation toolbars should be hidden. Note that this should be used when annotationToolbars is not defined.

```dart
// Viewer will use all the default toolbars except annotate or draw in this case
var hideDefaultAnnotationToolbars = [DefaultToolbars.annotate, DefaultToolbars.draw];
config.hideDefaultAnnotationToolbars = hideDefaultAnnotationToolbars;
```

#### hideAnnotationToolbarSwitcher
bool, default to false

Defines whether to show the toolbar switcher in the top toolbar.

```dart
config.hideAnnotationToolbarSwitcher = true;
```

#### hideTopToolbars
bool, default to false

Defines whether to show both the top nav app bar and the annotation toolbar.

```dart
config.hideTopToolbars = true;
```

#### hideTopAppNavBar
bool, default to false

Defines whether to show the top nav app bar.

```dart
config.hideTopAppNavBar = true;
```

#### showLeadingNavButton
bool, default to true

Defines whether to show the leading navigation button.

```dart
config.showLeadingNavButton = true;
```

#### readOnly
bool, default to false

Defines whether the document is read-only.

```dart
config.readOnly = true;
```

#### thumbnailViewEditingEnabled
bool, default to true

Defines whether use could modify through thumbnail view.

```dart
config.thumbnailViewEditingEnabled = false;
```

#### annotationAuthor
String

Defines the author name for all annotations in the current document

```dart
config.annotationAuthor = 'PDFTron';
```

#### continuousAnnotationEditing
bool, default to false

Defines whether annotations could be continuously edited

```dart
config.continuousAnnotationEditing = true;
```

#### tabTitle
String, default to the document name

Defines the tab title for the current document, if [multiTabEnabled](#multiTabEnabled) is true (For Android, tabTitle is only supported on the widget viewer)

```dart
config.tabTitle = 'tab1';
```

Example:
```dart
var disabledElements = [Buttons.shareButton, Buttons.searchButton];
var disabledTools = [Tools.annotationCreateLine, Tools.annotationCreateRectangle];
var hideDefaultAnnotationToolbars = [DefaultToolbars.annotate, DefaultToolbars.draw];

var config = Config();
config.disabledElements = disabledElements;
config.disabledTools = disabledTools;
config.multiTabEnabled = false;
config.customHeaders = {'headerName': 'headerValue'};
config.hideDefaultAnnotationToolbars = hideDefaultAnnotationToolbars;
config.hideAnnotationToolbarSwitcher = true;
config.continuousAnnotationEditing = true;

var password = 'pdf_password';
await PdftronFlutter.openDocument(_document, password: password, config: config);
```

### importAnnotations
To import XFDF annotation string to current document.

Parameters:

Name | Type | Description
--- | --- | ---
xfdf | String | the XFDF string for import

Return a Future.

```dart

var xfdf = '<?xml version="1.0" encoding="UTF-8"?>\n<xfdf xmlns="http://ns.adobe.com/xfdf/" xml:space="preserve">\n\t<annots>\n\t\t<circle style="solid" width="5" color="#E44234" opacity="1" creationdate="D:20190729202215Z" flags="print" date="D:20190729202215Z" page="0" rect="138.824,653.226,236.28,725.159" title="" /></annots>\n\t<pages>\n\t\t<defmtx matrix="1.333333,0.000000,0.000000,-1.333333,0.000000,1056.000000" />\n\t</pages>\n\t<pdf-info version="2" xmlns="http://www.pdftron.com/pdfinfo" />\n</xfdf>';
PdftronFlutter.importAnnotations(xfdf);
```

### exportAnnotations
To extract XFDF from the current document. If `annotationList` is null, export all annotations from the document; Else export the valid ones specified.

Parameters:

Name | Type | Description
--- | --- | ---
annotationList | List<`Annot`> | If not null, export the XFDF string for the valid annotations; Otherwise, export the XFDF string for all annotations

Return a Future.

Future Parameters:

Name | Type | Description
-- | -- | --
xfdf | String | The exported XFDF string

Export all annotations:
```dart
var xfdf = await PdftronFlutter.exportAnnotations(null);
```

Export specified annotations:
```dart
List<Annot> annotList = new List<Annot>();
list.add(new Annot('Hello', 1));
list.add(new Annot('World', 2));
var xfdf = await PdftronFlutter.exportAnnotations(annotList);
```

### flattenAnnotations
To flatten the forms and (optionally) annotations in the current document.

Parameters:

Name | Type | Description
--- | --- | ---
formsOnly | bool | If true, only forms will be flattened; Otherwise, all annotations would be flattened.

Return a Future.

```dart
PdftronFlutter.flattenAnnotations(true);
```

### deleteAnnotations
To delete the specified annotations in the current document.

Parameters:

Name | Type | Description
--- | --- | ---
annotations | List<`Annot`> | the list of annotations to be deleted

Return a Future.

```dart
List<Annot> annotList = new List<Annot>();
list.add(new Annot('Hello', 1));
list.add(new Annot('World', 2));
PdftronFlutter.deleteAnnotations(annotList);
```

### selectAnnotation
To select the specified annotation in the current document.

Parameters:

Name | Type | Description
--- | --- | ---
annotation | `Annot` | the annotation to be selected

Return a Future.

```dart
PdftronFlutter.selectAnnotation(new Annot('Hello', 1));
```

### setFlagsForAnnotations
To set flags for specified annotations in the current document.

Parameters:

Name | Type | Description
--- | --- | ---
annotationWithFlagsList | List<`AnnotWithFlags`> | a list of annotations with respective flags to be set

Return a Future.

```dart
List<AnnotWithFlags> annotsWithFlags = new List<AnnotWithFlags>();

Annot hello = new Annot('Hello', 1);
Annot world = new Annot('World', 3);
AnnotFlag printOn = new AnnotFlag(AnnotationFlags.print, true);
AnnotFlag unlock = new AnnotFlag(AnnotationFlags.locked, false);

// you can add an AnnotWithFlags object flexibly like this:
list.add(new AnnotWithFlags.fromAnnotAndFlags(hello, [printOn, unlock]));
list.add(new AnnotWithFlags.fromAnnotAndFlags(world, [unlock]));

// Or simply use the constructor like this:
list.add(new AnnotWithFlags('Pdftron', 10, AnnotationFlags.no_zoom, true));
PdftronFlutter.setFlagsForAnnotations(annotsWithFlags);
```

### importAnnotationCommand
To import XFDF command string to the document.
The XFDF needs to be a valid command format with `<add>` `<modify>` `<delete>` tags.

Parameters:

Name | Type | Description
--- | --- | ---
xfdfCommand | String | the XFDF command string for import

Return a Future.

```dart
var xfdfCommand = 'xfdfCommand <?xml version="1.0" encoding="UTF-8"?><xfdf xmlns="http://ns.adobe.com/xfdf/" xml:space="preserve"><add><circle style="solid" width="5" color="#E44234" opacity="1" creationdate="D:20201218025606Z" flags="print" date="D:20201218025606Z" name="9d0f2d63-a0cc-4f06-b786-58178c4bd2b1" page="0" rect="56.4793,584.496,208.849,739.369" title="PDF" /></add><modify /><delete /><pdf-info import-version="3" version="2" xmlns="http://www.pdftron.com/pdfinfo" /></xfdf>';
PdftronFlutter.importAnnotationCommand(xfdfCommand);
```

### importBookmarkJson
To import user bookmarks to the document. The input needs to be a valid bookmark JSON format.

Parameters:

Name | Type | Description
--- | --- | ---
bookmarkJson | String | needs to be in valid bookmark JSON format, for example {"0": "Page 1"}. The page numbers are 1-indexed

Return a Future.

```dart
PdftronFlutter.importBookmarkJson("{\"0\": \"Page 1\", \"3\": \"Page 4\"}");
```

### saveDocument
To save the currently opened document in the viewer and get the absolute path to the file. Must only be called when the document is opened in the viewer.

Return a Future.

Future Parameters:

Name | Type | Description
--- | --- | ---
path | String | the absolute path to the saved file

```dart
var path = await PdftronFlutter.saveDocument();
```

### commitTool
To commit the annotation being created by the tool to the PDF, only available for multi-stroke ink and poly-shape.

Return a Future.

Future Parameters:

Name | Type | Description
--- | --- | ---
committed | bool | true if either ink or poly-shape tool is committed, false otherwise

```dart
var committed = await PdftronFlutter.commitTool();
print("Tool committed: $committed");
```

### getPageCount
To get the total number of pages in the currently displayed document.

Return a Future.

Future Parameters:

Name | Type | Description
--- | --- | ---
pageCount | int | the page count of the current document

```dart
var pageCount = await PdftronFlutter.getPageCount();
print("The current doc has $pageCount pages");
```

### handleBackButton
To handle back button in search mode (Android only).

Return a Future.

Future Parameters:

Name | Type | Description
--- | --- | ---
handled | bool | whether the back button was handled successfully

```dart
var handled = await PdftronFlutter.handleBackButton();
print("Back button handled: $handled");
```

### getPageCropBox
To get a map object of the crop box for specified page.

Parameters:

Name | Type | Description
--- | --- | ---
pageNumber | int | the page number for the target crop box

Return a Future.

Future Parameters:

Name | Type | Description
--- | --- | ---
cropBox | Map<String, double> | the crop box information map. It contains information for position (bottom-left: `x1`, `y1`; top-right: `x2`, `y2`) and size (`width`, `height`)

```dart
var cropBox = await PdftronFlutter.getPageCropBox(1);
print('The width of crop box for page 1 is: ' + cropBox.width.toString());
```

### setToolMode
To set the current tool mode.

Parameters:

Name | Type | Description
--- | --- | ---
toolMode | String | the tool mode to be set, one of the constants from `Tools`

Return a Future.

```dart
 PdftronFlutter.setToolMode(Tools.annotationCreateEllipse);
```

### setFlagForFields
To set a field flag value on one or more form fields.

Parameters:

Name | Type | Description
--- | ---| ---
fieldNames | List<`String`> | A list of field names to be set
flag | int | The flag to be set, one of the constants from `FieldFlags`
flagValue | bool | To turn on/off the flag for the fields

Return a Future.

```dart
 PdftronFlutter.setFlagForFields(['First Name', 'Last Name'], FieldFlags.Required, true);
```

### setValuesForFields
To set field values on one or more form fields of different types.

Parameters:

Name | Type | Description
--- | ---| ---
fields | List<`Field`> | A list of fields with name and the value that you would like to set to, could be in type number, bool or string

Return a Future.

```dart
PdftronFlutter.setValuesForFields([
      new Field('textField1', "Pdftron"),
      new Field('textField2', 12.34),
      new Field('checkboxField1', true),
      new Field('checkboxField2', false),
      new Field('radioField', 'Yes'),
      new Field('choiceField', 'No')
    ]);
```

### setLeadingNavButtonIcon
To set the icon path to the navigation button. The button would use the specified icon if [showLeadingNavButton](#showLeadingNavButton) (which by default is true) is true in the config.

Parameters:

Name | Type | Description
--- | ---| ---
leadingNavButtonIcon | String | the icon path to the navigation button

Return a Future.

```dart
PdftronFlutter.setLeadingNavButtonIcon(Platform.isIOS ? 'ic_close_black_24px.png' : 'ic_arrow_back_white_24dp');
```

### closeAllTabs
To close all documents that are currently opened in a multiTab environment (that is, [multiTabEnabled](#multiTabEnabled) is true in the config).

```dart
PdftronFlutter.closeAllTabs();
```

## Event APIs
- [startExportAnnotationCommandListener](#startExportAnnotationCommandListener)
- [startExportBookmarkListener](#startExportBookmarkListener)
- [startDocumentLoadedListener](#startDocumentLoadedListener)
- [startDocumentErrorListener](#startDocumentErrorListener)
- [startAnnotationChangedListener](#startAnnotationChangedListener)
- [startAnnotationsSelectedListener](#startAnnotationsSelectedListener)
- [startFormFieldValueChangedListener](#startFormFieldValueChangedListener)
- [startLeadingNavButtonPressedListener](#startLeadingNavButtonPressedListener)
- [startPageChangedListener](#startPageChangedListener)
- [startZoomChangedListener](#startZoomChangedListener)

### startExportAnnotationCommandListener
Event is raised when local annotation changes committed to the document.

Event Parameters:

Name | Type | Description
--- | --- | ---
xfdfCommand | String | the XFDF command string exported

```dart
var annotCancel = startExportAnnotationCommandListener((xfdfCommand) {
  // local annotation changed
  // upload XFDF command to server here
  print("flutter xfdfCommand: $xfdfCommand");
});
```

### startExportBookmarkListener
Event is raised when user bookmark changes committed to the document.

Event Parameters:

Name | Type | Description
--- | --- | ---
bookmarkJson | String | the bookmark json string exported

```dart
var bookmarkCancel = startExportBookmarkListener((bookmarkJson) {
  print("flutter bookmark: ${bookmarkJson}");
});
```

### startDocumentLoadedListener
Event is raised when the document finishes loading.

Event Parameters:

Name | Type | Description
--- | --- | ---
path | String | the path to where the document is saved

```dart
var documentLoadedCancel = startDocumentLoadedListener((path)
{
  print("flutter document loaded: ${path}");
});
```

### startDocumentErrorListener
Event is raised when the document has errors when loading.

```dart
var documentErrorCancel = startDocumentErrorListener((){
  print("flutter document loaded unsuccessfully");
});
```

### startAnnotationChangedListener
Event is raised when there is a change to annotations to the document.

Event Parameters:

Name | Type | Description
--- | --- | ---
action | String | the action that occurred (add, delete, modify)
annotations | List<`Annot`> | the annotations that have been changed

```dart
var annotChangedCancel = startAnnotationChangedListener((action, annotations) 
{
  print("flutter annotation action: ${action}");
  for (Annot annot in annotations) {
    print("annotation has id: ${annot.id}");
    print("annotation is in page: ${annot.pageNumber}");
  }
});
```

### startAnnotationsSelectedListener
Event is raised when annotations are selected.

Event Parameters:

Name | Type | Description
--- | --- | ---
annotationWithRects | List<`AnnotWithRect`> | The list of annotations with their respective rects

```dart
var annotsSelectedCancel = startAnnotationsSelectedListener((annotationWithRects) 
{
  for (AnnotWithRect annotWithRect in annotationWithRects) {
    print("annotation has id: ${annotWithRect.id}");
    print("annotation is in page: ${annotWithRect.pageNumber}");
    print("annotation has width: ${annotWithRect.rect.width}");
  }
});

```

### startFormFieldValueChangedListener
Event is raised when there are changes to form field values.

Event Parameters:

Name | Type | Description
--- | --- | ---
fields | List<`Field`> | The fields that are changed

```dart
var fieldChangedCancel = startFormFieldValueChangedListener((fields)
{
  for (Field field in fields) {
    print("Field has name ${field.fieldName}");
    print("Field has value ${field.fieldValue}");
  }
});
```

### startLeadingNavButtonPressedListener
Event is raised when the leading navigation button is pressed.

```dart
var navPressedCancel = startLeadingNavButtonPressedListener(()
{
  print("flutter nav button pressed");
});
```

### startPageChangedListener
Event is raised when page changes.

Event Parameters:

Name | Type | Description
--- | --- | ---
previousPageNumber | int | The previous page number
pageNumber | int | the current page number

```dart
var pageChangedCancel = startPageChangedListener((previousPageNumber, pageNumber)
{
  print("flutter page changed. from $previousPageNumber to $pageNumber");
});
```

### startZoomChangedListener
Event is raised when zoom ratio is changed in the current document.

Event Parameters:

Name | Type | Description
--- | --- | ---
zoom | double | the zoom ratio in the current document viewer

```dart
var zoomChangedCancel = startZoomChangedListener((zoom) 
{
  print("flutter zoom changed. Current zoom is: $zoom");
});
```

## Contributing
See [Contributing](./CONTRIBUTING.md)

## License
See [License](./LICENSE)
![](https://onepixel.pdftron.com/pdftron-flutter)
