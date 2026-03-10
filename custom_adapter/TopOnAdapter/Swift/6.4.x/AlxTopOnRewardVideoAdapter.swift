//
//  AlxTopOnRewardVideoAdapter.swift
//

import Foundation
import AnyThinkSDK
import AnyThinkRewardedVideo
import AlxAds

@objc(AlxTopOnRewardVideoAdapter)
public class AlxTopOnRewardVideoAdapter:ATAdAdapter {
    
    private static let TAG = "AlxTopOnRewardVideoAdapter"
    
    private var rewardedAd: AlxRewardVideoAd? = nil
    private var customEvent:AlxTopOnRewardVideoEvent? = nil
    
    
    // MARK: - Initialization
    @objc public required init(networkCustomInfo serverInfo: [AnyHashable: Any],
                        localInfo: [AnyHashable: Any]) {
        super.init()
        NSLog("%@: init",AlxTopOnRewardVideoAdapter.TAG)
        NSLog("%@: init: isMainThread=%@",AlxTopOnRewardVideoAdapter.TAG,Thread.current.isMainThread ? "YES" : "NO")
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
        NSLog("%@: loadAD",AlxTopOnRewardVideoAdapter.TAG)
        NSLog("%@: loadAD: isMainThread=%@",AlxTopOnRewardVideoAdapter.TAG,Thread.current.isMainThread ? "YES" : "NO")
       
        DispatchQueue.main.async {
            if !AlxTopOnBaseManager.isInitialized {
                AlxTopOnBaseManager.initSDK(serverInfo: serverInfo)
            }
            
            let bidId=serverInfo[kATAdapterCustomInfoBuyeruIdKey] as? String
            NSLog("%@: loadAD: bidId=%@",AlxTopOnRewardVideoAdapter.TAG,bidId ?? "")
            
            guard let unitId = serverInfo[AlxTopOnBaseManager.unitID] as? String,!unitId.isEmpty else{
                let errorStr="unitid is empty"
                NSLog("%@: loadAD: error= %@",AlxTopOnRewardVideoAdapter.TAG,errorStr)
                completion(nil,AlxTopOnBaseManager.error(code: -100, msg: errorStr))
                return
            }
            
            NSLog("%@: loadAD: unitid=%@",AlxTopOnRewardVideoAdapter.TAG,unitId)
            
            if bidId != nil {
                let request:AlxTopOnBiddingRequest? = AlxTopOnTool.shared.getRequestItem(withUnitID: unitId) as? AlxTopOnBiddingRequest
                if let request = request {
                    self.customEvent = request.customEvent as? AlxTopOnRewardVideoEvent
                    self.customEvent?.requestCompletionBlock = completion
                    self.rewardedAd = request.customObject as? AlxRewardVideoAd
                    //判断广告源是否已经loaded过
                    if let rewardedAd = self.rewardedAd {
                        self.customEvent?.trackRewardedVideoAdLoaded(rewardedAd, adExtra: nil)
                    }else{
                        NSLog("%@: loadAD: bid ad object is empty",AlxTopOnRewardVideoAdapter.TAG)
                    }
                }
                AlxTopOnTool.shared.removeRequestItem(withUnitID: unitId)
            }else{
                self.customEvent = AlxTopOnRewardVideoEvent(info: serverInfo, localInfo: localInfo)
                self.customEvent?.requestCompletionBlock = completion
                
                // load ad
                self.rewardedAd = AlxRewardVideoAd()
                self.rewardedAd?.delegate = self.customEvent
                self.rewardedAd?.loadAd(adUnitId: unitId)
            }
        }
       
    }
    
    // MARK: - C2S header bidding 竞价
    @objc public static func bidRequestWithPlacementModel(_ placementModel: ATPlacementModel,unitGroupModel: ATUnitGroupModel, info: [AnyHashable: Any], completion: @escaping (ATBidInfo?, Error?) -> Void) {
        NSLog("%@: bidRequestWithPlacementModel",AlxTopOnRewardVideoAdapter.TAG)
        DispatchQueue.main.async {
            if !AlxTopOnBaseManager.isInitialized {
                AlxTopOnBaseManager.initSDK(serverInfo: info)
            }
        }
        
        let customEvent:AlxTopOnRewardVideoEvent = AlxTopOnRewardVideoEvent(info: info, localInfo: info)
        customEvent.isC2SBiding = true
        let request:AlxTopOnBiddingRequest = AlxTopOnBiddingRequest(
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
    
    // MARK: - 广告就绪检查
    @objc public static func adReady(withCustomObject customObject: Any, info: [AnyHashable: Any]) -> Bool {
        // 检查广告是否就绪
        // 实际实现中应根据广告网络的具体方法进行检查
        NSLog("%@: adReady",AlxTopOnRewardVideoAdapter.TAG)
        if customObject as? AlxRewardVideoAd != nil {
            NSLog("%@: adReady true",AlxTopOnRewardVideoAdapter.TAG)
            return true
        }else{
            NSLog("%@: adReady false",AlxTopOnRewardVideoAdapter.TAG)
            return false
        }
    }
    
    // MARK: - 广告展示
    @objc(showRewardedVideo:inViewController:delegate:)
    public static func showRewardedVideo(_ rewardedVideo: ATRewardedVideo,
                                       in viewController: UIViewController,
                                       delegate: ATRewardedVideoDelegate) {
        NSLog("%@: showRewardedVideo",AlxTopOnRewardVideoAdapter.TAG)
        guard let rewardAd = (rewardedVideo.customObject as? AlxRewardVideoAd) else {
            NSLog("%@: showRewardedVideo: rewardAd object is nil",AlxTopOnRewardVideoAdapter.TAG)
            return
        }
        rewardedVideo.customEvent.delegate = delegate
        if rewardAd.isReady() {
            rewardAd.showAd(present: viewController)
        }
    }
    
}
