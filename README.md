# RixEngine Mobile Ads SDK for iOS

[English](#english) | [简体中文](#简体中文)

---

## English

RixEngine Mobile Ads SDK helps you integrate multiple mediation platforms and scale demand safely while keeping the integration lightweight.

### Requirements

- Xcode 15.4 or later
- iOS 13.0 or later
- Swift 5.0 or later
- CocoaPods 1.16 or later is recommended

### Supported ad formats

- Banner
- Interstitial
- Rewarded video
- Native

See the [demo project](./AlxAdsDemo.xcodeproj) for implementation examples.

### CocoaPods integration

CocoaPods is the recommended integration method. Add the CocoaPods source and deployment target to your `Podfile`:

```ruby
source 'https://cdn.cocoapods.org/'

platform :ios, '13.0'
use_frameworks!
```

#### Core SDK only

Installing the root Pod includes only the Core SDK:

```ruby
target 'YourApp' do
  pod 'RixEngineAds', '2.0.2'
end
```


#### Swift adapters

Add only the mediation adapters required by your application:

```ruby
target 'YourApp' do
  pod 'RixEngineAds/AdmobAdapter', '2.0.2'
  pod 'RixEngineAds/MaxAdapter', '2.0.2'
  pod 'RixEngineAds/TopOnAdapter', '2.0.2'
  pod 'RixEngineAds/UnityLevelPlayAdapter', '2.0.2'
end
```

#### Objective-C adapters

Objective-C implementations are available as separate subspecs:

```ruby
target 'YourApp' do
  pod 'RixEngineAds/AdmobAdapterOC', '2.0.2'
  pod 'RixEngineAds/MaxAdapterOC', '2.0.2'
  pod 'RixEngineAds/TopOnAdapterOC', '2.0.2'
  pod 'RixEngineAds/UnityLevelPlayAdapterOC', '2.0.2'
end
```

Each adapter automatically installs the Core SDK and its required third-party SDK. You do not need to declare those dependencies again unless you need to pin a compatible version explicitly. `TPNDebugUISDK` is optional and can be added separately for TopOn debugging.

> Swift and Objective-C implementations for the same mediation network export identical runtime class names. Never install both variants of the same adapter in one target. For example, do not install both `AdmobAdapter` and `AdmobAdapterOC`.

Multiple different mediation networks can be installed together. For example:

```ruby
target 'YourApp' do
  pod 'RixEngineAds/AdmobAdapter', '2.0.2'
  pod 'RixEngineAds/MaxAdapter', '2.0.2'
end
```

Install dependencies and open the generated workspace:

```shell
pod install --repo-update
open YourApp.xcworkspace
```

#### Git integration

If you need to integrate directly from GitHub instead of CocoaPods Trunk:

```ruby
pod 'RixEngineAds/AdmobAdapter',
    :git => 'https://github.com/rixenginesdk/RixEngine-iOS-SDK.git',
    :tag => '2.0.2'
```

### Importing the SDK

The Pod name is `RixEngineAds`, while the Core framework module is named `AlxAds`.

Swift:

```swift
import AlxAds
```

Objective-C:

```objc
#import <AlxAds/AlxAds-Swift.h>
```

Mediation adapters are normally discovered by the mediation SDK through their runtime class names and do not need to be imported directly.

### Manual integration

Use manual integration only when CocoaPods cannot be used:

1. Copy `AlxAds.xcframework` into your project's Frameworks directory.
2. In the application target, open **General → Frameworks, Libraries, and Embedded Content**.
3. Add `AlxAds.xcframework` and select **Embed & Sign**.

> Do not manually embed `AlxAds.xcframework` when `RixEngineAds` is already installed through CocoaPods. Choose exactly one integration method.

### Troubleshooting

#### `pod search` raises `undefined method '=~' for an instance of Array`

This is a CocoaPods local search-index issue and does not mean the Pod publication failed. Use simple name search:

```shell
pod search RixEngineAds --simple
```

You can also verify the published Pod on the [RixEngineAds CocoaPods page](https://cocoapods.org/pods/RixEngineAds).

#### Git clone fails with `Error in the HTTP2 framing layer`

This is a GitHub connection or HTTP/2 transport issue rather than a Podspec error. Clear the failed cache and force HTTP/1.1 for one installation:

```shell
pod cache clean RixEngineAds --all

GIT_CONFIG_COUNT=1 \
GIT_CONFIG_KEY_0=http.version \
GIT_CONFIG_VALUE_0=HTTP/1.1 \
pod install --repo-update
```

To test GitHub connectivity:

```shell
git ls-remote \
  https://github.com/rixenginesdk/RixEngine-iOS-SDK.git \
  refs/tags/2.0.2
```

If this command also fails, check your proxy, VPN, firewall, or network connection.

#### Multiple commands produce `AlxAds.framework`

The project is embedding `AlxAds.framework` manually while CocoaPods is embedding it again. In the application target:

1. Remove the manually added `AlxAds.framework` or `AlxAds.xcframework` from **General → Frameworks, Libraries, and Embedded Content**.
2. Remove the manual `AlxAds.framework` entry from **Build Phases → Link Binary With Libraries**.
3. Remove it from the manual **Embed Frameworks** phase.
4. Keep the CocoaPods-managed **[CP] Embed Pods Frameworks** phase.
5. Remove the stale framework reference from the Project Navigator, clean the build folder, and rebuild the `.xcworkspace`.

### Support

For integration questions, contact [rix-sdk@rixengine.com](mailto:rix-sdk@rixengine.com).

---

## 简体中文

RixEngine Mobile Ads SDK 可以帮助开发者快速接入多个广告聚合平台，在保持 SDK 轻量的同时安全扩展广告需求并提升变现能力。

### 环境要求

- Xcode 15.4 或更高版本
- iOS 13.0 或更高版本
- Swift 5.0 或更高版本
- 推荐使用 CocoaPods 1.16 或更高版本

### 支持的广告类型

- 横幅广告
- 插屏广告
- 激励视频广告
- 原生广告

具体实现可以参考 [Demo 工程](./AlxAdsDemo.xcodeproj)。

### CocoaPods 集成

推荐使用 CocoaPods 集成。在 `Podfile` 中配置 CocoaPods 源及最低系统版本：

```ruby
source 'https://cdn.cocoapods.org/'

platform :ios, '13.0'
use_frameworks!
```

#### 仅集成核心 SDK

直接安装根 Pod 时，默认只会集成 Core：

```ruby
target 'YourApp' do
  pod 'RixEngineAds', '2.0.2'
end
```


#### Swift 适配器

根据应用实际使用的聚合平台按需添加：

```ruby
target 'YourApp' do
  pod 'RixEngineAds/AdmobAdapter', '2.0.2'
  pod 'RixEngineAds/MaxAdapter', '2.0.2'
  pod 'RixEngineAds/TopOnAdapter', '2.0.2'
  pod 'RixEngineAds/UnityLevelPlayAdapter', '2.0.2'
end
```

#### Objective-C 适配器

Objective-C 实现通过独立 subspec 提供：

```ruby
target 'YourApp' do
  pod 'RixEngineAds/AdmobAdapterOC', '2.0.2'
  pod 'RixEngineAds/MaxAdapterOC', '2.0.2'
  pod 'RixEngineAds/TopOnAdapterOC', '2.0.2'
  pod 'RixEngineAds/UnityLevelPlayAdapterOC', '2.0.2'
end
```

每个适配器都会自动安装 Core 和对应的第三方 SDK。除非需要显式锁定兼容版本，否则不需要在 `Podfile` 中重复声明这些依赖。`TPNDebugUISDK` 是可选的 TopOn 调试工具，可以单独添加。

> 同一聚合平台的 Swift 和 Objective-C 实现会导出相同的运行时类名，因此不能在同一个 Target 中同时安装。例如，不能同时安装 `AdmobAdapter` 和 `AdmobAdapterOC`。

不同聚合平台的适配器可以组合安装。例如，只接入 AdMob 和 MAX：

```ruby
target 'YourApp' do
  pod 'RixEngineAds/AdmobAdapter', '2.0.2'
  pod 'RixEngineAds/MaxAdapter', '2.0.2'
end
```

安装依赖并打开生成的 Workspace：

```shell
pod install --repo-update
open YourApp.xcworkspace
```

#### Git 集成

如果需要绕过 CocoaPods Trunk，直接从 GitHub 标签集成：

```ruby
pod 'RixEngineAds/AdmobAdapter',
    :git => 'https://github.com/rixenginesdk/RixEngine-iOS-SDK.git',
    :tag => '2.0.2'
```

### 导入 SDK

Pod 名称是 `RixEngineAds`，核心 Framework 的模块名是 `AlxAds`。

Swift：

```swift
import AlxAds
```

Objective-C：

```objc
#import <AlxAds/AlxAds-Swift.h>
```

聚合平台通常会通过运行时类名自动发现适配器，因此一般不需要在业务代码中直接导入适配器模块。

### 手动集成

仅在无法使用 CocoaPods 时选择手动集成：

1. 将 `AlxAds.xcframework` 复制到工程的 Frameworks 目录。
2. 打开应用 Target 的 **General → Frameworks, Libraries, and Embedded Content**。
3. 添加 `AlxAds.xcframework`，并选择 **Embed & Sign**。

> 如果已经通过 CocoaPods 安装 `RixEngineAds`，不要再手动嵌入 `AlxAds.xcframework`。两种集成方式只能选择一种。

### 常见问题

#### `pod search` 报错 `undefined method '=~' for an instance of Array`

这是 CocoaPods 本地搜索索引异常，不代表 Pod 发布失败。可以使用简单名称搜索：

```shell
pod search RixEngineAds --simple
```

也可以前往 [RixEngineAds CocoaPods 页面](https://cocoapods.org/pods/RixEngineAds)确认发布状态。

#### Git 克隆报错 `Error in the HTTP2 framing layer`

这是 GitHub 网络连接或 HTTP/2 传输问题，不是 Podspec 配置错误。清理失败缓存，并让本次安装强制使用 HTTP/1.1：

```shell
pod cache clean RixEngineAds --all

GIT_CONFIG_COUNT=1 \
GIT_CONFIG_KEY_0=http.version \
GIT_CONFIG_VALUE_0=HTTP/1.1 \
pod install --repo-update
```

可以先检查 GitHub 连接：

```shell
git ls-remote \
  https://github.com/rixenginesdk/RixEngine-iOS-SDK.git \
  refs/tags/2.0.2
```

如果这条命令也失败，请检查代理、VPN、防火墙或当前网络。

#### 编译报错 `Multiple commands produce AlxAds.framework`

这说明工程手动嵌入了一份 `AlxAds.framework`，同时 CocoaPods 又嵌入了一份。请在应用 Target 中：

1. 从 **General → Frameworks, Libraries, and Embedded Content** 删除手动添加的 `AlxAds.framework` 或 `AlxAds.xcframework`。
2. 从 **Build Phases → Link Binary With Libraries** 删除手动添加的 `AlxAds.framework`。
3. 从手动创建的 **Embed Frameworks** 阶段删除 `AlxAds.framework`。
4. 保留 CocoaPods 管理的 **[CP] Embed Pods Frameworks**。
5. 从左侧 Project Navigator 移除旧 Framework 引用，清理构建目录，然后使用 `.xcworkspace` 重新编译。

### 技术支持

如有集成问题，请联系 [rix-sdk@rixengine.com](mailto:rix-sdk@rixengine.com)。
