//
//  AlxRewardVideoVC.swift
//  AlxDemo
//
//  Created by liu weile on 2025/3/31.
//

import UIKit
import AlxAds

class AlxRewardVideoVC: BaseUIViewController {

    private let TAG = "Alx-rewardVideo:"
    // === AI MODIFIED BEGIN | gpt-5.3-codex | 2026-07-02 | modified | YangXk ===
    private let reloadRequiredTip = "广告已消费，请先重新 load ad"
    // === AI MODIFIED END ===

    private var rewardAd: AlxRewardVideoAd!
    private var isLoading = false
    private var selectedRewardAdId = AdConfig.Alx_Reward_Video_Ad_Id
    private lazy var rewardAdIds: [String] = {
        let ids = AdConfig.Alx_Reward_Video_Ad_Ids.filter { !$0.isEmpty }
        return ids.isEmpty ? [AdConfig.Alx_Reward_Video_Ad_Id] : ids
    }()
    private let gradientLayer = CAGradientLayer()
    private lazy var rewardIdSelectButton: UIButton = {
        let button = createButton(title: "Select Reward ID", action: #selector(selectRewardId))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var rewardIdValueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = UIColor(red: 0.17, green: 0.17, blue: 0.23, alpha: 1)
        label.backgroundColor = .white
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.text = selectedRewardAdId
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

    private weak var adLogContentStack: UIStackView?
    private weak var adLogControlsStack: UIStackView?
    private var adLogContentTopConstraint: NSLayoutConstraint?
    private var adLogContentBottomConstraint: NSLayoutConstraint?
    private var logCardHeightConstraint: NSLayoutConstraint?
    private var lastAdLogLayoutLandscape: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        if !rewardAdIds.contains(selectedRewardAdId) {
            selectedRewardAdId = rewardAdIds[0]
        }
        navigationItem.title = NSLocalizedString("rewardVideo_ad", comment: "")
        setupBackground()
        setupUI()
        createAd()
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
            (NSLocalizedString("load_ad", comment: ""), #selector(loadAd)),
            (NSLocalizedString("show_ad", comment: ""), #selector(showAd)),
            ("Clear Log", #selector(buttonClearLog))
        ])
        let adIdRow = UIStackView(arrangedSubviews: [rewardIdSelectButton, rewardIdValueLabel])
        adIdRow.axis = .horizontal
        adIdRow.spacing = 12
        adIdRow.distribution = .fillEqually
        adIdRow.translatesAutoresizingMaskIntoConstraints = false

        let controlsStack = UIStackView(arrangedSubviews: [adIdRow, buttonStack])
        controlsStack.axis = .vertical
        controlsStack.spacing = 12
        controlsStack.translatesAutoresizingMaskIntoConstraints = false
        adLogControlsStack = controlsStack

        layout.contentStack.addArrangedSubview(logCard)
        layout.contentStack.addArrangedSubview(controlsStack)

        logCardHeightConstraint = logCard.heightAnchor.constraint(equalToConstant: 220)

        NSLayoutConstraint.activate([
            logCardHeightConstraint!,

            logTextView.topAnchor.constraint(equalTo: logCard.topAnchor, constant: 10),
            logTextView.leadingAnchor.constraint(equalTo: logCard.leadingAnchor, constant: 12),
            logTextView.trailingAnchor.constraint(equalTo: logCard.trailingAnchor, constant: -12),
            logTextView.bottomAnchor.constraint(equalTo: logCard.bottomAnchor, constant: -10),

            rewardIdSelectButton.heightAnchor.constraint(equalToConstant: 44),
            rewardIdValueLabel.heightAnchor.constraint(equalToConstant: 44),
        ])

        updateAdLogLayoutIfNeeded()
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

    private func logMessage(_ msg: String) {
        print(msg)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.logTextView.text = (self.logTextView.text ?? "") + msg + "\n"
            let bottom = NSRange(location: max(self.logTextView.text.count - 1, 0), length: 1)
            self.logTextView.scrollRangeToVisible(bottom)
        }
    }

    private func createAd() {
        rewardAd = AlxRewardVideoAd()
    }

    @objc func loadAd() {
        logMessage("\(TAG) load ad clicked")
        if isLoading {
            return
        }
        isLoading = true
        logMessage("\(TAG) loading... id: \(selectedRewardAdId)")

        rewardAd.delegate = self
        let debugType: AlxRequestParamStore.DebugAdType = .rewardVideo
        AlxRequestParamStore.shared.applyVideoExtDebugConfig(for: debugType)
        // 测试新增的扩展字段
        let req = AlxAdRequest().withUserExt([:])
        req.userExt = AlxRequestParamStore.shared.userExtForDefaultBidFloor("1.68", for: debugType)
        logMessage("\(TAG) user_ext = \(req.userExt ?? [:])")
        rewardAd.loadAd(adUnitId: selectedRewardAdId, request: req)
    }

    @objc func showAd() {
        logMessage("\(TAG) show ad clicked")
        if rewardAd.isReady() {
            // === AI MODIFIED BEGIN | gpt-5.3-codex | 2026-07-02 | modified | YangXk ===
            rewardAd.showAd(present: self)
            // === AI MODIFIED END ===
        } else {
            logMessage("\(TAG) Ad wasn't ready")
            // === AI MODIFIED BEGIN | gpt-5.3-codex | 2026-07-02 | modified | YangXk ===
            showAutoDismissTip(reloadRequiredTip)
            // === AI MODIFIED END ===
        }
    }

    @objc private func buttonClearLog() {
        logTextView.text = ""
    }

    @objc private func selectRewardId() {
        let titleSpacer = "\n\n\n\n\n\n\n\n"
        let alert = UIAlertController(
            title: "Select Reward ID\(titleSpacer)",
            message: nil,
            preferredStyle: .actionSheet
        )
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.dataSource = self
        picker.delegate = self
        if let selectedIndex = rewardAdIds.firstIndex(of: selectedRewardAdId) {
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
            guard self.rewardAdIds.indices.contains(row) else { return }
            self.selectedRewardAdId = self.rewardAdIds[row]
            self.rewardIdValueLabel.text = self.selectedRewardAdId
            self.logMessage("\(self.TAG) selected reward id: \(self.selectedRewardAdId)")
        }))

        if let popover = alert.popoverPresentationController {
            popover.sourceView = rewardIdSelectButton
            popover.sourceRect = rewardIdSelectButton.bounds
        }
        present(alert, animated: true)
    }
}

