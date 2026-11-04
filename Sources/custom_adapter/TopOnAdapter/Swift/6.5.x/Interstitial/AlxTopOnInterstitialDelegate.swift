//
//  AlxTopOnInterstitialDelegate.swift
//  AlxAdsDemo
//

import Foundation
import AnyThinkSDK
import AlxAds

@objc(AlxTopOnInterstitialDelegate)
public class AlxTopOnInterstitialDelegate: NSObject, AlxInterstitialAdDelegate {
    
    /// 广告就绪时绑定竞价通知对象；返回false时忽略旧请求的加载回调。
    var onAdLoaded: ((AlxAdDelegate) -> Bool)?

    private static let TAG = "AlxTopOnInterstitialDelegate"
    
    @objc public var adStatusBridge: ATInterstitialAdStatusBridge?
    @objc public weak var interstitialAd: AlxInterstitialAd?
    
    // MARK: - AlxInterstitialAdDelegate
    
    public func interstitialAdLoad(_ ad: AlxInterstitialAd) {
        print("\(AlxTopOnInterstitialDelegate.TAG): interstitialAdLoad")
        
        // 保存广告对象引用
        self.interstitialAd = ad
        
        // 获取价格（用于 C2S Bidding）
        guard onAdLoaded?(ad) ?? true else { return }
        let rawPrice = ad.getPrice()
        let price = (rawPrice.isFinite && rawPrice >= 0) ? rawPrice : 0
        var adExtra: [AnyHashable: Any] = [:]
        let priceStr = String(price)
        adExtra[ATAdSendC2SBidPriceKey] = priceStr
        adExtra[ATAdSendC2SCurrencyTypeKey] = NSNumber(value: 1) // US Dollar
        print("\(AlxTopOnInterstitialDelegate.TAG): interstitialAdLoad: price = \(priceStr)")
        
        // 关键：将广告对象传给 TopOn SDK
        adExtra[kATAdAssetsCustomObjectKey] = ad
        
        // 调用 adStatusBridge 通知加载成功
        self.notifyInterstitialLoaded(adExtra: adExtra)
    }
    
    public func interstitialAdFailToLoad(_ ad: AlxInterstitialAd, didFailWithError error: Error) {
        print("\(AlxTopOnInterstitialDelegate.TAG): interstitialAdFailToLoad: \(error.localizedDescription)")
        self.notifyLoadFailed(error: error)
    }
    
    public func interstitialAdImpression(_ ad: AlxInterstitialAd) {
        print("\(AlxTopOnInterstitialDelegate.TAG): interstitialAdImpression")
        self.notifyAdShow()
    }
    
    public func interstitialAdClick(_ ad: AlxInterstitialAd) {
        print("\(AlxTopOnInterstitialDelegate.TAG): interstitialAdClick")
        self.notifyAdClick()
    }
    
    public func interstitialAdClose(_ ad: AlxInterstitialAd) {
        print("\(AlxTopOnInterstitialDelegate.TAG): interstitialAdClose")
        self.notifyAdClosed()
    }
    
    public func interstitialAdRenderFail(_ ad: AlxInterstitialAd, didFailWithError error: Error) {
        print("\(AlxTopOnInterstitialDelegate.TAG): interstitialAdRenderFail: \(error.localizedDescription)")
        self.notifyAdShowFailed(error: error)
    }
    
    public func interstitialAdVideoStart(_ ad: AlxInterstitialAd) {
        print("\(AlxTopOnInterstitialDelegate.TAG): interstitialAdVideoStart")
        self.notifyVideoStart()
    }
    
    public func interstitialAdVideoEnd(_ ad: AlxInterstitialAd) {
        print("\(AlxTopOnInterstitialDelegate.TAG): interstitialAdVideoEnd")
        self.notifyVideoEnd()
    }
    
    // MARK: - AdStatusBridge Helper Methods
    
    private func notifyInterstitialLoaded(adExtra: [AnyHashable: Any]) {
        guard let bridge = self.adStatusBridge else { return }
        let selector = NSSelectorFromString("atOnInterstitialAdLoadedExtra:")
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
    
    private func notifyAdShowFailed(error: Error) {
        guard let bridge = self.adStatusBridge else { return }
        let selector = NSSelectorFromString("atOnAdShowFailed:extra:")
        if bridge.responds(to: selector) {
            bridge.perform(selector, with: error as NSError, with: [:])
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
}
