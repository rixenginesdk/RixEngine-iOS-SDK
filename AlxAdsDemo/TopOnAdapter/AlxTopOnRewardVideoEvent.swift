//
//  AlxTopOnRewardVideoEvent.swift
//

import Foundation
import AnyThinkSDK
import AnyThinkRewardedVideo
import AlxAds

@objc(AlxTopOnRewardVideoEvent)
public class AlxTopOnRewardVideoEvent: ATRewardedVideoCustomEvent,AlxRewardVideoAdDelegate {
    
    private static let TAG = "AlxTopOnRewardVideoEvent"
    
    private var isRewarded:Bool = false
    
    public override init(info serverInfo: [AnyHashable : Any], localInfo: [AnyHashable : Any]) {
        super.init(info: serverInfo, localInfo: localInfo)
    }
    
    public func rewardVideoAdLoad(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdLoad",AlxTopOnRewardVideoEvent.TAG)
        if self.isC2SBiding {
            AlxTopOnBiddingRequestManager.disposeLoadSuccess(price: ad.getPrice(), unitID: self.serverInfo[AlxTopOnBaseManager.unitID] as? String)
            self.isC2SBiding = false
        }else{
            self.trackRewardedVideoAdLoaded(ad, adExtra: nil)
        }
    }
    
    public func rewardVideoAdFailToLoad(_ ad: AlxRewardVideoAd, didFailWithError error: Error) {
        NSLog("%@: rewardVideoAdFailToLoad",AlxTopOnRewardVideoEvent.TAG)
        if self.isC2SBiding {
            AlxTopOnBiddingRequestManager.disposeLoadFail(error: error, unitID: self.serverInfo[AlxTopOnBaseManager.unitID] as? String)
        }else{
            self.trackRewardedVideoAdLoadFailed(error)
        }
    }
    
    public func rewardVideoAdImpression(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdImpression",AlxTopOnRewardVideoEvent.TAG)
        self.trackRewardedVideoAdShow()
    }
    
    public func rewardVideoAdClick(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdClick",AlxTopOnRewardVideoEvent.TAG)
        self.trackRewardedVideoAdClick()
    }
    
    public func rewardVideoAdClose(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdClose",AlxTopOnRewardVideoEvent.TAG)
        let closeType:ATAdCloseType = .unknow
        self.trackRewardedVideoAdCloseRewarded(isRewarded, extra: [kATADDelegateExtraDismissTypeKey:closeType])
    }
    
    public func rewardVideoAdPlayStart(_ ad:AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdPlayStart",AlxTopOnRewardVideoEvent.TAG)
        self.trackRewardedVideoAdVideoStart()
    }
    
    public func rewardVideoAdPlayEnd(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdPlayEnd",AlxTopOnRewardVideoEvent.TAG)
        self.trackRewardedVideoAdVideoEnd()
    }
    
    public func rewardVideoAdReward(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdReward",AlxTopOnRewardVideoEvent.TAG)
        self.isRewarded = true
        self.trackRewardedVideoAdRewarded()
    }
    
    public func rewardVideoAdPlayFail(_ ad: AlxRewardVideoAd, didFailWithError error: Error) {
        NSLog("%@: rewardVideoAdPlayFail",AlxTopOnRewardVideoEvent.TAG)
        self.trackRewardedVideoAdPlayWithError(error)
    }
    
    public override var networkUnitId: String {
        get {
            return self.serverInfo[AlxTopOnBaseManager.unitID] as? String ?? ""
        }
        set {
        }
    }
    
    deinit {
        NSLog("%@: deinit",AlxTopOnRewardVideoEvent.TAG)
    }
    
}
