//
//  RixAdsMainListVC.swift
//  RixAdsSDKDemo
//
//  Created by YXk on 2026/8/30.
//

import UIKit

class RixAdsMainListVC: BasicMenuViewController {

    override var menuSections: [MenuSection] {
        [
            MenuSection(items: [
                MenuItem(
                    title: NSLocalizedString("banner_ad", comment: ""),
                    description: "Standard and preloaded banner formats.",
                    makeViewController: { RixBannerVC() }
                ),
                MenuItem(
                    title: NSLocalizedString("banner_ad_xib", comment: ""),
                    description: "Load banner ad directly within a Xib layout.",
                    makeViewController: { RixBannerXibVC() }
                ),
                MenuItem(
                    title: NSLocalizedString("rewardVideo_ad", comment: ""),
                    description: "Users engage with a video ad in exchange for rewards.",
                    makeViewController: { RixRewardVideoVC() }
                ),
                MenuItem(
                    title: NSLocalizedString("interstitial_video_ad", comment: ""),
                    description: "Full-screen video ad at transition points.",
                    makeViewController: { RixInterstitialVideoVC() }
                ),
                MenuItem(
                    title: NSLocalizedString("interstitial_banner_ad", comment: ""),
                    description: "Full-screen graphic banner interstitial.",
                    makeViewController: { RixInterstitialBannerVC() }
                ),
                MenuItem(
                    title: NSLocalizedString("native_ad", comment: ""),
                    description: "Customizable ad components matching app UI.",
                    makeViewController: { RixNativeVC() }
                )
            ])
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("alx_ad", comment: "")
    }
}

