//
//  AlxAdmobInterstitialAdapter.swift
//

import Foundation
import GoogleMobileAds
import AlxAds

@objc(AlxAdmobInterstitialAdapter)
public class AlxAdmobInterstitialAdapter: AlxAdmobBaseAdapter,MediationInterstitialAd {
    
    private static let TAG = "AlxAdmobInterstitialAdapter"
    
    private var interstitialAd: AlxInterstitialAd? = nil
    private var delegate: MediationInterstitialAdEventDelegate? = nil
    private var completionHandler: GADMediationInterstitialLoadCompletionHandler? = nil
    
    public func loadInterstitial(for adConfiguration: MediationInterstitialAdConfiguration, completionHandler: @escaping GADMediationInterstitialLoadCompletionHandler) {
        NSLog("%@: loadInterstitial",AlxAdmobInterstitialAdapter.TAG)
        guard let params = AlxAdmobBaseAdapter.parseAdparameter(for: adConfiguration.credentials) else {
            let errorStr="The parameter field is not found in the adConfiguration object"
            NSLog("%@: config params is empty",AlxAdmobInterstitialAdapter.TAG)
            self.delegate=completionHandler(nil,self.error(code: -100,msg: errorStr))
            return
        }
        
        if !AlxAdmobBaseAdapter.isInitialized {
            AlxAdmobBaseAdapter.initSdk(for: params)
        }
        
        guard let adId = params["unitid"] as? String,!adId.isEmpty else{
            let errorStr="unitid is empty in the parameter configuration"
            NSLog("%@: error: %@",AlxAdmobInterstitialAdapter.TAG,errorStr)
            self.delegate=completionHandler(nil,self.error(code: -100,msg: errorStr))
            return
        }
        
        NSLog("%@: loadInterstitial unitid=%@",AlxAdmobInterstitialAdapter.TAG,adId)
        self.completionHandler = completionHandler
        
        // load ad
        self.interstitialAd = AlxInterstitialAd()
        self.interstitialAd?.delegate = self
        self.interstitialAd?.loadAd(adUnitId: adId)
    }
    
    public func present(from viewController: UIViewController) {
        NSLog("%@: present",AlxAdmobInterstitialAdapter.TAG)
        
        if let interstitialAd = self.interstitialAd,interstitialAd.isReady(){
            interstitialAd.showAd(present: viewController)
        }
    }
    
}

extension AlxAdmobInterstitialAdapter:AlxInterstitialAdDelegate {
    
    
    public func interstitialAdLoad(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdLoad",AlxAdmobInterstitialAdapter.TAG)
        if let handler=self.completionHandler{
            self.delegate=handler(self,nil)
        }
    }
    
    public func interstitialAdFailToLoad(_ ad: AlxInterstitialAd, didFailWithError error: Error) {
        NSLog("%@: interstitialAdFailToLoad : %@",AlxAdmobInterstitialAdapter.TAG,error.localizedDescription)
        if let handler=self.completionHandler{
            self.delegate=handler(nil,error)
        }
    }
    
    public func interstitialAdImpression(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdImpression",AlxAdmobInterstitialAdapter.TAG)
        self.delegate?.willPresentFullScreenView()
        self.delegate?.reportImpression()
    }
    
    public func interstitialAdClick(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdClick",AlxAdmobInterstitialAdapter.TAG)
        self.delegate?.reportClick()
    }
    
    public func interstitialAdClose(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdClose",AlxAdmobInterstitialAdapter.TAG)
        self.delegate?.didDismissFullScreenView()
    }
    
    public func interstitialAdRenderFail(_ ad: AlxInterstitialAd, didFailWithError error: Error) {
        NSLog("%@: interstitialAdRenderFail",AlxAdmobInterstitialAdapter.TAG)
    }
    
    public func interstitialAdVideoStart(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdVideoStart",AlxAdmobInterstitialAdapter.TAG)
    }
    
    public func interstitialAdVideoEnd(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdVideoEnd",AlxAdmobInterstitialAdapter.TAG)
    }
    
}
