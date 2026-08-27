//
//  AdmobBannerVCViewController.swift
//  AdsDemo
//
//  Created by liu weile on 2023/5/30.
//

import UIKit
import GoogleMobileAds


class AdmobBannerVC: BaseUIViewController {
    
    private let TAG = "Admob-banner:"
    
    private var label:UILabel!

    private var isLoading:Bool=false

    private var bannerView:BannerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.title=NSLocalizedString("admob_banner", comment: "")

        let bnLoad=createButton(title: NSLocalizedString("load_ad", comment: ""),  action: #selector(buttonLoad))
        view.addSubview(bnLoad)
        
        label=createLabel()
        view.addSubview(label)

        bannerView=BannerView(adSize: AdSizeBanner)
        bannerView.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(bannerView)
          

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

            bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bannerView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),

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
        bannerView.adUnitID = AdConfig.Admob_Banner_Ad_Id
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(Request())
    }
    
    func updateUI(_ loading:Bool,_ msg:String){
        self.isLoading=loading
        self.label.text=msg
    }

}

extension AdmobBannerVC: BannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: BannerView) {
        print("\(TAG) bannerViewDidReceiveAd")
        updateUI(false, NSLocalizedString("load_success", comment: ""))
    }

    func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
        let error1 = error as NSError
        let msg = "\(error1.code): \(error1.localizedDescription)"
        print("\(TAG) bannerView: error: \(msg)")
        updateUI(false, String(format: NSLocalizedString("load_failed", comment: ""), msg))
    }

    func bannerViewDidRecordImpression(_ bannerView: BannerView) {
        print("\(TAG) bannerViewDidRecordImpression")
    }
    
    func bannerViewDidRecordClick(_ bannerView: BannerView) {
        print("\(TAG) bannerViewDidRecordClick")
    }

    func bannerViewWillPresentScreen(_ bannerView: BannerView) {
        print("\(TAG) bannerViewWillPresentScreen")
    }

    func bannerViewWillDismissScreen(_ bannerView: BannerView) {
        print("\(TAG) bannerViewWillDIsmissScreen")
    }

    func bannerViewDidDismissScreen(_ bannerView: BannerView) {
        print("\(TAG) bannerViewDidDismissScreen")
    }
}
