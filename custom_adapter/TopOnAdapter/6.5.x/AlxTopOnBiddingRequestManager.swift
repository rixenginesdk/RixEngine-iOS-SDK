//
//  AlxTopOnBiddingRequestManager.swift
//

import Foundation
import AnyThinkSDK
import AlxAds

@objc(AlxTopOnBiddingRequestManager)
public class AlxTopOnBiddingRequestManager:NSObject {
    
    private static let TAG = "AlxTopOnBiddingRequestManager"
    
    // MARK: - 单例
    static let shared = AlxTopOnBiddingRequestManager()
   
    private override init() {
       super.init()
    }
   
    // MARK: - 启动竞价请求
    func start(with request: AlxTopOnBiddingRequest) {
       DispatchQueue.main.async {
           switch request.adType {
               case .interstitial:
                   self.startLoadInterstitialAd(with: request)
               case .rewardedVideo:
                   self.startLoadRewardedVideoAd(with: request)
               case .native:
                   self.startLoadNativeAd(with: request)
               case .banner:
                   self.startLoadBannerAd(with: request)
               default:
                   break
           }
       }
    }
    
    private func startLoadInterstitialAd(with request:AlxTopOnBiddingRequest){
        guard let unitID = request.unitID,!unitID.isEmpty else{
            let errorStr="unitid is empty"
            NSLog("%@: startLoadInterstitialAd: error= %@",AlxTopOnBiddingRequestManager.TAG,errorStr)
            request.bidCompletion?(nil,AlxTopOnBaseManager.error(code: -100, msg: "unitId is empty"))
            return
        }
        NSLog("%@: startLoadInterstitialAd: unitid=%@",AlxTopOnBiddingRequestManager.TAG,unitID)
        
        guard let customEvent = request.customEvent as? AlxTopOnInterstitialEvent else{
            NSLog("%@: startLoadInterstitialAd: customEvent is empty",AlxTopOnBiddingRequestManager.TAG)
            request.bidCompletion?(nil,AlxTopOnBaseManager.error(code: -100, msg: "customEvent object is empty"))
            return
        }
        
        // load ad
        let interstitialAd = AlxInterstitialAd()
        interstitialAd.delegate = customEvent
        
        // 缓存
        request.customObject = interstitialAd
        AlxTopOnTool.shared.saveRequestItem(request,withUnitId: unitID)
        
        interstitialAd.loadAd(adUnitId: unitID)
    }
    
    private func startLoadRewardedVideoAd(with request:AlxTopOnBiddingRequest){
        guard let unitID = request.unitID,!unitID.isEmpty else{
            let errorStr="unitid is empty"
            NSLog("%@: startLoadRewardedVideoAd: error= %@",AlxTopOnBiddingRequestManager.TAG,errorStr)
            request.bidCompletion?(nil,AlxTopOnBaseManager.error(code: -100, msg: "unitId is empty"))
            return
        }
        NSLog("%@: startLoadRewardedVideoAd: unitid=%@",AlxTopOnBiddingRequestManager.TAG,unitID)
        
        guard let customEvent = request.customEvent as? AlxTopOnRewardVideoEvent else{
            NSLog("%@: startLoadRewardedVideoAd: customEvent is empty",AlxTopOnBiddingRequestManager.TAG)
            request.bidCompletion?(nil,AlxTopOnBaseManager.error(code: -100, msg: "customEvent object is empty"))
            return
        }
        
        // load ad
        let rewardedAd = AlxRewardVideoAd()
        rewardedAd.delegate = customEvent
        
        // 缓存
        request.customObject = rewardedAd
        AlxTopOnTool.shared.saveRequestItem(request,withUnitId: unitID)
        
        rewardedAd.loadAd(adUnitId: unitID)
    }
    
    private func startLoadNativeAd(with request:AlxTopOnBiddingRequest){
        guard let unitID = request.unitID,!unitID.isEmpty else{
            let errorStr="unitid is empty"
            NSLog("%@: startLoadNativeAd: error= %@",AlxTopOnBiddingRequestManager.TAG,errorStr)
            request.bidCompletion?(nil,AlxTopOnBaseManager.error(code: -100, msg: "unitId is empty"))
            return
        }
        NSLog("%@: startLoadNativeAd: unitid=%@",AlxTopOnBiddingRequestManager.TAG,unitID)
        
        guard let customEvent = request.customEvent as? AlxTopOnNativeEvent else{
            NSLog("%@: startLoadNativeAd: customEvent is empty",AlxTopOnBiddingRequestManager.TAG)
            request.bidCompletion?(nil,AlxTopOnBaseManager.error(code: -100, msg: "customEvent object is empty"))
            return
        }
        
        // load ad
        let nativeAd = AlxNativeAdLoader(adUnitID: unitID)
        nativeAd.delegate = customEvent
        
        // 缓存
        request.customObject = nativeAd
        AlxTopOnTool.shared.saveRequestItem(request,withUnitId: unitID)
        
        nativeAd.loadAd()
    }
    
