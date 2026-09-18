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
    
    private static let TAG = "AlxTopOnSplashDelegate"
    
    @objc public var adStatusBridge: ATSplashAdStatusBridge?
    @objc public weak var splashAd: AlxSplashAd?
    
    // MARK: - AlxSplashAdDelegate
    
    public func splashAdDidLoad(_ ad: AlxSplashAd) {
        NSLog("%@: splashAdDidLoad", AlxTopOnSplashDelegate.TAG)
        self.splashAd = ad
        
        let price = ad.getPrice()
        var adExtra: [AnyHashable: Any] = [:]
        
        if price > 0 {
            let priceStr = String(format: "%.2f", price)
            adExtra[ATAdSendC2SBidPriceKey] = priceStr
            adExtra[ATAdSendC2SCurrencyTypeKey] = NSNumber(value: 1)
            NSLog("%@: splashAdDidLoad: price = %@", AlxTopOnSplashDelegate.TAG, priceStr)
        }
        
        adExtra[kATAdAssetsCustomObjectKey] = ad
        self.notifySplashLoaded(adExtra: adExtra)
    }
    
    public func splashAdDidFailToLoad(_ ad: AlxSplashAd, didFailWithError error: Error) {
        NSLog("%@: splashAdDidFailToLoad: %@", AlxTopOnSplashDelegate.TAG, error.localizedDescription)
        self.notifyLoadFailed(error: error)
    }
    
    public func splashAdDidShow(_ ad: AlxSplashAd) {
        NSLog("%@: splashAdDidShow", AlxTopOnSplashDelegate.TAG)
        self.notifyAdShow()
    }
    
    public func splashAdDidClick(_ ad: AlxSplashAd) {
        NSLog("%@: splashAdDidClick", AlxTopOnSplashDelegate.TAG)
        self.notifyAdClick()
    }
    
    public func splashAdDidClose(_ ad: AlxSplashAd) {
        NSLog("%@: splashAdDidClose", AlxTopOnSplashDelegate.TAG)
        self.notifyAdClosed()
    }
    
    public func splashAdRenderDidFail(_ ad: AlxSplashAd, didFailWithError error: Error) {
        NSLog("%@: splashAdRenderDidFail: %@", AlxTopOnSplashDelegate.TAG, error.localizedDescription)
        self.notifyAdShowFailed(error: error)
    }
    
    public func splashAdCountdown(_ ad: AlxSplashAd, countdown: Int) {
        NSLog("%@: splashAdCountdown: %d", AlxTopOnSplashDelegate.TAG, countdown)
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnSplashAdCountdownTime:")
            if bridge.responds(to: selector) {
                bridge.perform(selector, with: countdown as NSNumber)
            }
        }
    }
    
    // MARK: - Dynamic Invocation Helper Methods
    
    private func notifySplashLoaded(adExtra: [AnyHashable: Any]) {
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnSplashAdLoadedExtra:")
            if bridge.responds(to: selector) {
                bridge.perform(selector, with: adExtra)
            }
        }
    }
    
    private func notifyLoadFailed(error: Error) {
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnAdLoadFailed:adExtra:")
            if bridge.responds(to: selector) {
                bridge.perform(selector, with: error, with: nil)
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
                bridge.perform(selector, with: error, with: nil)
            }
        }
    }
}
