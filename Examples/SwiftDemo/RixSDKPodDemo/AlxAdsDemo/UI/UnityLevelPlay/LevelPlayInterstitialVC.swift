//
//  LevelPlayInterstitialVC.swift
//  AlxAdsDemo
//
//  Created by YXk on 2026/4/1.
//

import UIKit
import IronSource

// MARK: - Unity LevelPlay Interstitial Ad
class LevelPlayInterstitialVC: BaseUIViewController {
    private let TAG = "LevelPlay-interstitial:"

    private var label: UILabel!
    private var isLoading = false
    private var interstitialAd: LPMInterstitialAd?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = NSLocalizedString("levelPlay_interstitial", comment: "")

        let bnLoad = createButton(title: NSLocalizedString("load_ad", comment: ""),
                                  action: #selector(buttonLoad))
        view.addSubview(bnLoad)

        let bnShow = createButton(title: NSLocalizedString("show_ad", comment: ""),
                                  action: #selector(buttonShow))
        view.addSubview(bnShow)

        label = createLabel()
        view.addSubview(label)

        NSLayoutConstraint.activate([
            bnLoad.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bnLoad.leftAnchor.constraint(equalTo: view.leftAnchor),
            bnLoad.rightAnchor.constraint(equalTo: view.rightAnchor),
            bnLoad.heightAnchor.constraint(equalToConstant: 50),

            bnShow.topAnchor.constraint(equalTo: bnLoad.bottomAnchor, constant: 20),
            bnShow.leftAnchor.constraint(equalTo: view.leftAnchor),
            bnShow.rightAnchor.constraint(equalTo: view.rightAnchor),
            bnShow.heightAnchor.constraint(equalToConstant: 50),

            label.topAnchor.constraint(equalTo: bnShow.bottomAnchor, constant: 20),
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

    @objc private func buttonShow() {
        guard let ad = interstitialAd, ad.isAdReady() else {
            print("\(TAG) Ad wasn't ready")
            return
        }
        ad.showAd(viewController: self, placementName: nil)
    }

    private func loadAd() {
        interstitialAd = LPMInterstitialAd(adUnitId: AdConfig.LevelPlay_Interstitial_Ad_Id)
        interstitialAd?.setDelegate(self)
        interstitialAd?.loadAd()
    }

    private func updateUI(_ loading: Bool, _ msg: String) {
        isLoading = loading
        label.text = msg
    }
}

// MARK: - LPMInterstitialAdDelegate

extension LevelPlayInterstitialVC: LPMInterstitialAdDelegate {

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

    func didFailToDisplayAd(with adInfo: LPMAdInfo, error: Error) {
        print("\(TAG) didFailToDisplayAd: \(error.localizedDescription)")
    }

    func didClickAd(with adInfo: LPMAdInfo) {
        print("\(TAG) didClickAd")
    }

    func didCloseAd(with adInfo: LPMAdInfo) {
        print("\(TAG) didCloseAd")
    }
}
