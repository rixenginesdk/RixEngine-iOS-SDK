//
//  AlxNativeAdLoaderDelegate.swift
//  AlxAds
//
//  Created by liu weile on 2025/5/6.
//

import Foundation

@objc public protocol AlxNativeAdLoaderDelegate: NSObjectProtocol{
    
    @objc func nativeAdLoaded(didReceive ads:[AlxNativeAd])
    
    @objc func nativeAdFailToLoad(didFailWithError error:Error)
    
}
