//
//  AlxRewardVideoAd.swift
//  AlxAds
//
//  Created by liu weile on 2025/3/31.
//

import Foundation
import UIKit

@objc public class AlxRewardVideoAd: NSObject, AlxAdDelegate {
    
    private var model: AlxRewardVideoModel?
    
    @objc public weak var delegate: AlxRewardVideoAdDelegate? {
        get { model?.delegate }
        set { model?.delegate = newValue }
    }
    
    @objc public override init() {
        super.init()
        model = AlxRewardVideoModel(adApi: self)
    }
    
    @objc public func loadAd(adUnitId: String) {
        model?.loadAd(adUnitId: adUnitId)
    }
    
    @objc public func showAd(present: UIViewController) {
        model?.showAd(present: present)
    }
    
    @objc public func isReady() -> Bool {
        guard let isReadyOK = model?.isReady() else { return false }
        return isReadyOK
    }
    
    @objc public func destroy() {
        model?.destroy()
    }
    
    @objc public func getPrice() -> Double {
        guard let currentPrict = model?.getPrice() else { return 0 }
        return currentPrict
    }
    
    @objc public func reportBiddingUrl() {
        model?.reportBiddingUrl()
    }
    
    @objc public func reportChargingUrl() {
        model?.reportChargingUrl()
    }
    
}
