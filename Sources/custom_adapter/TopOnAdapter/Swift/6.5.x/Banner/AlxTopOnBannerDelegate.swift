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
    
    /// 广告就绪时绑定竞价通知对象；返回false时忽略旧请求的加载回调。
    var onAdLoaded: ((AlxAdDelegate) -> Bool)?

    private static let TAG = "AlxTopOnBannerDelegate"
    
    @objc public var adStatusBridge: ATBannerAdStatusBridge?
    
    // MARK: - AlxBannerViewAdDelegate
    
    /// 平台广告准备就绪，可以进行展示
    @objc public func bannerViewAdLoad(_ bannerView: AlxBannerAdView) {
        print("\(AlxTopOnBannerDelegate.TAG): bannerViewAdLoad")
        
        // 获取价格（用于 C2S Bidding）
        guard onAdLoaded?(bannerView) ?? true else { return }
        let rawPrice = bannerView.getPrice()
        let price = (rawPrice.isFinite && rawPrice >= 0) ? rawPrice : 0
        var adExtra: [AnyHashable: Any] = [:]
        let priceStr = String(price)
        adExtra[ATAdSendC2SBidPriceKey] = priceStr
        // ATBiddingCurrencyTypeUS = 1
        adExtra[ATAdSendC2SCurrencyTypeKey] = NSNumber(value: 1) // US Dollar
        adExtra[kATAdAssetsCustomObjectKey] = bannerView
        print("\(AlxTopOnBannerDelegate.TAG): bannerViewAdLoad: price = \(priceStr)")
        
        // 使用动态调用
        self.notifyBannerLoaded(banner: bannerView, adExtra: adExtra)
    }
    
    /// Banner 条点击回调
    @objc public func bannerViewAdClick(_ bannerView: AlxBannerAdView) {
        print("\(AlxTopOnBannerDelegate.TAG): bannerViewAdClick")
        self.notifyClick()
    }
    
    /// Banner 广告关闭
    @objc public func bannerViewAdClose(_ bannerView: AlxBannerAdView) {
        print("\(AlxTopOnBannerDelegate.TAG): bannerViewAdClose")
        self.notifyClosed()
    }
    
    /// Banner 广告展示
    @objc public func bannerViewAdImpression(_ bannerView: AlxBannerAdView) {
        print("\(AlxTopOnBannerDelegate.TAG): bannerViewAdImpression")
        self.notifyShow()
    }
    
    /// 请求广告失败后调用
    @objc public func bannerViewAdFailToLoad(_ bannerView: AlxBannerAdView, didFailWithError error: Error) {
        print("\(AlxTopOnBannerDelegate.TAG): bannerViewAdFailToLoad: \(error.localizedDescription)")
        self.notifyLoadFailed(error: error)
    }
    
    // MARK: - AdStatusBridge Helper Methods
    
    private func notifyBannerLoaded(banner: AlxBannerAdView, adExtra: [AnyHashable: Any]) {
        guard let bridge = self.adStatusBridge else { return }
        let selector = NSSelectorFromString("atOnBannerAdLoadedWithView:adExtra:")
        if bridge.responds(to: selector) {
            bridge.perform(selector, with: banner, with: adExtra)
        }
    }
    
    private func notifyLoadFailed(error: Error) {
        guard let bridge = self.adStatusBridge else { return }
        let selector = NSSelectorFromString("atOnAdLoadFailed:adExtra:")
        if bridge.responds(to: selector) {
            bridge.perform(selector, with: error as NSError, with: [:])
        }
    }
    
    private func notifyShow() {
        guard let bridge = self.adStatusBridge else { return }
        let selector = NSSelectorFromString("atOnAdShow:")
        if bridge.responds(to: selector) {
            bridge.perform(selector, with: [:])
        }
    }
    
    private func notifyClick() {
        guard let bridge = self.adStatusBridge else { return }
        let selector = NSSelectorFromString("atOnAdClick:")
        if bridge.responds(to: selector) {
            bridge.perform(selector, with: [:])
        }
    }
    
    private func notifyClosed() {
        guard let bridge = self.adStatusBridge else { return }
        let selector = NSSelectorFromString("atOnAdClosed:")
        if bridge.responds(to: selector) {
            bridge.perform(selector, with: [:])
        }
    }
}
