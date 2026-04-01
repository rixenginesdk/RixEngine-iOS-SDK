//
//  LevelPlayMainVC.swift
//  AlxAdsDemo
//
//  Created by YXk on 2026/4/1.
//

import UIKit
import IronSource

// MARK: - Unity LevelPlay Ad Test | Main Page
class LevelPlayMainVC: BaseMenuVC {
    override var menuItems: [MenuItem] {[
        (title: NSLocalizedString("banner_ad",       comment: ""), makeVC: { LevelPlayBannerVC() }),
        (title: NSLocalizedString("rewardVideo_ad",  comment: ""), makeVC: { LevelPlayRewardVideoVC() }),
        (title: NSLocalizedString("interstitial_ad", comment: ""), makeVC: { LevelPlayInterstitialVC() }),
    ]}

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("levelPlay_ad", comment: "")
    }

    override func setupSDK() {
        let initRequest = LPMInitRequestBuilder(appKey: AdConfig.LevelPlay_App_Key).build()
        LevelPlay.initWith(initRequest) { _, error in
            if let error {
                NSLog("LevelPlayMainVC: initSDK failed: %@", error.localizedDescription)
            } else {
                NSLog("LevelPlayMainVC: initSDK success")
            }
        }
    }
}
