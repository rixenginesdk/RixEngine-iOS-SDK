//
//  AlxInterstitialAdDelegate.swift
//  AlxAds
//
//  Created by liu weile on 2025/4/25.
//

import Foundation

@objc public protocol AlxInterstitialAdDelegate : NSObjectProtocol{
    
    @objc func interstitialAdLoad(_ ad:AlxInterstitialAd)
    
    @objc func interstitialAdFailToLoad(_ ad:AlxInterstitialAd,didFailWithError error:Error)
    
    @objc optional func interstitialAdImpression(_ ad:AlxInterstitialAd)
    
    @objc optional func interstitialAdClick(_ ad:AlxInterstitialAd)
    
    @objc optional func interstitialAdClose(_ ad:AlxInterstitialAd)
    
    /**
     广告渲染失败【包含：视频播放失败、web失败等】
     */
    @objc optional func interstitialAdRenderFail(_ ad:AlxInterstitialAd,didFailWithError error:Error)
    
    @objc optional func interstitialAdVideoStart(_ ad:AlxInterstitialAd)
    
    @objc optional func interstitialAdVideoEnd(_ ad:AlxInterstitialAd)
    
}
