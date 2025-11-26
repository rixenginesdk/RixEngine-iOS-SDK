//
//  AlxBannerViewDelegate.swift
//  AlxAds
//
//  Created by liu weile on 2025/4/14.
//

import Foundation
import UIKit

@objc public protocol AlxBannerViewAdDelegate : NSObjectProtocol{
    
    @objc func bannerViewAdLoad(_ bannerView:AlxBannerAdView)
    
    @objc func bannerViewAdFailToLoad(_ bannerView:AlxBannerAdView,didFailWithError error:Error)
    
    @objc optional func bannerViewAdImpression(_ bannerView:AlxBannerAdView)
    
    @objc optional func bannerViewAdClick(_ bannerView:AlxBannerAdView)
    
    @objc optional func bannerViewAdClose(_ bannerView:AlxBannerAdView)
    
}
