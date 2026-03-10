//
//  AlxTopOnInterstitialAdapter.swift
//

import Foundation
import AnyThinkSDK
import AnyThinkInterstitial
import AlxAds

@objc(AlxTopOnInterstitialAdapter)
public class AlxTopOnInterstitialAdapter: ATAdAdapter {
    
    private static let TAG = "AlxTopOnInterstitialAdapter"
    
    private var interstitialAd: AlxInterstitialAd? = nil
    private var customEvent:AlxTopOnInterstitialEvent? = nil
    
    
    // MARK: - Initialization
    @objc public required init(networkCustomInfo serverInfo: [AnyHashable: Any],
                        localInfo: [AnyHashable: Any]) {
        super.init()
        NSLog("%@: init",AlxTopOnInterstitialAdapter.TAG)
        NSLog("%@: init: isMainThread=%@",AlxTopOnInterstitialAdapter.TAG,Thread.current.isMainThread ? "YES" : "NO")
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
        NSLog("%@: loadAD",AlxTopOnInterstitialAdapter.TAG)
        NSLog("%@: loadAD: isMainThread=%@",AlxTopOnInterstitialAdapter.TAG,Thread.current.isMainThread ? "YES" : "NO")
       
        DispatchQueue.main.async {
            if !AlxTopOnBaseManager.isInitialized {
                AlxTopOnBaseManager.initSDK(serverInfo: serverInfo)
            }
            
            let bidId=serverInfo[kATAdapterCustomInfoBuyeruIdKey] as? String
            NSLog("%@: loadAD: bidId=%@",AlxTopOnInterstitialAdapter.TAG,bidId ?? "")
            
            guard let unitId = serverInfo[AlxTopOnBaseManager.unitID] as? String,!unitId.isEmpty else{
                let errorStr="unitid is empty"
                NSLog("%@: loadAD: error= %@",AlxTopOnInterstitialAdapter.TAG,errorStr)
                completion(nil,AlxTopOnBaseManager.error(code: -100, msg: errorStr))
                return
            }
            NSLog("%@: loadAD: unitid=%@",AlxTopOnInterstitialAdapter.TAG,unitId)
            
            if bidId != nil {
                let request:AlxTopOnBiddingRequest? = AlxTopOnTool.shared.getRequestItem(withUnitID: unitId) as? AlxTopOnBiddingRequest
                if let request = request {
                    self.customEvent = request.customEvent as? AlxTopOnInterstitialEvent
                    self.customEvent?.requestCompletionBlock = completion
                    self.interstitialAd = request.customObject as? AlxInterstitialAd
                    //判断广告源是否已经loaded过
                    if let interstitialAd = self.interstitialAd {
                        self.customEvent?.trackInterstitialAdLoaded(interstitialAd, adExtra: nil)
                    }else{
                        NSLog("%@: loadAD: bid ad object is empty",AlxTopOnInterstitialAdapter.TAG)
                    }
                }
                AlxTopOnTool.shared.removeRequestItem(withUnitID: unitId)
            }else{
                self.customEvent = AlxTopOnInterstitialEvent(info: serverInfo, localInfo: localInfo)
                self.customEvent?.requestCompletionBlock = completion
                
                // load ad
                self.interstitialAd = AlxInterstitialAd()
                self.interstitialAd?.delegate = self.customEvent
                self.interstitialAd?.loadAd(adUnitId: unitId)
            }
        }
    }
    
    // MARK: - C2S header bidding 竞价
    @objc public static func bidRequestWithPlacementModel(_ placementModel: ATPlacementModel,unitGroupModel: ATUnitGroupModel, info: [AnyHashable: Any], completion: @escaping (ATBidInfo?, Error?) -> Void) {
        NSLog("%@: bidRequestWithPlacementModel",AlxTopOnInterstitialAdapter.TAG)
        NSLog("%@: bidRequestWithPlacementModel: isMainThread=%@",AlxTopOnInterstitialAdapter.TAG,Thread.current.isMainThread ? "YES" : "NO")
        
        DispatchQueue.main.async {
            if !AlxTopOnBaseManager.isInitialized {
                AlxTopOnBaseManager.initSDK(serverInfo: info)
            }
        }
        
        let customEvent:AlxTopOnInterstitialEvent = AlxTopOnInterstitialEvent(info: info, localInfo: info)
        customEvent.isC2SBiding = true
        let request:AlxTopOnBiddingRequest = AlxTopOnBiddingRequest(
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
    
    @objc(loadWithServerInfo:localInfo:)
    public func loadWithServerInfo(_ serverInfo:[AnyHashable: Any],localInfo:[AnyHashable: Any]){
        NSLog("%@: loadWithServerInfo",AlxTopOnInterstitialAdapter.TAG)
    }
    
    
    // MARK: - 广告就绪检查
    @objc public static func adReady(withCustomObject customObject: Any, info: [AnyHashable: Any]) -> Bool {
        // 检查广告是否就绪
        // 实际实现中应根据广告网络的具体方法进行检查
        NSLog("%@: adReady",AlxTopOnInterstitialAdapter.TAG)
        if customObject as? AlxInterstitialAd != nil {
            NSLog("%@: adReady true",AlxTopOnInterstitialAdapter.TAG)
            return true
        }else{
            NSLog("%@: adReady false",AlxTopOnInterstitialAdapter.TAG)
            return false
        }
    }
    
    // MARK: - 广告展示
    @objc(showInterstitial:inViewController:delegate:)
    public static func showInterstitial(_ interstitial: ATInterstitial,
                                       in viewController: UIViewController,
                                       delegate: ATInterstitialDelegate) {
        NSLog("%@: showInterstitial",AlxTopOnInterstitialAdapter.TAG)
        guard let interstitialAd = (interstitial.customObject as? AlxInterstitialAd) else {
            NSLog("%@: showInterstitial: interstitialAd object is nil",AlxTopOnInterstitialAdapter.TAG)
            return
        }
        interstitial.customEvent.delegate = delegate
        if interstitialAd.isReady() {
            interstitialAd.showAd(present: viewController)
        }
    }
}
