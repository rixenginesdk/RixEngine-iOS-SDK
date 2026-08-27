//
//  TopOnBannerVC.swift
//  AlxAdsDemo
//
//  Created by liu weile on 2025/8/18.
//

//import UIKit
//import AnyThinkSDK
//
//class TopOnBannerVC: BaseUIViewController {
//
//    private let TAG = "TopOn-banner:"
//
//    private var adContainer: UIView!
//    private var bannerView: ATBannerView?
//    private var isLoading = false
//    private let bannerSize = CGSize(width: 320, height: 50)
//    private weak var bannerContentStack: UIStackView?
//    private weak var bannerControlsStack: UIStackView?
//    private weak var bannerButtonGrid: UIStackView?
//    private var bannerContentTopConstraint: NSLayoutConstraint?
//    private var bannerContentBottomConstraint: NSLayoutConstraint?
//    private var logCardHeightConstraint: NSLayoutConstraint?
//    private var adContainerHeightConstraint: NSLayoutConstraint?
//    private var lastBannerLayoutLandscape: Bool?
//
//    private let gradientLayer = CAGradientLayer()
//
//    private lazy var logTextView: UITextView = {
//        let tv = UITextView()
//        tv.isEditable = false
//        tv.font = UIFont.systemFont(ofSize: 13)
//        tv.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.25, alpha: 1)
//        tv.backgroundColor = .clear
//        tv.translatesAutoresizingMaskIntoConstraints = false
//        return tv
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        navigationItem.title = NSLocalizedString("topOn_banner", comment: "")
//        setupBackground()
//        setupUI()
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        gradientLayer.frame = view.bounds
//        updateBannerLayoutIfNeeded()
//    }
//
//    // MARK: - Setup
//
//    private func setupBackground() {
//        gradientLayer.colors = [
//            UIColor(red: 0.93, green: 0.94, blue: 1.0, alpha: 1).cgColor,
//            UIColor(red: 0.96, green: 0.96, blue: 1.0, alpha: 1).cgColor,
//            UIColor.white.cgColor
//        ]
//        gradientLayer.locations = [0, 0.35, 1]
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
//        view.layer.insertSublayer(gradientLayer, at: 0)
//    }
//
//    private func setupUI() {
//        let layout = installScrollableContentStack(in: view, spacing: 16, horizontalInset: 16, bottomInset: 16)
//        bannerContentStack = layout.contentStack
//        bannerContentTopConstraint = layout.topConstraint
//        bannerContentBottomConstraint = layout.bottomConstraint
//
//        let logCard = UIView()
//        logCard.backgroundColor = .white
//        logCard.layer.cornerRadius = 12
//        logCard.layer.shadowColor = UIColor(red: 0.45, green: 0.45, blue: 0.65, alpha: 0.08).cgColor
//        logCard.layer.shadowOpacity = 1
//        logCard.layer.shadowOffset = CGSize(width: 0, height: 2)
//        logCard.layer.shadowRadius = 8
//        logCard.translatesAutoresizingMaskIntoConstraints = false
//
//        logCard.addSubview(logTextView)
//
//        adContainer = UIView()
//        adContainer.translatesAutoresizingMaskIntoConstraints = false
//
//        let buttonGrid = createButtonGrid([
//            (NSLocalizedString("load_ad", comment: ""), #selector(buttonLoad)),
//            ("Remove Ad", #selector(buttonRemove)),
//            (NSLocalizedString("show_ad", comment: ""), #selector(buttonShow)),
//            ("Re-show", #selector(buttonReshow)),
//            ("Clear Log", #selector(buttonClearLog)),
//            ("Hide Ad", #selector(buttonHide))
//        ])
//        bannerButtonGrid = buttonGrid
//        let controlsStack = UIStackView(arrangedSubviews: [buttonGrid])
//        controlsStack.axis = .vertical
//        controlsStack.spacing = 12
//        controlsStack.translatesAutoresizingMaskIntoConstraints = false
//        bannerControlsStack = controlsStack
//
//        layout.contentStack.addArrangedSubview(logCard)
//        layout.contentStack.addArrangedSubview(adContainer)
//        layout.contentStack.addArrangedSubview(controlsStack)
//
//        logCardHeightConstraint = logCard.heightAnchor.constraint(equalToConstant: 220)
//        adContainerHeightConstraint = adContainer.heightAnchor.constraint(equalToConstant: 80)
//        NSLayoutConstraint.activate([
//            logCardHeightConstraint!,
//
//            logTextView.topAnchor.constraint(equalTo: logCard.topAnchor, constant: 10),
//            logTextView.leadingAnchor.constraint(equalTo: logCard.leadingAnchor, constant: 12),
//            logTextView.trailingAnchor.constraint(equalTo: logCard.trailingAnchor, constant: -12),
//            logTextView.bottomAnchor.constraint(equalTo: logCard.bottomAnchor, constant: -10),
//
//            adContainerHeightConstraint!,
//        ])
//
//        updateBannerLayoutIfNeeded()
//    }
//
//    private func createButtonGrid(_ items: [(String, Selector)]) -> UIStackView {
//        let grid = UIStackView()
//        grid.axis = .vertical
//        grid.spacing = 12
//        grid.translatesAutoresizingMaskIntoConstraints = false
//
//        for row in stride(from: 0, to: items.count, by: 2) {
//            let rowStack = UIStackView()
//            rowStack.axis = .horizontal
//            rowStack.spacing = 16
//            rowStack.distribution = .fillEqually
//
//            let btn1 = createButton(title: items[row].0, action: items[row].1)
//            rowStack.addArrangedSubview(btn1)
//            btn1.heightAnchor.constraint(equalToConstant: 44).isActive = true
//
//            if row + 1 < items.count {
//                let btn2 = createButton(title: items[row + 1].0, action: items[row + 1].1)
//                rowStack.addArrangedSubview(btn2)
//            }
//
//            grid.addArrangedSubview(rowStack)
//        }
//        return grid
//    }
//
//    private func updateBannerLayoutIfNeeded() {
//        let isLandscape = view.bounds.width > view.bounds.height
//        guard lastBannerLayoutLandscape != isLandscape else { return }
//        lastBannerLayoutLandscape = isLandscape
//
//        let metrics = DemoBannerLayoutMetrics.current(for: view.bounds.size)
//        bannerContentStack?.spacing = metrics.contentSpacing
//        bannerContentTopConstraint?.constant = metrics.topInset
//        bannerContentBottomConstraint?.constant = -metrics.bottomInset
//        let portraitLogHeight = metrics.logCardHeight
//        logCardHeightConstraint?.constant = isLandscape ? (metrics.logCardHeight * 0.8) : portraitLogHeight
//        adContainerHeightConstraint?.constant = metrics.adAreaHeight
//        bannerControlsStack?.spacing = metrics.controlsSpacing
//        bannerButtonGrid?.spacing = metrics.buttonGridSpacing
//        for case let rowStack as UIStackView in bannerButtonGrid?.arrangedSubviews ?? [] {
//            rowStack.spacing = metrics.buttonRowSpacing
//        }
//    }
//
//    // MARK: - Log
//
//    private func logMessage(_ msg: String) {
//        print(msg)
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            self.logTextView.text = (self.logTextView.text ?? "") + msg + "\n"
//            let bottom = NSRange(location: max(self.logTextView.text.count - 1, 0), length: 1)
//            self.logTextView.scrollRangeToVisible(bottom)
//        }
//    }
//
//    // MARK: - Actions
//
//    @objc private func buttonLoad() {
//        guard !isLoading else { return }
//        isLoading = true
//        logMessage("\(TAG) loading...")
//
//        var extra: [String: Any] = [:]
//        extra[kATAdLoadingExtraMediaExtraKey] = "media_val_BannerVC"
//        ATAdManager.shared().loadAD(withPlacementID: AdConfig.TopOn_Banner_Ad_Id, extra: extra, delegate: self)
//    }
//
//    @objc private func buttonShow() {
//        showAd()
//    }
//
//    @objc private func buttonRemove() {
//        bannerView?.destroyBanner()
//        bannerView?.removeFromSuperview()
//        bannerView = nil
//        logMessage("\(TAG) ad removed")
//    }
//
//    @objc private func buttonReshow() {
//        buttonRemove()
//        buttonLoad()
//    }
//
//    @objc private func buttonClearLog() {
//        logTextView.text = ""
//    }
//
//    @objc private func buttonHide() {
//        adContainer.isHidden = !adContainer.isHidden
//        logMessage("\(TAG) ad \(adContainer.isHidden ? "hidden" : "visible")")
//    }
//
//    private func showAd() {
//        guard ATAdManager.shared().bannerAdReady(forPlacementID: AdConfig.TopOn_Banner_Ad_Id) else {
//            logMessage("\(TAG) ad not ready")
//            return
//        }
//        guard let banner = ATAdManager.shared().retrieveBannerView(forPlacementID: AdConfig.TopOn_Banner_Ad_Id) else {
//            logMessage("\(TAG) banner view is nil")
//            return
//        }
//        banner.delegate = self
//        banner.presentingViewController = self
//        banner.translatesAutoresizingMaskIntoConstraints = false
//        self.bannerView = banner
//
//        clearSubView(adContainer)
//        adContainer.isHidden = false
//        adContainer.addSubview(banner)
//
//        NSLayoutConstraint.activate([
//            banner.topAnchor.constraint(equalTo: adContainer.topAnchor),
//            banner.bottomAnchor.constraint(equalTo: adContainer.bottomAnchor),
//            banner.centerXAnchor.constraint(equalTo: adContainer.centerXAnchor),
//            banner.widthAnchor.constraint(equalToConstant: bannerSize.width),
//            banner.heightAnchor.constraint(equalToConstant: bannerSize.height),
//        ])
//    }
//}
//
//// MARK: - ATAdLoadingDelegate
//
//extension TopOnBannerVC: ATAdLoadingDelegate {
//    func didFinishLoadingAD(withPlacementID placementID: String!) {
//        isLoading = false
//        logMessage("\(TAG) didFinishLoadingAD:\(placementID ?? "")")
//        showAd()
//    }
//
//    func didFailToLoadAD(withPlacementID placementID: String!, error: (any Error)!) {
//        isLoading = false
//        logMessage("\(TAG) didFailToLoadAD: \(error.code): \(error.localizedDescription)")
//    }
//}
//
//// MARK: - ATBannerDelegate
//
//extension TopOnBannerVC: ATBannerDelegate {
//    func bannerView(_ bannerView: ATBannerView, didShowAdWithPlacementID placementID: String, extra: [AnyHashable: Any]) {
//        logMessage("\(TAG) bannerView:didShowAdWithPlacementID:\(placementID)")
//    }
//
//    func bannerView(_ bannerView: ATBannerView, didAutoRefreshWithPlacement placementID: String, extra: [AnyHashable: Any]) {
//        logMessage("\(TAG) bannerView:didAutoRefreshWithPlacement:\(placementID)")
//    }
//
//    func bannerView(_ bannerView: ATBannerView, didClickWithPlacementID placementID: String, extra: [AnyHashable: Any]) {
//        logMessage("\(TAG) bannerView:didClickWithPlacementID:\(placementID)")
//    }
//
//    func bannerView(_ bannerView: ATBannerView, didTapCloseButtonWithPlacementID placementID: String, extra: [AnyHashable: Any]) {
//        logMessage("\(TAG) bannerView:didTapCloseButton:\(placementID)")
//        buttonRemove()
//    }
//
//    func bannerView(_ bannerView: ATBannerView, didDeeplinkOrJumpForPlacementID placementID: String, extra: [AnyHashable: Any], result success: Bool) {
//        logMessage("\(TAG) didRevenueForPlacementID:\(placementID)")
//    }
//}
