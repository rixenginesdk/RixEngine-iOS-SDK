//
//  AlxTopOnNativeDelegate.swift
//  AlxAdsDemo
//

import Foundation
import AnyThinkSDK
import AlxAds

@objc(AlxTopOnNativeDelegate)
public class AlxTopOnNativeDelegate: NSObject, AlxNativeAdLoaderDelegate, AlxNativeAdDelegate {
    
    private static let TAG = "AlxTopOnNativeDelegate"
    
    @objc public var adStatusBridge: ATNativeAdStatusBridge?
    @objc public weak var nativeEvent: AlxTopOnNativeEvent?
    
    // MARK: - AlxNativeAdLoaderDelegate
    
    public func nativeAdLoaded(didReceive ads: [AlxNativeAd]) {
        NSLog("%@: nativeAdLoaded", AlxTopOnNativeDelegate.TAG)
        
        guard let nativeAd = ads.first else {
            let errorStr = "native ad data is empty"
            NSLog("%@: %@", AlxTopOnNativeDelegate.TAG, errorStr)
            let error = NSError(domain: "AlxTopOnAdapter", code: -100, userInfo: [NSLocalizedDescriptionKey: errorStr])
            self.notifyLoadFailed(error: error)
            return
        }
        
        // ⚠️ 创建 AlxTopOnNativeObject 对象 / Create AlxTopOnNativeObject instance
        let nativeObject = AlxTopOnNativeObject()
        nativeObject.nativeAd = nativeAd
        nativeObject.nativeEvent = self.nativeEvent
        
        // ✅ 关键：设置 nativeAd 的 delegate，以便接收展示、点击、关闭回调 / Key: set nativeAd's delegate to receive impression, click, and close callbacks
        nativeAd.delegate = self
        
        // 获取价格（用于 C2S Bidding）/ Get price (for C2S Bidding)
        let price = nativeAd.getPrice()
        var adExtra: [AnyHashable: Any] = [:]
        
        if price > 0 {
            let priceStr = String(format: "%.2f", price)
            adExtra[ATAdSendC2SBidPriceKey] = priceStr
            adExtra[ATAdSendC2SCurrencyTypeKey] = NSNumber(value: 1) // US Dollar
            NSLog("%@: nativeAdLoaded: price = %@", AlxTopOnNativeDelegate.TAG, priceStr)
        }
        
        // ⚠️ 传递对象数组（使用动态调用）/ Pass the object array (using dynamic invocation)
        self.notifyNativeAdLoaded(objects: [nativeObject], adExtra: adExtra)
    }
    
    public func nativeAdFailToLoad(didFailWithError error: Error) {
        NSLog("%@: nativeAdFailToLoad: %@", AlxTopOnNativeDelegate.TAG, error.localizedDescription)
        self.notifyLoadFailed(error: error)
    }
    
    // MARK: - AlxNativeAdDelegate
    
    public func nativeAdImpression(_ nativeAd: AlxNativeAd) {
        NSLog("%@: nativeAdImpression", AlxTopOnNativeDelegate.TAG)
        self.notifyAdShow()
    }
    
    public func nativeAdClick(_ nativeAd: AlxNativeAd) {
        NSLog("%@: nativeAdClick", AlxTopOnNativeDelegate.TAG)
        self.notifyAdClick()
    }
    
    public func nativeAdClose(_ nativeAd: AlxNativeAd) {
        NSLog("%@: nativeAdClose", AlxTopOnNativeDelegate.TAG)
        self.notifyAdClosed()
    }
    
    // MARK: - Dynamic Invocation Helper Methods
    
    private func notifyNativeAdLoaded(objects: [AlxTopOnNativeObject], adExtra: [AnyHashable: Any]) {
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnNativeAdLoadedArray:adExtra:")
            if bridge.responds(to: selector) {
                bridge.perform(selector, with: objects, with: adExtra)
            }
        }
    }
    
    private func notifyLoadFailed(error: Error) {
        if let bridge = self.adStatusBridge {
            let emptyDict: [AnyHashable: Any] = [:]
            let selector = NSSelectorFromString("atOnAdLoadFailed:adExtra:")
            if bridge.responds(to: selector) {
                bridge.perform(selector, with: error, with: emptyDict)
            }
        }
    }
    
    private func notifyAdShow() {
        if let bridge = self.adStatusBridge {
            let emptyDict: [AnyHashable: Any] = [:]
            let selector = NSSelectorFromString("atOnAdShow:")
            if bridge.responds(to: selector) {
                bridge.perform(selector, with: emptyDict)
            }
        }
    }
    
    private func notifyAdClick() {
        if let bridge = self.adStatusBridge {
            let emptyDict: [AnyHashable: Any] = [:]
            let selector = NSSelectorFromString("atOnAdClick:")
            if bridge.responds(to: selector) {
                bridge.perform(selector, with: emptyDict)
            }
        }
    }
    
    private func notifyAdClosed() {
        if let bridge = self.adStatusBridge {
            let emptyDict: [AnyHashable: Any] = [:]
            let selector = NSSelectorFromString("atOnAdClosed:")
            if bridge.responds(to: selector) {
                bridge.perform(selector, with: emptyDict)
            }
        }
    }
}
