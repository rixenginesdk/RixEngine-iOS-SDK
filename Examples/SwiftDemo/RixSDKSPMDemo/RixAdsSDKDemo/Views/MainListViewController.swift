//
//  MainListViewController.swift
//  RixAdsSDKDemo
//
//  Created by YXk on 2026/8/30.
//

import UIKit
import AppTrackingTransparency
import AdSupport
import AlxAds

// MARK: - MainVC

class MainListViewController: BasicMenuViewController {

    override var menuSections: [MenuSection] {
        [
            MenuSection(
                title: "Ad Platforms",
                items: [
                    MenuItem(
                        title: "Alx Ad",
                        description: "Direct integration with RixEngine ad serving.",
                        makeViewController: { RixAdsMainListVC() }
                    ),
                    MenuItem(
                        title: "Admob Ad",
                        description: "Google AdMob mediation integration.",
                        makeViewController: { AdmobAdsMainListVC() }
                    ),
                    MenuItem(
                        title: "Max Ad",
                        description: "AppLovin MAX mediation integration.",
                        makeViewController: { MaxAdsMainListVC() }
                    ),
                    MenuItem(
                        title: "TopOn Ad",
                        description: "TopOn mediation integration.",
                        makeViewController: { TopOnAdsMainListVC() }
                    ),
                    MenuItem(
                        title: "LevelPlay Ad",
                        description: "IronSource LevelPlay mediation integration.",
                        makeViewController: { UnityAdsMainListVC() }
                    )
                ]
            ),
        ]
    }

