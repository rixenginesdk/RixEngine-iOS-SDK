//
//  AlxTopOnNativeAdapter.swift
//  AlxAdsDemo
//

import Foundation
import AnyThinkSDK
import AlxAds

@objc(AlxTopOnNativeAdapter)
public class AlxTopOnNativeAdapter: AlxTopOnBaseAdapter, ATBaseNativeAdapterProtocol {
    
    private static let TAG = "AlxTopOnNativeAdapter"
    
    @objc public var adStatusBridge: ATNativeAdStatusBridge!
    
    private var nativeAdLoader: AlxNativeAdLoader?
    private var nativeAd: AlxNativeAd?
    private lazy var nativeDelegate: AlxTopOnNativeDelegate = {
        let delegate = AlxTopOnNativeDelegate()
        delegate.adStatusBridge = self.adStatusBridge
        return delegate
    }()
    private lazy var nativeEvent: AlxTopOnNativeEvent = {
        return AlxTopOnNativeEvent(info: [:], localInfo: [:])
    }()
    
    // MARK: - Ad Load
    
    @objc public override func loadAD(with argument: ATAdMediationArgument) {
        NSLog("%@: loadAD(with:)", AlxTopOnNativeAdapter.TAG)
        NSLog("%@: loadAD: isMainThread=%@", AlxTopOnNativeAdapter.TAG, Thread.current.isMainThread ? "YES" : "NO")
        
        let bidId = argument.serverContentDic[kATAdapterCustomInfoBuyeruIdKey] as? String
        NSLog("%@: loadAD: bidId=%@", AlxTopOnNativeAdapter.TAG, bidId ?? "空")
        
        DispatchQueue.main.async {
            guard let unitId = argument.serverContentDic[AlxTopOnBaseManager.unitID] as? String, !unitId.isEmpty else {
                let errorStr = "unitid is empty"
                NSLog("%@: loadAD: error = %@", AlxTopOnNativeAdapter.TAG, errorStr)
                let error = AlxTopOnBaseManager.error(code: -100, msg: errorStr)
                self.notifyLoadFailed(error: error)
                return
            }
            NSLog("%@: loadAD: unitid = %@", AlxTopOnNativeAdapter.TAG, unitId)
            
            if let bidId = bidId {
                // Bidding 场景：从缓存中取出已加载的广告 / Bidding scenario: retrieve the pre-loaded ad from cache
                if let biddingRequest = AlxTopOnTool.shared.getRequestItem(withUnitID: unitId) as? AlxTopOnBiddingRequest {
                    self.nativeAd = biddingRequest.customObject as? AlxNativeAd
                    
                    if let nativeAd = self.nativeAd {
                        NSLog("%@: loadAD: bid ad loaded, creating native object", AlxTopOnNativeAdapter.TAG)
                        
                        // ⚠️ 创建 AlxTopOnNativeObject 对象 / Create AlxTopOnNativeObject instance
                        let nativeObject = AlxTopOnNativeObject()
                        nativeObject.nativeAd = nativeAd
                        nativeObject.nativeEvent = self.nativeEvent
                        
                        // ✅ 关键：设置 nativeAd 的 delegate，以便接收展示、点击、关闭回调 / Key: set nativeAd's delegate to receive impression, click, and close callbacks
                        nativeAd.delegate = self.nativeDelegate
                        
                        // ⚠️ 传递对象数组 / Pass the object array
                        self.notifyNativeAdLoaded(objects: [nativeObject], adExtra: [:])
                    } else {
                        NSLog("%@: loadAD: bid ad object is empty", AlxTopOnNativeAdapter.TAG)
                        let error = NSError(domain: "AlxTopOnAdapter", code: -100, userInfo: [NSLocalizedDescriptionKey: "Bid ad object is empty"])
                        self.notifyLoadFailed(error: error)
                    }
                } else {
                    NSLog("%@: loadAD: bid request not found in cache", AlxTopOnNativeAdapter.TAG)
                    let error = NSError(domain: "AlxTopOnAdapter", code: -100, userInfo: [NSLocalizedDescriptionKey: "Bid request not found"])
                    self.notifyLoadFailed(error: error)
                }
                AlxTopOnTool.shared.removeRequestItem(withUnitID: unitId)
            } else {
                // 普通加载场景 / Normal loading scenario
                self.nativeAdLoader = AlxNativeAdLoader(adUnitID: unitId)
                self.nativeAdLoader?.delegate = self.getNativeDelegate()
                self.nativeDelegate.nativeEvent = self.nativeEvent
                
                NSLog("%@: start loading ad with unitId: %@", AlxTopOnNativeAdapter.TAG, unitId)
                self.nativeAdLoader?.loadAd()
            }
        }
    }
    
    // MARK: - C2S Bidding
    
    @objc public static func bidRequestWithPlacementModel(_ placementModel: ATPlacementModel,
                                                          unitGroupModel: ATUnitGroupModel,
                                                          info: [AnyHashable: Any],
                                                          completion: @escaping (ATBidInfo?, Error?) -> Void) {
        NSLog("%@: bidRequestWithPlacementModel", AlxTopOnNativeAdapter.TAG)
        
        DispatchQueue.main.async {
            if !AlxTopOnBaseManager.isInitialized {
                AlxTopOnBaseManager.initSDK(serverInfo: info)
            }
        }
        
        let customEvent = AlxTopOnNativeEvent(info: info, localInfo: info)
        customEvent.isC2SBiding = true
        
        let request = AlxTopOnBiddingRequest(
            unitGroup: unitGroupModel,
            customEvent: customEvent,
            unitID: info[AlxTopOnBaseManager.unitID] as? String,
            placementID: placementModel.placementID,
            extraInfo: info,
            adType: ATAdFormat.native,
            bidCompletion: completion
        )
        
        AlxTopOnBiddingRequestManager.shared.start(with: request)
    }
    
    // MARK: - Renderer Class
    
    @objc public static func rendererClass() -> AnyClass {
        NSLog("%@: rendererClass", AlxTopOnNativeAdapter.TAG)
        return AlxTopOnNativeRender.self
    }
    
    // MARK: - Helper Methods
    
    private func getNativeDelegate() -> AlxTopOnNativeDelegate {
        self.nativeDelegate.adStatusBridge = self.adStatusBridge
        return self.nativeDelegate
    }
    
    // MARK: - Dynamic Invocation Helper Methods
    
    private func notifyNativeAdLoaded(objects: [AlxTopOnNativeObject], adExtra: [AnyHashable: Any]) {
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnNativeAdLoadedArray:adExtra:")
            if bridge.responds(to: selector) {
                bridge.perform(selector, with: objects, with: adExtra)
            }
        }
    }
    
    private func notifyLoadFailed(error: Error) {
        if let bridge = self.adStatusBridge {
            let emptyDict: [AnyHashable: Any] = [:]
            let selector = NSSelectorFromString("atOnAdLoadFailed:adExtra:")
            if bridge.responds(to: selector) {
                bridge.perform(selector, with: error, with: emptyDict)
            }
        }
    }
}
