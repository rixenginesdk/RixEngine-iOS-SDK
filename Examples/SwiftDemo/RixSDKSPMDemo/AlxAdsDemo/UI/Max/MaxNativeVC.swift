//
//  MaxNativeVC.swift
//  AdsDemo
//
//  Created by liu weile on 2023/6/2.
//

import UIKit
import AppLovinSDK

class MaxNativeVC: BaseUIViewController {

    private let TAG = "Max-native:"

    private var isLoading = false
    private var adLoader: MANativeAdLoader?
    private var nativeAd: MAAd?
    private var pendingNativeAdView: MANativeAdView?

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
        navigationItem.title = NSLocalizedString("max_native", comment: "")
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

    @objc private func buttonLoad() {
        if isLoading {
            logMessage("\(TAG) ad is loading")
            return
        }

        isLoading = true
        pendingNativeAdView = nil
        logMessage("\(TAG) loading...")
        loadAd()
    }

    @objc private func buttonShow() {
        guard let nativeAdView = pendingNativeAdView else {
            logMessage("\(TAG) ad wasn't ready")
            return
        }
        let renderVC = MaxNativeRenderVC(nativeAdView: nativeAdView)
        navigationController?.pushViewController(renderVC, animated: true)
        logMessage("\(TAG) show ad -> push render vc")
    }

    @objc private func buttonClearLog() {
        logTextView.text = ""
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

    private func loadAd() {
        adLoader = MANativeAdLoader(adUnitIdentifier: AdConfig.Max_Native_Ad_Id)
        adLoader?.nativeAdDelegate = self
        adLoader?.loadAd(into: createNativeAdView())
    }

    private func createNativeAdView() -> MANativeAdView {
        let nativeAdView = MANativeAdView()
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false
        nativeAdView.backgroundColor = .white

        let iconImageView = UIImageView()
        iconImageView.tag = 101
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.clipsToBounds = true

        let titleLabel = UILabel()
        titleLabel.tag = 102
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .boldSystemFont(ofSize: 14)
        titleLabel.numberOfLines = 2

        let bodyLabel = UILabel()
        bodyLabel.tag = 103
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.font = .systemFont(ofSize: 12)
        bodyLabel.textColor = .darkGray
        bodyLabel.numberOfLines = 3
        
        let ctaButton = UIButton(type: .system)
        ctaButton.tag = 104
        ctaButton.translatesAutoresizingMaskIntoConstraints = false
        ctaButton.backgroundColor = .systemBlue
        ctaButton.setTitleColor(.white, for: .normal)
        ctaButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        ctaButton.layer.cornerRadius = 4

        let mediaContentView = UIView()
        mediaContentView.tag = 105
        mediaContentView.translatesAutoresizingMaskIntoConstraints = false
        mediaContentView.backgroundColor = .systemGray6

        let optionsView = UIView()
        optionsView.tag = 106
        optionsView.translatesAutoresizingMaskIntoConstraints = false

        nativeAdView.addSubview(iconImageView)
        nativeAdView.addSubview(titleLabel)
        nativeAdView.addSubview(mediaContentView)
        nativeAdView.addSubview(bodyLabel)
        nativeAdView.addSubview(ctaButton)
        nativeAdView.addSubview(optionsView)

        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: nativeAdView.topAnchor, constant: 8),
            iconImageView.leadingAnchor.constraint(equalTo: nativeAdView.leadingAnchor, constant: 8),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),

            titleLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor, constant: -8),

            mediaContentView.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 8),
            mediaContentView.leadingAnchor.constraint(equalTo: nativeAdView.leadingAnchor),
            mediaContentView.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor),
            mediaContentView.heightAnchor.constraint(equalToConstant: 200),

            bodyLabel.topAnchor.constraint(equalTo: mediaContentView.bottomAnchor, constant: 8),
            bodyLabel.leadingAnchor.constraint(equalTo: nativeAdView.leadingAnchor, constant: 8),
            bodyLabel.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor, constant: -8),

            ctaButton.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 8),
            ctaButton.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor, constant: -8),
            ctaButton.widthAnchor.constraint(equalToConstant: 100),
            ctaButton.heightAnchor.constraint(equalToConstant: 36),
            ctaButton.bottomAnchor.constraint(equalTo: nativeAdView.bottomAnchor, constant: -8),

            optionsView.topAnchor.constraint(equalTo: nativeAdView.topAnchor),
            optionsView.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor),
            optionsView.widthAnchor.constraint(equalToConstant: 20),
            optionsView.heightAnchor.constraint(equalToConstant: 20),
        ])

        let binder = MANativeAdViewBinder { builder in
            builder.iconImageViewTag = 101
            builder.titleLabelTag = 102
            builder.bodyLabelTag = 103
            builder.callToActionButtonTag = 104
            builder.mediaContentViewTag = 105
            builder.optionsContentViewTag = 106
        }
        nativeAdView.bindViews(with: binder)

        return nativeAdView
    }
}

extension MaxNativeVC: MANativeAdDelegate {
    func didLoadNativeAd(_ nativeAdView: MANativeAdView?, for ad: MAAd) {
        print("\(TAG) didLoadNativeAd")
        logMessage("networkName = \(ad.networkName)")
        logMessage("revenue = \(ad.revenue * 1000)")
        logMessage("revenuePrecision = \(ad.revenuePrecision)")
        logMessage("\(TAG) \(NSLocalizedString("load_success", comment: ""))")
        isLoading = false

        if let currentNativeAd = nativeAd {
            adLoader?.destroy(currentNativeAd)
        }
        nativeAd = ad

        guard let nativeAdView = nativeAdView else {
            print("\(TAG) nativeAdView is nil")
            return
        }
        pendingNativeAdView = nativeAdView
    }

    func didFailToLoadNativeAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        let msg = "\(error.code): \(error.description)"
        logMessage("\(TAG) \(String(format: NSLocalizedString("load_failed", comment: ""), msg))")
        isLoading = false
    }

    func didClickNativeAd(_ ad: MAAd) {
        print("\(TAG) didClickNativeAd")
    }
}
