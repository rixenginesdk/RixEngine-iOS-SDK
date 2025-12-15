//
//  AlxTopOnNativeAdapter.swift
//

import Foundation
import AnyThinkSDK
import AnyThinkNative
import AlxAds

@objc(AlxTopOnNativeAdapter)
public class AlxTopOnNativeAdapter:ATAdAdapter {
    
    private static let TAG = "AlxTopOnNativeAdapter"
    
    private var nativeAd:AlxNativeAdLoader? = nil
    private var customEvent:AlxTopOnNativeEvent? = nil
    
    
    // MARK: - Initialization
    @objc public required init(networkCustomInfo serverInfo: [AnyHashable: Any],
                               localInfo: [AnyHashable: Any]) {
        super.init()
        NSLog("%@: init",AlxTopOnNativeAdapter.TAG)
        NSLog("%@: init: isMainThread=%@",AlxTopOnNativeAdapter.TAG,Thread.current.isMainThread ? "YES" : "NO")
        DispatchQueue.main.async {
            if !AlxTopOnBaseManager.isInitialized {
                AlxTopOnBaseManager.initSDK(serverInfo: serverInfo)
            }
        }
    }
    
    /// 加载广告
    @objc public func loadAD(withInfo serverInfo: [AnyHashable: Any],
                             localInfo: [AnyHashable: Any],
                             completion: @escaping ([[AnyHashable: Any]]?, (any Error)?) -> Void) {
        NSLog("%@: loadAD",AlxTopOnNativeAdapter.TAG)
        NSLog("%@: loadAD: isMainThread=%@",AlxTopOnNativeAdapter.TAG,Thread.current.isMainThread ? "YES" : "NO")
        
        DispatchQueue.main.async {
            if !AlxTopOnBaseManager.isInitialized {
                AlxTopOnBaseManager.initSDK(serverInfo: serverInfo)
            }
            
            let bidId=serverInfo[kATAdapterCustomInfoBuyeruIdKey] as? String
            NSLog("%@: loadAD: bidId=%@",AlxTopOnNativeAdapter.TAG,bidId ?? "")     
            
            guard let unitId = serverInfo[AlxTopOnBaseManager.unitID] as? String,!unitId.isEmpty else{
                let errorStr="unitid is empty"
                NSLog("%@: loadAD: error= %@",AlxTopOnNativeAdapter.TAG,errorStr)
                completion(nil,AlxTopOnBaseManager.error(code: -100, msg: errorStr))
                return
            }
            
            NSLog("%@: loadAD: unitid=%@",AlxTopOnNativeAdapter.TAG,unitId)
            
            if bidId != nil {
                let request:AlxTopOnBiddingRequest? = AlxTopOnTool.shared.getRequestItem(withUnitID: unitId) as? AlxTopOnBiddingRequest
                if let request = request {
                    self.customEvent = request.customEvent as? AlxTopOnNativeEvent
                    self.customEvent?.requestCompletionBlock = completion
                    self.nativeAd = request.customObject as? AlxNativeAdLoader
                    //判断广告源是否已经loaded过
                    if let assets = self.customEvent?.assetDict {
                        NSLog("%@: loadAD: bid load success callback",AlxTopOnNativeAdapter.TAG)
                        self.customEvent?.trackNativeAdLoaded([assets])
                    }else{
                        NSLog("%@: loadAD: bid ad object is empty",AlxTopOnNativeAdapter.TAG)
                    }
                    self.customEvent?.assets.removeAllObjects()
                    self.customEvent?.assetDict = [:]
                }
                AlxTopOnTool.shared.removeRequestItem(withUnitID: unitId)
            }else{
                
                self.customEvent = AlxTopOnNativeEvent(info: serverInfo, localInfo: localInfo)
                self.customEvent?.requestCompletionBlock = completion
                
                // load ad
                self.nativeAd = AlxNativeAdLoader(adUnitID: unitId)
                self.nativeAd?.delegate = self.customEvent
                self.nativeAd?.loadAd()
            }
        }
        
    }
    
    // MARK: - C2S header bidding 竞价
    @objc public static func bidRequestWithPlacementModel(_ placementModel: ATPlacementModel,unitGroupModel: ATUnitGroupModel, info: [AnyHashable: Any], completion: @escaping (ATBidInfo?, Error?) -> Void) {
        NSLog("%@: bidRequestWithPlacementModel",AlxTopOnNativeAdapter.TAG)
        DispatchQueue.main.async {
            if !AlxTopOnBaseManager.isInitialized {
                AlxTopOnBaseManager.initSDK(serverInfo: info)
            }
        }
        
        let customEvent:AlxTopOnNativeEvent = AlxTopOnNativeEvent(info: info, localInfo: info)
        customEvent.isC2SBiding = true
        let request:AlxTopOnBiddingRequest = AlxTopOnBiddingRequest(
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
        
    // 实现 Objective-C 协议中的类方法: + (Class)rendererClass;
    @objc public static func rendererClass() -> AnyClass {
        NSLog("%@: rendererClass",AlxTopOnNativeAdapter.TAG)
        return AlxTopOnNativeRender.self
    }
    
}
