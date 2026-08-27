//
//  TopOnRewardVideoVC.swift
//  AlxAdsDemo
//
//  Created by liu weile on 2025/8/18.
//

//import UIKit
//import AnyThinkSDK
//
//class TopOnRewardVideoVC: BaseUIViewController {
//
//    private let TAG = "TopOn-rewardVideo:"
//    private var isLoading = false
//    private let gradientLayer = CAGradientLayer()
//    private weak var adLogContentStack: UIStackView?
//    private weak var adLogControlsStack: UIStackView?
//    private var adLogContentTopConstraint: NSLayoutConstraint?
//    private var adLogContentBottomConstraint: NSLayoutConstraint?
//    private var logCardHeightConstraint: NSLayoutConstraint?
//    private var lastAdLogLayoutLandscape: Bool?
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
//        navigationItem.title = NSLocalizedString("topOn_rewardVideo", comment: "")
//        setupBackground()
//        setupUI()
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        gradientLayer.frame = view.bounds
//        updateAdLogLayoutIfNeeded()
//    }
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
//        adLogContentStack = layout.contentStack
//        adLogContentTopConstraint = layout.topConstraint
//        adLogContentBottomConstraint = layout.bottomConstraint
//
//        let logCard = UIView()
//        logCard.backgroundColor = .white
//        logCard.layer.cornerRadius = 12
//        logCard.layer.shadowColor = UIColor(red: 0.45, green: 0.45, blue: 0.65, alpha: 0.08).cgColor
//        logCard.layer.shadowOpacity = 1
//        logCard.layer.shadowOffset = CGSize(width: 0, height: 2)
//        logCard.layer.shadowRadius = 8
//        logCard.translatesAutoresizingMaskIntoConstraints = false
//        logCard.addSubview(logTextView)
//
//        let buttonStack = createButtonStack([
//            (NSLocalizedString("load_ad", comment: ""), #selector(buttonLoad)),
//            (NSLocalizedString("show_ad", comment: ""), #selector(buttonShow)),
//            ("Clear Log", #selector(buttonClearLog))
//        ])
//        adLogControlsStack = buttonStack
//
//        layout.contentStack.addArrangedSubview(logCard)
//        layout.contentStack.addArrangedSubview(buttonStack)
//
//        logCardHeightConstraint = logCard.heightAnchor.constraint(equalToConstant: 220)
//        NSLayoutConstraint.activate([
//            logCardHeightConstraint!,
//
//            logTextView.topAnchor.constraint(equalTo: logCard.topAnchor, constant: 10),
//            logTextView.leadingAnchor.constraint(equalTo: logCard.leadingAnchor, constant: 12),
//            logTextView.trailingAnchor.constraint(equalTo: logCard.trailingAnchor, constant: -12),
//            logTextView.bottomAnchor.constraint(equalTo: logCard.bottomAnchor, constant: -10),
//        ])
//
//        updateAdLogLayoutIfNeeded()
//    }
//
//    private func updateAdLogLayoutIfNeeded() {
//        let isLandscape = view.bounds.width > view.bounds.height
//        guard lastAdLogLayoutLandscape != isLandscape else { return }
//        lastAdLogLayoutLandscape = isLandscape
//
//        applyDemoAdLogLayoutMetrics(
//            DemoAdLogLayoutMetrics.current(for: view.bounds.size),
//            contentStack: adLogContentStack,
//            topConstraint: adLogContentTopConstraint,
//            bottomConstraint: adLogContentBottomConstraint,
//            logCardHeightConstraint: logCardHeightConstraint,
//            controlsStack: adLogControlsStack
//        )
//    }
//
//    private func createButtonStack(_ items: [(String, Selector)]) -> UIStackView {
//        let stack = UIStackView()
//        stack.axis = .vertical
//        stack.spacing = 12
//        stack.translatesAutoresizingMaskIntoConstraints = false
//
//        for item in items {
//            let button = createButton(title: item.0, action: item.1)
//            button.heightAnchor.constraint(equalToConstant: 48).isActive = true
//            stack.addArrangedSubview(button)
//        }
//        return stack
//    }
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
//    @objc func buttonLoad() {
//        logMessage("Load ad clicked")
//        if isLoading {
//            return
//        }
//        isLoading = true
//        logMessage("\(TAG) loading...")
//        loadAd()
//    }
//
//    @objc func buttonShow() {
//        logMessage("Show ad clicked")
//        if ATAdManager.shared().rewardedVideoReady(forPlacementID: AdConfig.TopOn_Reward_Video_Ad_Id) {
//            ATAdManager.shared().showRewardedVideo(withPlacementID: AdConfig.TopOn_Reward_Video_Ad_Id, in: self, delegate: self)
//        } else {
//            logMessage("\(TAG) Ad wasn't ready")
//        }
//    }
//
//    @objc private func buttonClearLog() {
//        logTextView.text = ""
//    }
//
//    func loadAd() {
//        var extra: [String: Any] = [:]
//        extra[kATAdLoadingExtraMediaExtraKey] = "media_val_RewardedVC"
//        ATAdManager.shared().loadAD(withPlacementID: AdConfig.TopOn_Reward_Video_Ad_Id, extra: extra, delegate: self)
//    }
//}
//
//// MARK: - ATAdLoadingDelegate
//extension TopOnRewardVideoVC: ATAdLoadingDelegate {
//
//    func didFinishLoadingAD(withPlacementID placementID: String) {
//        logMessage("\(TAG) didFinishLoadingADWithPlacementID:\(placementID)")
//        isLoading = false
//    }
//
//    func didFailToLoadAD(withPlacementID placementID: String, error: (any Error)) {
//        let msg = "\(error.code): \(error.localizedDescription)"
//        logMessage("\(TAG) didFailToLoadADWithPlacementID:\(placementID), error:\(msg)")
//        isLoading = false
//    }
//}
//
//// MARK: - ATRewardedVideoDelegate
//extension TopOnRewardVideoVC: ATRewardedVideoDelegate {
//    func onRewardedSuccessRetry(forPlacemenID placementID: String, extra: [AnyHashable : Any]?) {
//        
//    }
//    
//    func rewardedVideoDidStartPlaying(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
//        logMessage("\(TAG) rewardedVideoDidStartPlaying:\(placementID)")
//    }
//
//    func rewardedVideoDidEndPlaying(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
//        logMessage("\(TAG) rewardedVideoDidEndPlaying:\(placementID)")
//    }
//
//    func rewardedVideoDidClick(forPlacementID placementID: String, extra: [AnyHashable : Any]) {
//        logMessage("\(TAG) rewardedVideoDidClick:\(placementID)")
//    }
//
//    func rewardedVideoDidClose(forPlacementID placementID: String, rewarded: Bool, extra: [AnyHashable : Any]) {
//        logMessage("\(TAG) rewardedVideoDidClose:\(placementID), rewarded:\(rewarded ? "yes" : "no")")
//    }
//
//    func rewardedVideoDidRewardSuccess(forPlacemenID placementID: String, extra: [AnyHashable : Any]) {
//        logMessage("\(TAG) rewardedVideoDidRewardSuccess:\(placementID)")
//    }
//
//    func rewardedVideoDidRewardSuccess(forPlacementID placementID: String, rewardAmount amount: Double) {
//        logMessage("\(TAG) rewardedVideoDidRewardSuccess:\(placementID), amount:\(amount)")
//    }
//
//    func rewardedVideoDidFailToPlay(forPlacementID placementID: String, error: any Error, extra: [AnyHashable : Any]) {
//        logMessage("\(TAG) rewardedVideoDidFailToPlay:\(placementID), error:\(error.localizedDescription)")
//    }
//}
