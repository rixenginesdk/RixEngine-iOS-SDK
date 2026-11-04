//
//  AlxTopOnBannerEvent.swift
//

import Foundation
import AnyThinkSDK
//import AnyThinkBanner
import AlxAds

@objc(AlxTopOnBannerEvent)
public class AlxTopOnBannerEvent: ATBannerCustomEvent,AlxBannerViewAdDelegate {
    
    private static let TAG = "AlxTopOnBannerEvent"
    
    public override init(info serverInfo: [AnyHashable : Any], localInfo: [AnyHashable : Any]) {
        super.init(info: serverInfo, localInfo: localInfo)
    }
    
    public func bannerViewAdLoad(_ bannerView: AlxBannerAdView) {
        print("\(AlxTopOnBannerEvent.TAG): bannerViewAdLoad")
        if self.isC2SBiding {
            AlxTopOnBiddingRequestManager.disposeLoadSuccess(price: bannerView.getPrice(), unitID: AlxTopOnBaseManager.parseUnitID(from: self.serverInfo))
            self.isC2SBiding = false
        }else{
            self.trackBannerAdLoaded(bannerView, adExtra: nil)
        }
    }
    
    public func bannerViewAdFailToLoad(_ bannerView: AlxBannerAdView, didFailWithError error: Error){
        print("\(AlxTopOnBannerEvent.TAG): bannerViewAdFailToLoad: \(error.localizedDescription)")
        if self.isC2SBiding {
            AlxTopOnBiddingRequestManager.disposeLoadFail(error: error, unitID: AlxTopOnBaseManager.parseUnitID(from: self.serverInfo))
        }else{
            self.trackBannerAdLoadFailed(error)
        }
    }
    
    /// callback to developer when ad is Impression
    public func bannerViewAdImpression(_ bannerView: AlxBannerAdView) {
        print("\(AlxTopOnBannerEvent.TAG): bannerViewAdImpression")
        self.trackBannerAdImpression()
    }
    
    public func bannerViewAdClick(_ bannerView: AlxBannerAdView) {
        print("\(AlxTopOnBannerEvent.TAG): bannerViewAdClick")
        self.trackBannerAdClick()
    }
    
    public func bannerViewAdClose(_ bannerView: AlxBannerAdView) {
        print("\(AlxTopOnBannerEvent.TAG): bannerViewAdClose")
        self.trackBannerAdClosed()
    }
    
    public override var networkUnitId: String {
        get {
            return AlxTopOnBaseManager.parseUnitID(from: self.serverInfo) ?? ""
        }
        set {
        }
    }
}
