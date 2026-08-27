//
//  AlxTopOnRewardVideoDelegate.swift
//  AlxAdsDemo
//

import Foundation
import AnyThinkSDK
import AlxAds

@objc(AlxTopOnRewardVideoDelegate)
public class AlxTopOnRewardVideoDelegate: NSObject, AlxRewardVideoAdDelegate {
    
    private static let TAG = "AlxTopOnRewardVideoDelegate"
    
    @objc public var adStatusBridge: ATRewardedAdStatusBridge?
    @objc public weak var rewardedAd: AlxRewardVideoAd?
    
    // MARK: - AlxRewardVideoAdDelegate
    
    public func rewardVideoAdLoad(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdLoad", AlxTopOnRewardVideoDelegate.TAG)
        
        // 保存广告对象引用
        self.rewardedAd = ad
        
        // 获取价格（用于 C2S Bidding）
        let price = ad.getPrice()
        var adExtra: [AnyHashable: Any] = [:]
        
        if price > 0 {
            let priceStr = String(format: "%.2f", price)
            adExtra[ATAdSendC2SBidPriceKey] = priceStr
            adExtra[ATAdSendC2SCurrencyTypeKey] = NSNumber(value: 1) // US Dollar
            NSLog("%@: rewardVideoAdLoad: price = %@", AlxTopOnRewardVideoDelegate.TAG, priceStr)
        }
        
        // 关键：将广告对象传给 TopOn SDK
        adExtra[kATAdAssetsCustomObjectKey] = ad
        
        // 调用 adStatusBridge 通知加载成功
        self.notifyRewardedAdLoaded(adExtra: adExtra)
    }
    
    public func rewardVideoAdFailToLoad(_ ad: AlxRewardVideoAd, didFailWithError error: Error) {
        NSLog("%@: rewardVideoAdFailToLoad: %@", AlxTopOnRewardVideoDelegate.TAG, error.localizedDescription)
        self.notifyLoadFailed(error: error)
    }
    
    public func rewardVideoAdImpression(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdImpression", AlxTopOnRewardVideoDelegate.TAG)
        self.notifyAdShow()
    }
    
    public func rewardVideoAdClick(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdClick", AlxTopOnRewardVideoDelegate.TAG)
        self.notifyAdClick()
    }
    
    public func rewardVideoAdClose(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdClose", AlxTopOnRewardVideoDelegate.TAG)
        self.notifyAdClosed()
    }
    
    public func rewardVideoAdPlayStart(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdPlayStart", AlxTopOnRewardVideoDelegate.TAG)
        self.notifyVideoStart()
    }
    
    public func rewardVideoAdPlayEnd(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdPlayEnd", AlxTopOnRewardVideoDelegate.TAG)
        self.notifyVideoEnd()
    }
    
    public func rewardVideoAdReward(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdReward", AlxTopOnRewardVideoDelegate.TAG)
        self.notifyRewarded()
    }
    
    public func rewardVideoAdPlayFail(_ ad: AlxRewardVideoAd, didFailWithError error: Error) {
        NSLog("%@: rewardVideoAdPlayFail: %@", AlxTopOnRewardVideoDelegate.TAG, error.localizedDescription)
        self.notifyAdShowFailed(error: error)
    }
    
    // MARK: - Dynamic Invocation Helper Methods
    
    private func notifyRewardedAdLoaded(adExtra: [AnyHashable: Any]) {
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnRewardedAdLoadedExtra:")
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
    
    private func notifyRewarded() {
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnRewardedVideoAdRewarded")
            if bridge.responds(to: selector) {
                bridge.perform(selector)
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
}
