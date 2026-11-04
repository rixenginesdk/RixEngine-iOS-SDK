//
//  AlxTopOnRewardVideoEvent.swift
//

import Foundation
import AnyThinkSDK
//import AnyThinkRewardedVideo
import AlxAds

@objc(AlxTopOnRewardVideoEvent)
public class AlxTopOnRewardVideoEvent: ATRewardedVideoCustomEvent,AlxRewardVideoAdDelegate {
    
    private static let TAG = "AlxTopOnRewardVideoEvent"
    
    private var isRewarded:Bool = false
    
    public override init(info serverInfo: [AnyHashable : Any], localInfo: [AnyHashable : Any]) {
        super.init(info: serverInfo, localInfo: localInfo)
    }
    
    public func rewardVideoAdLoad(_ ad: AlxRewardVideoAd) {
        print("\(AlxTopOnRewardVideoEvent.TAG): rewardVideoAdLoad")
        if self.isC2SBiding {
            AlxTopOnBiddingRequestManager.disposeLoadSuccess(price: ad.getPrice(), unitID: AlxTopOnBaseManager.parseUnitID(from: self.serverInfo))
            self.isC2SBiding = false
        }else{
            self.trackRewardedVideoAdLoaded(ad, adExtra: nil)
        }
    }
    
    public func rewardVideoAdFailToLoad(_ ad: AlxRewardVideoAd, didFailWithError error: Error) {
        print("\(AlxTopOnRewardVideoEvent.TAG): rewardVideoAdFailToLoad")
        if self.isC2SBiding {
            AlxTopOnBiddingRequestManager.disposeLoadFail(error: error, unitID: AlxTopOnBaseManager.parseUnitID(from: self.serverInfo))
        }else{
            self.trackRewardedVideoAdLoadFailed(error)
        }
    }
    
    public func rewardVideoAdImpression(_ ad: AlxRewardVideoAd) {
        print("\(AlxTopOnRewardVideoEvent.TAG): rewardVideoAdImpression")
        self.trackRewardedVideoAdShow()
    }
    
    public func rewardVideoAdClick(_ ad: AlxRewardVideoAd) {
        print("\(AlxTopOnRewardVideoEvent.TAG): rewardVideoAdClick")
        self.trackRewardedVideoAdClick()
    }
    
    public func rewardVideoAdClose(_ ad: AlxRewardVideoAd) {
        print("\(AlxTopOnRewardVideoEvent.TAG): rewardVideoAdClose")
        //let closeType: ATAdCloseType = .unknow
        //self.trackRewardedVideoAdCloseRewarded(isRewarded, extra: [kATADDelegateExtraDismissTypeKey:closeType])
        self.trackRewardedVideoAdCloseRewarded(isRewarded)
    }
    
    public func rewardVideoAdPlayStart(_ ad:AlxRewardVideoAd) {
        print("\(AlxTopOnRewardVideoEvent.TAG): rewardVideoAdPlayStart")
        self.trackRewardedVideoAdVideoStart()
    }
    
    public func rewardVideoAdPlayEnd(_ ad: AlxRewardVideoAd) {
        print("\(AlxTopOnRewardVideoEvent.TAG): rewardVideoAdPlayEnd")
        self.trackRewardedVideoAdVideoEnd()
    }
    
    public func rewardVideoAdReward(_ ad: AlxRewardVideoAd) {
        print("\(AlxTopOnRewardVideoEvent.TAG): rewardVideoAdReward")
        self.isRewarded = true
        self.trackRewardedVideoAdRewarded()
    }
    
    public func rewardVideoAdPlayFail(_ ad: AlxRewardVideoAd, didFailWithError error: Error) {
        print("\(AlxTopOnRewardVideoEvent.TAG): rewardVideoAdPlayFail")
        self.trackRewardedVideoAdPlayWithError(error)
    }
    
    public override var networkUnitId: String {
        get {
            return AlxTopOnBaseManager.parseUnitID(from: self.serverInfo) ?? ""
        }
        set {
        }
    }
    
    deinit {
        print("\(AlxTopOnRewardVideoEvent.TAG): deinit")
    }
    
}
