//
//  AlxTopOnBannerAdapter.swift
//

import Foundation
import AnyThinkSDK
import AnyThinkBanner
import AlxAds

@objc(AlxTopOnBannerAdapter)
public class AlxTopOnBannerAdapter: ATAdAdapter {
    
    private static let TAG = "AlxTopOnBannerAdapter"
    
    private var bannerAd:AlxBannerAdView? = nil
    private var customEvent:AlxTopOnBannerEvent? = nil
    
    // MARK: - Initialization
    @objc public required init(networkCustomInfo serverInfo: [AnyHashable: Any],
                        localInfo: [AnyHashable: Any]) {
        super.init()
        NSLog("%@: init",AlxTopOnBannerAdapter.TAG)
        NSLog("%@: init: isMainThread=%@",AlxTopOnBannerAdapter.TAG,Thread.current.isMainThread ? "YES" : "NO")
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
        NSLog("%@: loadAD",AlxTopOnBannerAdapter.TAG)
        NSLog("%@: loadAD: isMainThread=%@",AlxTopOnBannerAdapter.TAG,Thread.current.isMainThread ? "YES" : "NO")
        
        let bidId:String? = serverInfo[kATAdapterCustomInfoBuyeruIdKey] as? String
        NSLog("%@: loadAD: bidId=%@",AlxTopOnBannerAdapter.TAG,bidId ?? "空")
        
        DispatchQueue.main.async {
            if !AlxTopOnBaseManager.isInitialized {
                AlxTopOnBaseManager.initSDK(serverInfo: serverInfo)
            }
            
            let bidId=serverInfo[kATAdapterCustomInfoBuyeruIdKey] as? String
            NSLog("%@: loadAD: bidId=%@",AlxTopOnBannerAdapter.TAG,bidId ?? "")
            
            guard let unitId = serverInfo[AlxTopOnBaseManager.unitID] as? String,!unitId.isEmpty else{
                let errorStr="unitid is empty"
                NSLog("%@: loadAD: error= %@",AlxTopOnBannerAdapter.TAG,errorStr)
                completion(nil,AlxTopOnBaseManager.error(code: -100, msg: errorStr))
                return
            }
            
            NSLog("%@: loadAD: unitid=%@",AlxTopOnBannerAdapter.TAG,unitId)
            
            if bidId != nil {
                let request:AlxTopOnBiddingRequest? = AlxTopOnTool.shared.getRequestItem(withUnitID: unitId) as? AlxTopOnBiddingRequest
                if let request = request {
                    self.customEvent = request.customEvent as? AlxTopOnBannerEvent
                    self.customEvent?.requestCompletionBlock = completion
                    self.bannerAd = request.customObject as? AlxBannerAdView
                    //判断广告源是否已经loaded过
                    if let bannerAd = self.bannerAd {
                        self.customEvent?.trackBannerAdLoaded(bannerAd, adExtra: nil)
                    }else{
                        NSLog("%@: loadAD: bid ad object is empty",AlxTopOnBannerAdapter.TAG)
                    }
                }
                AlxTopOnTool.shared.removeRequestItem(withUnitID: unitId)
            }else{
                
                self.customEvent = AlxTopOnBannerEvent(info: serverInfo, localInfo: localInfo)
                self.customEvent?.requestCompletionBlock = completion
                
                // 提取广告尺寸信息
                var adSize = CGSize(width: 320, height: 50)
                let unitGroupModel:ATUnitGroupModel? = serverInfo[kATAdapterCustomInfoUnitGroupModelKey] as? ATUnitGroupModel
                if let unitGroupModel = unitGroupModel {
                    adSize = unitGroupModel.adSize
                    NSLog("%@: loadAD: width=%.2f , height=%.2f",AlxTopOnBannerAdapter.TAG,adSize.width,adSize.height)
                }
                
                // load ad
                self.bannerAd=AlxBannerAdView(frame: CGRect(origin: .zero, size: adSize))
                self.bannerAd?.delegate = self.customEvent
                self.bannerAd?.refreshInterval = 0
                self.bannerAd?.translatesAutoresizingMaskIntoConstraints = false
                self.bannerAd?.loadAd(adUnitId: unitId)
            }
        }
        
    }
    
    // MARK: - C2S header bidding 竞价
    @objc public static func bidRequestWithPlacementModel(_ placementModel: ATPlacementModel,unitGroupModel: ATUnitGroupModel, info: [AnyHashable: Any], completion: @escaping (ATBidInfo?, Error?) -> Void) {
        NSLog("%@: bidRequestWithPlacementModel",AlxTopOnBannerAdapter.TAG)
        
        DispatchQueue.main.async {
            if !AlxTopOnBaseManager.isInitialized {
                AlxTopOnBaseManager.initSDK(serverInfo: info)
            }
        }
        
        let customEvent:AlxTopOnBannerEvent = AlxTopOnBannerEvent(info: info, localInfo: info)
        customEvent.isC2SBiding = true
        let request:AlxTopOnBiddingRequest = AlxTopOnBiddingRequest(
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
        // 检查广告是否就绪
        // 实际实现中应根据广告网络的具体方法进行检查
        NSLog("%@: adReady",AlxTopOnBannerAdapter.TAG)
        if customObject as? AlxBannerAdView != nil {
            NSLog("%@: adReady true",AlxTopOnBannerAdapter.TAG)
            return true
        }else{
            NSLog("%@: adReady false",AlxTopOnBannerAdapter.TAG)
            return false
        }
    }
    
    // MARK: - 广告展示
    @objc(showBanner:inView:presentingViewController:)
    public static func showBanner(_ banner: ATBanner, in view: UIView, presenting viewController: UIViewController) {
        // 清空容器视图
        NSLog("%@: showBanner",AlxTopOnBannerAdapter.TAG)
        guard let bannerView = (banner.customObject as? AlxBannerAdView) else {
            NSLog("%@: showBanner banner is nil",AlxTopOnBannerAdapter.TAG)
            return
        }
        bannerView.rootViewController = viewController
        view.subviews.forEach { $0.removeFromSuperview() }
        view.addSubview(bannerView)
    }
    
}
