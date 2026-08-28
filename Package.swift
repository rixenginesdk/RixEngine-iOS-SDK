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
        ),
        .library(
            name: "RixAdsAdmobAdapter",
            targets: ["RixAdsAdmobAdapter"]
        ),
        .library(
            name: "RixAdsAdmobAdapterOC",
            targets: ["RixAdsAdmobAdapterOC"]
        ),
        .library(
            name: "RixAdsMaxAdapter",
            targets: ["RixAdsMaxAdapter"]
        ),
        .library(
            name: "RixAdsMaxAdapterOC",
            targets: ["RixAdsMaxAdapterOC"]
        ),
        .library(
            name: "RixAdsUnityLevelPlayAdapter",
            targets: ["RixAdsUnityLevelPlayAdapter"]
        ),
        .library(
            name: "RixAdsUnityLevelPlayAdapterOC",
            targets: ["RixAdsUnityLevelPlayAdapterOC"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git",
            exact: "12.6.0"
        ),
        .package(
            url: "https://github.com/AppLovin/AppLovin-MAX-Swift-Package.git",
            exact: "13.3.0"
        ),
        .package(
            url: "https://github.com/ironsource-mobile/LevelPlay-Swift-Package.git",
            exact: "9.3.0"
        )
    ],
    targets: [
        .binaryTarget(
            name: "RixEngineAds",
            path: "Sources/AlxAds.xcframework"
        ),
        .target(
            name: "RixAdsAdmobAdapter",
            dependencies: [
                "RixEngineAds",
                .product(
                    name: "GoogleMobileAds",
                    package: "swift-package-manager-google-mobile-ads"
                )
            ],
            path: "Sources/custom_adapter/AdmobAdapter/Swift"
        ),
        .target(
            name: "RixAdsAdmobAdapterOC",
            dependencies: [
                "RixEngineAds",
                .product(
                    name: "GoogleMobileAds",
                    package: "swift-package-manager-google-mobile-ads"
                )
            ],
            path: "Sources/custom_adapter/AdmobAdapter/Objc",
            publicHeadersPath: "."
        ),
        .target(
            name: "RixAdsMaxAdapter",
            dependencies: [
                "RixEngineAds",
                .product(
                    name: "AppLovinSDK",
                    package: "AppLovin-MAX-Swift-Package"
                )
            ],
            path: "Sources/custom_adapter/MaxAdapter/Swift"
        ),
        .target(
            name: "RixAdsMaxAdapterOC",
            dependencies: [
                "RixEngineAds",
                .product(
                    name: "AppLovinSDK",
                    package: "AppLovin-MAX-Swift-Package"
                )
            ],
            path: "Sources/custom_adapter/MaxAdapter/Objc",
            publicHeadersPath: "."
        ),
        .target(
            name: "RixAdsUnityLevelPlayAdapter",
            dependencies: [
                "RixEngineAds",
                .product(
                    name: "UnityMediationSDK",
                    package: "LevelPlay-Swift-Package"
                )
            ],
            path: "Sources/custom_adapter/UnityLevelPlayAdapter/Swift"
        ),
        .target(
            name: "RixAdsUnityLevelPlayAdapterOC",
            dependencies: [
                "RixEngineAds",
                .product(
                    name: "UnityMediationSDK",
                    package: "LevelPlay-Swift-Package"
                )
            ],
            path: "Sources/custom_adapter/UnityLevelPlayAdapter/Objc",
            publicHeadersPath: "."
        )
    ],
    swiftLanguageModes: [.v5]
)
