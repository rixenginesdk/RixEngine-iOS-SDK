//
//  AlxNativeAdLoader.swift
//  AlxAds
//
//  Created by liu weile on 2025/5/6.
//

import Foundation

@objc public class AlxNativeAdLoader:NSObject {
    
    private var model:AlxNativeAdModel!
    
    @objc public weak var delegate:AlxNativeAdLoaderDelegate? {
        get { model.delegate }
        set { model.delegate = newValue }
    }
    
    private override init() {
        super.init()
        model = AlxNativeAdModel()
    }
    
    @objc public init(adUnitID:String) {
        super.init()
        model = AlxNativeAdModel(adUnitID: adUnitID)
    }
    
    @objc public func loadAd(){
        model.load()
    }
    
    //    @objc public func loadAd(_ request:AlxAdRequest){
    //        model.load(request: request)
    //    }
    
}
