//
//  LevelPlayBannerVC.swift
//  AlxAdsDemo
//
//  Created by YXk on 2026/4/1.
//

import UIKit
import IronSource

// MARK: - Unity LevelPlay Banner Ad
class LevelPlayBannerVC: BaseUIViewController {
    private let TAG = "LevelPlay-banner:"

    private var label: UILabel!
    private var isLoading = false
    private var bannerAdView: LPMBannerAdView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = NSLocalizedString("levelPlay_banner", comment: "")

        let bnLoad = createButton(title: NSLocalizedString("load_ad", comment: ""),
                                  action: #selector(buttonLoad))
        view.addSubview(bnLoad)

        label = createLabel()
        view.addSubview(label)

        NSLayoutConstraint.activate([
            bnLoad.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bnLoad.leftAnchor.constraint(equalTo: view.leftAnchor),
            bnLoad.rightAnchor.constraint(equalTo: view.rightAnchor),
            bnLoad.heightAnchor.constraint(equalToConstant: 50),

            label.topAnchor.constraint(equalTo: bnLoad.bottomAnchor, constant: 20),
            label.leftAnchor.constraint(equalTo: view.leftAnchor),
            label.rightAnchor.constraint(equalTo: view.rightAnchor),
            label.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    @objc private func buttonLoad() {
        print("\(TAG) buttonLoad")
        guard !isLoading else { return }
        updateUI(true, NSLocalizedString("loading", comment: ""))
        loadAd()
    }

    private func loadAd() {
        bannerAdView?.destroy()
        bannerAdView?.removeFromSuperview()
        bannerAdView = nil

        var width = view.safeAreaLayoutGuide.layoutFrame.size.width
        if width <= 0 { width = UIScreen.main.bounds.size.width }

        guard let adSize = LPMAdSize.createAdaptiveAdSize(withWidth: width) else { return }

        let configBuilder = LPMBannerAdViewConfigBuilder()
        configBuilder.set(adSize: adSize)
        let config = configBuilder.build()

        let banner = LPMBannerAdView(adUnitId: AdConfig.LevelPlay_Banner_Ad_Id, config: config)
        banner.setDelegate(self)
        banner.translatesAutoresizingMaskIntoConstraints = false
        self.bannerAdView = banner

        view.addSubview(banner)
        NSLayoutConstraint.activate([
            banner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            banner.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            /**
             之前布局代码缺少 LPMBannerAdView 的宽高约束，导致 LPMBannerAdView 的 bounds 为零。

             UIKit 的 hitTest(_:with:) 在触摸命中测试时，会先检查 point(inside:with:)。零 bounds 的 view 永远返回 false，所以所有触摸事件都被 LPMBannerAdView 在命中测试阶段就拒绝了，触摸无法向下传递到内部的 AlxBannerAdView → WKWebView。

             banner 之所以"看得见但点不了"，是因为 clipsToBounds 默认为 false，子视图可以超出父 view 的 bounds 进行渲染，但触摸不会穿透零 bounds 的父 view。

             官方示例明确要求添加宽高约束，即以下两行新增的布局代码
             */
            banner.widthAnchor.constraint(equalToConstant: CGFloat(adSize.width)),
            banner.heightAnchor.constraint(equalToConstant: CGFloat(adSize.height)),
        ])

        banner.loadAd(with: self)
    }

    private func updateUI(_ loading: Bool, _ msg: String) {
        isLoading = loading
        label.text = msg
    }
}

// MARK: - LPMBannerAdViewDelegate

extension LevelPlayBannerVC: LPMBannerAdViewDelegate {

    func didLoadAd(with adInfo: LPMAdInfo) {
        print("\(TAG) didLoadAd")
        DispatchQueue.main.async { [weak self] in
            self?.updateUI(false, NSLocalizedString("load_success", comment: ""))
        }
    }

    func didFailToLoadAd(withAdUnitId adUnitId: String, error: Error) {
        let msg = "\((error as NSError).code): \(error.localizedDescription)"
        print("\(TAG) didFailToLoadAd: \(msg)")
        DispatchQueue.main.async { [weak self] in
            self?.updateUI(false, String(format: NSLocalizedString("load_failed", comment: ""), msg))
        }
    }

    func didDisplayAd(with adInfo: LPMAdInfo) {
        print("\(TAG) didDisplayAd")
    }

    func didClickAd(with adInfo: LPMAdInfo) {
        print("\(TAG) didClickAd")
    }

    func didLeaveApp(with adInfo: LPMAdInfo) {
        print("\(TAG) didLeaveApp")
    }

    func didExpandAd(with adInfo: LPMAdInfo) {
        print("\(TAG) didExpandAd")
    }

    func didCollapseAd(with adInfo: LPMAdInfo) {
        print("\(TAG) didCollapseAd")
    }
}
