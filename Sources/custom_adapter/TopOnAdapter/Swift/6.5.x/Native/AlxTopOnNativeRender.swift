//
//  AlxTopOnNativeRender.swift
//  AlxAdsDemo
//

import Foundation
import AnyThinkSDK
import AlxAds

@objc(AlxTopOnNativeRender)
public class AlxTopOnNativeRender: ATNativeRenderer {
    
    private static let TAG = "AlxTopOnNativeRender"
    
    private var nativeObject: AlxTopOnNativeObject?
    
    @objc public override init(configuraton configuration: ATNativeADConfiguration, adView: ATNativeADView) {
        super.init(configuraton: configuration, adView: adView)
    }
    
    /// 将资源渲染到相关的广告视图上。
    /// 您可以根据广告平台的要求，做渲染之后再做一些注册点击事件的功能    
    @objc public override func renderOffer(_ offer: ATAdOfferCacheModel) {
        super.renderOffer(offer)
        print("\(AlxTopOnNativeRender.TAG): renderOffer")
        
        // ⚠️ 注意：TopOn SDK 传的 customObject 就是我们的 AlxTopOnNativeObject
        if let nativeObject = offer.customObject as? AlxTopOnNativeObject {
            self.nativeObject = nativeObject
            print("\(AlxTopOnNativeRender.TAG): renderOffer: nativeObject found")
        } else {
            print("\(AlxTopOnNativeRender.TAG): renderOffer: customObject is not AlxTopOnNativeObject")
        }
    }
    
    @objc public override func getNetWorkMediaView() -> UIView {
        print("\(AlxTopOnNativeRender.TAG): getNetWorkMediaView")
        
        // ⚠️ 直接使用 nativeObject 的 mediaView 属性，避免重复创建
        if let nativeObject = self.nativeObject,
           let mediaView = nativeObject.mediaView {
            print("\(AlxTopOnNativeRender.TAG): getNetWorkMediaView: using mediaView from nativeObject")
            // 设置 frame（如果需要的话）
            mediaView.frame = self.configuration.mediaViewFrame
            return mediaView
        }
        
        print("\(AlxTopOnNativeRender.TAG): getNetWorkMediaView: no media view available")
        return UIView()
    }
    
    @objc public override func getCurrentNativeAdRenderType() -> ATNativeAdRenderType {
        print("\(AlxTopOnNativeRender.TAG): getCurrentNativeAdRenderType")
        return .selfRender
    }
    
    deinit {
        print("\(AlxTopOnNativeRender.TAG): deinit")
        // AlxTopOnNativeObject 的 deinit 会自动清理
    }
}