    override var menuContentInset: UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }

    // MARK: - SDK Info Value
    /// AlxSDK Version Content
    private lazy var cachedSDKVersion: String = AlxSdk.getSDKVersion()
    /// IDFA Content
    private lazy var cachedIdfaText: String = "IDFA:\(ASIdentifierManager.shared().advertisingIdentifier.uuidString)"
    /// SID Content
    private lazy var cachedSIDText: String = "SID:\(AlxSdk.getPubSid())"
    /// APPID Content
    private lazy var cachedAPPIDText: String = "APPID:\(AlxSdk.getAppID())"
    /// OMSDK Version Content
    private lazy var cachedOMSDKVersion: String = "OMSDK Version:\(AlxSdk.getOMSDKVersion())"
    /// RixEngineHost Content
    private lazy var cachedRixEngineHostText: String = "RixEngineHost:\(AlxSdk.getRixEngineHost())"
    /// Alx User ID Content
    private lazy var cachedAlxUserIDText: String = "Alx User ID:\(AlxSdk.getAlxUserID())"
    /// SDK 剪贴板信息
    private var sdkInfoClipboardText: String {
        [
            "SDK Version: \(cachedSDKVersion)",
            cachedIdfaText,
            cachedRixEngineHostText,
            cachedAPPIDText,
            cachedSIDText,
            cachedOMSDKVersion,
            cachedAlxUserIDText,
        ].joined(separator: "\n")
    }
    
    // MARK: - UI controls
    /// Logo
    private lazy var logoView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = UIImage(named: "appLogo") ?? UIImage(named: "Logo")
        logoView.contentMode = .scaleAspectFill
        logoView.clipsToBounds = true
        logoView.layer.cornerRadius = 22
        logoView.translatesAutoresizingMaskIntoConstraints = false
        return logoView
    }()
    /// Title
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "SDK Demo"
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    /// Version badge
    private lazy var versionBadge: PaddingLabel = {
        let versionBadge = PaddingLabel()
        versionBadge.text = self.cachedSDKVersion
        versionBadge.font = UIFont.monospacedSystemFont(ofSize: 11, weight: .medium)
        versionBadge.textColor = UIColor(red: 0.35, green: 0.35, blue: 0.55, alpha: 1)
        versionBadge.backgroundColor = UIColor(red: 0.92, green: 0.92, blue: 0.97, alpha: 1)
        versionBadge.layer.cornerRadius = 10
        versionBadge.clipsToBounds = true
        versionBadge.translatesAutoresizingMaskIntoConstraints = false
        return versionBadge
    }()
    /// Swift language badge
    private lazy var swiftBadge: UIView = {
        let swiftBadge = UIView()
        swiftBadge.backgroundColor = UIColor(red: 0.96, green: 0.93, blue: 0.98, alpha: 1)
        swiftBadge.layer.cornerRadius = 10
        swiftBadge.clipsToBounds = true
        swiftBadge.isUserInteractionEnabled = false
        swiftBadge.translatesAutoresizingMaskIntoConstraints = false
        return swiftBadge
    }()
    /// Swift Icon
    private lazy var swiftIcon: UIImageView = {
        let swiftIcon = UIImageView()
        let swiftConfig = UIImage.SymbolConfiguration(pointSize: 11, weight: .medium)
        swiftIcon.image = UIImage(systemName: "swift", withConfiguration: swiftConfig)
        swiftIcon.tintColor = UIColor(red: 0.95, green: 0.35, blue: 0.2, alpha: 1)
        swiftIcon.translatesAutoresizingMaskIntoConstraints = false
        return swiftIcon
    }()
    /// Swift Label
    private lazy var swiftLabel: UILabel = {
        let swiftLabel = UILabel()
        swiftLabel.text = "Swift"
        swiftLabel.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        swiftLabel.textColor = UIColor(red: 0.5, green: 0.35, blue: 0.55, alpha: 1)
        swiftLabel.translatesAutoresizingMaskIntoConstraints = false
        return swiftLabel
    }()
    /// IDFA Label
    private lazy var idfaLabel: UILabel = makeSDKInfoLabel(cachedIdfaText)
    /// RixEngineHost Label
    private lazy var hostLabel: UILabel = makeSDKInfoLabel(cachedRixEngineHostText)
    /// APPID Label
    private lazy var appidLabel: UILabel = makeSDKInfoLabel(cachedAPPIDText)
    /// SID Label
    private lazy var sidLabel: UILabel = makeSDKInfoLabel(cachedSIDText)
    /// OMSDK Version Label
    private lazy var omsdkVersionLabel: UILabel = makeSDKInfoLabel(cachedOMSDKVersion)
    /// Alx User ID Label
    private lazy var alxUserIdLabel: UILabel = makeSDKInfoLabel(cachedAlxUserIDText)
    /// Top-Right Blue Circle View
    private lazy var decoView: UIView = {
        // Decorative element (top-right blurred circle)
        let decoView = UIView()
        decoView.backgroundColor = UIColor(red: 0.7, green: 0.75, blue: 1.0, alpha: 0.15)
        decoView.layer.cornerRadius = 40
        decoView.isUserInteractionEnabled = false
        decoView.translatesAutoresizingMaskIntoConstraints = false
        return decoView
    }()
    private var headerBottomAnchor: NSLayoutYAxisAnchor!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { [weak self] in
            self?.requestATTPermission()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Setup

    override var menuTableTopAnchor: NSLayoutYAxisAnchor {
        headerBottomAnchor
    }

    override var menuTableTopOffset: CGFloat { 4 }

    override func setupMenuHeader() {
        setupHeader()
    }

    private func makeSDKInfoLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.attributedText = text.sdkInfoAttributedString()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    // MARK: - ATT

    func requestATTPermission() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                UserDefaults.standard.set(true, forKey: "hasRequestedTrackingAuthorization")
                switch status {
                case .authorized:   print("ATT Authorized")
                case .denied:       print("ATT Denied")
                case .notDetermined:print("ATT Not Determined")
                case .restricted:   print("ATT Restricted")
                @unknown default:   print("ATT Unknown")
                }
                let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                print("idfa:", idfa)
            }
        } else {
            let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            print("idfa:", idfa)
        }
    }
}

// MARK: - User Interface
extension MainListViewController {
    private func setupHeader() {
        let headerContainer = UIView()
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerContainer)

        swiftBadge.addSubview(swiftIcon)
        swiftBadge.addSubview(swiftLabel)

