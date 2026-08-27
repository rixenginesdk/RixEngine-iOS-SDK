//
//  AlxInterstitialBannerVC.swift
//  AlxDemo
//
//  Created by liu weile on 2025/4/25.
//

import UIKit
import AlxAds

class AlxInterstitialBannerVC: BaseUIViewController {
    
    private let TAG = "Alx-interstitial:"

    private var interstitialAd:AlxInterstitialAd!
    
    private var label:UILabel!
    
    private var isLoading:Bool=false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title=NSLocalizedString("interstitial_banner_ad", comment: "")
        
        let bnLoad=createButton(title: NSLocalizedString("load_ad", comment: ""),  action: #selector(loadAd))
        view.addSubview(bnLoad)
        
        let bnShow=createButton(title: NSLocalizedString("show_ad", comment: ""),  action: #selector(showAd))
        view.addSubview(bnShow)
        
        label=createLabel()
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            bnLoad.leftAnchor.constraint(equalTo: view.leftAnchor),
            bnLoad.rightAnchor.constraint(equalTo: view.rightAnchor),
            bnLoad.widthAnchor.constraint(equalTo: view.widthAnchor),
            bnLoad.heightAnchor.constraint(equalToConstant: 50),
            bnLoad.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            bnShow.leftAnchor.constraint(equalTo: view.leftAnchor),
            bnShow.rightAnchor.constraint(equalTo: view.rightAnchor),
            bnShow.widthAnchor.constraint(equalTo: view.widthAnchor),
            bnShow.heightAnchor.constraint(equalToConstant: 50),
            bnShow.topAnchor.constraint(equalTo: bnLoad.bottomAnchor, constant: 20),
            
            label.leftAnchor.constraint(equalTo: view.leftAnchor),
            label.rightAnchor.constraint(equalTo: view.rightAnchor),
            label.widthAnchor.constraint(equalTo: view.widthAnchor),
            label.heightAnchor.constraint(equalToConstant: 50),
            label.topAnchor.constraint(equalTo: bnShow.bottomAnchor, constant: 20),
           
        ])
        
        createAd()
    }
    
    private func createAd(){
        interstitialAd=AlxInterstitialAd()
    }
    
    @objc func loadAd(){
        if isLoading {
            return
        }
        
        isLoading=true
        label.text=NSLocalizedString("loading", comment: "")
        
        interstitialAd.delegate = self
        interstitialAd.loadAd(adUnitId: AdConfig.Alx_Interstitial_Banner_Ad_Id)
    }
    
    @objc func showAd(){
        if interstitialAd.isReady() {
            interstitialAd.showAd(present: self)
        }
    }

}

extension AlxInterstitialBannerVC:AlxInterstitialAdDelegate {
    
    
    func interstitialAdLoad(_ ad: AlxInterstitialAd) {
        print("\(TAG) interstitialAdLoaded")
        self.isLoading=false
        self.label.text=NSLocalizedString("load_success", comment: "")
    }
    
    func interstitialAdFailToLoad(_ ad: AlxInterstitialAd, didFailWithError error: Error) {
        let error1=error as NSError
        let msg="\(error1.code): \(error1.localizedDescription)"
        print("\(TAG) interstitialAdFailedToLoad: \(msg)")
        self.isLoading=false
        self.label.text=String(format: NSLocalizedString("load_failed", comment: ""), msg)
    }
    
    func interstitialAdImpression(_ ad: AlxInterstitialAd) {
        print("\(TAG) interstitialAdImpression")
    }
    
    func interstitialAdClick(_ ad: AlxInterstitialAd) {
        print("\(TAG) interstitialAdClick")
    }
    
    func interstitialAdClose(_ ad: AlxInterstitialAd) {
        print("\(TAG) interstitialAdClose")
    }
    
    func interstitialAdRenderFail(_ ad: AlxInterstitialAd, didFailWithError error: Error) {
        print("\(TAG) interstitialAdRenderFailed: \(error.localizedDescription)")
    }
    
    func interstitialAdVideoStart(_ ad: AlxInterstitialAd) {
        print("\(TAG) interstitialAdVideoStart")
    }
    
    func interstitialAdVideoEnd(_ ad: AlxInterstitialAd) {
        print("\(TAG) interstitialAdVideoEnd")
    }
   
}
