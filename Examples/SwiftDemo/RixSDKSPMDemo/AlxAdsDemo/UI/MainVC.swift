//
//  MainVC.swift
//  AlxDemo
//
//  Created by liu weile on 2025/3/31.
//

import UIKit
import AppTrackingTransparency
import AdSupport
import AlxAds

struct MenuItem {
    let title: String
    let description: String
    let viewControllerType: UIViewController.Type
}

struct MenuSection {
    let title: String
    let items: [MenuItem]
}

// MARK: - MainVC

class MainVC: BaseUIViewController {

    private let menuSections: [MenuSection] = [
        MenuSection(
            title: "Ad Platforms",
            items: [
                MenuItem(title: "Alx Ad",
                         description: "Direct integration with RixEngine ad serving.",
                         viewControllerType: AlxMainVC.self),
                MenuItem(title: "Admob Ad",
                         description: "Google AdMob mediation integration.",
                         viewControllerType: AdmobMainVC.self),
                MenuItem(title: "Max Ad",
                         description: "AppLovin MAX mediation integration.",
                         viewControllerType: MaxMainVC.self),
//                MenuItem(title: "TopOn Ad",
//                         description: "TopOn mediation integration.",
//                         viewControllerType: TopOnMainVC.self),
                MenuItem(title: "LevelPlay Ad",
                         description: "IronSource LevelPlay mediation integration.",
                         viewControllerType: LevelPlayMainVC.self)
            ]
        ),
        MenuSection(
            title: "Internal",
            items: [
                MenuItem(title: "Test",
                         description: "Internal testing tools for QA validation.",
                         viewControllerType: TestMainVC.self)
            ]
        )
    ]

    private lazy var tableView: UITableView = {
        let t = UITableView(frame: .zero, style: .grouped)
        t.translatesAutoresizingMaskIntoConstraints = false
        t.delegate = self
        t.dataSource = self
        t.separatorStyle = .none
        t.backgroundColor = .clear
        t.showsVerticalScrollIndicator = false
        t.register(MenuCardCell.self, forCellReuseIdentifier: MenuCardCell.reuseID)
        t.sectionFooterHeight = 0
        t.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        return t
    }()

    private let gradientLayer = CAGradientLayer()
    private var sectionHeaderCache: [Int: UIView] = [:]
    private lazy var cachedSDKVersion: String = AlxSdk.getSDKVersion()
    private lazy var cachedIdfaText: String = "IDFA:\(ASIdentifierManager.shared().advertisingIdentifier.uuidString)"

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupBackground()
        setupHeader()
        setupTableView()
        let appidString = AlxSdk.getAppID()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DemoMenuNavigation.warmupPlatformViewControllersIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.requestATTPermission()
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

    private var headerBottomAnchor: NSLayoutYAxisAnchor!

    private func setupHeader() {
        let headerContainer = UIView()
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerContainer)

        // Logo
        let logoView = UIImageView()
        logoView.image = UIImage(named: "Logo")
        logoView.contentMode = .scaleAspectFill
        logoView.clipsToBounds = true
        logoView.layer.cornerRadius = 22
        logoView.translatesAutoresizingMaskIntoConstraints = false

        // Title
        let titleLabel = UILabel()
        titleLabel.text = "SDK Demo"
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Version badge
        let versionBadge = PaddingLabel()
        versionBadge.text = cachedSDKVersion
        versionBadge.font = UIFont.monospacedSystemFont(ofSize: 11, weight: .medium)
        versionBadge.textColor = UIColor(red: 0.35, green: 0.35, blue: 0.55, alpha: 1)
        versionBadge.backgroundColor = UIColor(red: 0.92, green: 0.92, blue: 0.97, alpha: 1)
        versionBadge.layer.cornerRadius = 10
        versionBadge.clipsToBounds = true
        versionBadge.translatesAutoresizingMaskIntoConstraints = false

        // Swift language badge
        let swiftBadge = UIView()
        swiftBadge.backgroundColor = UIColor(red: 0.96, green: 0.93, blue: 0.98, alpha: 1)
        swiftBadge.layer.cornerRadius = 10
        swiftBadge.clipsToBounds = true
        swiftBadge.translatesAutoresizingMaskIntoConstraints = false

        let swiftIcon = UIImageView()
        let swiftConfig = UIImage.SymbolConfiguration(pointSize: 11, weight: .medium)
        swiftIcon.image = UIImage(systemName: "swift", withConfiguration: swiftConfig)
        swiftIcon.tintColor = UIColor(red: 0.95, green: 0.35, blue: 0.2, alpha: 1)
        swiftIcon.translatesAutoresizingMaskIntoConstraints = false

        let swiftLabel = UILabel()
        swiftLabel.text = "Swift"
        swiftLabel.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        swiftLabel.textColor = UIColor(red: 0.5, green: 0.35, blue: 0.55, alpha: 1)
        swiftLabel.translatesAutoresizingMaskIntoConstraints = false

        swiftBadge.addSubview(swiftIcon)
        swiftBadge.addSubview(swiftLabel)

        NSLayoutConstraint.activate([
            swiftIcon.leadingAnchor.constraint(equalTo: swiftBadge.leadingAnchor, constant: 6),
            swiftIcon.centerYAnchor.constraint(equalTo: swiftBadge.centerYAnchor),
            swiftLabel.leadingAnchor.constraint(equalTo: swiftIcon.trailingAnchor, constant: 3),
            swiftLabel.centerYAnchor.constraint(equalTo: swiftBadge.centerYAnchor),
            swiftLabel.trailingAnchor.constraint(equalTo: swiftBadge.trailingAnchor, constant: -6)
        ])

        // IDFA label
        let idfaLabel = UILabel()
        idfaLabel.text = cachedIdfaText
        idfaLabel.font = UIFont.monospacedSystemFont(ofSize: 11, weight: .regular)
        idfaLabel.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.6, alpha: 1)
        idfaLabel.translatesAutoresizingMaskIntoConstraints = false

        // Decorative element (top-right blurred circle)
        let decoView = UIView()
        decoView.backgroundColor = UIColor(red: 0.7, green: 0.75, blue: 1.0, alpha: 0.15)
        decoView.layer.cornerRadius = 40
        decoView.translatesAutoresizingMaskIntoConstraints = false

        headerContainer.addSubview(decoView)
        headerContainer.addSubview(logoView)
        headerContainer.addSubview(titleLabel)
        headerContainer.addSubview(versionBadge)
        headerContainer.addSubview(swiftBadge)
        headerContainer.addSubview(idfaLabel)

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
            idfaLabel.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: -8),

            decoView.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: -10),
            decoView.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: 10),
            decoView.widthAnchor.constraint(equalToConstant: 80),
            decoView.heightAnchor.constraint(equalToConstant: 80)
        ])

        headerBottomAnchor = headerContainer.bottomAnchor
    }

    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerBottomAnchor, constant: 4),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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

// MARK: - UITableViewDataSource

extension MainVC: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return menuSections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuSections[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuCardCell.reuseID, for: indexPath) as? MenuCardCell else {
            return UITableViewCell()
        }
        let item = menuSections[indexPath.section].items[indexPath.row]
        cell.configure(title: item.title, description: item.description)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MainVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = menuSections[indexPath.section].items[indexPath.row]
        DemoMenuNavigation.push(item.viewControllerType, from: navigationController)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let cached = sectionHeaderCache[section] {
            return cached
        }
        let container = UIView()
        let label = UILabel()
        label.text = menuSections[section].title
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.6, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 32),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -4)
        ])
        sectionHeaderCache[section] = container
        return container
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
