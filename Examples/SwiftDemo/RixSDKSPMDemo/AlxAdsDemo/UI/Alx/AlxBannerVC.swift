//
//  AlxBannerVC.swift
//  AlxDemo
//
//  Created by liu weile on 2025/3/31.
//

import UIKit
import AlxAds

class AlxBannerVC: BaseUIViewController {

    private let TAG = "Alx-banner:"

    private var isLoading = false
    private var bannerView: AlxBannerAdView!
    private var adContainer: UIView!
    private var bannerView2: AlxBannerAdView?
    private var isBanner2 = false
    private var selectedBannerAdId = AdConfig.Alx_Banner_Ad_Id
    private lazy var bannerAdIds: [String] = {
        let ids = AdConfig.Alx_Banner_Ad_Ids.filter { !$0.isEmpty }
        return ids.isEmpty ? [AdConfig.Alx_Banner_Ad_Id] : ids
    }()

    private let gradientLayer = CAGradientLayer()
    private lazy var bannerIdSelectButton: UIButton = {
        let button = createButton(title: "Select Banner ID", action: #selector(selectBannerId))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var bannerIdValueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = UIColor(red: 0.17, green: 0.17, blue: 0.23, alpha: 1)
        label.backgroundColor = UIColor.hex("#f0f0f0")
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.text = selectedBannerAdId
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var logTextView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.font = UIFont.systemFont(ofSize: 13)
        tv.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.25, alpha: 1)
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private weak var bannerContentStack: UIStackView?
    private weak var bannerControlsStack: UIStackView?
    private weak var bannerButtonGrid: UIStackView?
    private var bannerContentTopConstraint: NSLayoutConstraint?
    private var bannerContentBottomConstraint: NSLayoutConstraint?
    private var logCardHeightConstraint: NSLayoutConstraint?
    private var adContainerHeightConstraint: NSLayoutConstraint?
    private var lastBannerLayoutLandscape: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        if !bannerAdIds.contains(selectedBannerAdId) {
            selectedBannerAdId = bannerAdIds[0]
        }
        navigationItem.title = NSLocalizedString("alx_banner", comment: "")
        setupBackground()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
        updateBannerDemoLayoutIfNeeded()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bannerView.destroy()
        bannerView2?.destroy()
    }

    // MARK: - Setup

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

        bannerView = AlxBannerAdView()
        bannerView.translatesAutoresizingMaskIntoConstraints = false

