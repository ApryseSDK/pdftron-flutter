#!/bin/bash

readonly project_dir="example/"

cd "${project_dir}"

# Install the Flutter package dependencies, which contain Dart and native iOS code.

echo "Installing Flutter packages..."

flutter packages get

# Install the CocoaPods package dependencies.

cd 'ios/'

echo "Installing CocoaPods packages..."

pod install

# Build the iOS workspace.

echo "Building iOS workspace..."

xcodebuild \
    -workspace 'Runner.xcworkspace' \
    -scheme 'Runner' \
    -destination 'generic/platform=iOS Simulator' \
    build
