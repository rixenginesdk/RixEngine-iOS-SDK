//
//  MaxBannerVC.swift
//  AdsDemo
//
//  Created by liu weile on 2023/6/2.
//

import UIKit
import AppLovinSDK

class MaxBannerVC: BaseUIViewController {
    
    private let TAG = "Max-banner:"
    
    private var label:UILabel!

    private var isLoading:Bool=false

    private var bannerView:MAAdView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.title=NSLocalizedString("max_banner", comment: "")

        let bnLoad=createButton(title: NSLocalizedString("load_ad", comment: ""),  action: #selector(buttonLoad))
        view.addSubview(bnLoad)
        
        label=createLabel()
        view.addSubview(label)

        bannerView=MAAdView(adUnitIdentifier: AdConfig.Max_Banner_Ad_Id)
        bannerView.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(bannerView)
        let height:CGFloat=MAAdFormat.banner.adaptiveSize.height
          

        NSLayoutConstraint.activate([
            bnLoad.leftAnchor.constraint(equalTo: view.leftAnchor),
            bnLoad.rightAnchor.constraint(equalTo: view.rightAnchor),
            bnLoad.widthAnchor.constraint(equalTo: view.widthAnchor),
            bnLoad.heightAnchor.constraint(equalToConstant: 50),
            bnLoad.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),


            label.leftAnchor.constraint(equalTo: view.leftAnchor),
            label.rightAnchor.constraint(equalTo: view.rightAnchor),
            label.widthAnchor.constraint(equalTo: view.widthAnchor),
            label.heightAnchor.constraint(equalToConstant: 50),
            label.topAnchor.constraint(equalTo: bnLoad.bottomAnchor, constant: 20),

//            bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bannerView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            bannerView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            bannerView.heightAnchor.constraint(equalToConstant: height),

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
        bannerView.delegate=self
        
        bannerView.setExtraParameterForKey("adaptive_banner", value: "true")
        bannerView.setLocalExtraParameterForKey("adaptive_banner_width", value: 400)
//        bannerView.getAdFormat().getAdaptiveSize(400).getHeight() // Set your ad height to this value
        
        bannerView.loadAd()
    }
    
    func updateUI(_ loading:Bool,_ msg:String){
        self.isLoading=loading
        self.label.text=msg
    }

   

}

extension MaxBannerVC:MAAdViewAdDelegate{
    
    func didExpand(_ ad: MAAd) {
        print("\(TAG) didExpand")
    }
    
    func didCollapse(_ ad: MAAd) {
        print("\(TAG) didCollapse")
    }
    
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
        print("\(TAG) didFail: \(error.code) \(error.description)")
    }
    
    
}
