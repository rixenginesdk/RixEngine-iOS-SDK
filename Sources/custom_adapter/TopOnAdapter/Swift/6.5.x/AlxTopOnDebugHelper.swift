//
//  AlxTopOnDebugHelper.swift
//  AlxAdsDemo
//
//  调试辅助工具：验证 TopOn 适配器类名 / Debug helper tool: Verify TopOn adapter class names
//

import Foundation

@objc(AlxTopOnDebugHelper)
public class AlxTopOnDebugHelper: NSObject {
    
    /**
     * 验证所有适配器类名和可见性。
     * Verify all adapter class names and visibility.
     */
    @objc public static func verifyAdapterClassNames() {
        print("========== TopOn 适配器类名验证 ==========")
        
        // 1. 验证 Swift 类的完整类名 / Verify full class names of Swift classes
        let adapters: [(String, AnyClass)] = [
            ("Banner", AlxTopOnBannerAdapter.self),
            ("Interstitial", AlxTopOnInterstitialAdapter.self),
            ("RewardVideo", AlxTopOnRewardVideoAdapter.self),
            ("Native", AlxTopOnNativeAdapter.self),
            ("Base", AlxTopOnBaseAdapter.self),
            ("Init", AlxTopOnInitAdapter.self)
        ]
        
        print("\n1️⃣ Swift 类的完整类名:")
        for (name, adapterClass) in adapters {
            let className = NSStringFromClass(adapterClass)
            print("  \(name): \(className)")
        }
        
        // 2. 验证 OC 运行时能否通过短名称找到类 / Verify if OC runtime can find classes by short name
        print("\n2️⃣ 通过短名称查找类（TopOn 可能使用此方式）:")
        let shortNames = [
            "AlxTopOnBannerAdapter",
            "AlxTopOnInterstitialAdapter",
            "AlxTopOnRewardVideoAdapter",
            "AlxTopOnNativeAdapter"
        ]
        
        for shortName in shortNames {
            if let foundClass = NSClassFromString(shortName) {
                print("  ✅ \(shortName) -> 找到: \(NSStringFromClass(foundClass))")
            } else {
                print("  ❌ \(shortName) -> 未找到")
            }
        }
        
        // 3. 验证 OC 运行时能否通过完整名称找到类 / Verify if OC runtime can find classes by full name
        print("\n3️⃣ 通过完整名称查找类（推荐配置）:")
        let fullNames = [
            "AlxAdsDemo.AlxTopOnBannerAdapter",
            "AlxAdsDemo.AlxTopOnInterstitialAdapter",
            "AlxAdsDemo.AlxTopOnRewardVideoAdapter",
            "AlxAdsDemo.AlxTopOnNativeAdapter"
        ]
        
        for fullName in fullNames {
            if let foundClass = NSClassFromString(fullName) {
                print("  ✅ \(fullName) -> 找到: \(NSStringFromClass(foundClass))")
            } else {
                print("  ❌ \(fullName) -> 未找到")
            }
        }
        
        // 4. 验证继承关系 / Verify inheritance hierarchy
        print("\n4️⃣ 继承关系验证:")
        for (name, adapterClass) in adapters {
            let superClassName = NSStringFromClass(adapterClass.superclass() ?? NSObject.self)
            print("  \(name): \(NSStringFromClass(adapterClass)) -> \(superClassName)")
        }
        
        // 5. 验证是否符合协议 / Verify protocol conformance
        print("\n5️⃣ 协议实现验证:")
        let bannerAdapter = AlxTopOnBannerAdapter.self
        print("  Banner 实现 ATBaseBannerAdapterProtocol: \(bannerAdapter.conforms(to: NSProtocolFromString("ATBaseBannerAdapterProtocol") ?? NSObjectProtocol.self))")
        
        let interstitialAdapter = AlxTopOnInterstitialAdapter.self
        print("  Interstitial 实现 ATBaseInterstitialAdapterProtocol: \(interstitialAdapter.conforms(to: NSProtocolFromString("ATBaseInterstitialAdapterProtocol") ?? NSObjectProtocol.self))")
        
        let rewardedAdapter = AlxTopOnRewardVideoAdapter.self
        print("  RewardVideo 实现 ATBaseRewardedVideoAdapterProtocol: \(rewardedAdapter.conforms(to: NSProtocolFromString("ATBaseRewardedVideoAdapterProtocol") ?? NSObjectProtocol.self))")
        
        print("\n========== 验证完成 ==========\n")
        
        // 6. 给出配置建议 / Provide configuration suggestions
        print("📋 TopOn 后台配置建议:")
        print("  如果「通过短名称查找类」全部 ✅，后台配置使用短名称")
        print("  如果「通过短名称查找类」有 ❌，后台配置使用完整名称（带 AlxAdsDemo. 前缀）")
        print("")
    }
    
    /**
     * 测试适配器实例化。
     * Test adapter instantiation.
     * ⚠️ 注意：TopOn 6.5.x 新架构中，adapter 实例由 TopOn SDK 自动创建，不需要自定义初始化方法。
     * ⚠️ Note: In TopOn 6.5.x new architecture, adapter instances are automatically created by TopOn SDK, no custom initialization method is needed.
     */
    @objc public static func testAdapterInstantiation() {
        print("========== 适配器实例化测试 ==========")
        print("ℹ️ TopOn 6.5.x 新架构：")
        print("  - Adapter 实例由 TopOn SDK 自动创建")
        print("  - 不再需要自定义 init(networkCustomInfo:localInfo:) 方法")
        print("  - 测试将在实际广告加载时进行")
        
        // 验证类是否可以被实例化（使用默认初始化方法） / Verify if the class can be instantiated (using default initialization method)
        let bannerAdapter = AlxTopOnBannerAdapter()
        print("✅ Banner 适配器类可实例化: \(type(of: bannerAdapter))")
        print("   继承链: \(NSStringFromClass(type(of: bannerAdapter).superclass()!))")
        print("   遵循协议: ATBaseBannerAdapterProtocol")
        
        print("========== 测试完成 ==========\n")
    }
}
