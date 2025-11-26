//
//  AlxAdmobRewardVideoAdapter.swift
//

import Foundation
import GoogleMobileAds
import AlxAds

@objc(AlxAdmobRewardVideoAdapter)
public class AlxAdmobRewardVideoAdapter:AlxAdmobBaseAdapter,MediationRewardedAd {
    
    private static let TAG = "AlxAdmobRewardVideoAdapter"
    
    private var rewardedAd: AlxRewardVideoAd? = nil
    private var delegate: MediationRewardedAdEventDelegate? = nil
    private var completionHandler: GADMediationRewardedLoadCompletionHandler? = nil
   
    public func loadRewardedAd(for adConfiguration: MediationRewardedAdConfiguration, completionHandler: @escaping GADMediationRewardedLoadCompletionHandler) {
        NSLog("%@: loadRewardedAd",AlxAdmobRewardVideoAdapter.TAG)
        guard let params = AlxAdmobBaseAdapter.parseAdparameter(for: adConfiguration.credentials) else {
            let errorStr="The parameter field is not found in the adConfiguration object"
            NSLog("%@: config params is empty",AlxAdmobRewardVideoAdapter.TAG)
            self.delegate=completionHandler(nil,self.error(code: -100,msg: errorStr))
            return
        }
        
        if !AlxAdmobBaseAdapter.isInitialized {
            AlxAdmobBaseAdapter.initSdk(for: params)
        }
        
        guard let adId = params["unitid"] as? String,!adId.isEmpty else{
            let errorStr="unitid is empty in the parameter configuration"
            NSLog("%@: error: %@",AlxAdmobRewardVideoAdapter.TAG,errorStr)
            self.delegate=completionHandler(nil,self.error(code: -100,msg: errorStr))
            return
        }
        
        NSLog("%@: loadRewardedAd unitid=%@",AlxAdmobRewardVideoAdapter.TAG,adId)
        self.completionHandler = completionHandler
        
        // load ad
        self.rewardedAd = AlxRewardVideoAd()
        self.rewardedAd?.delegate = self
        self.rewardedAd?.loadAd(adUnitId: adId)
    }
    
    public func present(from viewController: UIViewController) {
        NSLog("%@: present",AlxAdmobRewardVideoAdapter.TAG)
        if let rewardedAd = self.rewardedAd,rewardedAd.isReady(){
            rewardedAd.showAd(present: viewController)
        }
    }
    
}

extension AlxAdmobRewardVideoAdapter:AlxRewardVideoAdDelegate{
    
    public func rewardVideoAdLoad(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdLoad",AlxAdmobRewardVideoAdapter.TAG)
        if let handler=self.completionHandler{
            self.delegate=handler(self,nil)
        }
    }
    
    public func rewardVideoAdFailToLoad(_ ad: AlxRewardVideoAd, didFailWithError error: Error) {
        NSLog("%@: rewardVideoAdLoad",AlxAdmobRewardVideoAdapter.TAG)
        if let handler=self.completionHandler{
            self.delegate=handler(nil,error)
        }
    }
    
    public func rewardVideoAdImpression(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdImpression",AlxAdmobRewardVideoAdapter.TAG)
        self.delegate?.willPresentFullScreenView()
        self.delegate?.reportImpression()
    }
    
    public func rewardVideoAdClick(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdClick",AlxAdmobRewardVideoAdapter.TAG)
        self.delegate?.reportClick()
    }
    
    public func rewardVideoAdClose(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdClose",AlxAdmobRewardVideoAdapter.TAG)
        self.delegate?.didDismissFullScreenView()
    }
    
    public func rewardVideoAdPlayStart(_ ad:AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdPlayStart",AlxAdmobRewardVideoAdapter.TAG)
        self.delegate?.didStartVideo()
    }
    
    public func rewardVideoAdPlayEnd(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdPlayEnd",AlxAdmobRewardVideoAdapter.TAG)
        self.delegate?.didEndVideo()
    }
    
    public func rewardVideoAdReward(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdReward",AlxAdmobRewardVideoAdapter.TAG)
        self.delegate?.didRewardUser()
    }
    
    public func rewardVideoAdPlayFail(_ ad: AlxRewardVideoAd, didFailWithError error: Error) {
        NSLog("%@: rewardVideoAdPlayFail",AlxAdmobRewardVideoAdapter.TAG)
    }
    
}
