//
//  AdmobNativeVC.swift
//  AdsDemo
//
//  Created by liu weile on 2023/5/30.
//

import UIKit
import GoogleMobileAds

class AdmobNativeVC: BaseUIViewController {

    private let TAG = "Admob-native:"

    private var isLoading = false
    private var adLoader: AdLoader?
    private var pendingNativeAd: NativeAd?

    private let gradientLayer = CAGradientLayer()
    private lazy var logTextView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.font = UIFont.systemFont(ofSize: 13)
        tv.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.25, alpha: 1)
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    private weak var adLogContentStack: UIStackView?
    private weak var adLogControlsStack: UIStackView?
    private var adLogContentTopConstraint: NSLayoutConstraint?
    private var adLogContentBottomConstraint: NSLayoutConstraint?
    private var logCardHeightConstraint: NSLayoutConstraint?
    private var lastAdLogLayoutLandscape: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("admob_native", comment: "")
        setupBackground()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
        updateAdLogLayoutIfNeeded()
    }

    private func setupBackground() {
        gradientLayer.colors = [
            UIColor(red: 0.93, green: 0.94, blue: 1.0, alpha: 1).cgColor,
            UIColor(red: 0.96, green: 0.96, blue: 1.0, alpha: 1).cgColor,
            UIColor.white.cgColor
        ]
        gradientLayer.locations = [0, 0.35, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func setupUI() {
        let layout = installScrollableContentStack(in: view, spacing: 16, horizontalInset: 16, bottomInset: 16)
        adLogContentStack = layout.contentStack
        adLogContentTopConstraint = layout.topConstraint
        adLogContentBottomConstraint = layout.bottomConstraint

        let logCard = UIView()
        logCard.backgroundColor = .white
        logCard.layer.cornerRadius = 12
        logCard.layer.shadowColor = UIColor(red: 0.45, green: 0.45, blue: 0.65, alpha: 0.08).cgColor
        logCard.layer.shadowOpacity = 1
        logCard.layer.shadowOffset = CGSize(width: 0, height: 2)
        logCard.layer.shadowRadius = 8
        logCard.translatesAutoresizingMaskIntoConstraints = false
        logCard.addSubview(logTextView)

        let buttonStack = createButtonStack([
            (NSLocalizedString("load_ad", comment: ""), #selector(buttonLoad)),
            (NSLocalizedString("show_ad", comment: ""), #selector(buttonShow)),
            ("Clear Log", #selector(buttonClearLog))
        ])
        adLogControlsStack = buttonStack

        layout.contentStack.addArrangedSubview(logCard)
        layout.contentStack.addArrangedSubview(buttonStack)

        logCardHeightConstraint = logCard.heightAnchor.constraint(equalToConstant: 220)
        NSLayoutConstraint.activate([
            logCardHeightConstraint!,
            logTextView.topAnchor.constraint(equalTo: logCard.topAnchor, constant: 10),
            logTextView.leadingAnchor.constraint(equalTo: logCard.leadingAnchor, constant: 12),
            logTextView.trailingAnchor.constraint(equalTo: logCard.trailingAnchor, constant: -12),
            logTextView.bottomAnchor.constraint(equalTo: logCard.bottomAnchor, constant: -10),
        ])

        updateAdLogLayoutIfNeeded()
    }

    private func createButtonStack(_ items: [(String, Selector)]) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        for item in items {
            let button = createButton(title: item.0, action: item.1)
            button.heightAnchor.constraint(equalToConstant: 48).isActive = true
            stack.addArrangedSubview(button)
        }
        return stack
    }

    private func updateAdLogLayoutIfNeeded() {
        let isLandscape = view.bounds.width > view.bounds.height
        guard lastAdLogLayoutLandscape != isLandscape else { return }
        lastAdLogLayoutLandscape = isLandscape

        applyDemoAdLogLayoutMetrics(
            DemoAdLogLayoutMetrics.current(for: view.bounds.size),
            contentStack: adLogContentStack,
            topConstraint: adLogContentTopConstraint,
            bottomConstraint: adLogContentBottomConstraint,
            logCardHeightConstraint: logCardHeightConstraint,
            controlsStack: adLogControlsStack
        )
    }

    private func logMessage(_ msg: String) {
        print(msg)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.logTextView.text = (self.logTextView.text ?? "") + msg + "\n"
            let bottom = NSRange(location: max(self.logTextView.text.count - 1, 0), length: 1)
            self.logTextView.scrollRangeToVisible(bottom)
        }
    }

    @objc private func buttonLoad() {
        if isLoading {
            logMessage("\(TAG) ad is loading")
            return
        }

        isLoading = true
        pendingNativeAd = nil
        logMessage("\(TAG) loading...")
        loadAd()
    }

    @objc private func buttonShow() {
        guard let nativeAd = pendingNativeAd else {
            logMessage("\(TAG) ad wasn't ready")
            return
        }
        let renderVC = AdmobNativeRenderVC(nativeAd: nativeAd)
        navigationController?.pushViewController(renderVC, animated: true)
        logMessage("\(TAG) show ad -> push render vc")
    }

    @objc private func buttonClearLog() {
        logTextView.text = ""
    }

    private func loadAd() {
        let multipleAdOptions = MultipleAdsAdLoaderOptions()
        adLoader = AdLoader(
            adUnitID: AdConfig.Admob_Native_Ad_Id,
            rootViewController: self,
            adTypes: [.native],
            options: [multipleAdOptions]
        )
        adLoader?.delegate = self
        adLoader?.load(Request())
    }
}

extension AdmobNativeVC:NativeAdLoaderDelegate{
    func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
        logMessage("\(TAG) ad loaded")
        pendingNativeAd = nativeAd
        nativeAd.delegate = self
    }

    func adLoaderDidFinishLoading(_ adLoader: AdLoader) {
        logMessage("\(TAG) \(NSLocalizedString("load_success", comment: ""))")
        isLoading = false
    }

    func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
        let error1 = error as NSError
        let msg = "\(error1.code): \(error1.localizedDescription)"
        logMessage("\(TAG) \(String(format: NSLocalizedString("load_failed", comment: ""), msg))")
        isLoading = false
    }
}

extension AdmobNativeVC: NativeAdDelegate{
    func nativeAdDidRecordImpression(_ nativeAd: NativeAd) {
        logMessage("\(TAG) nativeAdDidRecordImpression")
    }

    func nativeAdDidRecordClick(_ nativeAd: NativeAd) {
        logMessage("\(TAG) nativeAdDidRecordClick")
    }

    func nativeAdWillPresentScreen(_ nativeAd: NativeAd) {
        logMessage("\(TAG) nativeAdWillPresentScreen")
    }
}
