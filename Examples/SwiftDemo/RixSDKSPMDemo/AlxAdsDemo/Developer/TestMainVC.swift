//
//  Main.swift
//  AlxDevelop
//
//  Created by liu weile on 2025/6/16.
//

import UIKit
import CoreLocation
import StoreKit
//import AlxAds

struct TestMenuItem {
    let title: String
    let description: String
    let action: Selector
}

@objc public class TestMainVC: BaseUIViewController {

    private let menuItems: [TestMenuItem] = [
        TestMenuItem(title: "Web View",
                     description: "Open a web view for testing.",
                     action: #selector(bnWeb)),
        TestMenuItem(title: "获取设备信息",
                     description: "Print current device details to console.",
                     action: #selector(bnAdmob)),
        TestMenuItem(title: "请求案例",
                     description: "Execute a sample network request.",
                     action: #selector(bnMax))
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

    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Test"
        setupBackground()
        setupTableView()
    }

    public override func viewDidLayoutSubviews() {
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
}

// MARK: - UITableViewDataSource

extension TestMainVC: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MenuCardCell.reuseID, for: indexPath) as? MenuCardCell else {
            return UITableViewCell()
        }
        let item = menuItems[indexPath.row]
        cell.configure(title: item.title, description: item.description)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TestMainVC: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = menuItems[indexPath.row]
        perform(item.action)
    }
}

// MARK: - Action Methods

extension TestMainVC {
    @objc func bnWeb() {
//        self.testReqeust()
    }

    @objc func bnAdmob() {
//        self.navigationController?.pushViewController(AdmobMainVC(), animated: false)
//        testDownload()
    }

    @objc func bnMax() {
//        self.navigationController?.pushViewController(MaxMainVC(), animated: false)
//        openLink()
    }

    @objc func bnIronSource() {
//        self.navigationController?.pushViewController(IronSourceMainVC(), animated: false)
    }

    @objc func bnTopOn() {
//        self.navigationController?.pushViewController(TopOnMainVC(), animated: false)
    }
}
