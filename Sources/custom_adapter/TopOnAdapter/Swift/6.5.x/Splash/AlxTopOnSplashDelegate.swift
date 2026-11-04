//
//  AlxTopOnSplashDelegate.swift
//  AlxAdsDemo
//

import Foundation
import UIKit
import AnyThinkSDK
import AlxAds

@objc(AlxTopOnSplashDelegate)
public class AlxTopOnSplashDelegate: NSObject, AlxSplashAdDelegate {
    
    /// 广告就绪时绑定竞价通知对象；返回false时忽略旧请求的加载回调。
    var onAdLoaded: ((AlxAdDelegate) -> Bool)?

    private static let TAG = "AlxTopOnSplashDelegate"
    
    @objc public var adStatusBridge: ATSplashAdStatusBridge?
    @objc public weak var splashAd: AlxSplashAd?
    
    // MARK: - AlxSplashAdDelegate
    
    public func splashAdDidLoad(_ ad: AlxSplashAd) {
        print("\(AlxTopOnSplashDelegate.TAG): splashAdDidLoad")
        self.splashAd = ad
        
        guard onAdLoaded?(ad) ?? true else { return }
        let rawPrice = ad.getPrice()
        let price = (rawPrice.isFinite && rawPrice >= 0) ? rawPrice : 0
        var adExtra: [AnyHashable: Any] = [:]
        let priceStr = String(price)
        adExtra[ATAdSendC2SBidPriceKey] = priceStr
        adExtra[ATAdSendC2SCurrencyTypeKey] = NSNumber(value: 1)
        print("\(AlxTopOnSplashDelegate.TAG): splashAdDidLoad: price = \(priceStr)")
        
        adExtra[kATAdAssetsCustomObjectKey] = ad
        
        self.notifySplashLoaded(adExtra: adExtra)
    }
    
    public func splashAdDidFailToLoad(_ ad: AlxSplashAd, didFailWithError error: Error) {
        print("\(AlxTopOnSplashDelegate.TAG): splashAdDidFailToLoad: \(error.localizedDescription)")
        self.notifyLoadFailed(error: error)
    }
    
    public func splashAdDidShow(_ ad: AlxSplashAd) {
        print("\(AlxTopOnSplashDelegate.TAG): splashAdDidShow")
        self.notifyAdShow()
    }
    
    public func splashAdDidClick(_ ad: AlxSplashAd) {
        print("\(AlxTopOnSplashDelegate.TAG): splashAdDidClick")
        self.notifyAdClick()
    }
    
    public func splashAdDidClose(_ ad: AlxSplashAd) {
        print("\(AlxTopOnSplashDelegate.TAG): splashAdDidClose")
        self.notifyAdClosed()
    }
    
    public func splashAdRenderDidFail(_ ad: AlxSplashAd, didFailWithError error: Error) {
        print("\(AlxTopOnSplashDelegate.TAG): splashAdRenderDidFail: \(error.localizedDescription)")
        self.notifyAdShowFailed(error: error)
    }
    
    public func splashAdCountdown(_ ad: AlxSplashAd, countdown: Int) {
        print("\(AlxTopOnSplashDelegate.TAG): splashAdCountdown: \(countdown)")
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnSplashAdCountdownTime:")
            if bridge.responds(to: selector) {
                bridge.perform(selector, with: countdown)
            }
        }
    }
    
    // MARK: - AdStatusBridge Helper Methods
    
    private func notifySplashLoaded(adExtra: [AnyHashable: Any]) {
        guard let bridge = self.adStatusBridge else { return }
        let selector = NSSelectorFromString("atOnSplashAdLoadedExtra:")
        if bridge.responds(to: selector) {
            bridge.perform(selector, with: adExtra)
        }
    }
    
    private func notifyLoadFailed(error: Error) {
        guard let bridge = self.adStatusBridge else { return }
        let selector = NSSelectorFromString("atOnAdLoadFailed:adExtra:")
        if bridge.responds(to: selector) {
            bridge.perform(selector, with: error as NSError, with: nil)
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
            bridge.perform(selector, with: error as NSError, with: nil)
        }
    }
}
