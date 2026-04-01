workspace 'AlxAdsDemo'
platform :ios, '12.0'
use_frameworks!

# Demo工程
project 'AlxAdsDemo.xcodeproj'
target 'AlxAdsDemo' do
  project 'AlxAdsDemo.xcodeproj'
  
  # 添加SDK依赖库
  # max 广告sdk
  pod 'AppLovinSDK', '13.3.0'
  # google admob 广告sdk
  pod 'Google-Mobile-Ads-SDK', '12.6.0'
  # TopOn 广告sdk
  #   pod 'TPNiOS','6.4.87'
  pod 'TPNiOS', '6.5.34'  # 统一使用 6.5.34 版本
  pod 'TPNDebugUISDK'     # 调试 UI 建议两个 Demo 都带上
  # 必须引入 ADX 适配器以解决组件缺失弹窗
  pod 'TPNMediationAdxSmartdigimktAdapter', '6.5.42.1'
  pod 'IronSourceSDK','9.2.0.0' # Unity Ads SDK
end


