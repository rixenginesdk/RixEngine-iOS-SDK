//
//  MaxBannerVC.swift
//  AdsDemo
//
//  Created by liu weile on 2023/6/2.
//

import UIKit
import AppLovinSDK

class MaxBannerVC: BaseUIViewController {

    private let TAG = "Max-banner:"

    private var isLoading = false
    private var bannerView: MAAdView!
    private var adContainer: UIView!
    private weak var bannerContentStack: UIStackView?
    private weak var bannerControlsStack: UIStackView?
    private weak var bannerButtonGrid: UIStackView?
    private var bannerContentTopConstraint: NSLayoutConstraint?
    private var bannerContentBottomConstraint: NSLayoutConstraint?
    private var logCardHeightConstraint: NSLayoutConstraint?
    private var adContainerHeightConstraint: NSLayoutConstraint?
    private var lastBannerLayoutLandscape: Bool?

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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("max_banner", comment: "")
        setupBackground()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
        updateBannerLayoutIfNeeded()
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
        bannerContentStack = layout.contentStack
        bannerContentTopConstraint = layout.topConstraint
        bannerContentBottomConstraint = layout.bottomConstraint

        let logCard = UIView()
        logCard.backgroundColor = .white
        logCard.layer.cornerRadius = 12
        logCard.layer.shadowColor = UIColor(red: 0.45, green: 0.45, blue: 0.65, alpha: 0.08).cgColor
        logCard.layer.shadowOpacity = 1
        logCard.layer.shadowOffset = CGSize(width: 0, height: 2)
        logCard.layer.shadowRadius = 8
        logCard.translatesAutoresizingMaskIntoConstraints = false
        logCard.addSubview(logTextView)

        adContainer = UIView()
        adContainer.translatesAutoresizingMaskIntoConstraints = false

        bannerView = MAAdView(adUnitIdentifier: AdConfig.Max_Banner_Ad_Id)
        bannerView.translatesAutoresizingMaskIntoConstraints = false