    private func startLoadBannerAd(with request:AlxTopOnBiddingRequest){
        guard let unitID = request.unitID,!unitID.isEmpty else{
            let errorStr="unitid is empty"
            NSLog("%@: startLoadBannerAd: error= %@",AlxTopOnBiddingRequestManager.TAG,errorStr)
            request.bidCompletion?(nil,AlxTopOnBaseManager.error(code: -100, msg: "unitId is empty"))
            return
        }
        NSLog("%@: startLoadBannerAd: unitid=%@",AlxTopOnBiddingRequestManager.TAG,unitID)
        
        guard let customEvent = request.customEvent as? AlxTopOnBannerEvent else{
            NSLog("%@: startLoadBannerAd: customEvent is empty",AlxTopOnBiddingRequestManager.TAG)
            request.bidCompletion?(nil,AlxTopOnBaseManager.error(code: -100, msg: "customEvent object is empty"))
            return
        }
        
        // 提取广告尺寸信息
        var adSize = CGSize(width: 320, height: 50)
        let unitGroupModel:ATUnitGroupModel? = request.extraInfo[kATAdapterCustomInfoUnitGroupModelKey] as? ATUnitGroupModel
        if let unitGroupModel = unitGroupModel {
            adSize = unitGroupModel.adSize
            NSLog("%@: loadAD: width=%.2f , height=%.2f",AlxTopOnBiddingRequestManager.TAG,adSize.width,adSize.height)
        }
        
        // load ad
        let bannerAd = AlxBannerAdView(frame: CGRect(origin: .zero, size: adSize))
        bannerAd.delegate = customEvent
        bannerAd.refreshInterval = 0
        bannerAd.translatesAutoresizingMaskIntoConstraints = false
        
        // 缓存
        request.customObject = bannerAd
        AlxTopOnTool.shared.saveRequestItem(request,withUnitId: unitID)
        
        bannerAd.loadAd(adUnitId: unitID)
    }
    
    /// 竞价成功回调
    public static func disposeLoadSuccess(price: Double, unitID: String?) {
        NSLog("%@: disposeLoadSuccess",AlxTopOnBiddingRequestManager.TAG)
        let priceStr = String(price)
        
        guard let unitID = unitID else {
            NSLog("%@: disposeLoadSuccess: unitID is empty",AlxTopOnBiddingRequestManager.TAG)
            return
        }

        guard let bidRequest=AlxTopOnTool.shared.getRequestItem(withUnitID: unitID) as? AlxTopOnBiddingRequest else {
            NSLog("%@: disposeLoadSuccess: bidRequest cache no found",AlxTopOnBiddingRequestManager.TAG)
           return
        }
        
        guard let placementID = bidRequest.placementID else {
            bidRequest.bidCompletion?(nil,AlxTopOnBaseManager.error(code: -100, msg: "placementID is empty"))
            AlxTopOnTool.shared.removeRequestItem(withUnitID: unitID)
            return
        }
        
        guard let unitGroupUnitID = bidRequest.unitGroup.unitID else {
            bidRequest.bidCompletion?(nil,AlxTopOnBaseManager.error(code: -100, msg: "ATUnitGroupModel object: unitID is empty"))
            AlxTopOnTool.shared.removeRequestItem(withUnitID: unitID)
            return
        }
        
        guard let adapterClassString = bidRequest.unitGroup.adapterClassString else {
            bidRequest.bidCompletion?(nil,AlxTopOnBaseManager.error(code: -100, msg: "ATUnitGroupModel object: adapterClassString is empty"))
            AlxTopOnTool.shared.removeRequestItem(withUnitID: unitID)
            return
        }
        
        let bidInfo:ATBidInfo = ATBidInfo(c2SWithPlacementID: placementID, unitGroupUnitID: unitGroupUnitID, adapterClassString: adapterClassString, price: priceStr, currencyType: ATBiddingCurrencyType.US, expirationInterval: bidRequest.unitGroup.bidTokenTime, customObject: bidRequest.customObject)
        bidInfo.networkFirmID = bidRequest.unitGroup.networkFirmID
      
        print("\(AlxTopOnBiddingRequestManager.TAG): disposeLoadSuccess: price=\(bidInfo.price)")
        print("\(AlxTopOnBiddingRequestManager.TAG): disposeLoadSuccess: adapterClassString=\(bidInfo.adapterClassString)")
        print("\(AlxTopOnBiddingRequestManager.TAG): disposeLoadSuccess: bidTokenTime=\(bidInfo.expireDate)")
        
        if bidRequest.bidCompletion != nil {
            bidRequest.bidCompletion?(bidInfo, nil)
            NSLog("%@: disposeLoadSuccess: bidCompletion is called successfully",AlxTopOnBiddingRequestManager.TAG)
        }else{
            NSLog("%@: disposeLoadSuccess: bidCompletion is empty",AlxTopOnBiddingRequestManager.TAG)
        }
//        bidRequest.bidCompletion?(bidInfo, nil)
    }

    /// 竞价失败回调
    public static func disposeLoadFail(error: Error, unitID: String?) {
        NSLog("%@: disposeLoadFail",AlxTopOnBiddingRequestManager.TAG)
        guard let unitID = unitID else {
            NSLog("%@: disposeLoadFail: unitID is empty",AlxTopOnBiddingRequestManager.TAG)
            return
        }

        guard let bidRequest=AlxTopOnTool.shared.getRequestItem(withUnitID: unitID) as? AlxTopOnBiddingRequest else {
            NSLog("%@: disposeLoadFail: bidRequest cache no found",AlxTopOnBiddingRequestManager.TAG)
           return
        }
        bidRequest.bidCompletion?(nil,error)
        AlxTopOnTool.shared.removeRequestItem(withUnitID: unitID)
    }
}