        let buttonGrid = createButtonGrid([
            (NSLocalizedString("load_ad", comment: ""), #selector(preloadAd)),
            (NSLocalizedString("show_ad", comment: ""), #selector(showAd)),
            (NSLocalizedString("load_and_show_ad", comment: ""), #selector(loadAndShowAd)),
            ("Remove Ad", #selector(buttonRemove)),
            ("Clear Log", #selector(buttonClearLog)),
            ("Hide Ad", #selector(buttonHide))
        ])
        bannerButtonGrid = buttonGrid
        let bannerIdRow = UIStackView(arrangedSubviews: [bannerIdSelectButton, bannerIdValueLabel])
        bannerIdRow.axis = .horizontal
        bannerIdRow.spacing = 12
        bannerIdRow.distribution = .fillEqually
        bannerIdRow.alignment = .fill
        bannerIdRow.translatesAutoresizingMaskIntoConstraints = false

        let controlsStack = UIStackView(arrangedSubviews: [bannerIdRow, buttonGrid])
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
            adContainerHeightConstraint!,

            logTextView.topAnchor.constraint(equalTo: logCard.topAnchor, constant: 10),
            logTextView.leadingAnchor.constraint(equalTo: logCard.leadingAnchor, constant: 12),
            logTextView.trailingAnchor.constraint(equalTo: logCard.trailingAnchor, constant: -12),
            logTextView.bottomAnchor.constraint(equalTo: logCard.bottomAnchor, constant: -10),

            bannerIdSelectButton.heightAnchor.constraint(equalToConstant: 44),
            bannerIdValueLabel.heightAnchor.constraint(equalToConstant: 44),
        ])

        updateBannerDemoLayoutIfNeeded()
    }

    private func updateBannerDemoLayoutIfNeeded() {
        let isLandscape = view.bounds.width > view.bounds.height
        guard lastBannerLayoutLandscape != isLandscape else { return }
        lastBannerLayoutLandscape = isLandscape

        let metrics = DemoBannerLayoutMetrics.current(for: view.bounds.size)
        bannerContentStack?.spacing = metrics.contentSpacing
        bannerContentTopConstraint?.constant = metrics.topInset
        bannerContentBottomConstraint?.constant = -metrics.bottomInset
        logCardHeightConstraint?.constant = metrics.logCardHeight
        adContainerHeightConstraint?.constant = metrics.adAreaHeight
        bannerControlsStack?.spacing = metrics.controlsSpacing
        bannerButtonGrid?.spacing = metrics.buttonGridSpacing
        bannerButtonGrid?.arrangedSubviews
            .compactMap { $0 as? UIStackView }
            .forEach { $0.spacing = metrics.buttonRowSpacing }
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

    @objc private func preloadAd() {
        isBanner2 = true
        guard !isLoading else { return }
        isLoading = true
        logMessage("\(TAG) preload loading... id: \(selectedBannerAdId)")

        bannerView2 = AlxBannerAdView()
        bannerView2?.translatesAutoresizingMaskIntoConstraints = false
        bannerView2?.refreshInterval = 0
        bannerView2?.delegate = self
        bannerView2?.rootViewController = self
        AlxRequestParamStore.shared.applyVideoExtDebugConfig()
        // 测试新增的扩展字段
        let req = AlxAdRequest().withUserExt([:])
        req.userExt = AlxRequestParamStore.shared.userExtForDefaultBidFloor("1.68")
        logMessage("\(TAG) user_ext=\(req.userExt ?? [:])")
        bannerView2?.loadAd(adUnitId: selectedBannerAdId, request: req)
    }

    @objc private func showAd() {
        guard let banner = bannerView2, banner.isReady() else {
            logMessage("\(TAG) preloaded ad not ready")
            return
        }
        clearSubView(adContainer)
        adContainer.isHidden = false
        adContainer.addSubview(banner)
        NSLayoutConstraint.activate([
            banner.topAnchor.constraint(equalTo: adContainer.topAnchor),
            banner.bottomAnchor.constraint(equalTo: adContainer.bottomAnchor),
            banner.widthAnchor.constraint(equalTo: adContainer.widthAnchor),
        ])
        logMessage("\(TAG) show preloaded ad")
    }

    @objc private func loadAndShowAd() {
        isBanner2 = false
        logMessage("\(TAG) load and show loading... id: \(selectedBannerAdId)")

        clearSubView(adContainer)
        adContainer.isHidden = false
        adContainer.addSubview(bannerView)
        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: adContainer.topAnchor),
            bannerView.bottomAnchor.constraint(equalTo: adContainer.bottomAnchor),
            bannerView.widthAnchor.constraint(equalTo: adContainer.widthAnchor),
        ])

        bannerView.delegate = self
        bannerView.rootViewController = self
        bannerView.isHideClose = false
        AlxRequestParamStore.shared.applyVideoExtDebugConfig()
        let req = AlxAdRequest().withUserExt([:])
        req.userExt = AlxRequestParamStore.shared.userExtForDefaultBidFloor("1.68")
        logMessage("\(TAG) user_ext=\(req.userExt ?? [:])")
        bannerView.loadAd(adUnitId: selectedBannerAdId, request: req)
    }

    @objc private func selectBannerId() {
        let titleSpacer = "\n\n\n\n\n\n\n\n"
        let alert = UIAlertController(
            title: "Select Banner ID\(titleSpacer)",
            message: nil,
            preferredStyle: .actionSheet
        )
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.dataSource = self
        picker.delegate = self
        if let selectedIndex = bannerAdIds.firstIndex(of: selectedBannerAdId) {
            picker.selectRow(selectedIndex, inComponent: 0, animated: false)
        }
        alert.view.addSubview(picker)
        NSLayoutConstraint.activate([
            picker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 46),
            picker.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor, constant: 8),
            picker.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor, constant: -8),
            picker.heightAnchor.constraint(equalToConstant: 160),
        ])

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            let row = picker.selectedRow(inComponent: 0)
            guard self.bannerAdIds.indices.contains(row) else { return }
            self.selectedBannerAdId = self.bannerAdIds[row]
            self.bannerIdValueLabel.text = self.selectedBannerAdId
            self.logMessage("\(self.TAG) selected banner id: \(self.selectedBannerAdId)")
        }))

        if let popover = alert.popoverPresentationController {
            popover.sourceView = bannerIdSelectButton
            popover.sourceRect = bannerIdSelectButton.bounds
        }
        present(alert, animated: true)
    }

    @objc private func buttonRemove() {
        clearSubView(adContainer)
        bannerView2?.destroy()
        bannerView2 = nil
        logMessage("\(TAG) ad removed")
    }

    @objc private func buttonClearLog() {
        logTextView.text = ""
    }

    @objc private func buttonHide() {
        adContainer.isHidden = !adContainer.isHidden
        logMessage("\(TAG) ad \(adContainer.isHidden ? "hidden" : "visible")")
    }
}

extension AlxBannerVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bannerAdIds.count
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        label.frame = CGRect(x: 0, y: 0, width: pickerView.bounds.width, height: 36)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .label
        label.text = bannerAdIds.indices.contains(row) ? bannerAdIds[row] : ""
        return label
    }
}

// MARK: - AlxBannerViewAdDelegate

extension AlxBannerVC: AlxBannerViewAdDelegate {
    func bannerViewAdLoad(_ bannerView: AlxBannerAdView) {
        logMessage("\(TAG) bannerViewAdLoad: ")
        logMessage("\(TAG) price = \(bannerView.getPrice())")
        bannerView.reportBiddingUrl()
        bannerView.reportChargingUrl()
        if isBanner2 {
            isLoading = false
            logMessage("\(TAG) preload success, tap Show to display")
        }
    }

    func bannerViewAdFailToLoad(_ bannerView: AlxBannerAdView, didFailWithError error: Error) {
        let e = error as NSError
        logMessage("\(TAG) bannerViewAdFailToLoad: \(e.code): \(e.localizedDescription)")
        if isBanner2 { isLoading = false }
    }

    func bannerViewAdImpression(_ bannerView: AlxBannerAdView) {
        logMessage("\(TAG) bannerViewAdImpression")
    }

    func bannerViewAdClick(_ bannerView: AlxBannerAdView) {
        logMessage("\(TAG) bannerViewAdClick")
    }

    func bannerViewAdClose(_ bannerView: AlxBannerAdView) {
        logMessage("\(TAG) bannerViewAdClose")
        if isBanner2 { clearSubView(adContainer) }
    }
}