        NSLayoutConstraint.activate([
            swiftIcon.leadingAnchor.constraint(equalTo: swiftBadge.leadingAnchor, constant: 6),
            swiftIcon.centerYAnchor.constraint(equalTo: swiftBadge.centerYAnchor),
            swiftLabel.leadingAnchor.constraint(equalTo: swiftIcon.trailingAnchor, constant: 3),
            swiftLabel.centerYAnchor.constraint(equalTo: swiftBadge.centerYAnchor),
            swiftLabel.trailingAnchor.constraint(equalTo: swiftBadge.trailingAnchor, constant: -6)
        ])

        /// 视图数组
        let headerSubviews: [UIView] = [
            decoView, logoView, titleLabel, versionBadge, swiftBadge,
            idfaLabel, hostLabel, appidLabel, sidLabel, omsdkVersionLabel, alxUserIdLabel
        ]
        /* 循环遍历添加到父视图，避免一行一行添加的啰嗦代码 */
        headerSubviews.forEach { headerContainer.addSubview($0) }

        NSLayoutConstraint.activate([
            headerContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            logoView.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 16),
            logoView.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 24),
            logoView.widthAnchor.constraint(equalToConstant: 44),
            logoView.heightAnchor.constraint(equalToConstant: 44),

            titleLabel.centerYAnchor.constraint(equalTo: logoView.centerYAnchor, constant: -1),
            titleLabel.leadingAnchor.constraint(equalTo: logoView.trailingAnchor, constant: 12),

            versionBadge.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            versionBadge.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            versionBadge.heightAnchor.constraint(equalToConstant: 20),

            swiftBadge.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            swiftBadge.leadingAnchor.constraint(equalTo: versionBadge.trailingAnchor, constant: 6),
            swiftBadge.heightAnchor.constraint(equalToConstant: 20),

            idfaLabel.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 10),
            idfaLabel.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 24),
            idfaLabel.trailingAnchor.constraint(lessThanOrEqualTo: headerContainer.trailingAnchor, constant: -24),
//            idfaLabel.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: -36),
            
            hostLabel.topAnchor.constraint(equalTo: idfaLabel.bottomAnchor, constant: 10),
            hostLabel.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 24),
            hostLabel.trailingAnchor.constraint(lessThanOrEqualTo: headerContainer.trailingAnchor, constant: -24),
//            hostLabel.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: -8),
            
            appidLabel.topAnchor.constraint(equalTo: hostLabel.bottomAnchor, constant: 10),
            appidLabel.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 24),
            appidLabel.trailingAnchor.constraint(lessThanOrEqualTo: headerContainer.trailingAnchor, constant: -24),
//            appidLabel.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: -8),
            
            sidLabel.topAnchor.constraint(equalTo: appidLabel.bottomAnchor, constant: 10),
            sidLabel.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 24),
            sidLabel.trailingAnchor.constraint(lessThanOrEqualTo: headerContainer.trailingAnchor, constant: -24),
            
            omsdkVersionLabel.topAnchor.constraint(equalTo: sidLabel.bottomAnchor, constant: 10),
            omsdkVersionLabel.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 24),
            omsdkVersionLabel.trailingAnchor.constraint(lessThanOrEqualTo: headerContainer.trailingAnchor, constant: -24),
//            omsdkVersionLabel.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: -8),
            
            alxUserIdLabel.topAnchor.constraint(equalTo: omsdkVersionLabel.bottomAnchor, constant: 10),
            alxUserIdLabel.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 24),
            alxUserIdLabel.trailingAnchor.constraint(lessThanOrEqualTo: headerContainer.trailingAnchor, constant: -24),
            alxUserIdLabel.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: 0),

            decoView.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: -10),
            decoView.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: 10),
            decoView.widthAnchor.constraint(equalToConstant: 80),
            decoView.heightAnchor.constraint(equalToConstant: 80)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(headerContainerTapped))
        headerContainer.addGestureRecognizer(tap)

        headerBottomAnchor = headerContainer.bottomAnchor
    }

    @objc private func headerContainerTapped() {
        UIPasteboard.general.string = sdkInfoClipboardText
        let alert = UIAlertController(title: nil, message: "SDK 信息已复制到剪贴板", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

