# Pdftron Flutter example

Demonstrates how to use the `pdftron_flutter` plugin.

## Prerequisites
- PDFTron SDK >= 12.2.0
- Flutter >= 3.24 (required for Swift Package Manager support on iOS)
- Xcode >= 15 for iOS builds

This example integrates its iOS dependencies through Swift Package Manager and
ships no Podfile. Swift Package Manager is enabled for this project in
`example/pubspec.yaml`, so it works even when the feature is turned off
machine-wide:

```yaml
flutter:
  config:
    enable-swift-package-manager: true
```

Run `flutter pub get` in this directory before opening
`example/ios/Runner.xcworkspace`. The Xcode project references a generated
Swift package under `ios/Flutter/ephemeral/`, which the Flutter tool creates
during `flutter pub get`. Opening Xcode beforehand reports a missing package
product.

## Installation

If you want to use local files, add the following dependency to `example/pubspec.yaml`:

  ```yaml
    permission_handler: ^8.1.1
  ```
There will be sections of code that must then be uncommented. These areas have alrady been indicated within `example/lib/main.dart`

## Run

### Android
1. Check that your Android device is running by running the command `flutter devices`. If none are available, follow the device set up instructions in the [Install](https://flutter.io/docs/get-started/install) guides for your platform.
2. Run the app with the command `flutter run`.

### iOS
1. Run `flutter emulators --launch apple_ios_simulator`.
2. Run the app with the command `flutter run`.