//
//  AlxTopOnNativeEvent.swift
//

import Foundation
import AnyThinkSDK
//import AnyThinkNative
import AlxAds

@objc(AlxTopOnNativeEvent)
public class AlxTopOnNativeEvent: ATNativeADCustomEvent,AlxNativeAdLoaderDelegate,AlxNativeAdDelegate {
    
    private static let TAG = "AlxTopOnNativeEvent"
    
    public var assetDict:[AnyHashable:Any] = [:]
    
    public override init(info serverInfo: [AnyHashable : Any], localInfo: [AnyHashable : Any]) {
        super.init(info: serverInfo, localInfo: localInfo)
    }
    
    public func nativeAdLoaded(didReceive ads: [AlxNativeAd]) {
        print("\(AlxTopOnNativeEvent.TAG): nativeAdLoaded")
        
        guard let nativeAd = ads.first else{
            let errorStr = "native ad data is empty"
            print("\(AlxTopOnNativeEvent.TAG): native ad data is empty")
            let error = AlxTopOnBaseManager.error(code: -100, msg: errorStr)
            if self.isC2SBiding {
                AlxTopOnBiddingRequestManager.disposeLoadFail(error: error, unitID: AlxTopOnBaseManager.parseUnitID(from: self.serverInfo))
            }else{
                self.trackNativeAdLoadFailed(error)
            }
            return
        }
        
        let assetData = self.createAsset(nativeAd: nativeAd)
        if self.isC2SBiding {
            self.assetDict = assetData
            AlxTopOnBiddingRequestManager.disposeLoadSuccess(price: nativeAd.getPrice(), unitID: AlxTopOnBaseManager.parseUnitID(from: self.serverInfo))
            self.isC2SBiding = false
        }else{
            self.trackNativeAdLoaded([assetData])
        }
    }
    
    public func nativeAdFailToLoad(didFailWithError error: Error) {
        print("\(AlxTopOnNativeEvent.TAG): nativeAdFailToLoad")
        if self.isC2SBiding {
            AlxTopOnBiddingRequestManager.disposeLoadFail(error: error, unitID: AlxTopOnBaseManager.parseUnitID(from: self.serverInfo))
        }else{
            self.trackNativeAdLoadFailed(error)
        }
    }
    
    public func nativeAdImpression(_ nativeAd:AlxNativeAd){
        print("\(AlxTopOnNativeEvent.TAG): nativeAdImpression")
        self.trackNativeAdImpression()
    }
    
    public func nativeAdClick(_ nativeAd:AlxNativeAd){
        print("\(AlxTopOnNativeEvent.TAG): nativeAdClick")
        self.trackNativeAdClick()
    }
    
    public func nativeAdClose(_ nativeAd:AlxNativeAd){
        print("\(AlxTopOnNativeEvent.TAG): nativeAdClose")
        self.trackNativeAdClosed()
    }
    
    public func createAsset(nativeAd:AlxNativeAd)->[AnyHashable:Any]{
        var assetDic:[AnyHashable:Any] = [:]
        assetDic[kATAdAssetsCustomEventKey] = self
        assetDic[kATAdAssetsCustomObjectKey] = nativeAd
        
        //原生广告自渲染：数据添加
        assetDic[kATNativeADAssetsIsExpressAdKey] = false
        assetDic[kATNativeADAssetsMainTitleKey] = nativeAd.title
        assetDic[kATNativeADAssetsMainTextKey] = nativeAd.desc
        assetDic[kATNativeADAssetsIconURLKey] = nativeAd.icon?.url
        assetDic[kATNativeADAssetsImageURLKey] = nativeAd.images?.first?.url
        assetDic[kATNativeADAssetsCTATextKey] = nativeAd.callToAction
        assetDic[kATNativeADAssetsAdvertiserKey] = nativeAd.adSource
        assetDic[kATNativeADAssetsLogoImageKey] = nativeAd.adLogo
        assetDic[kATNativeADAssetsContainsVideoFlag] = nativeAd.createType == AlxNativeAd.Create_Type_Video ? true : false
        
        if nativeAd.images?.count == 1,let mainImage = nativeAd.images?.first {
            assetDic[kATNativeADAssetsMainImageWidthKey] = mainImage.width
            assetDic[kATNativeADAssetsMainImageHeightKey] = mainImage.height
        }
        
        return assetDic
    }
    
    public override var networkUnitId: String {
        get {
            return AlxTopOnBaseManager.parseUnitID(from: self.serverInfo) ?? ""
        }
        set {
        }
    }
    
    public override var assets: NSMutableArray{
        get {
            return [self.assetDict]
        }
        set {
        }
    }
    
}
