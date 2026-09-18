//
//  MaxAdsMainListVC.swift
//  RixAdsSDKDemo
//
//  Created by YXk on 2026/8/30.
//

import UIKit
import AppLovinSDK

class MaxAdsMainListVC: BasicMenuViewController {

    override var menuSections: [MenuSection] {
        [
            MenuSection(items: [
                MenuItem(
                    title: NSLocalizedString("banner_ad", comment: ""),
                    description: "Flexible formats at the top, middle or bottom of your app.",
                    makeViewController: { MaxBannerVC() }
                ),
                MenuItem(
                    title: NSLocalizedString("rewardVideo_ad", comment: ""),
                    description: "Users engage with a video ad in exchange for in-app rewards.",
                    makeViewController: { MaxRewardVideoVC() }
                ),
                MenuItem(
                    title: NSLocalizedString("interstitial_ad", comment: ""),
                    description: "Full-screen ads at natural breaks or transition points.",
                    makeViewController: { MaxInterstitialVC() }
                ),
                MenuItem(
                    title: NSLocalizedString("native_ad", comment: ""),
                    description: "Ads that match the look and feel of your app.",
                    makeViewController: { MaxNativeVC() }
                )
            ])
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("max_ad", comment: "")
    }

    override func setupSDK() {
        let initConfig = ALSdkInitializationConfiguration(sdkKey: AdsConfig.Max_App_Key) { builder in
            builder.mediationProvider = ALMediationProviderMAX
        }

        let settings = ALSdk.shared().settings
        settings.setExtraParameterForKey("uid2_token", value: "liuweileliuweile")

        ALPrivacySettings.setDoNotSell(false)
        ALPrivacySettings.setHasUserConsent(true)

        ALSdk.shared().initialize(with: initConfig) { _ in }
    }
}