        let buttonGrid = createButtonGrid([
            (NSLocalizedString("load_ad", comment: ""), #selector(buttonLoad)),
            ("Remove Ad", #selector(buttonRemove)),
            (NSLocalizedString("show_ad", comment: ""), #selector(buttonShow)),
            ("Re-show", #selector(buttonReshow)),
            ("Clear Log", #selector(buttonClearLog)),
            ("Hide Ad", #selector(buttonHide))
        ])
        bannerButtonGrid = buttonGrid
        let controlsStack = UIStackView(arrangedSubviews: [buttonGrid])
        controlsStack.axis = .vertical
        controlsStack.spacing = 12
        controlsStack.translatesAutoresizingMaskIntoConstraints = false
        bannerControlsStack = controlsStack

        layout.contentStack.addArrangedSubview(logCard)
        layout.contentStack.addArrangedSubview(adContainer)
        layout.contentStack.addArrangedSubview(controlsStack)

        logCardHeightConstraint = logCard.heightAnchor.constraint(equalToConstant: 220)
        adContainerHeightConstraint = adContainer.heightAnchor.constraint(equalToConstant: 80)
        NSLayoutConstraint.activate([
            logCardHeightConstraint!,

            logTextView.topAnchor.constraint(equalTo: logCard.topAnchor, constant: 10),
            logTextView.leadingAnchor.constraint(equalTo: logCard.leadingAnchor, constant: 12),
            logTextView.trailingAnchor.constraint(equalTo: logCard.trailingAnchor, constant: -12),
            logTextView.bottomAnchor.constraint(equalTo: logCard.bottomAnchor, constant: -10),

            adContainerHeightConstraint!,
        ])

        updateBannerLayoutIfNeeded()
    }

    private func createButtonGrid(_ items: [(String, Selector)]) -> UIStackView {
        let grid = UIStackView()
        grid.axis = .vertical
        grid.spacing = 12
        grid.translatesAutoresizingMaskIntoConstraints = false
        for row in stride(from: 0, to: items.count, by: 2) {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 16
            rowStack.distribution = .fillEqually
            let btn1 = createButton(title: items[row].0, action: items[row].1)
            rowStack.addArrangedSubview(btn1)
            btn1.heightAnchor.constraint(equalToConstant: 44).isActive = true
            if row + 1 < items.count {
                let btn2 = createButton(title: items[row + 1].0, action: items[row + 1].1)
                rowStack.addArrangedSubview(btn2)
            }
            grid.addArrangedSubview(rowStack)
        }
        return grid
    }

    private func updateBannerLayoutIfNeeded() {
        let isLandscape = view.bounds.width > view.bounds.height
        guard lastBannerLayoutLandscape != isLandscape else { return }
        lastBannerLayoutLandscape = isLandscape

        let metrics = DemoBannerLayoutMetrics.current(for: view.bounds.size)
        bannerContentStack?.spacing = metrics.contentSpacing
        bannerContentTopConstraint?.constant = metrics.topInset
        bannerContentBottomConstraint?.constant = -metrics.bottomInset
        let portraitLogHeight = metrics.logCardHeight
        logCardHeightConstraint?.constant = isLandscape ? (metrics.logCardHeight * 0.8) : portraitLogHeight
        adContainerHeightConstraint?.constant = metrics.adAreaHeight
        bannerControlsStack?.spacing = metrics.controlsSpacing
        bannerButtonGrid?.spacing = metrics.buttonGridSpacing
        for case let rowStack as UIStackView in bannerButtonGrid?.arrangedSubviews ?? [] {
            rowStack.spacing = metrics.buttonRowSpacing
        }
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

    // MARK: - Actions

    @objc private func buttonLoad() {
        guard !isLoading else { return }
        isLoading = true
        logMessage("\(TAG) loading...")
        bannerView.delegate = self
        bannerView.setExtraParameterForKey("adaptive_banner", value: "true")
        bannerView.setLocalExtraParameterForKey("adaptive_banner_width", value: 400)
        bannerView.loadAd()
    }

    @objc private func buttonShow() {
        clearSubView(adContainer)
        adContainer.isHidden = false
        adContainer.addSubview(bannerView)
        let height = MAAdFormat.banner.adaptiveSize.height
        NSLayoutConstraint.activate([
            bannerView.centerXAnchor.constraint(equalTo: adContainer.centerXAnchor),
            bannerView.centerYAnchor.constraint(equalTo: adContainer.centerYAnchor),
            bannerView.widthAnchor.constraint(equalTo: adContainer.widthAnchor),
            bannerView.heightAnchor.constraint(equalToConstant: height),
        ])
        logMessage("\(TAG) show ad")
    }

    @objc private func buttonRemove() {
        bannerView.removeFromSuperview()
        logMessage("\(TAG) ad removed")
    }

    @objc private func buttonReshow() {
        buttonRemove()
        buttonLoad()
    }

    @objc private func buttonClearLog() {
        logTextView.text = ""
    }

    @objc private func buttonHide() {
        adContainer.isHidden = !adContainer.isHidden
        logMessage("\(TAG) ad \(adContainer.isHidden ? "hidden" : "visible")")
    }
}

// MARK: - MAAdViewAdDelegate

extension MaxBannerVC: MAAdViewAdDelegate {
    func didExpand(_ ad: MAAd) {
        logMessage("\(TAG) didExpand")
    }

    func didCollapse(_ ad: MAAd) {
        logMessage("\(TAG) didCollapse")
    }

    func didLoad(_ ad: MAAd) {
        isLoading = false
        logMessage("\(TAG) didLoad")
        logMessage("networkName = \(ad.networkName)")
        logMessage("revenue = \(ad.revenue * 1000)")
        logMessage("revenuePrecision = \(ad.revenuePrecision)")
        buttonShow()
    }

    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        isLoading = false
        logMessage("\(TAG) didFailToLoadAd: \(error.code): \(error.description)")
    }

    func didDisplay(_ ad: MAAd) {
        logMessage("\(TAG) didDisplay")
    }

    func didHide(_ ad: MAAd) {
        logMessage("\(TAG) didHide")
    }

    func didClick(_ ad: MAAd) {
        logMessage("\(TAG) didClick")
    }

    func didFail(toDisplay ad: MAAd, withError error: MAError) {
        logMessage("\(TAG) didFailToDisplay: \(error.code): \(error.description)")
    }
}
