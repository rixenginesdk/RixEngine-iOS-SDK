//
//  MaxInterstitialVC.swift
//  AdsDemo
//
//  Created by liu weile on 2023/6/2.
//

import UIKit
import AppLovinSDK

class MaxInterstitialVC: BaseUIViewController {
    
    private let TAG = "Max-interstitial:"

    private var label:UILabel!

    private var isLoading:Bool=false

    private var interstitialAd:MAInterstitialAd?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.title=NSLocalizedString("max_interstitial", comment: "")

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

    @objc func buttonShow(){
        if let ad=interstitialAd,ad.isReady {
            ad.show()
        }else{
            print("Ad wasn't ready")
        }
    }
    
    func loadAd() {
        interstitialAd=MAInterstitialAd(adUnitIdentifier: AdConfig.Max_Interstitial_Ad_Id)
        interstitialAd?.delegate=self
        interstitialAd?.load()
    }
    
    
    func updateUI(_ loading:Bool,_ msg:String){
        self.isLoading=loading
        self.label.text=msg
    }

}

extension MaxInterstitialVC:MAAdDelegate{
    
    func didLoad(_ ad: MAAd) {
        print("\(TAG) didLoad")
        updateUI(false, NSLocalizedString("load_success", comment: ""))
    }
    
    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        let msg="\(error.code): \(error.description)"
        print("\(TAG) didFailToLoadAd: \(msg)")
        updateUI(false, String(format: NSLocalizedString("load_failed", comment: ""), msg))
    }
    
    func didDisplay(_ ad: MAAd) {
        print("\(TAG) didDisplay")
    }
    
    func didHide(_ ad: MAAd) {
        print("\(TAG) didHide")
    }
    
    func didClick(_ ad: MAAd) {
        print("\(TAG) didClick")
    }
    
    func didFail(toDisplay ad: MAAd, withError error: MAError) {
        print("\(TAG) didFail:\(error.code) \(error.description)")
    }
    
    
}
