//
//  AlxInterstitialAd.swift
//  AlxAds
//
//  Created by liu weile on 2025/4/25.
//

import Foundation
import UIKit

@objc public class AlxInterstitialAd:NSObject,AlxAdDelegate {
    
    private var model:AlxInterstitialModel!
    
    @objc public weak var delegate:AlxInterstitialAdDelegate? {
        get { model.delegate }
        set { model.delegate = newValue }
    }
    
    @objc public override init(){
        super.init()
        model = AlxInterstitialModel(adApi: self)
    }
    
    @objc public func loadAd(adUnitId:String){
        model.loadAd(adUnitId: adUnitId)
    }
    
    @objc public func showAd(present:UIViewController){
        model.showAd(present: present)
    }
    
    @objc public func isReady()->Bool {
        return model.isReady()
    }
    
    @objc public func destroy(){
        model.destroy()
    }
    
    @objc public func getPrice() -> Double {
        return model.getPrice()
    }
    
    @objc public func reportBiddingUrl() {
        model.reportBiddingUrl()
    }
    
    @objc public func reportChargingUrl() {
        model.reportChargingUrl()
    }
    
}
