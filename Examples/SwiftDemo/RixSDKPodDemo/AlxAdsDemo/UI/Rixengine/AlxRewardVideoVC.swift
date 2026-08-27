//
//  AlxRewardVideoVC.swift
//  AlxDemo
//
//  Created by liu weile on 2025/3/31.
//

import UIKit
import AlxAds

class AlxRewardVideoVC: BaseUIViewController {
    
    private let TAG = "Alx-rewardVideo:"

    private var rewardAd:AlxRewardVideoAd!
    
    private var label:UILabel!
    
    private var isLoading:Bool=false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title=NSLocalizedString("rewardVideo_ad", comment: "")
        
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
        rewardAd=AlxRewardVideoAd()
    }
    
    @objc func loadAd(){
        if isLoading {
            return
        }
        isLoading=true
        label.text=NSLocalizedString("loading", comment: "")
        
        rewardAd.delegate = self
        rewardAd.loadAd(adUnitId: AdConfig.Alx_Reward_Video_Ad_Id)
    }
    
    @objc func showAd(){
        if rewardAd.isReady() {
            rewardAd.showAd(present: self)
        }
    }

}

extension AlxRewardVideoVC:AlxRewardVideoAdDelegate{
    
    func rewardVideoAdLoad(_ ad: AlxRewardVideoAd) {
        print("\(TAG) rewardVideoAdLoad")
        self.isLoading=false
        self.label.text=NSLocalizedString("load_success", comment: "")
    }
    
    func rewardVideoAdFailToLoad(_ ad: AlxRewardVideoAd, didFailWithError error: Error) {
        let error1=error as NSError
        let msg="\(error1.code): \(error1.localizedDescription)"
        print("\(TAG) rewardVideoAdFailToLoad: \(msg)")
        
        self.isLoading=false
        self.label.text=String(format: NSLocalizedString("load_failed", comment: ""), msg)
    }
    
    func rewardVideoAdImpression(_ ad: AlxRewardVideoAd) {
        print("\(TAG) rewardVideoAdImpression")
    }
    
    func rewardVideoAdClick(_ ad: AlxRewardVideoAd) {
        print("\(TAG) rewardVideoAdClick")
    }
    
    func rewardVideoAdClose(_ ad: AlxRewardVideoAd) {
        print("\(TAG) rewardVideoAdClose")
    }
    
    func rewardVideoAdPlayStart(_ ad:AlxRewardVideoAd) {
        print("\(TAG) rewardVideoAdPlayStart")
    }
    
    func rewardVideoAdPlayEnd(_ ad: AlxRewardVideoAd) {
        print("\(TAG) rewardVideoAdPlayEnd")
    }
    
    func rewardVideoAdReward(_ ad: AlxRewardVideoAd) {
        print("\(TAG) rewardVideoAdReward")
    }
    
    func rewardVideoAdPlayFail(_ ad: AlxRewardVideoAd, didFailWithError error: Error) {
        print("\(TAG) rewardVideoAdPlayFail \(error.localizedDescription)")
    }
    
        
    
}


