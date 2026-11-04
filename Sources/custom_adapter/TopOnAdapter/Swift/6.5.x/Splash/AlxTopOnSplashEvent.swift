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
        print("\(AlxTopOnSplashEvent.TAG): splashAdDidLoad")
        if self.isC2SBiding {
            AlxTopOnBiddingRequestManager.disposeLoadSuccess(price: ad.getPrice(), unitID: AlxTopOnBaseManager.parseUnitID(from: self.serverInfo))
            self.isC2SBiding = false
        } else {
            var adExtra: [AnyHashable: Any] = [:]
            adExtra[kATAdAssetsCustomObjectKey] = ad
            self.trackSplashAdLoaded(adExtra)
        }
    }
    
    public func splashAdDidFailToLoad(_ ad: AlxSplashAd, didFailWithError error: Error) {
        print("\(AlxTopOnSplashEvent.TAG): splashAdDidFailToLoad: \(error.localizedDescription)")
        if self.isC2SBiding {
            AlxTopOnBiddingRequestManager.disposeLoadFail(error: error, unitID: AlxTopOnBaseManager.parseUnitID(from: self.serverInfo))
        } else {
            self.trackSplashAdLoadFailed(error)
        }
    }
    
    public func splashAdDidShow(_ ad: AlxSplashAd) {
        print("\(AlxTopOnSplashEvent.TAG): splashAdDidShow")
        self.trackSplashAdShow()
    }
    
    public func splashAdDidClick(_ ad: AlxSplashAd) {
        print("\(AlxTopOnSplashEvent.TAG): splashAdDidClick")
        self.trackSplashAdClick()
    }
    
    public func splashAdDidClose(_ ad: AlxSplashAd) {
        print("\(AlxTopOnSplashEvent.TAG): splashAdDidClose")
        self.trackSplashAdClosed(nil)
    }
    
    public func splashAdRenderDidFail(_ ad: AlxSplashAd, didFailWithError error: Error) {
        print("\(AlxTopOnSplashEvent.TAG): splashAdRenderDidFail: \(error.localizedDescription)")
    }
    
    public func splashAdCountdown(_ ad: AlxSplashAd, countdown: Int) {
        print("\(AlxTopOnSplashEvent.TAG): splashAdCountdown: \(countdown)")
        self.trackSplashAdCountdownTime(countdown)
    }
    
    public override var networkUnitId: String {
        get {
            return AlxTopOnBaseManager.parseUnitID(from: self.serverInfo) ?? ""
        }
        set {
        }
    }
    
    deinit {
        print("\(AlxTopOnSplashEvent.TAG): deinit")
    }
}
