//
//  TopOnMainVC.swift
//  AlxAdsDemo
//
//  Created by liu weile on 2025/8/18.
//

import UIKit
import AnyThinkSDK

class TopOnMainVC: BaseMenuVC {

    override var menuItems: [MenuItem] {[
        (title: NSLocalizedString("banner_ad",           comment: ""), makeVC: { TopOnBannerVC() }),
        (title: NSLocalizedString("rewardVideo_ad",      comment: ""), makeVC: { TopOnRewardVideoVC() }),
        (title: NSLocalizedString("interstitial_ad",     comment: ""), makeVC: { TopOnInterstitialVC() }),
        (title: NSLocalizedString("native_ad_template",  comment: ""), makeVC: { TopOnNativeVC() }),
        (title: NSLocalizedString("native_ad_self_render", comment: ""), makeVC: { TopOnNativeSelfRenderVC() }),
    ]}

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("topOn_ad", comment: "")
    }

    override var menuAppearance: MenuAppearance { .card }

    override func menuSubtitle(at index: Int) -> String? {
        let subtitles = [
            "Flexible formats at the top, middle or bottom of your app.",
            "Users engage with a video ad in exchange for in-app rewards.",
            "Full-screen ads at natural breaks or transition points.",
            "Native template rendering with prebuilt layouts.",
            "Custom native rendering with full UI control."
        ]
        guard index >= 0, index < subtitles.count else { return nil }
        return subtitles[index]
    }

    override func setupSDK() {
        ATAPI.setLogEnabled(true)
        ATAPI.integrationChecking()

        do {
            let result: () = try ATAPI.sharedInstance().start(
                withAppID: AdConfig.TopOn_App_Id,
                appKey: AdConfig.TopOn_App_Key
            )
            print("TopOn SDK init status:\(result)")
        } catch {
            print("TopOn sdk init error:\(error.localizedDescription)")
        }
    }
}
