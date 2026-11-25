# RixEngine Mobile Ads SDK for iOS

English | [中文](README_ZH.md)

[![CocoaPods](https://img.shields.io/cocoapods/v/RixEngineAds?label=CocoaPods&color=4C6FFF)](https://cocoapods.org/pods/RixEngineAds)
[![iOS](https://img.shields.io/badge/iOS-15.0%2B-000000?logo=apple&logoColor=white)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.0%2B-F05138?logo=swift&logoColor=white)](https://swift.org)
[![SPM](https://img.shields.io/badge/SPM-Compatible-4C6FFF)](Package.swift)
[![License](https://img.shields.io/badge/License-MIT-4C6FFF)](LICENSE)

> **v2.3.0 Stable** · A more stable, faster, and more capable monetization engine

**Welcome to the RixEngine Mobile Ads SDK for iOS** — helping you monetize mobile applications efficiently while strictly following the **minimal external dependency principle**.

The core SDK is distributed with zero third-party dependencies via CocoaPods and Swift Package Manager (SPM). Mediation adapters are decoupled as open-source code in [`Sources/custom_adapter/`](Sources/custom_adapter), allowing you to integrate only what you need with full control over third-party ad network versions.

---

## ✨ What's New in v2.3.0

v2.3.0 is a comprehensive upgrade built on stability, driven by speed, and aimed at revenue.

### 🛡️ More Stable

- **Proven in Production**: Built upon a stable release validated over the long term across multiple apps and games — safe and reliable.
- **Legacy Issues Resolved**: Multiple internal iterations fix known production crashes and ad display anomalies, clearing out long-standing bugs.
- **Broad Device & OS Compatibility**: Adapted for the latest **iOS 27** and diverse form factors, including iPhone, iPad, and foldable devices (iPhone Duo).

### ⚡ Faster

- **Cold / Warm Start Caching**: Built-in dual caching for cold and warm starts — faster preloading on warm start, quicker ad loading on cold start.
- **Weak-Network Optimization**: The request pipeline is specifically optimized for weak-network environments, significantly improving request success rates in those regions.
- **Legacy Device Optimization**: Loading and rendering optimizations reduce the risk of out-of-memory issues and add safety safeguards on older devices.

### 🚀 More Capabilities

- **Bidding Event Callbacks**: New win / loss / impression callback APIs make the bidding pipeline more transparent and controllable.
- **App StoreKit Inline Installation**: Integrated StoreKit inline app installation shortens the user conversion path to lift eCPM and conversion rates.
- **Rich Ad Formats**: Full support for Interstitial, Rewarded Video, Banner, Native, and Splash ads.
- **Allowlisted Test Devices**: Target individual devices for streamlined integration and testing.
- **Mediation Adapter Upgrades**: Updated and adapted third-party mediation adapters for the latest versions of AdMob, GAM, AppLovin MAX, Unity Ads, TopOn, and other major platforms.

---

## 🎯 Supported Ad Formats

| Ad Format | Use Case |
| :--- | :--- |
| **Splash** | Full-screen impression at app launch to capture first-glance attention |
| **Interstitial** | Natural transition points such as page switches or level completions |
| **Rewarded Video** | Opt-in video viewing in exchange for in-app rewards, balancing UX and revenue |
| **Banner** | Persistent top or bottom placement for continuous exposure |
| **Native** | Customizable layout that blends naturally into your app's feed |

---

## 🚀 Integration Guide

### Requirements

| Item | Requirement |
| :--- | :--- |
| **Xcode** | 16.0 or later |
| **iOS** | 15.0 or later |
| **Swift** | 5.0 or later |
| **CocoaPods** | 1.16 or later (if using CocoaPods) |

### 1. CocoaPods (Recommended for Core SDK)

> **Important Notice on CocoaPods Trunk Availability**:
> - **Current Availability (`v2.3.0`)**: Standard CocoaPods Trunk installation (`pod 'RixEngineAds', '~> 2.3.0'`) is supported.
> - **Long-Term Usage (Post Dec 2, 2026)**: As the official [CocoaPods Specs Repo (Trunk)](https://blog.cocoapods.org/CocoaPods-Specs-Repo/) is scheduled to become permanently read-only on **December 2, 2026**, you can also integrate `2.3.0` (and all future releases) either by specifying the **Git repository and tag** directly in your `Podfile` (Method B below) or by migrating to **Swift Package Manager (SPM)**.

**Method A: Via CocoaPods Trunk**

```ruby
source 'https://cdn.cocoapods.org/'

platform :ios, '15.0'
use_frameworks!

target 'YourApp' do
  pod 'RixEngineAds', '~> 2.3.0'
end
```

**Method B: Via Git Repository & Tag (Permanent & Trunk-Independent)**

```ruby
platform :ios, '15.0'
use_frameworks!

target 'YourApp' do
  pod 'RixEngineAds', :git => 'https://github.com/rixenginesdk/RixEngine-iOS-SDK.git', :tag => '2.3.0'
end
```

Then run:

```shell
pod install --repo-update
```

### 2. Swift Package Manager (SPM)

Swift Package Manager requires Xcode 16.0 or later. In Xcode, choose **File → Add Package Dependencies…** and enter the repository URL:

```text
https://github.com/rixenginesdk/RixEngine-iOS-SDK.git
```

Select the package product:
- `RixEngineAds`: Core SDK (zero external dependencies).

### 3. Manual Integration

If you prefer direct binary integration:
1. Copy `Sources/AlxAds.xcframework` into your project.
2. In your application target settings under **General → Frameworks, Libraries, and Embedded Content**, add `AlxAds.xcframework` and select **Embed & Sign**.

---

## 🔌 Mediation Adapters Integration

To adhere to the **minimal external dependency principle**, mediation adapters are decoupled from the SDK package distribution. The adapter source code is provided in [`Sources/custom_adapter/`](Sources/custom_adapter) in both **Swift** and **Objective-C**:

| Mediation Platform | Swift Adapter Directory | Objective-C Adapter Directory |
| :--- | :--- | :--- |
| **Google AdMob / GAM** | `Sources/custom_adapter/AdmobAdapter/Swift/` | `Sources/custom_adapter/AdmobAdapter/Objc/` |
| **AppLovin MAX** | `Sources/custom_adapter/MaxAdapter/Swift/` | `Sources/custom_adapter/MaxAdapter/Objc/` |
| **TopOn (AnyThink)** | `Sources/custom_adapter/TopOnAdapter/Swift/6.5.x/` | `Sources/custom_adapter/TopOnAdapter/Objc/6.5.x/` |
| **Unity LevelPlay** | `Sources/custom_adapter/UnityLevelPlayAdapter/Swift/` | `Sources/custom_adapter/UnityLevelPlayAdapter/Objc/` |

### How to Use Adapters

1. Add the corresponding mediation platform SDK to your project via CocoaPods or SPM (e.g., `Google-Mobile-Ads-SDK`, `AppLovinSDK`, `TPNiOS`, or `IronSourceSDK`).
2. Drag and drop the adapter directory corresponding to your preferred language (Swift or Objective-C) into your Xcode project.
3. Configure your mediation platform waterfall or custom event mapping using the adapter class names.

> **Note**: For any given mediation network, do not include both the Swift and Objective-C adapter implementations in the same target, as they register identical runtime class names.

---

## ⚡ Importing and Initializing the SDK

The pod / SPM package name is `RixEngineAds`, while the module name is `AlxAds`.

### Swift

```swift
import AlxAds

// Initialize the SDK
AlxSdk.initializeSDK(token: "YOUR_TOKEN", sid: "YOUR_SID", appId: "YOUR_APP_ID")
```

### Objective-C

```objc
#import <AlxAds/AlxAds-Swift.h>

// Initialize the SDK
[AlxSdk initializeSDKWithToken:@"YOUR_TOKEN" sid:@"YOUR_SID" appId:@"YOUR_APP_ID"];
```

---

## 📱 Unified Demo Workspace

All sample projects are consolidated into a single unified entry workspace: **[`Examples/RixEngineDemos.xcworkspace`](Examples/RixEngineDemos.xcworkspace)**, following the multi-project workspace pattern.

```text
Examples/
├── Podfile                        # CocoaPods configuration managing all demo targets
├── RixEngineDemos.xcworkspace     # Unified entry point for all Demos
├── ObjcDemo/
│   ├── RixSDKPodDemo/             # Objective-C CocoaPods Demo (with full mediation adapters)
│   └── RixSDKSPMDemo/             # Objective-C SPM Demo (pure SDK integration via SPM)
└── SwiftDemo/
    ├── RixSDKPodDemo/             # Swift CocoaPods Demo (with full mediation adapters)
    └── RixSDKSPMDemo/             # Swift SPM Demo (pure SDK integration via SPM)
```

### Running the Demos

1. Navigate to the `Examples` directory and install CocoaPods dependencies:
   ```shell
   cd Examples
   pod install
   ```
2. Open the unified workspace:
   ```shell
   open RixEngineDemos.xcworkspace
   ```
3. Choose the desired scheme in Xcode:
   - **`RixEngineObjcDemo`**: Objective-C demo with CocoaPods and adapter testing.
   - **`AlxAdsDemo`**: Swift demo with CocoaPods and adapter testing.
   - **`RixEngineSPMDemo`**: Objective-C demo with local Swift Package integration.
   - **`RixAdsSDKDemo`**: Swift demo with local Swift Package integration.

---

## 🛠️ Troubleshooting

### Multiple commands produce `AlxAds.framework`
This indicates the project has both manually embedded `AlxAds.xcframework` and integrated it via CocoaPods/SPM. Ensure only one integration method is used.

### Git clone fails with `Error in the HTTP2 framing layer`
Force HTTP/1.1 for CocoaPods installation:
```shell
pod cache clean RixEngineAds --all
GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=http.version GIT_CONFIG_VALUE_0=HTTP/1.1 pod install --repo-update
```

---

## 💬 Support

For technical support or inquiries, please contact [rix-sdk@rixengine.com](mailto:rix-sdk@rixengine.com).

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

If RixEngine SDK helps your app grow, please give us a Star ⭐!
