//
//  TopOnBannerVC.swift
//  AlxAdsDemo
//
//  Created by liu weile on 2025/8/18.
//

import UIKit
import AnyThinkSDK
import AnyThinkBanner

class TopOnBannerVC: BaseUIViewController {
    
    private let TAG = "TopOn-banner:"
    
    private var label:UILabel!

    private var isLoading:Bool=false

    private var adContainer:UIView!
    private var bannerView:ATBannerView?
    
    private let bannerSize:CGSize=CGSize(width: 320, height: 50)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.title=NSLocalizedString("topOn_banner", comment: "")

        let bnLoad=createButton(title: NSLocalizedString("load_ad", comment: ""),  action: #selector(buttonLoad))
        view.addSubview(bnLoad)
        
        label=createLabel()
        view.addSubview(label)
        
        adContainer=UIView()
        adContainer.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(adContainer)

        NSLayoutConstraint.activate([
            bnLoad.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bnLoad.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bnLoad.heightAnchor.constraint(equalToConstant: 50),
            bnLoad.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
           
            label.topAnchor.constraint(equalTo: bnLoad.bottomAnchor, constant: 20),
            label.widthAnchor.constraint(equalTo: view.widthAnchor),
            label.heightAnchor.constraint(equalToConstant: 50),
            
            adContainer.topAnchor.constraint(equalTo: label.bottomAnchor,constant: 20),
            adContainer.widthAnchor.constraint(equalTo: view.widthAnchor),
            adContainer.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    
    @objc func buttonLoad(){
        print("load ad")
        if isLoading {
            return
        }
        updateUI(true, NSLocalizedString("loading", comment: ""))

        loadAd()
    }
    
    private func loadAd(){
        var extra:[String:Any] = [:]
        extra[kATAdLoadingExtraMediaExtraKey]="media_val_BannerVC"
        
        ATAdManager.shared().loadAD(withPlacementID: AdConfig.TopOn_Banner_Ad_Id, extra: extra, delegate: self)
    }
    
    func updateUI(_ loading:Bool,_ msg:String){
        self.isLoading=loading
        self.label.text=msg
    }
    
    func showAd(){
        if !ATAdManager.shared().bannerAdReady(forPlacementID: AdConfig.TopOn_Banner_Ad_Id) {
            print("Ad wasn't ready")
            self.label.text="Ad wasn't ready"
            return
        }
        let bannerView:ATBannerView? = ATAdManager.shared().retrieveBannerView(forPlacementID: AdConfig.TopOn_Banner_Ad_Id)
        if let bannerView = bannerView  {
            bannerView.delegate=self
            bannerView.presentingViewController=self
            bannerView.translatesAutoresizingMaskIntoConstraints = false
            self.bannerView = bannerView
            
            clearSubView(adContainer)
            adContainer.addSubview(bannerView)
            
            NSLayoutConstraint.activate([
                bannerView.topAnchor.constraint(equalTo: adContainer.topAnchor),
                bannerView.bottomAnchor.constraint(equalTo: adContainer.bottomAnchor),
                bannerView.centerXAnchor.constraint(equalTo: adContainer.centerXAnchor),
                bannerView.widthAnchor.constraint(equalToConstant: bannerSize.width),
                bannerView.heightAnchor.constraint(equalToConstant: bannerSize.height),
            ])
        }else{
            self.label.text="TopOn BannerView is empty"
        }
        
    }
    
    func close(){
        self.bannerView?.destroyBanner()
        self.bannerView?.removeFromSuperview()
        self.bannerView = nil
    }
   

}

extension TopOnBannerVC:ATAdLoadingDelegate{
    
    func didFinishLoadingAD(withPlacementID placementID: String!) {
        print("\(TAG) didFinishLoadingAD")
        updateUI(false, NSLocalizedString("load_success", comment: ""))
        self.showAd()
    }
    
    func didFailToLoadAD(withPlacementID placementID: String!, error: (any Error)!) {
        let msg="\(error.code): \(error.localizedDescription)"
        print("\(TAG) didFailToLoadAD: \(msg)")
        updateUI(false, String(format: NSLocalizedString("load_failed", comment: ""), msg))
    }
    
}


extension TopOnBannerVC:ATBannerDelegate {
    
    
    func bannerView(_ bannerView: ATBannerView, didShowAdWithPlacementID placementID: String, extra: [AnyHashable : Any]) {
        print("\(TAG) bannerView: Impression")
    }
    
    func bannerView(_ bannerView: ATBannerView, didClickWithPlacementID placementID: String, extra: [AnyHashable : Any]) {
        print("\(TAG) bannerView: click")
    }
    
    func bannerView(_ bannerView: ATBannerView, didTapCloseButtonWithPlacementID placementID: String, extra: [AnyHashable : Any]) {
        print("\(TAG) bannerView: close")
        self.close()
    }
    
    
    
    
}
