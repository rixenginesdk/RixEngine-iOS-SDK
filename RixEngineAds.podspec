Pod::Spec.new do |s|

  # ――― 1. Spec Metadata ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.name         = "RixEngineAds"
  s.version      = "2.0.4"
  s.summary      = "RixEngineAds Mobile Ad Aggregation SDK."

  s.description  = <<-DESC
                   With the RixEngine SDK, you can quickly integrate with multiple platforms and safely scale your demand, thus maximizing your potential revenue. Meanwhile, its lightweight package ensures you continue delivering users with the best experience possible.
                   DESC

  s.homepage     = "https://github.com/rixenginesdk/RixEngine-iOS-SDK"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "RixEngine" => "rix-sdk@rixengine.com" }

  # ――― 2. Platform & Settings ―――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.ios.deployment_target = "13.0"
  s.swift_version         = '5.0'

  # GitHub release tags use the v-prefixed semantic version.
  s.source       = { :git => "https://github.com/rixenginesdk/RixEngine-iOS-SDK.git", :tag => "#{s.version}" }
  
  # 声明包含静态二进制 (解决 Google/IronSource 传递依赖报错)
  s.static_framework = true

  # 默认仅集成 Core 二进制核心包
  s.default_subspecs = 'Core'

  # ==========================================================
  # 1. 核心二进制模块 (Core)
  # ==========================================================
  s.subspec 'Core' do |core|
    core.name             = 'Core'
    # 如果放在 Sources/ 下，写 'Sources/AlxAds.xcframework'
    core.vendored_frameworks = 'Sources/AlxAds.xcframework'
    core.frameworks       = 'UIKit', 'Foundation', 'WebKit', 'CoreGraphics', 'SystemConfiguration', 'CoreTelephony'
  end

  # ==========================================================
  # 2. Admob 适配器
  # ==========================================================
  # Swift and Objective-C variants export the same runtime class names.
  # Consumers must select only one variant for each mediation network.
  s.subspec 'AdmobAdapter' do |admob|
    admob.source_files = 'Sources/custom_adapter/AdmobAdapter/Swift/**/*.swift'
    admob.dependency 'RixEngineAds/Core'
    admob.dependency 'Google-Mobile-Ads-SDK', '12.6.0'
  end

  s.subspec 'AdmobAdapterOC' do |admob_oc|
    admob_oc.source_files = 'Sources/custom_adapter/AdmobAdapter/Objc/**/*.{h,m}'
    admob_oc.dependency 'RixEngineAds/Core'
    admob_oc.dependency 'Google-Mobile-Ads-SDK', '12.6.0'
  end

  # ==========================================================
  # 3. MAX 适配器
  # ==========================================================
  s.subspec 'MaxAdapter' do |max|
    max.source_files = 'Sources/custom_adapter/MaxAdapter/Swift/**/*.swift'
    max.dependency 'RixEngineAds/Core'
    max.dependency 'AppLovinSDK'
  end

  s.subspec 'MaxAdapterOC' do |max_oc|
    max_oc.source_files = 'Sources/custom_adapter/MaxAdapter/Objc/**/*.{h,m}'
    max_oc.dependency 'RixEngineAds/Core'
    max_oc.dependency 'AppLovinSDK'
  end

  # ==========================================================
  # 4. TopOn 适配器 (精确指定 6.5.x 目录，防止同名冲突)
  # ==========================================================
  s.subspec 'TopOnAdapter' do |topon|
    topon.source_files = 'Sources/custom_adapter/TopOnAdapter/Swift/6.5.x/**/*.swift'
    topon.dependency 'RixEngineAds/Core'
    topon.dependency 'TPNiOS', '~> 6.5.34'
    topon.dependency 'TPNMediationAdxSmartdigimktAdapter', '~> 6.5.42'
  end

  s.subspec 'TopOnAdapterOC' do |topon_oc|
    topon_oc.source_files = 'Sources/custom_adapter/TopOnAdapter/Objc/6.5.x/**/*.{h,m}'
    topon_oc.dependency 'RixEngineAds/Core'
    topon_oc.dependency 'TPNiOS', '~> 6.5.34'
    topon_oc.dependency 'TPNMediationAdxSmartdigimktAdapter', '~> 6.5.42'
  end

  # ==========================================================
  # 5. UnityLevelPlay 适配器
  # ==========================================================
  s.subspec 'UnityLevelPlayAdapter' do |unity|
    unity.source_files = 'Sources/custom_adapter/UnityLevelPlayAdapter/Swift/**/*.swift'
    unity.dependency 'RixEngineAds/Core'
    unity.dependency 'IronSourceSDK'
  end

  s.subspec 'UnityLevelPlayAdapterOC' do |unity_oc|
    unity_oc.source_files = 'Sources/custom_adapter/UnityLevelPlayAdapter/Objc/**/*.{h,m}'
    unity_oc.dependency 'RixEngineAds/Core'
    unity_oc.dependency 'IronSourceSDK'
  end

end
