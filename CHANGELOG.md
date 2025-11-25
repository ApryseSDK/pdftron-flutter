# 1.0.1-51 - October 16, 2025
- Update Android to v11.9.0

# 1.0.1-50 - October 16, 2025
- Update the example project to use the official Apryse iOS podspec links

# 1.0.1-49 - October 15, 2025
- Performance update for the `importAnnotations()` API on iOS

# 1.0.1-48 - September 25, 2025
- Update Android to v11.8.0

# 1.0.1-47 - August 18, 2025
- Update Android to v11.7.0

# 1.0.1-46 - July 8, 2025
- Update Android to v11.6.0

# 1.0.1-45 - Jun 10, 2025
- Update Android to embedding v2

# 1.0.1-44 - May 28, 2025
- Update Android to v11.5.0

# 1.0.1-43 - April 9, 2025
- Update Android to v11.4.0

# 1.0.1-40 - February 19, 2025
- Update Android to v11.3.0

# 1.0.1-39 - January 6, 2025
- Update Android to v11.2.0

# 1.0.1-37 - November 25, 2024
- Update Android to v11.1.0

# 1.0.1-36 - October 28, 2024
- Update Android to v11.0.0
- Update Android targetSDK to 34

# 1.0.1-33 - September 4, 2024
- Update Android to v10.12.0

# 1.0.1-32 - July 24, 2024
- Update Android to v10.11.0

# 1.0.1-31 - May 27, 2024
- Fix bug in `startAnnotationToolbarItemPressedListener`

# 1.0.1-30 - May 1, 2024
- Update Android to v10.9.0

# 1.0.1-29 - March 20, 2024
- Update Android to v10.8.0

# 1.0.1-27 - February 7, 2024
- Update Android to v10.7.0

# 1.0.1-24 - December 13, 2023
- expose Pan tool

# 1.0.1-23 - December 6, 2023
- Update Android to v10.6.0

# 1.0.1-22 - October 25, 2023
- Update Android to v10.5.0

# 1.0.1-21 - September 21, 2023
- Fix bug in mergeAnnotations()

# 1.0.1-20 - September 13, 2023
- Update Android to v10.4.0

# 1.0.1-18 - August 23, 2023
- mergeAnnotations()

# 1.0.1-17 - August 8, 2023
- added eraser to PTToolKey (iOS)
  
# 1.0.1-16 - August 2, 2023
- Update Android to v10.3.0

# 1.0.1-15 - July 4, 2023
- Fix bug in Android `saveDocument`

# 1.0.1-14 - June 21, 2023
- Update Android to v10.2.0

# 1.0.1-13 - May 10, 2023
- Update Android to v10.1.0

# 1.0.1-9 - Mar 27, 2023
- Update Android to v10.0.0

# 1.0.1-8 - Feb 17, 2023
- Update Android to v9.5.0

# 1.0.1-4 - Dec 19, 2022
- Update Android to v9.4.2

# 1.0.1-3 - Dec 16, 2022
- setFitMode()
- setLayoutMode()

# 1.0.1-2 - Dec 2, 2022
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

- Updated the Android plugin and widget ([#128](https://github.com/ApryseSDK/pdftron-flutter/issues/128)):
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
