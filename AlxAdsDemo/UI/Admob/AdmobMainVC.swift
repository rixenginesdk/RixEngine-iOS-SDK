//
//  AdmobMainVC.swift
//  AdsDemo
//
//  Created by liu weile on 2023/5/30.
//


import UIKit
import GoogleMobileAds

class AdmobMainVC: BaseUIViewController {

    var bnBanner:UIButton!
    var bnReward:UIButton!
    var bnInterstitial:UIButton!
    var bnNative:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title=NSLocalizedString("admob_ad", comment: "")

        // Mark: init SDK
        initSDK()

        let scrollView=UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(scrollView)
        scrollView.isScrollEnabled=true
        
        let contentView=UIStackView()
        contentView.translatesAutoresizingMaskIntoConstraints=false
        scrollView.addSubview(contentView)
        contentView.axis = .vertical
        contentView.spacing = 20


        bnBanner=createButton(title: NSLocalizedString("banner_ad", comment: ""), action: #selector(buttonBanner))
        contentView.addArrangedSubview(bnBanner)

        bnReward=createButton(title: NSLocalizedString("rewardVideo_ad", comment: ""), action: #selector(buttonReward))
        contentView.addArrangedSubview(bnReward)

        bnInterstitial=createButton(title: NSLocalizedString("interstitial_ad", comment: ""), action: #selector(buttonInterstitial))
        contentView.addArrangedSubview(bnInterstitial)

        bnNative=createButton(title: NSLocalizedString("native_ad", comment: ""), action: #selector(buttonNative))
        contentView.addArrangedSubview(bnNative)


        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor,constant: 20),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            bnBanner.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bnBanner.heightAnchor.constraint(equalToConstant: 50),

            bnReward.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bnReward.heightAnchor.constraint(equalToConstant: 50),

            bnInterstitial.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bnInterstitial.heightAnchor.constraint(equalToConstant: 50),

            bnNative.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bnNative.heightAnchor.constraint(equalToConstant: 50),
            
        ])
        
    }

    @objc func buttonBanner(){
        navigationController?.pushViewController(AdmobBannerVC(), animated: false)
    }

    @objc func buttonReward(){
        navigationController?.pushViewController(AdmobRewardVideoVC(), animated: false)
    }

    @objc func buttonInterstitial(){
        navigationController?.pushViewController(AdmobInterstitialVC(), animated: false)
    }

    @objc func buttonNative(){
        navigationController?.pushViewController(AdmobNativeVC(), animated: false)
    }

    
    private func initSDK(){
        MobileAds.shared.start(){status in
            let adapterStatuses = status.adapterStatusesByClassName
            for adapter in adapterStatuses {
                let adapterStatus = adapter.value
                NSLog("Adapter Name: %@, Description: %@, Latency: %f", adapter.key,
                adapterStatus.description, adapterStatus.latency)
            }
        }
    }

}
