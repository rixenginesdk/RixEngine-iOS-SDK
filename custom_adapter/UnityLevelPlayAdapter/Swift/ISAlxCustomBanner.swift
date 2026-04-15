//
//  ISAlxCustomBanner.swift
//  AlxAdsDemo
//
//  LevelPlay Banner 广告适配器 / LevelPlay Banner Ad Adapter
//  文档参考 / Documentation: https://docs.unity.com/zh-cn/grow/levelplay/sdk/ios/build-custom-adapter
//

import Foundation
import UIKit
import IronSource
import AlxAds

@objc(ISAlxCustomBanner)
public class ISAlxCustomBanner: ISBaseBanner {

    private static let TAG = "ISAlxCustomBanner"

    private var bannerAdView: AlxBannerAdView?
    private weak var adDelegate: ISBannerAdDelegate?

    // MARK: - ISBaseBanner

    /**
     * LevelPlay 请求加载 Banner 广告。
     * LevelPlay requests to load a Banner ad.
     *
     * adData.configuration 包含 / contains:
     *   appid / sid / token (app 级 / app-level) + unitid (instance 级 / instance-level)
     */
    public override func loadAd(with adData: ISAdData,
                                viewController: UIViewController,
                                size: ISBannerSize,
                                delegate: ISBannerAdDelegate) {
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

        let adSize = bannerSize(from: size)
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let banner = AlxBannerAdView(frame: CGRect(origin: .zero, size: adSize))
            banner.delegate = self
            banner.refreshInterval = 0
            banner.rootViewController = viewController
            self.bannerAdView = banner
            banner.loadAd(adUnitId: unitId)
        }
    }

    /**
     * LevelPlay 销毁 Banner。
     * LevelPlay destroys the Banner.
     */
    public override func destroyAd(with adData: ISAdData) {
        NSLog("%@: destroyAd", Self.TAG)
        DispatchQueue.main.async { [weak self] in
            self?.bannerAdView?.destroy()
            self?.bannerAdView = nil
        }
    }

    // MARK: - Private

    /**
     * 将 LevelPlay ISBannerSize 映射为 CGSize。
     * Maps LevelPlay ISBannerSize to CGSize.
     *
     * ⚠️ 此方法可能在后台线程调用，禁止访问 vc.view（UI API），改用 UIScreen。
     * ⚠️ This method may be called on a background thread; do not access vc.view (UI API), use UIScreen instead.
     */
    private func bannerSize(from size: ISBannerSize) -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        switch size.sizeDescription {
        case "RECTANGLE":
            return CGSize(width: 300, height: 250)
        case "LARGE":
            return CGSize(width: 320, height: 90)
        case "SMART", "BANNER":
            return CGSize(width: screenWidth, height: 50)
        default:
            return CGSize(width: 320, height: 50)
        }
    }
}

// MARK: - AlxBannerViewAdDelegate

extension ISAlxCustomBanner: AlxBannerViewAdDelegate {

    public func bannerViewAdLoad(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdLoad", ISAlxCustomBanner.TAG)
        adDelegate?.adDidLoad(with: bannerView)
    }

    public func bannerViewAdFailToLoad(_ bannerView: AlxBannerAdView, didFailWithError error: Error) {
        NSLog("%@: bannerViewAdFailToLoad: %@", ISAlxCustomBanner.TAG, error.localizedDescription)
        let nsError = error as NSError
        (adDelegate as? ISAlxAdapterFailureReporter)?.adDidFailToLoad(
            withErrorType: 2,
            errorCode: nsError.code,
            errorMessage: error.localizedDescription)
    }

    public func bannerViewAdImpression(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdImpression", ISAlxCustomBanner.TAG)
        adDelegate?.adDidOpen()
    }

    public func bannerViewAdClick(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdClick", ISAlxCustomBanner.TAG)
        adDelegate?.adDidClick()
    }

    public func bannerViewAdClose(_ bannerView: AlxBannerAdView) {
        NSLog("%@: bannerViewAdClose", ISAlxCustomBanner.TAG)
        adDelegate?.adDidDismissScreen()
    }
}
