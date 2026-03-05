//
//  AlxTopOnNativeRender.swift
//


import Foundation
import AnyThinkSDK
import AnyThinkNative
import AlxAds

@objc(AlxTopOnNativeRender)
public class AlxTopOnNativeRender: ATNativeRenderer {
    
    private static let TAG = "AlxTopOnNativeRender"
    
    private weak var customEvent: AlxTopOnNativeEvent? = nil
    private var nativeAd:AlxNativeAd? = nil
    
    @objc public override init(configuraton configuration: ATNativeADConfiguration, adView: ATNativeADView) {
        super.init(configuraton: configuration, adView: adView)
    }
    
    /// 将资源渲染到相关的广告视图上。
    /// 您可以根据广告平台的要求，做渲染之后再做一些注册点击事件的功能
    @objc public override func renderOffer(_ offer: ATNativeADCache) {
        super.renderOffer(offer)
        NSLog("%@: renderOffer",AlxTopOnNativeRender.TAG)
        
        self.customEvent = offer.assets[kATAdAssetsCustomEventKey] as? AlxTopOnNativeEvent
        self.customEvent?.adView = self.adView
        if let customEvent = self.customEvent {
            NSLog("%@: renderOffer: customEvent",AlxTopOnNativeRender.TAG)
            self.adView?.customEvent = customEvent
        }
        
        self.nativeAd = offer.assets[kATAdAssetsCustomObjectKey] as? AlxNativeAd
        if let nativeAd = self.nativeAd,let adView = self.adView {
            NSLog("%@: renderOffer: nativeAd",AlxTopOnNativeRender.TAG)
            nativeAd.rootViewController = self.configuration.rootViewController
            nativeAd.delegate = self.customEvent
            nativeAd.registerView(container: adView, clickableViews: adView.clickableViews())
        }
    }
    
    @objc public override func getNetWorkMediaView() -> UIView {
        NSLog("%@: getNetWorkMediaView",AlxTopOnNativeRender.TAG)
        let offer:ATNativeADCache? = self.adView?.nativeAd as? ATNativeADCache
        if let nativeAd = offer?.assets[kATAdAssetsCustomObjectKey] as? AlxNativeAd, let mediaContent = nativeAd.mediaContent{
            NSLog("%@: getNetWorkMediaView: add mediaview",AlxTopOnNativeRender.TAG)
            let mediaView = AlxMediaView(frame: self.configuration.mediaViewFrame)
            mediaView.setMediaContent(mediaContent)
            return mediaView
        }
        return UIView()
    }
    
    @objc public override func getCurrentNativeAdRenderType() -> ATNativeAdRenderType{
        NSLog("%@: getCurrentNativeAdRenderType",AlxTopOnNativeRender.TAG)
        return .selfRender
    }
    
    
    deinit {
        NSLog("%@: deinit",AlxTopOnNativeRender.TAG)
        self.nativeAd?.unregisterView()
    }
    
}
