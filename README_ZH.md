# RixEngine Mobile Ads SDK for iOS

中文 | [English](README.md)

[![CocoaPods](https://img.shields.io/cocoapods/v/RixEngineAds?label=CocoaPods&color=4C6FFF)](https://cocoapods.org/pods/RixEngineAds)
[![iOS](https://img.shields.io/badge/iOS-15.0%2B-000000?logo=apple&logoColor=white)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.0%2B-F05138?logo=swift&logoColor=white)](https://swift.org)
[![SPM](https://img.shields.io/badge/SPM-Compatible-4C6FFF)](Package.swift)
[![License](https://img.shields.io/badge/License-MIT-4C6FFF)](LICENSE)

> **v2.3.0 稳定版** · 更稳定、更快速、更全面的变现引擎

**欢迎使用 RixEngine Mobile Ads SDK for iOS** —— 助您高效变现移动应用。SDK 严格遵循**最小外部依赖原则**：核心 SDK 通过 CocoaPods 和 Swift Package Manager (SPM) 分发，零引入任何第三方依赖；各平台广告聚合适配器（Mediation Adapters）以源码形式开放于 [`Sources/custom_adapter/`](Sources/custom_adapter)，由开发者按需引入，完全掌控第三方广告平台版本。

---

## ✨ 版本亮点

v2.3.0 以「稳定」为底座、以「速度」为抓手、以「收益」为目标，带来一次全面升级。

### 🛡️ 更稳定

- **线上验证底座**：以多款应用与游戏产品长期线上验证的稳定版本为基础，安全可靠。
- **修复遗留 Bug**：多轮内部迭代修复已知线上崩溃与广告展示异常问题，解决老版本遗留 Bug，提高稳定性。
- **多设备兼容**：适配最新版本 **iOS 27** 系统及多种设备形态（含 iPhone、iPad、iPhone Duo 折叠屏），提升兼容性。

### ⚡ 更快速

- **冷/热启动双缓存**：内置冷 / 热启动双缓存，热启动场景预加载提速，冷启动场景广告加载更快。
- **弱网环境优化**：针对弱网环境专项优化请求链路，显著提升弱网地区的请求成功率。
- **老旧设备优化**：对老旧设备系统进行加载与展示双端优化，避免内存不足风险，做好安全性防范。

### 🚀 更全面

- **Bidding 竞价事件回传**：新增成功 / 失败 / 展示回传 API，竞价链路更加透明、多样且可控。
- **App StoreKit 内联安装**：支持 App StoreKit 内联安装功能，减少转化路径，提高 eCPM 与转化率。
- **广告样式更丰富**：全面覆盖插屏、激励视频、横幅广告、原生广告、开屏广告。
- **白名单测试设备**：加入白名单测试设备功能，可针对单独设备进行精准测试，联调更高效便捷。
- **三方聚合平台升级**：第三方适配器针对 AdMob、GAM、MAX、Unity Ads、TopOn 等主流聚合平台新版本进行适配支持与升级。

---

## 🎯 广告样式

| 广告样式 | 适用场景 |
| :--- | :--- |
| **开屏广告 (Splash)** | 应用启动首屏曝光，抢占第一眼注意力 |
| **插屏广告 (Interstitial)** | 页面切换、关卡结束等自然停顿点 |
| **激励视频 (Rewarded Video)** | 观看视频换取奖励，兼顾体验与收益 |
| **横幅广告 (Banner)** | 常驻页面顶部或底部，持续曝光 |
| **原生广告 (Native)** | 自定义样式，自然融入信息流 |

---

## 🚀 集成指南

### 环境要求

| 项目 | 要求 |
| :--- | :--- |
| **Xcode** | 16.0 及以上 |
| **iOS** | 15.0 及以上 |
| **Swift** | 5.0 及以上 |
| **CocoaPods** | 1.16 及以上（若使用 CocoaPods） |

### 1. CocoaPods 集成（推荐核心 SDK）

> **关于 CocoaPods 官方源（Trunk）可用性说明**：
> - **当前版本（`v2.3.0`）**：支持直接通过 CocoaPods 官方中心源拉取（下方方式 A：`pod 'RixEngineAds', '~> 2.3.0'`）。
> - **后续长期方案（2026 年 12 月 2 日后）**：鉴于 [CocoaPods 官方将于 2026 年 12 月 2 日将 Trunk 永久设为只读](https://blog.cocoapods.org/CocoaPods-Specs-Repo/)，开发者也可在 `Podfile` 中通过 **Git 仓库 + Tag 方式**（下方方式 B）集成，或直接使用 **Swift Package Manager (SPM)** 集成，均不受官方 Trunk 状态影响。

**方式 A：通过 CocoaPods 官方源集成**

```ruby
source 'https://cdn.cocoapods.org/'

platform :ios, '15.0'
use_frameworks!

target 'YourApp' do
  pod 'RixEngineAds', '~> 2.3.0'
end
```

**方式 B：通过 Git 仓库与 Tag 直接集成（永久有效，不依赖官方 Trunk）**

```ruby
platform :ios, '15.0'
use_frameworks!

target 'YourApp' do
  pod 'RixEngineAds', :git => 'https://github.com/rixenginesdk/RixEngine-iOS-SDK.git', :tag => '2.3.0'
end
```

执行安装：

```shell
pod install --repo-update
```

### 2. Swift Package Manager (SPM) 集成

要求 Xcode 16.0 及以上。在 Xcode 菜单中选择 **File → Add Package Dependencies…**，输入仓库地址：

```text
https://github.com/rixenginesdk/RixEngine-iOS-SDK.git
```

勾选 Product：
- `RixEngineAds`：SDK 核心二进制库（无任何第三方外部依赖）。

### 3. 手动集成

1. 将 `Sources/AlxAds.xcframework` 拖入项目工程中。
2. 在 Target 设置的 **General → Frameworks, Libraries, and Embedded Content** 中，将 `AlxAds.xcframework` 设置为 **Embed & Sign**。

---

## 🔌 聚合平台适配（Mediation Adapters）

为谨遵最小外部依赖原则，各聚合平台的适配器均已从 Podspec 与 SPM 中解耦，以开源源码形式存放于 [`Sources/custom_adapter/`](Sources/custom_adapter)，均提供 **Swift** 与 **Objective-C** 双语言版本：

| 聚合平台 | Swift 适配器源码路径 | Objective-C 适配器源码路径 |
| :--- | :--- | :--- |
| **Google AdMob / GAM** | `Sources/custom_adapter/AdmobAdapter/Swift/` | `Sources/custom_adapter/AdmobAdapter/Objc/` |
| **AppLovin MAX** | `Sources/custom_adapter/MaxAdapter/Swift/` | `Sources/custom_adapter/MaxAdapter/Objc/` |
| **TopOn (AnyThink)** | `Sources/custom_adapter/TopOnAdapter/Swift/6.5.x/` | `Sources/custom_adapter/TopOnAdapter/Objc/6.5.x/` |
| **Unity LevelPlay** | `Sources/custom_adapter/UnityLevelPlayAdapter/Swift/` | `Sources/custom_adapter/UnityLevelPlayAdapter/Objc/` |

### 使用步骤

1. 在宿主工程中正常引入对应聚合平台的 SDK（如通过 Pod 引入 `Google-Mobile-Ads-SDK`、`AppLovinSDK`、`TPNiOS` 或 `IronSourceSDK`）。
2. 将对应聚合平台、所需语言（Swift 或 ObjC）的适配器源码文件夹直接拖入宿主 Xcode 工程中参与编译。
3. 在聚合后台或代码中配置自定义事件类名（Custom Event Class Name）即可。

> **注意**：同一聚合平台的 Swift 和 Objective-C 适配器导出的运行时类名完全一致，切勿在同一个 Target 中同时引入双语言版本。

---

## ⚡ 导入与初始化 SDK

Pod / SPM 包名为 `RixEngineAds`，核心 Framework 的模块名为 `AlxAds`。

### Swift

```swift
import AlxAds

// 初始化 SDK
AlxSdk.initializeSDK(token: "YOUR_TOKEN", sid: "YOUR_SID", appId: "YOUR_APP_ID")
```

### Objective-C

```objc
#import <AlxAds/AlxAds-Swift.h>

// 初始化 SDK
[AlxSdk initializeSDKWithToken:@"YOUR_TOKEN" sid:@"YOUR_SID" appId:@"YOUR_APP_ID"];
```

---

## 📱 统一示例工程入口（Unified Workspace）

根据统一多工程管理模式，所有示例工程均已归整到统一入口：**[`Examples/RixEngineDemos.xcworkspace`](Examples/RixEngineDemos.xcworkspace)**。

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

### 运行与测试步骤

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

## 🛠️ 常见问题

### 编译报错 `Multiple commands produce AlxAds.framework`
工程中既手动嵌入了 `AlxAds.xcframework`，又通过 CocoaPods/SPM 集成了一份。请确保仅保留一种集成方式。

### Git 克隆报错 `Error in the HTTP2 framing layer`
为本次安装强制使用 HTTP/1.1：
```shell
pod cache clean RixEngineAds --all
GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0=http.version GIT_CONFIG_VALUE_0=HTTP/1.1 pod install --repo-update
```

---

## 💬 技术支持

如有任何集成与使用疑问，请联系 [rix-sdk@rixengine.com](mailto:rix-sdk@rixengine.com)。

---

## 📄 开源协议

本项目基于 [MIT License](LICENSE) 开源。

如果 RixEngine SDK 对您有帮助，欢迎 Star ⭐ 支持我们。
