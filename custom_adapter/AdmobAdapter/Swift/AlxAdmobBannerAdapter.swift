//
//  AlxAdmobBannerAdapter.swift
//

import Foundation
import GoogleMobileAds
import AlxAds

@objc(AlxAdmobBannerAdapter)
public class AlxAdmobBannerAdapter:AlxAdmobBaseAdapter,MediationBannerAd{
    
    private static let TAG = "AlxAdmobBannerAdapter"
    
    // Mark - Banner Ad
    private var bannerAd:AlxBannerAdView? = nil
    // The ad event delegate to forward ad rendering events to the Google Mobile Ads SDK.
    private var delegate:MediationBannerAdEventDelegate? = nil
    // Completion handler called after ad load
    private var completionHandler: GADMediationBannerLoadCompletionHandler? = nil
    
    public func loadBanner(for adConfiguration: MediationBannerAdConfiguration, completionHandler: @escaping GADMediationBannerLoadCompletionHandler) {
        NSLog("%@: loadBanner",AlxAdmobBannerAdapter.TAG)
        guard let params = AlxAdmobBaseAdapter.parseAdparameter(for: adConfiguration.credentials) else {
            let errorStr="The parameter field is not found in the adConfiguration object"
            NSLog("%@: config params is empty",AlxAdmobBannerAdapter.TAG)
            self.delegate=completionHandler(nil,self.error(code: -100,msg: errorStr))
            return
        }
        
        if !AlxAdmobBaseAdapter.isInitialized {
            AlxAdmobBaseAdapter.initSdk(for: params)
        }
        
        guard let adId = params["unitid"] as? String,!adId.isEmpty else{
            let errorStr="unitid is empty in the parameter configuration"
            NSLog("%@: error: %@",AlxAdmobBannerAdapter.TAG,errorStr)
            self.delegate=completionHandler(nil,self.error(code: -100,msg: errorStr))
            return
        }
        
        NSLog("%@: loadBanner unitid=%@",AlxAdmobBannerAdapter.TAG,adId)
        self.completionHandler = completionHandler
        
        // load ad
        let adSize = CGSize(width: adConfiguration.adSize.size.width, height: adConfiguration.adSize.size.height)
        self.bannerAd=AlxBannerAdView(frame: CGRect(origin: .zero, size: adSize))
        self.bannerAd?.delegate = self
        self.bannerAd?.refreshInterval = 0
        self.bannerAd?.rootViewController=adConfiguration.topViewController
        self.bannerAd?.loadAd(adUnitId: adId)
    }
    
    
    public var view: UIView {
        return bannerAd ?? UIView()
    }
}

extension AlxAdmobBannerAdapter:AlxBannerViewAdDelegate {
    
    
    public func bannerViewAdLoad(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdLoad",AlxAdmobBannerAdapter.TAG)
        if let handler=self.completionHandler{
            self.delegate=handler(self,nil)
        }
    }
    
    public func bannerViewAdFailToLoad(_ bannerView: AlxBannerAdView, didFailWithError error: Error){
        NSLog("%@: bannerViewAdFailToLoad: %@",AlxAdmobBannerAdapter.TAG,error.localizedDescription)
        if let handler=self.completionHandler{
            self.delegate=handler(self,error)
        }
    }
    
    public func bannerViewAdImpression(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdImpression",AlxAdmobBannerAdapter.TAG)
        self.delegate?.reportImpression()
    }
    
    public func bannerViewAdClick(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdClick",AlxAdmobBannerAdapter.TAG)
        self.delegate?.reportClick()
    }
    
    public func bannerViewAdClose(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdClose",AlxAdmobBannerAdapter.TAG)
        self.delegate?.didDismissFullScreenView()
    }
    
    
}
