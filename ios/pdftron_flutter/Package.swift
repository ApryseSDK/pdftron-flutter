// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "pdftron_flutter",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "pdftron-flutter", targets: ["pdftron_flutter"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/ApryseSDK/pdftron-apple-package.git",
            .upToNextMajor(from: "12.2.0")
        )
    ],
    targets: [
        .target(
            name: "pdftron_flutter",
            dependencies: [
                .product(name: "PDFTron", package: "pdftron-apple-package")
            ],
            cSettings: [
                .headerSearchPath("include/pdftron_flutter")
            ]
        )
    ]
)
