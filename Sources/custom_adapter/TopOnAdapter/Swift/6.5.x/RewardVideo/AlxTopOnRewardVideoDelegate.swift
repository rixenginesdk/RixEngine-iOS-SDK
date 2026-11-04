//
//  AlxTopOnRewardVideoDelegate.swift
//  AlxAdsDemo
//

import Foundation
import AnyThinkSDK
import AlxAds

@objc(AlxTopOnRewardVideoDelegate)
public class AlxTopOnRewardVideoDelegate: NSObject, AlxRewardVideoAdDelegate {
    
    /// 广告就绪时绑定竞价通知对象；返回false时忽略旧请求的加载回调。
    var onAdLoaded: ((AlxAdDelegate) -> Bool)?

    private static let TAG = "AlxTopOnRewardVideoDelegate"
    
    @objc public var adStatusBridge: ATRewardedAdStatusBridge?
    @objc public weak var rewardedAd: AlxRewardVideoAd?
    
    // MARK: - AlxRewardVideoAdDelegate
    
    public func rewardVideoAdLoad(_ ad: AlxRewardVideoAd) {
        print("\(AlxTopOnRewardVideoDelegate.TAG): rewardVideoAdLoad")
        
        // 保存广告对象引用
        self.rewardedAd = ad
        
        // 获取价格（用于 C2S Bidding）
        guard onAdLoaded?(ad) ?? true else { return }
        let rawPrice = ad.getPrice()
        let price = (rawPrice.isFinite && rawPrice >= 0) ? rawPrice : 0
        var adExtra: [AnyHashable: Any] = [:]
        let priceStr = String(price)
        adExtra[ATAdSendC2SBidPriceKey] = priceStr
        adExtra[ATAdSendC2SCurrencyTypeKey] = NSNumber(value: 1) // US Dollar
        print("\(AlxTopOnRewardVideoDelegate.TAG): rewardVideoAdLoad: price = \(priceStr)")
        
        // 关键：将广告对象传给 TopOn SDK
        adExtra[kATAdAssetsCustomObjectKey] = ad
        
        // 调用 adStatusBridge 通知加载成功
        self.notifyRewardedAdLoaded(adExtra: adExtra)
    }
    
    public func rewardVideoAdFailToLoad(_ ad: AlxRewardVideoAd, didFailWithError error: Error) {
        print("\(AlxTopOnRewardVideoDelegate.TAG): rewardVideoAdFailToLoad: \(error.localizedDescription)")
        self.notifyLoadFailed(error: error)
    }
    
    public func rewardVideoAdImpression(_ ad: AlxRewardVideoAd) {
        print("\(AlxTopOnRewardVideoDelegate.TAG): rewardVideoAdImpression")
        self.notifyAdShow()
    }
    
    public func rewardVideoAdClick(_ ad: AlxRewardVideoAd) {
        print("\(AlxTopOnRewardVideoDelegate.TAG): rewardVideoAdClick")
        self.notifyAdClick()
    }
    
    public func rewardVideoAdClose(_ ad: AlxRewardVideoAd) {
        print("\(AlxTopOnRewardVideoDelegate.TAG): rewardVideoAdClose")
        self.notifyAdClosed()
    }
    
    public func rewardVideoAdPlayStart(_ ad: AlxRewardVideoAd) {
        print("\(AlxTopOnRewardVideoDelegate.TAG): rewardVideoAdPlayStart")
        self.notifyVideoStart()
    }
    
    public func rewardVideoAdPlayEnd(_ ad: AlxRewardVideoAd) {
        print("\(AlxTopOnRewardVideoDelegate.TAG): rewardVideoAdPlayEnd")
        self.notifyVideoEnd()
    }
    
    public func rewardVideoAdReward(_ ad: AlxRewardVideoAd) {
        print("\(AlxTopOnRewardVideoDelegate.TAG): rewardVideoAdReward")
        self.notifyRewarded()
    }
    
    public func rewardVideoAdPlayFail(_ ad: AlxRewardVideoAd, didFailWithError error: Error) {
        print("\(AlxTopOnRewardVideoDelegate.TAG): rewardVideoAdPlayFail: \(error.localizedDescription)")
        self.notifyAdShowFailed(error: error)
    }
    
    // MARK: - AdStatusBridge Helper Methods
    
    private func notifyRewardedAdLoaded(adExtra: [AnyHashable: Any]) {
        guard let bridge = self.adStatusBridge else { return }
        let selector = NSSelectorFromString("atOnRewardedAdLoadedExtra:")
        if bridge.responds(to: selector) {
            bridge.perform(selector, with: adExtra)
        }
    }
    
    private func notifyLoadFailed(error: Error) {
        guard let bridge = self.adStatusBridge else { return }
        let selector = NSSelectorFromString("atOnAdLoadFailed:adExtra:")
        if bridge.responds(to: selector) {
            bridge.perform(selector, with: error as NSError, with: [:])
        }
    }
    
    private func notifyAdShow() {
        guard let bridge = self.adStatusBridge else { return }
        let selector = NSSelectorFromString("atOnAdShow:")
        if bridge.responds(to: selector) {
            bridge.perform(selector, with: [:])
        }
    }
    
    private func notifyAdClick() {
        guard let bridge = self.adStatusBridge else { return }
        let selector = NSSelectorFromString("atOnAdClick:")
        if bridge.responds(to: selector) {
            bridge.perform(selector, with: [:])
        }
    }
    
    private func notifyAdClosed() {
        guard let bridge = self.adStatusBridge else { return }
        let selector = NSSelectorFromString("atOnAdClosed:")
        if bridge.responds(to: selector) {
            bridge.perform(selector, with: [:])
        }
    }
    
    private func notifyVideoStart() {
        guard let bridge = self.adStatusBridge else { return }
        let selector = NSSelectorFromString("atOnAdVideoStart:")
        if bridge.responds(to: selector) {
            bridge.perform(selector, with: [:])
        }
    }
    
    private func notifyVideoEnd() {
        guard let bridge = self.adStatusBridge else { return }
        let selector = NSSelectorFromString("atOnAdVideoEnd:")
        if bridge.responds(to: selector) {
            bridge.perform(selector, with: [:])
        }
    }
    
    private func notifyRewarded() {
        guard let bridge = self.adStatusBridge else { return }
        let selector = NSSelectorFromString("atOnRewardedVideoAdRewarded")
        if bridge.responds(to: selector) {
            bridge.perform(selector)
        }
    }
    
    private func notifyAdShowFailed(error: Error) {
        guard let bridge = self.adStatusBridge else { return }
        let selector = NSSelectorFromString("atOnAdShowFailed:extra:")
        if bridge.responds(to: selector) {
            bridge.perform(selector, with: error as NSError, with: [:])
        }
    }
}
