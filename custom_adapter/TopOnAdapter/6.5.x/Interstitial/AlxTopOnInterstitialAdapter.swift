//
//  AlxTopOnInterstitialAdapter.swift
//

import Foundation
import AnyThinkSDK
import AlxAds

@objc(AlxTopOnInterstitialAdapter)
public class AlxTopOnInterstitialAdapter: AlxTopOnBaseAdapter, ATBaseInterstitialAdapterProtocol {
    
    private static let TAG = "AlxTopOnInterstitialAdapter"
    
    private var interstitialAd: AlxInterstitialAd?
    private lazy var interstitialDelegate: AlxTopOnInterstitialDelegate = {
        let delegate = AlxTopOnInterstitialDelegate()
        delegate.adStatusBridge = self.adStatusBridge
        return delegate
    }()
    
    // MARK: - ATBaseInterstitialAdapterProtocol
    
    @objc public var adStatusBridge: ATInterstitialAdStatusBridge!
    
    // MARK: - Ad Load
    
    @objc public override func loadAD(with argument: ATAdMediationArgument) {
        NSLog("%@: loadAD(with:)", AlxTopOnInterstitialAdapter.TAG)
        NSLog("%@: loadAD: isMainThread=%@", AlxTopOnInterstitialAdapter.TAG, Thread.current.isMainThread ? "YES" : "NO")
        
        let bidId = argument.serverContentDic[kATAdapterCustomInfoBuyeruIdKey] as? String
        NSLog("%@: loadAD: bidId=%@", AlxTopOnInterstitialAdapter.TAG, bidId ?? "空")
        
        DispatchQueue.main.async {
            let unitKeyStr = AlxTopOnBaseManager.unitID
            guard let unitId = argument.serverContentDic[unitKeyStr] as? String, !unitId.isEmpty else {
                let errorStr = "unitid is empty"
                NSLog("%@: loadAD: error = %@", AlxTopOnInterstitialAdapter.TAG, errorStr)
                let error = AlxTopOnBaseManager.error(code: -100, msg: errorStr)
                self.notifyLoadFailed(error: error)
                return
            }
            NSLog("%@: loadAD: unitid = %@", AlxTopOnInterstitialAdapter.TAG, unitId)
            
            if let bidId = bidId {
                // Bidding 场景：从缓存中取出已加载的广告
                if let biddingRequest = AlxTopOnTool.shared.getRequestItem(withUnitID: unitId) as? AlxTopOnBiddingRequest {
                    self.interstitialAd = biddingRequest.customObject as? AlxInterstitialAd
                    
                    if let interstitialAd = self.interstitialAd {
                        NSLog("%@: loadAD: bid ad loaded, notify success", AlxTopOnInterstitialAdapter.TAG)
                        var adExtra: [AnyHashable: Any] = [:]
                        adExtra[kATAdAssetsCustomObjectKey] = interstitialAd
                        self.notifyInterstitialLoaded(adExtra: adExtra)
                    } else {
                        NSLog("%@: loadAD: bid ad object is empty", AlxTopOnInterstitialAdapter.TAG)
                        let error = NSError(domain: "AlxTopOnAdapter", code: -100, userInfo: [NSLocalizedDescriptionKey: "Bid ad object is empty"])
                        self.notifyLoadFailed(error: error)
                    }
                } else {
                    NSLog("%@: loadAD: bid request not found in cache", AlxTopOnInterstitialAdapter.TAG)
                    let error = NSError(domain: "AlxTopOnAdapter", code: -100, userInfo: [NSLocalizedDescriptionKey: "Bid request not found"])
                    self.notifyLoadFailed(error: error)
                }
                AlxTopOnTool.shared.removeRequestItem(withUnitID: unitId)
            } else {
                // 普通加载场景
                self.interstitialAd = AlxInterstitialAd()
                self.interstitialAd?.delegate = self.getInterstitialDelegate()
                self.interstitialDelegate.interstitialAd = self.interstitialAd
                
                NSLog("%@: start loading ad with unitId: %@", AlxTopOnInterstitialAdapter.TAG, unitId)
                self.interstitialAd?.loadAd(adUnitId: unitId)
            }
        }
    }
    
    private func getInterstitialDelegate() -> AlxTopOnInterstitialDelegate {
        self.interstitialDelegate.adStatusBridge = self.adStatusBridge
        return self.interstitialDelegate
    }
    
    // MARK: - Dynamic Invocation Helper Methods
    
    private func notifyInterstitialLoaded(adExtra: [AnyHashable: Any]) {
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnInterstitialAdLoadedExtra:")
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
        NSLog("%@: bidRequestWithPlacementModel", AlxTopOnInterstitialAdapter.TAG)
        
        DispatchQueue.main.async {
            if !AlxTopOnBaseManager.isInitialized {
                AlxTopOnBaseManager.initSDK(serverInfo: info)
            }
        }
        
        let customEvent = AlxTopOnInterstitialEvent(info: info, localInfo: info)
        customEvent.isC2SBiding = true
        
        let request = AlxTopOnBiddingRequest(
            unitGroup: unitGroupModel,
            customEvent: customEvent,
            unitID: info[AlxTopOnBaseManager.unitID] as? String,
            placementID: placementModel.placementID,
            extraInfo: info,
            adType: ATAdFormat.interstitial,
            bidCompletion: completion
        )
        
        AlxTopOnBiddingRequestManager.shared.start(with: request)
    }
    
    // MARK: - Ad Ready Check (实例方法)
    
    @objc public func adReadyInterstitial(withInfo info: [AnyHashable: Any]) -> Bool {
        NSLog("%@: adReadyInterstitialWithInfo", AlxTopOnInterstitialAdapter.TAG)
        
        if self.interstitialAd != nil {
            NSLog("%@: adReady = YES", AlxTopOnInterstitialAdapter.TAG)
            return true
        }
        
        NSLog("%@: adReady = NO", AlxTopOnInterstitialAdapter.TAG)
        return false
    }
    
    // MARK: - Show Ad (实例方法)
    
    @objc(showInterstitialInViewController:)
    public func showInterstitial(in viewController: UIViewController) {
        NSLog("%@: showInterstitialInViewController", AlxTopOnInterstitialAdapter.TAG)
        
        DispatchQueue.main.async {
            if let interstitialAd = self.interstitialAd {
                interstitialAd.showAd(present: viewController)
                NSLog("%@: ad shown", AlxTopOnInterstitialAdapter.TAG)
            } else {
                NSLog("%@: interstitialAd is nil", AlxTopOnInterstitialAdapter.TAG)
            }
        }
    }
}
