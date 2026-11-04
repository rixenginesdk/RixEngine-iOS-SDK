# RixEngine Mobile Ads SDK for iOS

[English](#english) | [简体中文](#简体中文)

---

## English

RixEngine Mobile Ads SDK helps you monetize mobile applications efficiently while strictly following the **minimal external dependency principle**. The core SDK is distributed with zero third-party dependencies via CocoaPods and Swift Package Manager (SPM). Mediation adapters are decoupled as open-source code in `Sources/custom_adapter/`, allowing developers to integrate only what they need with full control over third-party ad network versions.

### Requirements

- Xcode 16.0 or later
- iOS 15.0 or later
- Swift 5.0 or later
- CocoaPods 1.16 or later (if using CocoaPods)

### Supported Ad Formats

- Banner
- Interstitial
- Rewarded Video
- Native
- Splash

---

### Integration Guide

#### 1. CocoaPods (Recommended for Core SDK)

In your `Podfile`, specify:

```ruby
source 'https://cdn.cocoapods.org/'

platform :ios, '15.0'
use_frameworks!

target 'YourApp' do
  pod 'RixEngineAds', '~> 2.2.0'
end
```

Then run:

```shell
pod install --repo-update
```

#### 2. Swift Package Manager (SPM)

Swift Package Manager requires Xcode 16.0 or later. In Xcode, choose **File → Add Package Dependencies…** and enter the repository URL:

```text
https://github.com/rixenginesdk/RixEngine-iOS-SDK.git
```

Select the package product:
- `RixEngineAds`: Core SDK (zero external dependencies).

#### 3. Manual Integration

If you prefer direct binary integration:
1. Copy `Sources/AlxAds.xcframework` into your project.
2. In your application target settings under **General → Frameworks, Libraries, and Embedded Content**, add `AlxAds.xcframework` and select **Embed & Sign**.

---

### Mediation Adapters Integration

To adhere to the **minimal external dependency principle**, mediation adapters are decoupled from the SDK package distribution. The adapter source code is provided in `Sources/custom_adapter/` in both **Swift** and **Objective-C**:

| Mediation Platform | Swift Adapter Directory | Objective-C Adapter Directory |
| :--- | :--- | :--- |
| **Google AdMob** | `Sources/custom_adapter/AdmobAdapter/Swift/` | `Sources/custom_adapter/AdmobAdapter/Objc/` |
| **AppLovin MAX** | `Sources/custom_adapter/MaxAdapter/Swift/` | `Sources/custom_adapter/MaxAdapter/Objc/` |
| **TopOn (AnyThink)** | `Sources/custom_adapter/TopOnAdapter/Swift/6.5.x/` | `Sources/custom_adapter/TopOnAdapter/Objc/6.5.x/` |
| **Unity LevelPlay** | `Sources/custom_adapter/UnityLevelPlayAdapter/Swift/` | `Sources/custom_adapter/UnityLevelPlayAdapter/Objc/` |

#### How to Use Adapters:
1. Add the corresponding mediation platform SDK to your project via CocoaPods or SPM (e.g., `Google-Mobile-Ads-SDK`, `AppLovinSDK`, `TPNiOS`, or `IronSourceSDK`).
2. Drag and drop the adapter directory corresponding to your preferred language (Swift or Objective-C) into your Xcode project.
3. Configure your mediation platform waterfall or custom event mapping using the adapter class names.

> **Note**: For any given mediation network, do not include both the Swift and Objective-C adapter implementations in the same target, as they register identical runtime class names.

---

### Importing and Initializing the SDK

The pod / SPM package name is `RixEngineAds`, while the module name is `AlxAds`.

#### Swift:
```swift
import AlxAds

// Initialize the SDK
AlxSdk.initializeSDK(token: "YOUR_TOKEN", sid: "YOUR_SID", appId: "YOUR_APP_ID")
```

#### Objective-C:
```objc
#import <AlxAds/AlxAds-Swift.h>

// Initialize the SDK
[AlxSdk initializeSDKWithToken:@"YOUR_TOKEN" sid:@"YOUR_SID" appId:@"YOUR_APP_ID"];
```

---

### Unified Demo Workspace

All sample projects are consolidated into a single unified entry workspace: **`Examples/RixEngineDemos.xcworkspace`**, following the multi-project workspace pattern.

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

#### Running the Demos:
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

### Troubleshooting

#### Multiple commands produce `AlxAds.framework`
This indicates the project has both manually embedded `AlxAds.xcframework` and integrated it via CocoaPods/SPM. Ensure only one integration method is used.

#### Git clone fails with `Error in the HTTP2 framing layer`
Force HTTP/1.1 for CocoaPods installation:
```shell
pod cache clean RixEngineAds --all
GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=http.version GIT_CONFIG_VALUE_0=HTTP/1.1 pod install --repo-update
```

### Support

For technical support or inquiries, please contact [rix-sdk@rixengine.com](mailto:rix-sdk@rixengine.com).

---

## 简体中文

RixEngine Mobile Ads SDK 帮助开发者高效变现移动应用。SDK 严格遵循**最小外部依赖原则**：核心 SDK 通过 CocoaPods 和 Swift Package Manager (SPM) 分发，零引入任何第三方依赖；各平台广告聚合适配器（Mediation Adapters）以源码形式开放于 `Sources/custom_adapter/`，由开发者按需引入，完全掌控第三方广告平台版本。

### 环境要求

- Xcode 16.0 或更高版本
- iOS 15.0 或更高版本
- Swift 5.0 或更高版本
- CocoaPods 1.16 或更高版本（若使用 CocoaPods）

### 支持的广告类型

- 横幅广告 (Banner)
- 插屏广告 (Interstitial)
- 激励视频广告 (Rewarded Video)
- 原生广告 (Native)
- 开屏广告 (Splash)

---

### 集成指南

#### 1. CocoaPods 集成（推荐核心 SDK）

在工程的 `Podfile` 中添加：

```ruby
source 'https://cdn.cocoapods.org/'

platform :ios, '15.0'
use_frameworks!

target 'YourApp' do
  pod 'RixEngineAds', '~> 2.2.0'
end
```

执行安装：

```shell
pod install --repo-update
```

#### 2. Swift Package Manager (SPM) 集成

要求 Xcode 16.0 及以上。在 Xcode 菜单中选择 **File → Add Package Dependencies…**，输入仓库地址：

```text
https://github.com/rixenginesdk/RixEngine-iOS-SDK.git
```

勾选 Product：
- `RixEngineAds`：SDK 核心二进制库（无任何第三方外部依赖）。

#### 3. 手动集成

1. 将 `Sources/AlxAds.xcframework` 拖入项目工程中。
2. 在 Target 设置的 **General → Frameworks, Libraries, and Embedded Content** 中，将 `AlxAds.xcframework` 设置为 **Embed & Sign**。

---

### 广告聚合适配器（Mediation Adapters）使用指引

为谨遵最小外部依赖原则，各聚合平台的适配器均已从 Podspec 与 SPM 中解耦，以开源源码形式存放于 `Sources/custom_adapter/`，均提供 **Swift** 与 **Objective-C** 双语言版本：

| 聚合平台 | Swift 适配器源码路径 | Objective-C 适配器源码路径 |
| :--- | :--- | :--- |
| **Google AdMob** | `Sources/custom_adapter/AdmobAdapter/Swift/` | `Sources/custom_adapter/AdmobAdapter/Objc/` |
| **AppLovin MAX** | `Sources/custom_adapter/MaxAdapter/Swift/` | `Sources/custom_adapter/MaxAdapter/Objc/` |
| **TopOn (AnyThink)** | `Sources/custom_adapter/TopOnAdapter/Swift/6.5.x/` | `Sources/custom_adapter/TopOnAdapter/Objc/6.5.x/` |
| **Unity LevelPlay** | `Sources/custom_adapter/UnityLevelPlayAdapter/Swift/` | `Sources/custom_adapter/UnityLevelPlayAdapter/Objc/` |

#### 使用步骤：
1. 在宿主工程中正常引入对应聚合平台的 SDK（如通过 Pod 引入 `Google-Mobile-Ads-SDK`、`AppLovinSDK`、`TPNiOS` 或 `IronSourceSDK`）。
2. 将对应聚合平台、所需语言（Swift 或 ObjC）的适配器源码文件夹直接拖入宿主 Xcode 工程中参与编译。
3. 在聚合后台或代码中配置自定义事件类名（Custom Event Class Name）即可。

> **注意**：同一聚合平台的 Swift 和 Objective-C 适配器导出的运行时类名完全一致，切勿在同一个 Target 中同时引入双语言版本。

---

### 导入与初始化 SDK

Pod / SPM 包名为 `RixEngineAds`，核心 Framework 的模块名为 `AlxAds`。

#### Swift：
```swift
import AlxAds

// 初始化 SDK
AlxSdk.initializeSDK(token: "YOUR_TOKEN", sid: "YOUR_SID", appId: "YOUR_APP_ID")
```

#### Objective-C：
```objc
#import <AlxAds/AlxAds-Swift.h>

// 初始化 SDK
[AlxSdk initializeSDKWithToken:@"YOUR_TOKEN" sid:@"YOUR_SID" appId:@"YOUR_APP_ID"];
```

---

### 统一示例工程入口（Unified Workspace）

根据统一多工程管理模式，所有示例工程均已归整到统一入口：**`Examples/RixEngineDemos.xcworkspace`**。

```text
Examples/
├── Podfile                        # 统一管理所有 Demo 的 CocoaPods 依赖
├── RixEngineDemos.xcworkspace     # 统一启动工程入口
├── ObjcDemo/
│   ├── RixSDKPodDemo/             # Objective-C CocoaPods 示例（含全聚合平台适配器测试）
│   └── RixSDKSPMDemo/             # Objective-C SPM 示例（验证纯 SPM 集成）
└── SwiftDemo/
    ├── RixSDKPodDemo/             # Swift CocoaPods 示例（含全聚合平台适配器测试）
    └── RixSDKSPMDemo/             # Swift SPM 示例（验证纯 SPM 集成）
```

#### 运行与测试步骤：
1. 进入 `Examples` 目录安装 Pod 依赖：
   ```shell
   cd Examples
   pod install
   ```
2. 双击打开统一工作区：
   ```shell
   open RixEngineDemos.xcworkspace
   ```
3. 在 Xcode 顶部的 Scheme 选择器中自由切换调试目标：
   - **`RixEngineObjcDemo`**：Objective-C + CocoaPods（适配器测试）
   - **`AlxAdsDemo`**：Swift + CocoaPods（适配器测试）
   - **`RixEngineSPMDemo`**：Objective-C + SPM（本地 Package 集成测试）
   - **`RixAdsSDKDemo`**：Swift + SPM（本地 Package 集成测试）

---

### 常见问题

#### 编译报错 `Multiple commands produce AlxAds.framework`
工程中既手动嵌入了 `AlxAds.xcframework`，又通过 CocoaPods/SPM 集成了一份。请确保仅保留一种集成方式。

#### Git 克隆报错 `Error in the HTTP2 framing layer`
为本次安装强制使用 HTTP/1.1：
```shell
pod cache clean RixEngineAds --all
GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=http.version GIT_CONFIG_VALUE_0=HTTP/1.1 pod install --repo-update
```

### 技术支持

如有任何集成与使用疑问，请联系 [rix-sdk@rixengine.com](mailto:rix-sdk@rixengine.com)。
