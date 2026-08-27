//
//  AlxTopOnInterstitialDelegate.swift
//  AlxAdsDemo
//

import Foundation
import AnyThinkSDK
import AlxAds

@objc(AlxTopOnInterstitialDelegate)
public class AlxTopOnInterstitialDelegate: NSObject, AlxInterstitialAdDelegate {
    
    private static let TAG = "AlxTopOnInterstitialDelegate"
    
    @objc public var adStatusBridge: ATInterstitialAdStatusBridge?
    @objc public weak var interstitialAd: AlxInterstitialAd?
    
    // MARK: - AlxInterstitialAdDelegate
    
    public func interstitialAdLoad(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdLoad", AlxTopOnInterstitialDelegate.TAG)
        
        // 保存广告对象引用 / Save the ad object reference
        self.interstitialAd = ad
        
        // 获取价格（用于 C2S Bidding）/ Get price (for C2S Bidding)
        let price = ad.getPrice()
        var adExtra: [AnyHashable: Any] = [:]
        
        if price > 0 {
            let priceStr = String(format: "%.2f", price)
            adExtra[ATAdSendC2SBidPriceKey] = priceStr
            adExtra[ATAdSendC2SCurrencyTypeKey] = NSNumber(value: 1) // US Dollar
            NSLog("%@: interstitialAdLoad: price = %@", AlxTopOnInterstitialDelegate.TAG, priceStr)
        }
        
        // 关键：将广告对象传给 TopOn SDK / Key: pass the ad object to TopOn SDK
        adExtra[kATAdAssetsCustomObjectKey] = ad
        
        // 调用 adStatusBridge 通知加载成功 / Call adStatusBridge to notify load success
        self.notifyInterstitialLoaded(adExtra: adExtra)
    }
    
    public func interstitialAdFailToLoad(_ ad: AlxInterstitialAd, didFailWithError error: Error) {
        NSLog("%@: interstitialAdFailToLoad: %@", AlxTopOnInterstitialDelegate.TAG, error.localizedDescription)
        self.notifyLoadFailed(error: error)
    }
    
    public func interstitialAdImpression(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdImpression", AlxTopOnInterstitialDelegate.TAG)
        self.notifyAdShow()
    }
    
    public func interstitialAdClick(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdClick", AlxTopOnInterstitialDelegate.TAG)
        self.notifyAdClick()
    }
    
    public func interstitialAdClose(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdClose", AlxTopOnInterstitialDelegate.TAG)
        self.notifyAdClosed()
    }
    
    public func interstitialAdRenderFail(_ ad: AlxInterstitialAd, didFailWithError error: Error) {
        NSLog("%@: interstitialAdRenderFail: %@", AlxTopOnInterstitialDelegate.TAG, error.localizedDescription)
        self.notifyAdShowFailed(error: error)
    }
    
    public func interstitialAdVideoStart(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdVideoStart", AlxTopOnInterstitialDelegate.TAG)
        self.notifyVideoStart()
    }
    
    public func interstitialAdVideoEnd(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdVideoEnd", AlxTopOnInterstitialDelegate.TAG)
        self.notifyVideoEnd()
    }
    
    // MARK: - Dynamic Invocation Helper Methods
    
    private func notifyInterstitialLoaded(adExtra: [AnyHashable: Any]) {
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnInterstitialAdLoadedExtra:")
            if bridge.responds(to: selector) {
                bridge.perform(selector, with: adExtra)
            }
        }
    }
    
    private func notifyLoadFailed(error: Error) {
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnAdLoadFailed:adExtra:")
            if bridge.responds(to: selector) {
                let emptyDict: [AnyHashable: Any] = [:]
                bridge.perform(selector, with: error, with: emptyDict)
            }
        }
    }
    
    private func notifyAdShow() {
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnAdShow:")
            if bridge.responds(to: selector) {
                let emptyDict: [AnyHashable: Any] = [:]
                bridge.perform(selector, with: emptyDict)
            }
        }
    }
    
    private func notifyAdClick() {
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnAdClick:")
            if bridge.responds(to: selector) {
                let emptyDict: [AnyHashable: Any] = [:]
                bridge.perform(selector, with: emptyDict)
            }
        }
    }
    
    private func notifyAdClosed() {
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnAdClosed:")
            if bridge.responds(to: selector) {
                let emptyDict: [AnyHashable: Any] = [:]
                bridge.perform(selector, with: emptyDict)
            }
        }
    }
    
    private func notifyAdShowFailed(error: Error) {
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnAdShowFailed:extra:")
            if bridge.responds(to: selector) {
                let emptyDict: [AnyHashable: Any] = [:]
                bridge.perform(selector, with: error, with: emptyDict)
            }
        }
    }
    
    private func notifyVideoStart() {
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnAdVideoStart:")
            if bridge.responds(to: selector) {
                let emptyDict: [AnyHashable: Any] = [:]
                bridge.perform(selector, with: emptyDict)
            }
        }
    }
    
    private func notifyVideoEnd() {
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnAdVideoEnd:")
            if bridge.responds(to: selector) {
                let emptyDict: [AnyHashable: Any] = [:]
                bridge.perform(selector, with: emptyDict)
            }
        }
    }
}
