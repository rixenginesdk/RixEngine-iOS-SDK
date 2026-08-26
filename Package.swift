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
            targets: ["AlxAds"]
        ),
        .library(
            name: "RixEngineAdsAdmobAdapter",
            targets: ["RixEngineAdsAdmobAdapter"]
        ),
        .library(
            name: "RixEngineAdsAdmobAdapterOC",
            targets: ["RixEngineAdsAdmobAdapterOC"]
        ),
        .library(
            name: "RixEngineAdsMaxAdapter",
            targets: ["RixEngineAdsMaxAdapter"]
        ),
        .library(
            name: "RixEngineAdsMaxAdapterOC",
            targets: ["RixEngineAdsMaxAdapterOC"]
        ),
        .library(
            name: "RixEngineAdsUnityLevelPlayAdapter",
            targets: ["RixEngineAdsUnityLevelPlayAdapter"]
        ),
        .library(
            name: "RixEngineAdsUnityLevelPlayAdapterOC",
            targets: ["RixEngineAdsUnityLevelPlayAdapterOC"]
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
            name: "AlxAds",
            path: "AlxAds.xcframework"
        ),
        .target(
            name: "RixEngineAdsAdmobAdapter",
            dependencies: [
                "AlxAds",
                .product(
                    name: "GoogleMobileAds",
                    package: "swift-package-manager-google-mobile-ads"
                )
            ],
            path: "custom_adapter/AdmobAdapter/Swift"
        ),
        .target(
            name: "RixEngineAdsAdmobAdapterOC",
            dependencies: [
                "AlxAds",
                .product(
                    name: "GoogleMobileAds",
                    package: "swift-package-manager-google-mobile-ads"
                )
            ],
            path: "custom_adapter/AdmobAdapter/Objc",
            publicHeadersPath: "."
        ),
        .target(
            name: "RixEngineAdsMaxAdapter",
            dependencies: [
                "AlxAds",
                .product(
                    name: "AppLovinSDK",
                    package: "AppLovin-MAX-Swift-Package"
                )
            ],
            path: "custom_adapter/MaxAdapter/Swift"
        ),
        .target(
            name: "RixEngineAdsMaxAdapterOC",
            dependencies: [
                "AlxAds",
                .product(
                    name: "AppLovinSDK",
                    package: "AppLovin-MAX-Swift-Package"
                )
            ],
            path: "custom_adapter/MaxAdapter/Objc",
            publicHeadersPath: "."
        ),
        .target(
            name: "RixEngineAdsUnityLevelPlayAdapter",
            dependencies: [
                "AlxAds",
                .product(
                    name: "UnityMediationSDK",
                    package: "LevelPlay-Swift-Package"
                )
            ],
            path: "custom_adapter/UnityLevelPlayAdapter/Swift"
        ),
        .target(
            name: "RixEngineAdsUnityLevelPlayAdapterOC",
            dependencies: [
                "AlxAds",
                .product(
                    name: "UnityMediationSDK",
                    package: "LevelPlay-Swift-Package"
                )
            ],
            path: "custom_adapter/UnityLevelPlayAdapter/Objc",
            publicHeadersPath: "."
        )
    ],
    swiftLanguageModes: [.v5]
)
