//
//  AlxNativeAdDelegate.swift
//  AlxAds
//
//  Created by liu weile on 2025/5/6.
//

import Foundation

// MARK: - 原生广告事件回调
@objc public protocol AlxNativeAdDelegate: NSObjectProtocol {
    
    @objc optional func nativeAdImpression(_ nativeAd: AlxNativeAd)
    
    @objc optional func nativeAdClick(_ nativeAd: AlxNativeAd)
    
    @objc optional func nativeAdClose(_ nativeAd: AlxNativeAd)
    
}
