//
//  MaxMainVC.swift
//  AdsDemo
//
//  Created by liu weile on 2023/6/2.
//

import UIKit
import AppLovinSDK

class MaxMainVC: BaseUIViewController {

    var bnBanner:UIButton!
    var bnReward:UIButton!
    var bnInterstitial:UIButton!
    var bnNative:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title=NSLocalizedString("max_ad", comment: "")
        
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
        navigationController?.pushViewController(MaxBannerVC(), animated: false)
    }

    @objc func buttonReward(){
        navigationController?.pushViewController(MaxRewardVideoVC(), animated: false)
    }

    @objc func buttonInterstitial(){
        navigationController?.pushViewController(MaxInterstitialVC(), animated: false)
    }

    @objc func buttonNative(){
        navigationController?.pushViewController(MaxNativeVC(), animated: false)
    }
    
    private func initSDK(){
        let initConfig = ALSdkInitializationConfiguration(sdkKey: AdConfig.Max_App_Key) { builder in
            builder.mediationProvider = ALMediationProviderMAX
        }
        
        let settings = ALSdk.shared().settings
        settings.setExtraParameterForKey("uid2_token", value: "liuweileliuweile")
        
        ALPrivacySettings.setDoNotSell(false)
        ALPrivacySettings.setHasUserConsent(true)

          // Initialize the SDK with the configuration
        ALSdk.shared().initialize(with: initConfig) { sdkConfig in
        // Start loading ads
        }
    }

}
