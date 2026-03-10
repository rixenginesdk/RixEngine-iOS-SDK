//
//  AlxTopOnBannerAdapter.swift
//  AlxAdsDemo
//
//  TopOn 6.5.x 新架构
//

import Foundation
import AnyThinkSDK
import AlxAds

// ⚠️ 关键：必须遵循 ATBaseBannerAdapterProtocol 协议才能访问 adStatusBridge
@objc(AlxTopOnBannerAdapter)
public class AlxTopOnBannerAdapter: AlxTopOnBaseAdapter, ATBaseBannerAdapterProtocol {
    
    private static let TAG = "AlxTopOnBannerAdapter"
    
    // ⚠️ ATBaseBannerAdapterProtocol 要求的属性
    // 这个属性会由 TopOn SDK 自动设置
    // 使用隐式解包可选类型，表示运行时总是有值，但初始化时可以为 nil
    @objc public var adStatusBridge: ATBannerAdStatusBridge!
    
    // Alx SDK 的 banner 广告对象
    private var bannerAd: AlxBannerAdView?
    // Delegate
    private var bannerDelegate: AlxTopOnBannerDelegate?
    
    // MARK: - Lazy Load
    private func getBannerDelegate() -> AlxTopOnBannerDelegate {
        if bannerDelegate == nil {
            bannerDelegate = AlxTopOnBannerDelegate()
            bannerDelegate?.adStatusBridge = self.adStatusBridge
        }
        return bannerDelegate!
    }
    
    // MARK: - Ad Load (ATBaseBannerAdapterProtocol)
    /// 实现广告加载方法（TopOn 6.5.x 新架构）
    @objc public override func loadAD(with argument: ATAdMediationArgument) {
        NSLog("%@: loadAD", AlxTopOnBannerAdapter.TAG)
        NSLog("%@: loadAD: isMainThread=%@", AlxTopOnBannerAdapter.TAG, Thread.current.isMainThread ? "YES" : "NO")
        
        let bidId = argument.serverContentDic[kATAdapterCustomInfoBuyeruIdKey] as? String
        NSLog("%@: loadAD: bidId=%@", AlxTopOnBannerAdapter.TAG, bidId ?? "空")
        
        DispatchQueue.main.async {
            let unitIdKey = AlxTopOnBaseManager.unitID
            guard let unitId = argument.serverContentDic[unitIdKey] as? String, !unitId.isEmpty else {
                let errorStr = "unitid is empty"
                NSLog("%@: loadAD: error = %@", AlxTopOnBannerAdapter.TAG, errorStr)
                let error = AlxTopOnBaseManager.error(code: -100, msg: errorStr)
                // 使用 delegate 来调用，避免 Swift 桥接问题
                self.notifyLoadFailed(error: error)
                return
            }
            NSLog("%@: loadAD: unitid = %@", AlxTopOnBannerAdapter.TAG, unitId)
            
            if let bidId = bidId {
                // Bidding 场景：从缓存中取出已加载的广告
                if let biddingRequest = AlxTopOnTool.shared.getRequestItem(withUnitID: unitId) as? AlxTopOnBiddingRequest {
                    self.bannerAd = biddingRequest.customObject as? AlxBannerAdView
                    
                    if let bannerAd = self.bannerAd {
                        NSLog("%@: loadAD: bid ad loaded, notify success", AlxTopOnBannerAdapter.TAG)
                        self.notifyBannerLoaded(banner: bannerAd)
                    } else {
                        NSLog("%@: loadAD: bid ad object is empty", AlxTopOnBannerAdapter.TAG)
                        let error = NSError(domain: "AlxTopOnAdapter", code: -100, 
                                          userInfo: [NSLocalizedDescriptionKey: "Bid ad object is empty"])
                        self.notifyLoadFailed(error: error)
                    }
                } else {
                    NSLog("%@: loadAD: bid request not found in cache", AlxTopOnBannerAdapter.TAG)
                    let error = NSError(domain: "AlxTopOnAdapter", code: -100, 
                                      userInfo: [NSLocalizedDescriptionKey: "Bid request not found"])
                    self.notifyLoadFailed(error: error)
                }
                // ⚠️ 注意：移除缓存
                AlxTopOnTool.shared.removeRequestItem(withUnitID: unitId)
            } else {
                // 非 Bidding 场景：直接加载广告
                var bannerSize = CGSize(width: 320, height: 50)
                if !argument.bannerSize.equalTo(.zero),
                   let _ = argument.serverContentDic[kATAdapterCustomInfoUnitGroupModelKey] as? ATUnitGroupModel {
                    bannerSize = argument.bannerSize
                    NSLog("%@: loadAD: width = %.2f, height = %.2f", 
                         AlxTopOnBannerAdapter.TAG, bannerSize.width, bannerSize.height)
                }
                
                self.bannerAd = AlxBannerAdView(frame: CGRect(origin: .zero, size: bannerSize))
                
                // ⚠️ 注意：delegate 应该设置为 bannerDelegate，而不是 adStatusBridge
                self.bannerAd?.delegate = self.getBannerDelegate()
                self.bannerAd?.refreshInterval = 0
                self.bannerAd?.translatesAutoresizingMaskIntoConstraints = false
                
                NSLog("%@: start loading ad with unitId: %@", AlxTopOnBannerAdapter.TAG, unitId)
                self.bannerAd?.loadAd(adUnitId: unitId)
            }
        }
    }
    
