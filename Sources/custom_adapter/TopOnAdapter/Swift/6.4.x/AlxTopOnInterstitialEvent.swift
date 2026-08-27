//
//  AlxTopOnInterstitialEvent.swift
//


import Foundation
import AnyThinkSDK
import AnyThinkInterstitial
import AlxAds

@objc(AlxTopOnInterstitialEvent)
public class AlxTopOnInterstitialEvent: ATInterstitialCustomEvent,AlxInterstitialAdDelegate {
    
    private static let TAG = "AlxTopOnInterstitialEvent"
    
    public override init(info serverInfo: [AnyHashable : Any], localInfo: [AnyHashable : Any]) {
        super.init(info: serverInfo, localInfo: localInfo)
    }
    
    public func interstitialAdLoad(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdLoad",AlxTopOnInterstitialEvent.TAG)
        if self.isC2SBiding {
            AlxTopOnBiddingRequestManager.disposeLoadSuccess(price: ad.getPrice(), unitID: self.serverInfo[AlxTopOnBaseManager.unitID] as? String)
            self.isC2SBiding = false
        }else{
            self.trackInterstitialAdLoaded(ad, adExtra: nil)
        }
    }
    
    public func interstitialAdFailToLoad(_ ad: AlxInterstitialAd, didFailWithError error: Error) {
        NSLog("%@: interstitialAdFailToLoad : %@",AlxTopOnInterstitialEvent.TAG,error.localizedDescription)
        if self.isC2SBiding {
            AlxTopOnBiddingRequestManager.disposeLoadFail(error: error, unitID: self.serverInfo[AlxTopOnBaseManager.unitID] as? String)
        }else{
            self.trackInterstitialAdLoadFailed(error)
        }
    }
    
    public func interstitialAdImpression(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdImpression",AlxTopOnInterstitialEvent.TAG)
        self.trackInterstitialAdShow()
    }
    
    public func interstitialAdClick(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdClick",AlxTopOnInterstitialEvent.TAG)
        self.trackInterstitialAdClick()
    }
    
    public func interstitialAdClose(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdClose",AlxTopOnInterstitialEvent.TAG)
        self.trackInterstitialAdClose(nil)
    }
    
    public func interstitialAdRenderFail(_ ad: AlxInterstitialAd, didFailWithError error: Error) {
        NSLog("%@: interstitialAdRenderFail",AlxTopOnInterstitialEvent.TAG)
    }
    
    public func interstitialAdVideoStart(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdVideoStart",AlxTopOnInterstitialEvent.TAG)
        self.trackInterstitialAdVideoStart()
    }
    
    public func interstitialAdVideoEnd(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdVideoEnd",AlxTopOnInterstitialEvent.TAG)
        self.trackInterstitialAdVideoEnd()
    }
    
    public override var networkUnitId: String {
        get {
            return self.serverInfo[AlxTopOnBaseManager.unitID] as? String ?? ""
        }
        set {
        }
    }
    
    deinit {
        NSLog("%@: deinit",AlxTopOnInterstitialEvent.TAG)
    }
    
}
