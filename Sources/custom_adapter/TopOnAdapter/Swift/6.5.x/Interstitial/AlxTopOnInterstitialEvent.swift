//
//  AlxTopOnInterstitialEvent.swift
//

import Foundation
import AnyThinkSDK
//import AnyThinkInterstitial
import AlxAds

@objc(AlxTopOnInterstitialEvent)
public class AlxTopOnInterstitialEvent: ATInterstitialCustomEvent,AlxInterstitialAdDelegate {
    
    private static let TAG = "AlxTopOnInterstitialEvent"
    
    public override init(info serverInfo: [AnyHashable : Any], localInfo: [AnyHashable : Any]) {
        super.init(info: serverInfo, localInfo: localInfo)
    }
    
    public func interstitialAdLoad(_ ad: AlxInterstitialAd) {
        print("\(AlxTopOnInterstitialEvent.TAG): interstitialAdLoad")
        if self.isC2SBiding {
            AlxTopOnBiddingRequestManager.disposeLoadSuccess(price: ad.getPrice(), unitID: AlxTopOnBaseManager.parseUnitID(from: self.serverInfo))
            self.isC2SBiding = false
        }else{
            self.trackInterstitialAdLoaded(ad, adExtra: nil)
        }
    }
    
    public func interstitialAdFailToLoad(_ ad: AlxInterstitialAd, didFailWithError error: Error) {
        print("\(AlxTopOnInterstitialEvent.TAG): interstitialAdFailToLoad : \(error.localizedDescription)")
        if self.isC2SBiding {
            AlxTopOnBiddingRequestManager.disposeLoadFail(error: error, unitID: AlxTopOnBaseManager.parseUnitID(from: self.serverInfo))
        }else{
            self.trackInterstitialAdLoadFailed(error)
        }
    }
    
    public func interstitialAdImpression(_ ad: AlxInterstitialAd) {
        print("\(AlxTopOnInterstitialEvent.TAG): interstitialAdImpression")
        self.trackInterstitialAdShow()
    }
    
    public func interstitialAdClick(_ ad: AlxInterstitialAd) {
        print("\(AlxTopOnInterstitialEvent.TAG): interstitialAdClick")
        self.trackInterstitialAdClick()
    }
    
    public func interstitialAdClose(_ ad: AlxInterstitialAd) {
        print("\(AlxTopOnInterstitialEvent.TAG): interstitialAdClose")
        self.trackInterstitialAdClose(nil)
    }
    
    public func interstitialAdRenderFail(_ ad: AlxInterstitialAd, didFailWithError error: Error) {
        print("\(AlxTopOnInterstitialEvent.TAG): interstitialAdRenderFail")
    }
    
    public func interstitialAdVideoStart(_ ad: AlxInterstitialAd) {
        print("\(AlxTopOnInterstitialEvent.TAG): interstitialAdVideoStart")
        self.trackInterstitialAdVideoStart()
    }
    
    public func interstitialAdVideoEnd(_ ad: AlxInterstitialAd) {
        print("\(AlxTopOnInterstitialEvent.TAG): interstitialAdVideoEnd")
        self.trackInterstitialAdVideoEnd()
    }
    
    public override var networkUnitId: String {
        get {
            return AlxTopOnBaseManager.parseUnitID(from: self.serverInfo) ?? ""
        }
        set {
        }
    }
    
    deinit {
        print("\(AlxTopOnInterstitialEvent.TAG): deinit")
    }
    
}
