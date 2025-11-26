//
//  AlxNativeAdDelegate.swift
//  AlxAds
//
//  Created by liu weile on 2025/5/6.
//

import Foundation


@objc public protocol AlxNativeAdDelegate:NSObjectProtocol{
    
    @objc optional func nativeAdImpression(_ nativeAd:AlxNativeAd)
    
    @objc optional func nativeAdClick(_ nativeAd:AlxNativeAd)
    
    @objc optional func nativeAdClose(_ nativeAd:AlxNativeAd)
    
}
