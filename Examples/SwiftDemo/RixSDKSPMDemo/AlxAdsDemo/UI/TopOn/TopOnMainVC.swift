//
//  TopOnMainVC.swift
//  AlxAdsDemo
//
//  Created by liu weile on 2025/8/18.
//

//import UIKit
//import AnyThinkSDK
//
//class TopOnMainVC: BaseUIViewController, DemoDeferredSDKInitializing {
//
//    var didScheduleSDKInit = false
//
//    private let adTypes: [MenuItem] = [
//        MenuItem(title: NSLocalizedString("banner_ad", comment: ""),
//                 description: "Flexible formats at the top, middle or bottom of your app.",
//                 viewControllerType: TopOnBannerVC.self),
//        MenuItem(title: NSLocalizedString("rewardVideo_ad", comment: ""),
//                 description: "Users engage with a video ad in exchange for in-app rewards.",
//                 viewControllerType: TopOnRewardVideoVC.self),
//        MenuItem(title: NSLocalizedString("interstitial_ad", comment: ""),
//                 description: "Full-screen ads at natural breaks or transition points.",
//                 viewControllerType: TopOnInterstitialVC.self),
//        MenuItem(title: NSLocalizedString("native_ad_template", comment: ""),
//                 description: "Native ads rendered with a platform-provided template.",
//                 viewControllerType: TopOnNativeVC.self),
//        MenuItem(title: NSLocalizedString("native_ad_self_render", comment: ""),
//                 description: "Native ads with fully customized rendering by the app.",
//                 viewControllerType: TopOnNativeSelfRenderVC.self)
//    ]
//
//    private lazy var tableView: UITableView = {
//        let t = UITableView(frame: .zero, style: .plain)
//        t.translatesAutoresizingMaskIntoConstraints = false
//        t.delegate = self
//        t.dataSource = self
//        t.separatorStyle = .none
//        t.backgroundColor = .clear
//        t.showsVerticalScrollIndicator = false
//        t.register(MenuCardCell.self, forCellReuseIdentifier: MenuCardCell.reuseID)
//        t.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 20, right: 0)
//        return t
//    }()
//
//    private let gradientLayer = CAGradientLayer()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        navigationItem.title = NSLocalizedString("topOn_ad", comment: "")
//        setupBackground()
//        setupTableView()
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        scheduleSDKInitializationIfNeeded()
//    }
//
//    func performSDKInitialization() {
//        initSDK()
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        gradientLayer.frame = view.bounds
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
//    private func setupTableView() {
//        view.addSubview(tableView)
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//
//    private func initSDK() {
//        #if DEBUG
//        ATAPI.setLogEnabled(true)
//        ATAPI.integrationChecking()
//        #endif
//
//        do {
//            let result: () = try ATAPI.sharedInstance().start(withAppID: AdConfig.TopOn_App_Id, appKey: AdConfig.TopOn_App_Key)
//            print("TopOn SDK init status:\(result)")
//        } catch {
//            print("TopOn sdk init error:\(error.localizedDescription)")
//        }
//    }
//}
//
//// MARK: - UITableViewDataSource
//
//extension TopOnMainVC: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return adTypes.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuCardCell.reuseID, for: indexPath) as? MenuCardCell else {
//            return UITableViewCell()
//        }
//        let item = adTypes[indexPath.row]
//        cell.configure(title: item.title, description: item.description)
//        return cell
//    }
//}
//
//// MARK: - UITableViewDelegate
//
//extension TopOnMainVC: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let item = adTypes[indexPath.row]
//        DemoMenuNavigation.push(item.viewControllerType, from: navigationController)
//    }
//}
