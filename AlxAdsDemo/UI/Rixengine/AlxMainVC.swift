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
}
