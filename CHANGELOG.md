# 1.0.0-18 - August 23, 2023
- mergeAnnotations()

# 1.0.0-16 - August 2, 2023
- Update Android to v10.3.0

# 1.0.0-15 - July 4, 2023
- Fix bug in Android `saveDocument`

# 1.0.0-14 - June 21, 2023
- Update Android to v10.2.0

# 1.0.0-13 - May 10, 2023
- Update Android to v10.1.0

# 1.0.0-9 - Mar 27, 2023
- Update Android to v10.0.0

# 1.0.0-8 - Feb 17, 2023
- Update Android to v9.5.0

# 1.0.0-4 - Dec 19, 2022
- Update Android to v9.4.2

# 1.0.0-3 - Dec 16, 2022
- setFitMode()
- setLayoutMode()

# 1.0.0-2 - Dec 2, 2022
- Update Android to v9.4.1

# 1.0.0-beta.55 - Oct 13, 2022
- Update Android to v9.4.0

# 1.0.0-beta.48 - Aug 25, 2022
- Update Android to v9.4.0

# 1.0.0-beta.36 - Jul 13, 2022
- Update Android to v9.3.0

# 1.0.0-beta.24 - Jul 13, 2022
- Update Android to v9.2.3

# 1.0.0-beta.21 - April 22, 2022
- Update Android to v9.2.2

# 1.0.0-beta.18 - April 22, 2022
- Fix for setting layout mode on document open on iOS


# 1.0.0-beta.17 - March 31, 2022
- hideScrollbars_iOS
# 1.0.0-beta.16 - March 31, 2022
- zoomWithCenter()
- zoomToRect()

# 1.0.0-beta.16 - March 31, 2022
- Minor updates to API docs
# 1.0.0-beta.15 - March 23, 2022
- getZoom Method
- setZoomLimits Methods

# 1.0.0-beta.12 - March 23, 2022
- QuickBookMarkConfig Option
# 1.0.0-beta.11 - March 22, 2022
- Update Android to v9.2.1

# 1.0.0-beta.10 - March 18, 2022
- Minor bug fixes in pubspec.yaml and other files 

# 1.0.0-beta.9 - March 18, 2022
- Implemented the following APIs:
- GetSavedSignatures()
- GetSavedSignaturesFolder()
- GetSavedSignaturesJpgFolder()

# 1.0.0-beta.8 - March 11, 2022

- Bug Fixes

# 1.0.0-beta.7 - March 4, 2022

- Add additional viewMode hiding options (vertical scrolling)
# 1.0.0-beta.5 - Februrary 22, 2022

- Toggle widget and plugin (internal sample)
- Remove Jcenter (Android)


# 1.0.0-beta.4 - Februrary 3, 2022

- Added sound null safety support for new API's
- Updated API.md files to reflect changes

# 1.0.0-beta.3 - November 8, 2021

- Updated the Android plugin and widget ([#128](https://github.com/PDFTron/pdftron-flutter/issues/128)):
  - The plugin now supports [Flutter's new embedding engine](https://flutter.dev/docs/development/packages-and-plugins/plugin-api-migration).
  - The widget now uses [hybrid composition](https://flutter.dev/docs/development/platform-integration/platform-views?tab=ios-platform-views-objective-c-tab#hybrid-composition). This update fixes issues such as: https://github.com/flutter/flutter/issues/58273
    and in regards to stability, places the widget on parity with the plugin.
- Fixed a bug that caused incorrect viewer configurations to be placed on the iOS plugin and widget ([#138](https://github.com/PDFTron/pdftron-flutter/pull/138) and [#143](https://github.com/PDFTron/pdftron-flutter/pull/143)).
- Added new APIs for:
  - opening UI lists e.g. `openAnnotationList()`
  - traversing to different pages e.g. `gotoPreviousPage()`
  - configuring the viewer e.g. `config.defaultEraserType`

See [the commit history](https://github.com/PDFTron/pdftron-flutter/commits/publish-prep) for the full list of new APIs.

- Made minor updates to `API.md`, `README.md`, and `dartdoc` comments.
- Edited example app:
  - Updated its Podfile.
  - Commented out code related to permission handling and added instructions for use.

# 1.0.0-beta.2 - June 14, 2021

- Added support for sound null safety:
  - Updated the `API.md` and `README.md` to use null safe code.
- Added `dartdoc` comments across the library.
- Updated the `README.md` to use absolute URLs, remove redudancies and explain how to download the package from either GitHub or pub.dev.

# 1.0.0-beta.1 - June 11, 2021

- Initial prerelease on pub.dev

## Previous Versions

Development of `pdftron-flutter` has been ongoing since January 25, 2019. To see previous versions of and more information on the package, please look at our [GitHub repository](https://github.com/PDFTron/pdftron-flutter).
