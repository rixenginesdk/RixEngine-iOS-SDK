//
//  AlxRewardVideoAdDelegate.swift
//  AlxAds
//
//  Created by liu weile on 2025/3/31.
//

import Foundation

@objc public protocol AlxRewardVideoAdDelegate : NSObjectProtocol{
    
    @objc func rewardVideoAdLoad(_ ad:AlxRewardVideoAd)
    
    @objc func rewardVideoAdFailToLoad(_ ad:AlxRewardVideoAd,didFailWithError error:Error)
    
    @objc optional func rewardVideoAdImpression(_ ad:AlxRewardVideoAd)
    
    @objc optional func rewardVideoAdClick(_ ad:AlxRewardVideoAd)
    
    @objc optional func rewardVideoAdClose(_ ad:AlxRewardVideoAd)
    
    @objc optional func rewardVideoAdPlayStart(_ ad:AlxRewardVideoAd)
    
    @objc optional func rewardVideoAdPlayEnd(_ ad:AlxRewardVideoAd)
    
    @objc optional func rewardVideoAdReward(_ ad:AlxRewardVideoAd)
    
    @objc optional func rewardVideoAdPlayFail(_ ad:AlxRewardVideoAd,didFailWithError error:Error)
    
}
