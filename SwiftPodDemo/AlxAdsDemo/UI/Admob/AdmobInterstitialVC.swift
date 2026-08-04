//
//  AdmobInterstitialVC.swift
//  AdsDemo
//
//  Created by liu weile on 2023/5/30.
//

import UIKit
import GoogleMobileAds

class AdmobInterstitialVC: BaseUIViewController {
    
    private let TAG = "Admob-interstitial:"

    private var label:UILabel!

    private var isLoading:Bool=false

    private var interstitialAd:InterstitialAd?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.title=NSLocalizedString("admob_interstitial", comment: "")

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
        if let ad=interstitialAd {
            ad.present(from: self)
        }else{
            print("Ad wasn't ready")
        }
    }
    
    func loadAd() {
        let request = Request()
        InterstitialAd.load(with:AdConfig.Admob_Interstitial_Ad_Id,
                           request: request,
                           completionHandler: { [self] ad, error in
            if let error = error {
                let error1 = error as NSError
                let msg="\(error1.code): \(error1.localizedDescription)"
                print("\(TAG) load: errror: \(msg)")
                updateUI(false, String(format: NSLocalizedString("load_failed", comment: ""), msg))
                return
            }
            print("\(TAG) load: success")
            updateUI(false, NSLocalizedString("load_success", comment: ""))
            self.interstitialAd = ad
            self.interstitialAd?.fullScreenContentDelegate=self
        })
    }
    
    func updateUI(_ loading:Bool,_ msg:String){
        self.isLoading=loading
        self.label.text=msg
    }

}

extension AdmobInterstitialVC:FullScreenContentDelegate{
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        let error1 = error as NSError
        let msg = "\(error1.code): \(error1.localizedDescription)"
        print("\(TAG) ad: error:\(msg)")
    }

    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("\(TAG) adWillPresentFullScreenContent")
    }

    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("\(TAG) adDidDismissFullScreenContent")
    }
    
    func adDidRecordImpression(_ ad: any FullScreenPresentingAd) {
        print("\(TAG) adDidRecordImpression")
    }
    
    func adDidRecordClick(_ ad: any FullScreenPresentingAd) {
        print("\(TAG) adDidRecordClick")
    }
    
    func adWillDismissFullScreenContent(_ ad: any FullScreenPresentingAd) {
        print("\(TAG) adWillDismissFullScreenContent")
    }
    
}

