//
//  AdmobMainVC.swift
//  AdsDemo
//
//  Created by liu weile on 2023/5/30.
//

import UIKit
import GoogleMobileAds

class AdmobMainVC: BaseMenuVC {

    override var menuItems: [MenuItem] {[
        (title: NSLocalizedString("banner_ad",       comment: ""), makeVC: { AdmobBannerVC() }),
        (title: NSLocalizedString("rewardVideo_ad",  comment: ""), makeVC: { AdmobRewardVideoVC() }),
        (title: NSLocalizedString("interstitial_ad", comment: ""), makeVC: { AdmobInterstitialVC() }),
        (title: NSLocalizedString("native_ad",       comment: ""), makeVC: { AdmobNativeVC() }),
    ]}

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("admob_ad", comment: "")
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
        MobileAds.shared.start { status in
            for (key, adapterStatus) in status.adapterStatusesByClassName {
                NSLog("Adapter Name: %@, Description: %@, Latency: %f",
                      key, adapterStatus.description, adapterStatus.latency)
            }
        }
    }
}
