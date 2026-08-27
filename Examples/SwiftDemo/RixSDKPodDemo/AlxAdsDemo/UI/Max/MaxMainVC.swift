//
//  MaxMainVC.swift
//  AdsDemo
//
//  Created by liu weile on 2023/6/2.
//

import UIKit
import AppLovinSDK

class MaxMainVC: BaseMenuVC {

    override var menuItems: [MenuItem] {[
        (title: NSLocalizedString("banner_ad",       comment: ""), makeVC: { MaxBannerVC() }),
        (title: NSLocalizedString("rewardVideo_ad",  comment: ""), makeVC: { MaxRewardVideoVC() }),
        (title: NSLocalizedString("interstitial_ad", comment: ""), makeVC: { MaxInterstitialVC() }),
        (title: NSLocalizedString("native_ad",       comment: ""), makeVC: { MaxNativeVC() }),
    ]}

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("max_ad", comment: "")
    }

    override var menuAppearance: MenuAppearance { .card }

    override func menuSubtitle(at index: Int) -> String? {
        let subtitles = [
            "Flexible formats at the top, middle or bottom of your app.",
            "Users engage with a video ad in exchange for in-app rewards.",
            "Full-screen ads at natural breaks or transition points.",
            "Ads that match the look and feel of your app."
        ]
        guard index >= 0, index < subtitles.count else { return nil }
        return subtitles[index]
    }

    override func setupSDK() {
        let initConfig = ALSdkInitializationConfiguration(sdkKey: AdConfig.Max_App_Key) { builder in
            builder.mediationProvider = ALMediationProviderMAX
        }

        let settings = ALSdk.shared().settings
        settings.setExtraParameterForKey("uid2_token", value: "liuweileliuweile")

        ALPrivacySettings.setDoNotSell(false)
        ALPrivacySettings.setHasUserConsent(true)

        ALSdk.shared().initialize(with: initConfig) { _ in }
    }
}
