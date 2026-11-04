//
//  AlxTopOnBannerAdapter.swift
//  AlxAdsDemo
//
//  TopOn 6.5.x 新架构
//  TopOn 6.5.x New Architecture
//

import Foundation
import AnyThinkSDK
import AlxAds

// ⚠️ 关键：必须遵循 ATBaseBannerAdapterProtocol 协议才能访问 adStatusBridge
// ⚠️ Critical: Must conform to ATBaseBannerAdapterProtocol to access adStatusBridge
@objc(AlxTopOnBannerAdapter)
public class AlxTopOnBannerAdapter: AlxTopOnBaseAdapter, ATBaseBannerAdapterProtocol {
    
    private static let TAG = "AlxTopOnBannerAdapter"
    
    // ⚠️ ATBaseBannerAdapterProtocol 要求的属性，由 TopOn SDK 自动设置
    // ⚠️ Required property of ATBaseBannerAdapterProtocol; automatically set by TopOn SDK.
    // 使用隐式解包可选类型，表示运行时总是有值，但初始化时可以为 nil
    // Uses implicitly unwrapped optional: always has a value at runtime, but can be nil at init.
    @objc public var adStatusBridge: ATBannerAdStatusBridge!
    
    // Alx SDK 的 banner 广告对象 / Alx SDK banner ad object
    private var bannerAd: AlxBannerAdView?
    // 广告事件代理 / Ad event delegate
    private var bannerDelegate: AlxTopOnBannerDelegate?
    
    // MARK: - 懒加载 / Lazy Load
    private func getBannerDelegate() -> AlxTopOnBannerDelegate {
        if bannerDelegate == nil {
            bannerDelegate = AlxTopOnBannerDelegate()
            bannerDelegate?.adStatusBridge = self.adStatusBridge
        }
        return bannerDelegate!
    }
    
    // MARK: - 广告加载 / Ad Load (ATBaseBannerAdapterProtocol)
    /// 实现广告加载方法（TopOn 6.5.x 新架构）
    /// Implements the ad loading method (TopOn 6.5.x new architecture).
    @objc public override func loadAD(with argument: ATAdMediationArgument) {
        print("\(AlxTopOnBannerAdapter.TAG): loadAD")
        print("\(AlxTopOnBannerAdapter.TAG): loadAD: isMainThread=\(Thread.current.isMainThread ? "YES" : "NO")")
        
        DispatchQueue.main.async {
            self.bannerDelegate = AlxTopOnBannerDelegate()
            self.bannerDelegate?.adStatusBridge = self.adStatusBridge
            self.bannerDelegate?.onAdLoaded = self.beginBiddingRequest(with: argument)
            guard let unitId = AlxTopOnBaseManager.parseUnitID(from: argument.serverContentDic), !unitId.isEmpty else {
                let errorStr = "unitid is empty"
                print("\(AlxTopOnBannerAdapter.TAG): loadAD: error = \(errorStr)")
                let error = AlxTopOnBaseManager.error(code: -100, msg: errorStr)
                // 使用 delegate 来调用，避免 Swift 桥接问题
                // Use delegate to call, avoiding Swift bridging issues
                self.notifyLoadFailed(error: error)
                return
            }
            print("\(AlxTopOnBannerAdapter.TAG): loadAD: unitid = \(unitId)")
            
            var bannerSize = CGSize(width: 320, height: 50)
            if !argument.bannerSize.equalTo(.zero),
               let _ = argument.serverContentDic[kATAdapterCustomInfoUnitGroupModelKey] as? ATUnitGroupModel {
                bannerSize = argument.bannerSize
                print(String(format: "%@: loadAD: width = %.2f, height = %.2f",
                     AlxTopOnBannerAdapter.TAG, bannerSize.width, bannerSize.height))
            }

            self.bannerAd = AlxBannerAdView(frame: CGRect(origin: .zero, size: bannerSize))

            // ⚠️ 注意：delegate 应该设置为 bannerDelegate，而不是 adStatusBridge
            // ⚠️ Note: delegate must be set to bannerDelegate, not adStatusBridge
            self.bannerAd?.delegate = self.getBannerDelegate()
            self.bannerAd?.refreshInterval = 0
            self.bannerAd?.translatesAutoresizingMaskIntoConstraints = false

            print("\(AlxTopOnBannerAdapter.TAG): start loading ad with unitId: \(unitId)")
            let req = self.buildAdRequest(with: argument)
            self.bannerAd?.loadAd(adUnitId: unitId, request: req)
        }
    }
    
    // MARK: - 辅助方法（避免 Swift 桥接问题）/ Helper Methods (Avoiding Swift Bridging Issues)
    private func notifyBannerLoaded(banner: AlxBannerAdView) {
        // 使用 OC 选择器动态调用，避免 Swift 桥接问题
        // Dynamically invoke using ObjC selector to avoid Swift bridging issues
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnBannerAdLoadedWithView:adExtra:")
            if bridge.responds(to: selector) {
                bridge.perform(selector, with: banner, with: nil)
            }
        }
    }
    
    private func notifyLoadFailed(error: Error) {
        // 使用 OC 选择器动态调用，避免 Swift 桥接问题
        // Dynamically invoke using ObjC selector to avoid Swift bridging issues
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnAdLoadFailed:adExtra:")
            if bridge.responds(to: selector) {
                bridge.perform(selector, with: error, with: nil)
            }
        }
    }
    
    // MARK: - 广告就绪检查 / Ad Ready Check
    @objc public static func adReady(withCustomObject customObject: Any, info: [AnyHashable: Any]) -> Bool {
        print("\(AlxTopOnBannerAdapter.TAG): adReady")
        if customObject as? AlxBannerAdView != nil {
            print("\(AlxTopOnBannerAdapter.TAG): adReady true")
            return true
        } else {
            print("\(AlxTopOnBannerAdapter.TAG): adReady false")
            return false
        }
    }
    
    // MARK: - 广告展示 / Show Ad
    @objc(showBanner:inView:presentingViewController:)
    public static func showBanner(_ banner: ATBanner, in view: UIView, presenting viewController: UIViewController) {
        print("\(AlxTopOnBannerAdapter.TAG): showBanner")
        guard let bannerView = banner.customObject as? AlxBannerAdView else {
            print("\(AlxTopOnBannerAdapter.TAG): showBanner banner is nil")
            return
        }
        bannerView.rootViewController = viewController
        view.subviews.forEach { $0.removeFromSuperview() }
        view.addSubview(bannerView)
    }
}
