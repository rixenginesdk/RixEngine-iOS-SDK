//
//  UnityAdsMainListVC.swift
//  RixAdsSDKDemo
//
//  Created by YXk on 2026/8/30.
//

import UIKit
import IronSource

class UnityAdsMainListVC: BasicMenuViewController {

    override var menuSections: [MenuSection] {
        [
            MenuSection(items: [
                MenuItem(
                    title: NSLocalizedString("banner_ad", comment: ""),
                    description: "Flexible formats at the top, middle or bottom of your app.",
                    makeViewController: { LevelPlayBannerVC() }
                ),
                MenuItem(
                    title: NSLocalizedString("rewardVideo_ad", comment: ""),
                    description: "Users engage with a video ad in exchange for in-app rewards.",
                    makeViewController: { LevelPlayRewardVideoVC() }
                ),
                MenuItem(
                    title: NSLocalizedString("interstitial_ad", comment: ""),
                    description: "Full-screen ads at natural breaks or transition points.",
                    makeViewController: { LevelPlayInterstitialVC() }
                )
            ])
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("levelPlay_ad", comment: "")
    }

    override func setupSDK() {
        let initRequest = LPMInitRequestBuilder(appKey: AdsConfig.LevelPlay_App_Key).build()
        LevelPlay.initWith(initRequest) { _, error in
            if let error {
                NSLog("UnityAdsMainListVC: initSDK failed: %@", error.localizedDescription)
            } else {
                NSLog("UnityAdsMainListVC: initSDK success")
            }
        }
    }
}
