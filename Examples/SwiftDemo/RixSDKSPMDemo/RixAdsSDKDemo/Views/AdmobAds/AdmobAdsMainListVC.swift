//
//  AdmobAdsMainListVC.swift
//  RixAdsSDKDemo
//
//  Created by YXk on 2026/8/30.
//

import UIKit
import GoogleMobileAds

class AdmobAdsMainListVC: BasicMenuViewController {

    override var menuSections: [MenuSection] {
        [
            MenuSection(items: [
                MenuItem(
                    title: NSLocalizedString("banner_ad", comment: ""),
                    description: "Flexible formats at the top, middle or bottom of your app.",
                    makeViewController: { AdmobBannerVC() }
                ),
                MenuItem(
                    title: NSLocalizedString("rewardVideo_ad", comment: ""),
                    description: "Users engage with a video ad in exchange for in-app rewards.",
                    makeViewController: { AdmobRewardVideoVC() }
                ),
                MenuItem(
                    title: NSLocalizedString("interstitial_ad", comment: ""),
                    description: "Full-screen ads at natural breaks or transition points.",
                    makeViewController: { AdmobInterstitialVC() }
                ),
                MenuItem(
                    title: NSLocalizedString("native_ad", comment: ""),
                    description: "Ads that match the look and feel of your app.",
                    makeViewController: { AdmobNativeVC() }
                )
            ])
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("admob_ad", comment: "")
    }

    override func setupSDK() {
        MobileAds.shared.start { status in
            for (key, adapterStatus) in status.adapterStatusesByClassName {
                NSLog("Adapter Name: %@, Description: %@, Latency: %f",
                      key, adapterStatus.description, adapterStatus.latency)
            }
        }
    }
}
