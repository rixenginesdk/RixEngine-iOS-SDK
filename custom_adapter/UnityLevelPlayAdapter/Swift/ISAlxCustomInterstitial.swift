//
//  ISAlxCustomInterstitial.swift
//  AlxAdsDemo
//
//  LevelPlay Interstitial 广告适配器
//  文档参考: https://docs.unity.com/zh-cn/grow/levelplay/sdk/ios/build-custom-adapter
//

import Foundation
import UIKit
import IronSource
import AlxAds

@objc(ISAlxCustomInterstitial)
public class ISAlxCustomInterstitial: ISBaseInterstitial {

    private static let TAG = "ISAlxCustomInterstitial"

    private var interstitialAd: AlxInterstitialAd?
    private weak var adDelegate: ISInterstitialAdDelegate?

    // MARK: - ISBaseInterstitial

    public override func loadAd(with adData: ISAdData, delegate: ISInterstitialAdDelegate) {
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
        let ad = AlxInterstitialAd()
        ad.delegate = self
        self.interstitialAd = ad
        ad.loadAd(adUnitId: unitId)
    }

    public override func isAdAvailable(with adData: ISAdData) -> Bool {
        let ready = interstitialAd?.isReady() ?? false
        NSLog("%@: isAdAvailable = %@", Self.TAG, ready ? "YES" : "NO")
        return ready
    }

    public override func showAd(with viewController: UIViewController,
                                adData: ISAdData,
                                delegate: ISInterstitialAdDelegate) {
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
            self?.interstitialAd?.showAd(present: viewController)
        }
    }
}

// MARK: - AlxInterstitialAdDelegate

extension ISAlxCustomInterstitial: AlxInterstitialAdDelegate {

    public func interstitialAdLoad(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdLoad", Self.TAG)
        adDelegate?.adDidLoad()
    }

    public func interstitialAdFailToLoad(_ ad: AlxInterstitialAd, didFailWithError error: Error) {
        NSLog("%@: interstitialAdFailToLoad: %@", Self.TAG, error.localizedDescription)
        (adDelegate as? ISAlxAdapterFailureReporter)?.adDidFailToLoad(
            withErrorType: 2,
            errorCode: (error as NSError).code,
            errorMessage: error.localizedDescription)
    }

    public func interstitialAdImpression(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdImpression", Self.TAG)
        adDelegate?.adDidOpen()
    }

    public func interstitialAdClick(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdClick", Self.TAG)
        adDelegate?.adDidClick()
    }

    public func interstitialAdClose(_ ad: AlxInterstitialAd) {
        NSLog("%@: interstitialAdClose", Self.TAG)
        adDelegate?.adDidClose()
        interstitialAd = nil
    }

    public func interstitialAdFailToShow(_ ad: AlxInterstitialAd, didFailWithError error: Error) {
        NSLog("%@: interstitialAdFailToShow: %@", Self.TAG, error.localizedDescription)
        (adDelegate as? ISAlxAdapterFailureReporter)?.adDidFailToShow(
            withErrorCode: 1000,
            errorMessage: error.localizedDescription)
    }
}
