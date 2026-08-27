//
//  AlxTopOnNativeObject.swift
//  AlxAdsDemo
//
//  关键：父类属性是 readwrite，必须提供 setter / Key: superclass properties are readwrite, so setters must be provided
//

import Foundation
import AnyThinkSDK
import AlxAds

@objc(AlxTopOnNativeObject)
public class AlxTopOnNativeObject: ATCustomNetworkNativeAd {
    
    @objc public var nativeAd: AlxNativeAd?
    @objc public weak var nativeEvent: AlxTopOnNativeEvent?
    
    // ⚠️ 缓存 mediaView 实例，避免重复创建 / Cache the mediaView instance to avoid repeated creation
    private var _cachedMediaView: AlxMediaView?
    
    // MARK: - Override Readwrite Properties
    // ⚠️ 关键：父类是 readwrite，必须提供 getter 和 setter / Key: superclass is readwrite, must provide both getter and setter
    
    @objc public override var isExpressAd: Bool {
        get {
            return false
        }
        set {
            // 不需要实现，父类属性我们不修改 / No implementation needed, we don't modify the superclass property
        }
    }
    
    @objc public override var title: String? {
        get {
            let result = nativeAd?.title ?? ""
            NSLog("AlxTopOnNativeObject: title = \(result)")
            return result
        }
        set {
            // 不需要实现 / No implementation needed
        }
    }
    
    @objc public override var mainText: String? {
        get {
            let result = nativeAd?.desc ?? ""
            NSLog("AlxTopOnNativeObject: mainText = \(result)")
            return result
        }
        set {
            // 不需要实现 / No implementation needed
        }
    }
    
    @objc public override var iconUrl: String? {
        get {
            let result = nativeAd?.icon?.url ?? ""
            NSLog("AlxTopOnNativeObject: iconUrl = \(result)")
            return result
        }
        set {
            // 不需要实现 / No implementation needed
        }
    }
    
    @objc public var mainImageUrl: String? {
        get {
            var result = ""
            if let images = nativeAd?.images, images.count > 0 {
                result = images.first?.url ?? ""
            }
            NSLog("AlxTopOnNativeObject: mainImageUrl = \(result)")
            return result
        }
    }
    
    @objc public override var ctaText: String? {
        get {
            let result = nativeAd?.callToAction ?? ""
            NSLog("AlxTopOnNativeObject: ctaText = \(result)")
            return result
        }
        set {
            // 不需要实现 / No implementation needed
        }
    }
    
    @objc public override var advertiser: String? {
        get {
            let result = nativeAd?.adSource ?? ""
            NSLog("AlxTopOnNativeObject: advertiser = \(result)")
            return result
        }
        set {
            // 不需要实现 / No implementation needed
        }
    }
    
    @objc public var logoImage: UIImage? {
        get {
            let result = nativeAd?.adLogo
            NSLog("AlxTopOnNativeObject: logoImage = \(result != nil ? "exists" : "nil")")
            return result
        }
    }
    
    @objc public override var isVideoContents: Bool {
        get {
            let result = nativeAd?.createType == 1
            NSLog("AlxTopOnNativeObject: isVideoContents = \(result)")
            return result
        }
        set {
            // 不需要实现 / No implementation needed
        }
    }
    
    @objc public override var mediaView: UIView? {
        get {
            NSLog("AlxTopOnNativeObject: mediaView requested")
            
            // 如果已经创建过，直接返回缓存的实例 / If already created, return the cached instance directly
            if let cachedView = _cachedMediaView {
                NSLog("AlxTopOnNativeObject: returning cached mediaView")
                return cachedView
            }
            
            // 否则创建新的 mediaView / Otherwise create a new mediaView
            if let mediaContent = nativeAd?.mediaContent {
                NSLog("AlxTopOnNativeObject: creating new mediaView")
                let mediaView = AlxMediaView()
                mediaView.setMediaContent(mediaContent)
                _cachedMediaView = mediaView
                return mediaView
            }
            
            NSLog("AlxTopOnNativeObject: no mediaContent")
            return nil
        }
        set {
            // 不需要实现 / No implementation needed
        }
    }
    
    @objc public override var mainImageWidth: CGFloat {
        get {
            var result: CGFloat = 0
            if let images = nativeAd?.images, images.count > 0 {
                result = CGFloat(images.first?.width ?? 0)
            }
            NSLog("AlxTopOnNativeObject: mainImageWidth = \(result)")
            return result
        }
        set {
            // 不需要实现 / No implementation needed
        }
    }
    
    @objc public override var mainImageHeight: CGFloat {
        get {
            var result: CGFloat = 0
            if let images = nativeAd?.images, images.count > 0 {
                result = CGFloat(images.first?.height ?? 0)
            }
            NSLog("AlxTopOnNativeObject: mainImageHeight = \(result)")
            return result
        }
        set {
            // 不需要实现 / No implementation needed
        }
    }
    
    // MARK: - Override Method
    
    @objc public override func registerClickableViews(_ clickableViews: [UIView], 
                                                     withContainer container: UIView, 
                                                     registerArgument: ATNativeRegisterArgument?) {
        NSLog("AlxTopOnNativeObject: registerClickableViews")
        
        guard let nativeAd = self.nativeAd else {
            NSLog("AlxTopOnNativeObject: nativeAd is nil, cannot register")
            return
        }
        
        if let viewController = registerArgument?.viewController {
            nativeAd.rootViewController = viewController
        }
        
        let views = clickableViews.isEmpty ? [container] : clickableViews
        nativeAd.registerView(container: container, clickableViews: views)
    }
    
    deinit {
        NSLog("AlxTopOnNativeObject: dealloc")
        nativeAd?.unregisterView()
        _cachedMediaView = nil
    }
}
