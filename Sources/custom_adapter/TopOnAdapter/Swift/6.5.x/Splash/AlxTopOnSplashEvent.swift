//
//  AlxTopOnSplashEvent.swift
//  AlxAdsDemo
//

import Foundation
import AnyThinkSDK
import AlxAds

@objc(AlxTopOnSplashEvent)
public class AlxTopOnSplashEvent: ATSplashCustomEvent, AlxSplashAdDelegate {
    
    private static let TAG = "AlxTopOnSplashEvent"
    
    public override init(info serverInfo: [AnyHashable: Any], localInfo: [AnyHashable: Any]) {
        super.init(info: serverInfo, localInfo: localInfo)
    }
    
    public func splashAdDidLoad(_ ad: AlxSplashAd) {
        NSLog("%@: splashAdDidLoad", AlxTopOnSplashEvent.TAG)
        if self.isC2SBiding {
            AlxTopOnBiddingRequestManager.disposeLoadSuccess(price: ad.getPrice(), unitID: self.serverInfo[AlxTopOnBaseManager.unitID] as? String)
            self.isC2SBiding = false
        } else {
            var adExtra: [AnyHashable: Any] = [:]
            adExtra[kATAdAssetsCustomObjectKey] = ad
            self.trackSplashAdLoaded(adExtra)
        }
    }
    
    public func splashAdDidFailToLoad(_ ad: AlxSplashAd, didFailWithError error: Error) {
        NSLog("%@: splashAdDidFailToLoad: %@", AlxTopOnSplashEvent.TAG, error.localizedDescription)
        if self.isC2SBiding {
            AlxTopOnBiddingRequestManager.disposeLoadFail(error: error, unitID: self.serverInfo[AlxTopOnBaseManager.unitID] as? String)
        } else {
            self.trackSplashAdLoadFailed(error)
        }
    }
    
    public func splashAdDidShow(_ ad: AlxSplashAd) {
        NSLog("%@: splashAdDidShow", AlxTopOnSplashEvent.TAG)
        self.trackSplashAdShow()
    }
    
    public func splashAdDidClick(_ ad: AlxSplashAd) {
        NSLog("%@: splashAdDidClick", AlxTopOnSplashEvent.TAG)
        self.trackSplashAdClick()
    }
    
    public func splashAdDidClose(_ ad: AlxSplashAd) {
        NSLog("%@: splashAdDidClose", AlxTopOnSplashEvent.TAG)
        self.trackSplashAdClosed(nil)
    }
    
    public func splashAdRenderDidFail(_ ad: AlxSplashAd, didFailWithError error: Error) {
        NSLog("%@: splashAdRenderDidFail: %@", AlxTopOnSplashEvent.TAG, error.localizedDescription)
    }
    
    public func splashAdCountdown(_ ad: AlxSplashAd, countdown: Int) {
        NSLog("%@: splashAdCountdown: %d", AlxTopOnSplashEvent.TAG, countdown)
        self.trackSplashAdCountdownTime(countdown)
    }
    
    public override var networkUnitId: String {
        get {
            return self.serverInfo[AlxTopOnBaseManager.unitID] as? String ?? ""
        }
        set {
        }
    }
    
    deinit {
        NSLog("%@: deinit", AlxTopOnSplashEvent.TAG)
    }
}