extension AlxRewardVideoVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rewardAdIds.count
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
        label.text = rewardAdIds.indices.contains(row) ? rewardAdIds[row] : ""
        return label
    }
}

extension AlxRewardVideoVC: AlxRewardVideoAdDelegate {

    func rewardVideoAdLoad(_ ad: AlxRewardVideoAd) {
        logMessage("\(TAG) rewardVideoAdLoad")
        logMessage("\(TAG) price = price:\(ad.getPrice())")
        isLoading = false
    }

    func rewardVideoAdFailToLoad(_ ad: AlxRewardVideoAd, didFailWithError error: Error) {
        let error1 = error as NSError
        let msg = "\(error1.code): \(error1.localizedDescription)"
        logMessage("\(TAG) rewardVideoAdFailToLoad: \(msg)")
        isLoading = false
    }

    func rewardVideoAdImpression(_ ad: AlxRewardVideoAd) {
        logMessage("\(TAG) rewardVideoAdImpression")
    }

    func rewardVideoAdClick(_ ad: AlxRewardVideoAd) {
        logMessage("\(TAG) rewardVideoAdClick")
    }

    func rewardVideoAdClose(_ ad: AlxRewardVideoAd) {
        logMessage("\(TAG) rewardVideoAdClose")
    }

    func rewardVideoAdPlayStart(_ ad: AlxRewardVideoAd) {
        logMessage("\(TAG) rewardVideoAdPlayStart")
    }

    func rewardVideoAdPlayEnd(_ ad: AlxRewardVideoAd) {
        logMessage("\(TAG) rewardVideoAdPlayEnd")
    }

    func rewardVideoAdReward(_ ad: AlxRewardVideoAd) {
        logMessage("\(TAG) rewardVideoAdReward")
    }

    func rewardVideoAdPlayFail(_ ad: AlxRewardVideoAd, didFailWithError error: Error) {
        logMessage("\(TAG) rewardVideoAdPlayFail \(error.localizedDescription)")
    }
}
