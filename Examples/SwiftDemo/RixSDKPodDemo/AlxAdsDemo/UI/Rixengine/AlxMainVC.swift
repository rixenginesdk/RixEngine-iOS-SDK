//
//  AlxMainVC.swift
//  AlxDemo
//
//  Created by liu weile on 2025/3/31.
//

import UIKit

class AlxMainVC: BaseMenuVC {

    override var menuItems: [MenuItem] {[
        (title: NSLocalizedString("banner_ad",             comment: ""), makeVC: { AlxBannerVC() }),
        (title: NSLocalizedString("banner_ad_xib",         comment: ""), makeVC: { AlxBannerXibVC() }),
        (title: NSLocalizedString("rewardVideo_ad",        comment: ""), makeVC: { AlxRewardVideoVC() }),
        (title: NSLocalizedString("interstitial_video_ad", comment: ""), makeVC: { AlxInterstitialVC() }),
        (title: NSLocalizedString("interstitial_banner_ad",comment: ""), makeVC: { AlxInterstitialBannerVC() }),
        (title: NSLocalizedString("native_ad",             comment: ""), makeVC: { AlxNativeVC() }),
    ]}

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("Alx_ad", comment: "")
    }

    override var menuAppearance: MenuAppearance { .card }

    override func menuSubtitle(at index: Int) -> String? {
        let subtitles = [
            "Flexible formats at the top, middle or bottom of your app.",
            "Load banner ads using Interface Builder (Xib).",
            "Users engage with a video ad in exchange for in-app rewards.",
            "Full-screen video ads at natural breaks or transition points.",
            "Full-screen banner ads at natural breaks or transition points.",
            "Ads that match the look and feel of your app."
        ]
        guard index >= 0, index < subtitles.count else { return nil }
        return subtitles[index]
    }
}
