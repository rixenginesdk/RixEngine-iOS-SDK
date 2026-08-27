//
//  AlxTopOnBannerEvent.swift
//

import Foundation
import AnyThinkSDK
import AnyThinkBanner
import AlxAds

@objc(AlxTopOnBannerEvent)
public class AlxTopOnBannerEvent: ATBannerCustomEvent,AlxBannerViewAdDelegate {
    
    private static let TAG = "AlxTopOnBannerEvent"
    
    public override init(info serverInfo: [AnyHashable : Any], localInfo: [AnyHashable : Any]) {
        super.init(info: serverInfo, localInfo: localInfo)
    }
    
    public func bannerViewAdLoad(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdLoad",AlxTopOnBannerEvent.TAG)
        if self.isC2SBiding {
            AlxTopOnBiddingRequestManager.disposeLoadSuccess(price: bannerView.getPrice(), unitID: self.serverInfo[AlxTopOnBaseManager.unitID] as? String)
            self.isC2SBiding = false
        }else{
            self.trackBannerAdLoaded(bannerView, adExtra: nil)
        }
    }
    
    public func bannerViewAdFailToLoad(_ bannerView: AlxBannerAdView, didFailWithError error: Error){
        NSLog("%@: bannerViewAdFailToLoad: %@",AlxTopOnBannerEvent.TAG,error.localizedDescription)
        if self.isC2SBiding {
            AlxTopOnBiddingRequestManager.disposeLoadFail(error: error, unitID: self.serverInfo[AlxTopOnBaseManager.unitID] as? String)
        }else{
            self.trackBannerAdLoadFailed(error)
        }
    }
    
    public func bannerViewAdImpression(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdImpression",AlxTopOnBannerEvent.TAG)
        self.trackBannerAdImpression()
    }
    
    public func bannerViewAdClick(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdClick",AlxTopOnBannerEvent.TAG)
        self.trackBannerAdClick()
    }
    
    public func bannerViewAdClose(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdClose",AlxTopOnBannerEvent.TAG)
        self.trackBannerAdClosed()
    }
    
    public override var networkUnitId: String {
        get {
            return self.serverInfo[AlxTopOnBaseManager.unitID] as? String ?? ""
        }
        set {
        }
    }
}
