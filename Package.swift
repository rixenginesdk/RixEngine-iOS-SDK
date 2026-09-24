// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "RixEngineAds",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "RixEngineAds",
            targets: ["RixEngineAds"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "RixEngineAds",
            path: "Sources/AlxAds.xcframework"
        )
    ],
    swiftLanguageModes: [.v5]
)
