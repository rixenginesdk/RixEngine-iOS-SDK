//
//  AlxTopOnBannerDelegate.swift
//  AlxAdsDemo
//
//  TopOn 6.5.x 新架构：专门的 Delegate 类
//

import Foundation
import AnyThinkSDK
import AlxAds

@objc(AlxTopOnBannerDelegate)
public class AlxTopOnBannerDelegate: NSObject, AlxBannerViewAdDelegate {
    
    private static let TAG = "AlxTopOnBannerDelegate"
    
    @objc public var adStatusBridge: ATBannerAdStatusBridge?
    
    // MARK: - AlxBannerViewAdDelegate
    
    /// 平台广告准备就绪，可以进行展示
    @objc public func bannerViewAdLoad(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdLoad", AlxTopOnBannerDelegate.TAG)
        
        // 获取价格（用于 C2S Bidding）
        let price = bannerView.getPrice()
        var adExtra: [AnyHashable: Any] = [:]
        
        // 如果有价格，添加到 extra 中
        if price > 0 {
            let priceStr = String(format: "%.2f", price)
            adExtra[ATAdSendC2SBidPriceKey] = priceStr
            // ATBiddingCurrencyTypeUS = 1
            adExtra[ATAdSendC2SCurrencyTypeKey] = NSNumber(value: 1) // US Dollar
            NSLog("%@: bannerViewAdLoad: price = %@", AlxTopOnBannerDelegate.TAG, priceStr)
        }
        
        // 使用动态调用
        self.notifyBannerLoaded(banner: bannerView, adExtra: adExtra)
    }
    
    /// Banner 条点击回调
    @objc public func bannerViewAdClick(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdClick", AlxTopOnBannerDelegate.TAG)
        self.notifyClick()
    }
    
    /// Banner 广告关闭
    @objc public func bannerViewAdClose(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdClose", AlxTopOnBannerDelegate.TAG)
        self.notifyClosed()
    }
    
    /// Banner 广告展示
    @objc public func bannerViewAdImpression(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdImpression", AlxTopOnBannerDelegate.TAG)
        self.notifyShow()
    }
    
    /// 请求广告失败后调用
    @objc public func bannerViewAdFailToLoad(_ bannerView: AlxBannerAdView, didFailWithError error: Error) {
        NSLog("%@: bannerViewAdFailToLoad: %@", AlxTopOnBannerDelegate.TAG, error.localizedDescription)
        self.notifyLoadFailed(error: error)
    }
    
    // MARK: - Helper Methods (使用动态调用避免 Swift 桥接问题)
    
    private func notifyBannerLoaded(banner: AlxBannerAdView, adExtra: [AnyHashable: Any]) {
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnBannerAdLoadedWithView:adExtra:")
            if bridge.responds(to: selector) {
                bridge.perform(selector, with: banner, with: adExtra)
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
    
    private func notifyShow() {
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnAdShow:")
            if bridge.responds(to: selector) {
                let emptyDict: [AnyHashable: Any] = [:]
                bridge.perform(selector, with: emptyDict)
            }
        }
    }
    
    private func notifyClick() {
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnAdClick:")
            if bridge.responds(to: selector) {
                let emptyDict: [AnyHashable: Any] = [:]
                bridge.perform(selector, with: emptyDict)
            }
        }
    }
    
    private func notifyClosed() {
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnAdClosed:")
            if bridge.responds(to: selector) {
                let emptyDict: [AnyHashable: Any] = [:]
                bridge.perform(selector, with: emptyDict)
            }
        }
    }
}