    // MARK: - Helper Methods (避免 Swift 桥接问题)
    private func notifyBannerLoaded(banner: AlxBannerAdView) {
        // 使用 OC 选择器动态调用，避免 Swift 桥接问题
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnBannerAdLoadedWithView:adExtra:")
            if bridge.responds(to: selector) {
                bridge.perform(selector, with: banner, with: nil)
            }
        }
    }
    
    private func notifyLoadFailed(error: Error) {
        // 使用 OC 选择器动态调用，避免 Swift 桥接问题
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnAdLoadFailed:adExtra:")
            if bridge.responds(to: selector) {
                bridge.perform(selector, with: error, with: nil)
            }
        }
    }
    
    // MARK: - C2S Header Bidding 竞价
    @objc public static func bidRequestWithPlacementModel(_ placementModel: ATPlacementModel,
                                                         unitGroupModel: ATUnitGroupModel,
                                                         info: [AnyHashable: Any],
                                                         completion: @escaping (ATBidInfo?, Error?) -> Void) {
        NSLog("%@: bidRequestWithPlacementModel", AlxTopOnBannerAdapter.TAG)
        
        DispatchQueue.main.async {
            if !AlxTopOnBaseManager.isInitialized {
                AlxTopOnBaseManager.initSDK(serverInfo: info)
            }
        }
        
        let customEvent = AlxTopOnBannerEvent(info: info, localInfo: info)
        customEvent.isC2SBiding = true
        
        let request = AlxTopOnBiddingRequest(
            unitGroup: unitGroupModel,
            customEvent: customEvent,
            unitID: info[AlxTopOnBaseManager.unitID] as? String,
            placementID: placementModel.placementID,
            extraInfo: info,
            adType: ATAdFormat.banner,
            bidCompletion: completion
        )
        AlxTopOnBiddingRequestManager.shared.start(with: request)
    }
    
    // MARK: - 广告就绪检查
    @objc public static func adReady(withCustomObject customObject: Any, info: [AnyHashable: Any]) -> Bool {
        NSLog("%@: adReady", AlxTopOnBannerAdapter.TAG)
        if customObject as? AlxBannerAdView != nil {
            NSLog("%@: adReady true", AlxTopOnBannerAdapter.TAG)
            return true
        } else {
            NSLog("%@: adReady false", AlxTopOnBannerAdapter.TAG)
            return false
        }
    }
    
    // MARK: - 广告展示
    @objc(showBanner:inView:presentingViewController:)
    public static func showBanner(_ banner: ATBanner, in view: UIView, presenting viewController: UIViewController) {
        NSLog("%@: showBanner", AlxTopOnBannerAdapter.TAG)
        guard let bannerView = banner.customObject as? AlxBannerAdView else {
            NSLog("%@: showBanner banner is nil", AlxTopOnBannerAdapter.TAG)
            return
        }
        bannerView.rootViewController = viewController
        view.subviews.forEach { $0.removeFromSuperview() }
        view.addSubview(bannerView)
    }
}
