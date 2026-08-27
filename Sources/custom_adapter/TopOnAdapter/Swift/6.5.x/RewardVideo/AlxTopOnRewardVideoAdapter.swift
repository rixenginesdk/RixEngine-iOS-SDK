//
//  AlxTopOnRewardVideoAdapter.swift
//

import Foundation
import AnyThinkSDK
import AlxAds

@objc(AlxTopOnRewardVideoAdapter)
public class AlxTopOnRewardVideoAdapter: AlxTopOnBaseAdapter, ATBaseRewardedAdapterProtocol {
    
    private static let TAG = "AlxTopOnRewardVideoAdapter"
    
    private var rewardedAd: AlxRewardVideoAd?
    private lazy var rewardVideoDelegate: AlxTopOnRewardVideoDelegate = {
        let delegate = AlxTopOnRewardVideoDelegate()
        delegate.adStatusBridge = self.adStatusBridge
        return delegate
    }()
    
    // MARK: - ATBaseRewardedAdapterProtocol
    
    @objc public var adStatusBridge: ATRewardedAdStatusBridge!
    
    // MARK: - Ad Load
    
    @objc public override func loadAD(with argument: ATAdMediationArgument) {
        NSLog("%@: loadAD(with:)", AlxTopOnRewardVideoAdapter.TAG)
        NSLog("%@: loadAD: isMainThread=%@", AlxTopOnRewardVideoAdapter.TAG, Thread.current.isMainThread ? "YES" : "NO")
        
        let bidId = argument.serverContentDic[kATAdapterCustomInfoBuyeruIdKey] as? String
        NSLog("%@: loadAD: bidId=%@", AlxTopOnRewardVideoAdapter.TAG, bidId ?? "空")
        
        DispatchQueue.main.async {
            let unitKeyStr = AlxTopOnBaseManager.unitID
            guard let unitId = argument.serverContentDic[unitKeyStr] as? String, !unitId.isEmpty else {
                let errorStr = "unitid is empty"
                NSLog("%@: loadAD: error = %@", AlxTopOnRewardVideoAdapter.TAG, errorStr)
                let error = AlxTopOnBaseManager.error(code: -100, msg: errorStr)
                self.notifyLoadFailed(error: error)
                return
            }
            NSLog("%@: loadAD: unitid = %@", AlxTopOnRewardVideoAdapter.TAG, unitId)
            
            if let bidId = bidId {
                // Bidding 场景：从缓存中取出已加载的广告 / Bidding scenario: retrieve the pre-loaded ad from cache
                if let biddingRequest = AlxTopOnTool.shared.getRequestItem(withUnitID: unitId) as? AlxTopOnBiddingRequest {
                    self.rewardedAd = biddingRequest.customObject as? AlxRewardVideoAd
                    
                    if let rewardedAd = self.rewardedAd {
                        NSLog("%@: loadAD: bid ad loaded, notify success", AlxTopOnRewardVideoAdapter.TAG)
                        var adExtra: [AnyHashable: Any] = [:]
                        adExtra[kATAdAssetsCustomObjectKey] = rewardedAd
                        self.notifyRewardedAdLoaded(adExtra: adExtra)
                    } else {
                        NSLog("%@: loadAD: bid ad object is empty", AlxTopOnRewardVideoAdapter.TAG)
                        let error = NSError(domain: "AlxTopOnAdapter", code: -100, userInfo: [NSLocalizedDescriptionKey: "Bid ad object is empty"])
                        self.notifyLoadFailed(error: error)
                    }
                } else {
                    NSLog("%@: loadAD: bid request not found in cache", AlxTopOnRewardVideoAdapter.TAG)
                    let error = NSError(domain: "AlxTopOnAdapter", code: -100, userInfo: [NSLocalizedDescriptionKey: "Bid request not found"])
                    self.notifyLoadFailed(error: error)
                }
                AlxTopOnTool.shared.removeRequestItem(withUnitID: unitId)
            } else {
                // 普通加载场景 / Normal loading scenario
                self.rewardedAd = AlxRewardVideoAd()
                self.rewardedAd?.delegate = self.getRewardVideoDelegate()
                self.rewardVideoDelegate.rewardedAd = self.rewardedAd
                
                NSLog("%@: start loading ad with unitId: %@", AlxTopOnRewardVideoAdapter.TAG, unitId)
                self.rewardedAd?.loadAd(adUnitId: unitId)
            }
        }
    }
    
    private func getRewardVideoDelegate() -> AlxTopOnRewardVideoDelegate {
        self.rewardVideoDelegate.adStatusBridge = self.adStatusBridge
        return self.rewardVideoDelegate
    }
    
    // MARK: - Dynamic Invocation Helper Methods
    
    private func notifyRewardedAdLoaded(adExtra: [AnyHashable: Any]) {
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnRewardedAdLoadedExtra:")
            if bridge.responds(to: selector) {
                bridge.perform(selector, with: adExtra)
            }
        }
    }
    
    private func notifyLoadFailed(error: Error) {
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnAdLoadFailed:adExtra:")
            if bridge.responds(to: selector) {
                let emptyDict: [AnyHashable: Any] = [:]
                bridge.perform(selector, with: error, with: emptyDict)
            }
        }
    }
    
    // MARK: - C2S Bidding
    
    @objc public static func bidRequestWithPlacementModel(_ placementModel: ATPlacementModel,
                                                          unitGroupModel: ATUnitGroupModel,
                                                          info: [AnyHashable: Any],
                                                          completion: @escaping (ATBidInfo?, Error?) -> Void) {
        NSLog("%@: bidRequestWithPlacementModel", AlxTopOnRewardVideoAdapter.TAG)
        
        DispatchQueue.main.async {
            if !AlxTopOnBaseManager.isInitialized {
                AlxTopOnBaseManager.initSDK(serverInfo: info)
            }
        }
        
        let customEvent = AlxTopOnRewardVideoEvent(info: info, localInfo: info)
        customEvent.isC2SBiding = true
        
        let request = AlxTopOnBiddingRequest(
            unitGroup: unitGroupModel,
            customEvent: customEvent,
            unitID: info[AlxTopOnBaseManager.unitID] as? String,
            placementID: placementModel.placementID,
            extraInfo: info,
            adType: ATAdFormat.rewardedVideo,
            bidCompletion: completion
        )
        
        AlxTopOnBiddingRequestManager.shared.start(with: request)
    }
    
    // MARK: - Ad Ready Check (实例方法 / Instance Method)
    
    @objc public func adReadyRewarded(withInfo info: [AnyHashable: Any]) -> Bool {
        NSLog("%@: adReadyRewardedWithInfo", AlxTopOnRewardVideoAdapter.TAG)
        
        if self.rewardedAd != nil {
            NSLog("%@: adReady = YES", AlxTopOnRewardVideoAdapter.TAG)
            return true
        }
        
        NSLog("%@: adReady = NO", AlxTopOnRewardVideoAdapter.TAG)
        return false
    }
    
    // MARK: - Show Ad (实例方法 / Instance Method)
    
    @objc(showRewardedVideoInViewController:)
    public func showRewardedVideo(in viewController: UIViewController) {
        NSLog("%@: showRewardedVideoInViewController", AlxTopOnRewardVideoAdapter.TAG)
        
        DispatchQueue.main.async {
            if let rewardedAd = self.rewardedAd {
                rewardedAd.showAd(present: viewController)
                NSLog("%@: ad shown", AlxTopOnRewardVideoAdapter.TAG)
            } else {
                NSLog("%@: rewardedAd is nil", AlxTopOnRewardVideoAdapter.TAG)
            }
        }
    }
}
