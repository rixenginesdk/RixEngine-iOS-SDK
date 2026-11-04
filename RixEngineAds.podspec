Pod::Spec.new do |s|

  # ――― 1. Spec Metadata ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.name         = "RixEngineAds"
  s.version      = "2.2.0"
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

  # 核心二进制模块
  s.vendored_frameworks   = 'Sources/AlxAds.xcframework'
  s.frameworks            = 'UIKit', 'Foundation', 'WebKit', 'CoreGraphics', 'SystemConfiguration', 'CoreTelephony'

end
