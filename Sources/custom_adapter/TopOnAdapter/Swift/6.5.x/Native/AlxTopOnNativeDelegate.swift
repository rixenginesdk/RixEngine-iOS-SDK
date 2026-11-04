//
//  AlxTopOnNativeDelegate.swift
//  AlxAdsDemo
//

import Foundation
import AnyThinkSDK
import AlxAds

@objc(AlxTopOnNativeDelegate)
public class AlxTopOnNativeDelegate: NSObject, AlxNativeAdLoaderDelegate, AlxNativeAdDelegate {
    
    /// 广告就绪时绑定竞价通知对象；返回false时忽略旧请求的加载回调。
    var onAdLoaded: ((AlxAdDelegate) -> Bool)?

    private static let TAG = "AlxTopOnNativeDelegate"
    
    @objc public var adStatusBridge: ATNativeAdStatusBridge?
    @objc public weak var nativeEvent: AlxTopOnNativeEvent?
    
    // MARK: - AlxNativeAdLoaderDelegate
    
    public func nativeAdLoaded(didReceive ads: [AlxNativeAd]) {
        print("\(AlxTopOnNativeDelegate.TAG): nativeAdLoaded")
        
        guard let nativeAd = ads.first else {
            let errorStr = "native ad data is empty"
            print("\(AlxTopOnNativeDelegate.TAG): \(errorStr)")
            let error = NSError(domain: "AlxTopOnAdapter", code: -100, userInfo: [NSLocalizedDescriptionKey: errorStr])
            self.notifyLoadFailed(error: error)
            return
        }
        
        // ⚠️ 创建 AlxTopOnNativeObject 对象
        let nativeObject = AlxTopOnNativeObject()
        nativeObject.nativeAd = nativeAd
        nativeObject.nativeEvent = self.nativeEvent
        
        // ✅ 关键：设置 nativeAd 的 delegate，以便接收展示、点击、关闭回调
        nativeAd.delegate = self
        
        // 获取价格（用于 C2S Bidding）
        guard onAdLoaded?(nativeAd) ?? true else { return }
        let rawPrice = nativeAd.getPrice()
        let price = (rawPrice.isFinite && rawPrice >= 0) ? rawPrice : 0
        var adExtra: [AnyHashable: Any] = [:]
        let priceStr = String(price)
        adExtra[ATAdSendC2SBidPriceKey] = priceStr
        adExtra[ATAdSendC2SCurrencyTypeKey] = NSNumber(value: 1) // US Dollar
        print("\(AlxTopOnNativeDelegate.TAG): nativeAdLoaded: price = \(priceStr)")
        
        // ⚠️ 传递对象数组（使用动态调用）
        self.notifyNativeAdLoaded(objects: [nativeObject], adExtra: adExtra)
    }
    
    public func nativeAdFailToLoad(didFailWithError error: Error) {
        print("\(AlxTopOnNativeDelegate.TAG): nativeAdFailToLoad: \(error.localizedDescription)")
        self.notifyLoadFailed(error: error)
    }
    
    // MARK: - AlxNativeAdDelegate
    
    public func nativeAdImpression(_ nativeAd: AlxNativeAd) {
        print("\(AlxTopOnNativeDelegate.TAG): nativeAdImpression")
        self.notifyAdShow()
    }
    
    public func nativeAdClick(_ nativeAd: AlxNativeAd) {
        print("\(AlxTopOnNativeDelegate.TAG): nativeAdClick")
        self.notifyAdClick()
    }
    
    public func nativeAdClose(_ nativeAd: AlxNativeAd) {
        print("\(AlxTopOnNativeDelegate.TAG): nativeAdClose")
        self.notifyAdClosed()
    }
    
    // MARK: - AdStatusBridge Helper Methods
    
    private func notifyNativeAdLoaded(objects: [AlxTopOnNativeObject], adExtra: [AnyHashable: Any]) {
        guard let bridge = self.adStatusBridge else { return }
        let selector = NSSelectorFromString("atOnNativeAdLoadedArray:adExtra:")
        if bridge.responds(to: selector) {
            bridge.perform(selector, with: objects, with: adExtra)
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
}
