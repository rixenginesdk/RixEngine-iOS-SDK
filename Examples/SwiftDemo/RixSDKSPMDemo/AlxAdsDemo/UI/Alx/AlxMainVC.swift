//
//  AlxMainVC.swift
//  AlxDemo
//
//  Created by liu weile on 2025/3/31.
//

import UIKit
//import AlxAds

class AlxMainVC: BaseUIViewController {

    private var didApplyDebugConfig = false

    private let adTypes: [MenuItem] = [
        MenuItem(title: NSLocalizedString("banner_ad", comment: ""),
                 description: "Flexible formats at the top, middle or bottom of your app.",
                 viewControllerType: AlxBannerVC.self),
        MenuItem(title: NSLocalizedString("banner_ad_xib", comment: ""),
                 description: "Load banner ads using Interface Builder (Xib).",
                 viewControllerType: AlxBannerXibVC.self),
        MenuItem(title: NSLocalizedString("rewardVideo_ad", comment: ""),
                 description: "Users engage with a video ad in exchange for in-app rewards.",
                 viewControllerType: AlxRewardVideoVC.self),
        MenuItem(title: NSLocalizedString("interstitial_video_ad", comment: ""),
                 description: "Full-screen video ads at natural breaks or transition points.",
                 viewControllerType: AlxInterstitialVC.self),
        MenuItem(title: NSLocalizedString("interstitial_banner_ad", comment: ""),
                 description: "Full-screen banner ads at natural breaks or transition points.",
                 viewControllerType: AlxInterstitialBannerVC.self),
        MenuItem(title: NSLocalizedString("native_ad", comment: ""),
                 description: "Ads that match the look and feel of your app.",
                 viewControllerType: AlxNativeVC.self)
    ]

    private lazy var tableView: UITableView = {
        let t = UITableView(frame: .zero, style: .plain)
        t.translatesAutoresizingMaskIntoConstraints = false
        t.delegate = self
        t.dataSource = self
        t.separatorStyle = .none
        t.backgroundColor = .clear
        t.showsVerticalScrollIndicator = false
        t.register(MenuCardCell.self, forCellReuseIdentifier: MenuCardCell.reuseID)
        t.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 20, right: 0)
        return t
    }()

    private let gradientLayer = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("alx_ad", comment: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "请求参数",
            style: .plain,
            target: self,
            action: #selector(openRequestConfig)
        )
        setupBackground()
        setupTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !didApplyDebugConfig else { return }
        didApplyDebugConfig = true
        DispatchQueue.main.async {
            AlxRequestParamStore.shared.applyVideoExtDebugConfig()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
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

    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func openRequestConfig() {
        let vc = AlxRequestConfigVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension AlxMainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adTypes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuCardCell.reuseID, for: indexPath) as? MenuCardCell else {
            return UITableViewCell()
        }
        let item = adTypes[indexPath.row]
        cell.configure(title: item.title, description: item.description)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension AlxMainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = adTypes[indexPath.row]
        DemoMenuNavigation.push(item.viewControllerType, from: navigationController)
    }
}
