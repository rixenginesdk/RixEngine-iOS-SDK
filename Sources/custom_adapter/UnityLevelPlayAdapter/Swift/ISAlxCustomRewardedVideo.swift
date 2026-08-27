//
//  ISAlxCustomRewardedVideo.swift
//  AlxAdsDemo
//
//  LevelPlay RewardedVideo 广告适配器 / LevelPlay RewardedVideo Ad Adapter
//  文档参考 / Documentation: https://docs.unity.com/zh-cn/grow/levelplay/sdk/ios/build-custom-adapter
//

import Foundation
import UIKit
import IronSource
import AlxAds

@objc(ISAlxCustomRewardedVideo)
public class ISAlxCustomRewardedVideo: ISBaseRewardedVideo {

    private static let TAG = "ISAlxCustomRewardedVideo"

    private var rewardedAd: AlxRewardVideoAd?
    private weak var adDelegate: ISRewardedVideoAdDelegate?

    // MARK: - ISBaseRewardedVideo

    public override func loadAd(with adData: ISAdData, delegate: ISRewardedVideoAdDelegate) {
        NSLog("%@: loadAd", Self.TAG)
        self.adDelegate = delegate
        ISAlxCustomAdapter.initSdk(with: adData)

        guard let unitId = adData.configuration["unitid"] as? String, !unitId.isEmpty else {
            let msg = "unitid is empty"
            NSLog("%@: error: %@", Self.TAG, msg)
            (delegate as? ISAlxAdapterFailureReporter)?.adDidFailToLoad(
                withErrorType: 2,
                errorCode: ISAdapterErrors.missingParams.rawValue,
                errorMessage: msg)
            return
        }

        NSLog("%@: loadAd unitid=%@", Self.TAG, unitId)
        let ad = AlxRewardVideoAd()
        ad.delegate = self
        self.rewardedAd = ad
        ad.loadAd(adUnitId: unitId)
    }

    public override func isAdAvailable(with adData: ISAdData) -> Bool {
        let ready = rewardedAd?.isReady() ?? false
        NSLog("%@: isAdAvailable = %@", Self.TAG, ready ? "YES" : "NO")
        return ready
    }

    public override func showAd(with viewController: UIViewController,
                                adData: ISAdData,
                                delegate: ISRewardedVideoAdDelegate) {
        NSLog("%@: showAd", Self.TAG)
        self.adDelegate = delegate

        guard isAdAvailable(with: adData) else {
            let msg = "ad is not ready"
            NSLog("%@: error: %@", Self.TAG, msg)
            (delegate as? ISAlxAdapterFailureReporter)?.adDidFailToShow(
                withErrorCode: 1000,
                errorMessage: msg)
            return
        }

        DispatchQueue.main.async { [weak self] in
            self?.rewardedAd?.showAd(present: viewController)
        }
    }
}

// MARK: - AlxRewardVideoAdDelegate

extension ISAlxCustomRewardedVideo: AlxRewardVideoAdDelegate {

    public func rewardVideoAdLoad(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdLoad", Self.TAG)
        adDelegate?.adDidLoad()
    }

    public func rewardVideoAdFailToLoad(_ ad: AlxRewardVideoAd, didFailWithError error: Error) {
        NSLog("%@: rewardVideoAdFailToLoad: %@", Self.TAG, error.localizedDescription)
        (adDelegate as? ISAlxAdapterFailureReporter)?.adDidFailToLoad(
            withErrorType: 2,
            errorCode: (error as NSError).code,
            errorMessage: error.localizedDescription)
    }

    public func rewardVideoAdImpression(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdImpression", Self.TAG)
        adDelegate?.adDidOpen()
        adDelegate?.adDidBecomeVisible()
    }

    public func rewardVideoAdClick(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdClick", Self.TAG)
        adDelegate?.adDidClick()
    }

    public func rewardVideoAdClose(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdClose", Self.TAG)
        adDelegate?.adDidClose()
        rewardedAd = nil
    }

    public func rewardVideoAdPlayStart(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdPlayStart", Self.TAG)
        adDelegate?.adDidStart()
    }

    public func rewardVideoAdPlayEnd(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdPlayEnd", Self.TAG)
        adDelegate?.adDidEnd()
    }

    public func rewardVideoAdReward(_ ad: AlxRewardVideoAd) {
        NSLog("%@: rewardVideoAdReward", Self.TAG)
        adDelegate?.adRewarded()
    }

    public func rewardVideoAdPlayFail(_ ad: AlxRewardVideoAd, didFailWithError error: Error) {
        NSLog("%@: rewardVideoAdPlayFail: %@", Self.TAG, error.localizedDescription)
        (adDelegate as? ISAlxAdapterFailureReporter)?.adDidFailToShow(
            withErrorCode: 1000,
            errorMessage: error.localizedDescription)
    }
}
