//
//  TopOnInterstitialVC.swift
//  AlxAdsDemo
//
//  Created by liu weile on 2025/8/21.
//

import UIKit
import AnyThinkSDK
import AnyThinkInterstitial

class TopOnInterstitialVC: BaseUIViewController {
    
    private let TAG = "TopOn-interstitial:"

    private var label:UILabel!

    private var isLoading:Bool=false

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.title=NSLocalizedString("topOn_interstitial", comment: "")

        let bnLoad=createButton(title: NSLocalizedString("load_ad", comment: ""),  action: #selector(buttonLoad))
        view.addSubview(bnLoad)

        let bnShow=createButton(title: NSLocalizedString("show_ad", comment: ""),  action: #selector(buttonShow))
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
    }
    
    @objc func buttonLoad(){
        print("bnLoad")
        if isLoading {
            return
        }

        updateUI(true, NSLocalizedString("loading", comment: ""))

        loadAd()
    }
    
    func updateUI(_ loading:Bool,_ msg:String){
        self.isLoading=loading
        self.label.text=msg
    }

    
    @objc func buttonShow(){
        if ATAdManager.shared().interstitialReady(forPlacementID: AdConfig.TopOn_Interstitial_Ad_Id) {
            ATAdManager.shared().showInterstitial(withPlacementID: AdConfig.TopOn_Interstitial_Ad_Id, in: self, delegate: self)
        }else{
            print("Ad wasn't ready")
        }
    }
    
    func loadAd() {
        var extra:[String:Any] = [:]
        extra[kATAdLoadingExtraMediaExtraKey]="media_val_InterstitialVC"
        
        ATAdManager.shared().loadAD(withPlacementID: AdConfig.TopOn_Interstitial_Ad_Id, extra: extra, delegate: self)
    }

}

extension TopOnInterstitialVC:ATAdLoadingDelegate{
    
    func didFinishLoadingAD(withPlacementID placementID: String) {
        print("\(TAG) didFinishLoadingAD")
        updateUI(false, NSLocalizedString("load_success", comment: ""))
    }
    
    func didFailToLoadAD(withPlacementID placementID: String, error: (any Error)) {
        let msg="\(error.code): \(error.localizedDescription)"
        print("\(TAG) didFailToLoadAD: \(msg)")
        updateUI(false, String(format: NSLocalizedString("load_failed", comment: ""), msg))
    }
    
}

extension TopOnInterstitialVC:ATInterstitialDelegate{
    
    func interstitialDidShow(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        print("\(TAG) interstitialDidShow: impression")
    }
    
    func interstitialDidClick(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        print("\(TAG) interstitialDidClick: click")
    }
    
    func interstitialDidClose(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
        print("\(TAG) interstitialDidClose: close")
    }
    
    
}
