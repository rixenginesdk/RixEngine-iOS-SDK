//
//  BasicMenuViewController.swift
//  RixAdsSDKDemo
//
//  Created by YXk on 2026/8/30.
//

import UIKit

/// 卡片式 Demo 菜单基类，统一菜单展示、导航和延迟初始化。
class BasicMenuViewController: BasicUIViewController {

    struct MenuItem {
        let title: String
        let description: String
        let makeViewController: () -> UIViewController

        init(
            title: String,
            description: String,
            makeViewController: @escaping () -> UIViewController
        ) {
            self.title = title
            self.description = description
            self.makeViewController = makeViewController
        }
    }

    struct MenuSection {
        let title: String?
        let items: [MenuItem]

        init(title: String? = nil, items: [MenuItem]) {
            self.title = title
            self.items = items
        }
    }

    // MARK: - Subclass interface

    var menuSections: [MenuSection] { [] }

    var menuContentInset: UIEdgeInsets {
        UIEdgeInsets(top: 8, left: 0, bottom: 20, right: 0)
    }

    var menuTableTopAnchor: NSLayoutYAxisAnchor {
        view.safeAreaLayoutGuide.topAnchor
    }

    var menuTableTopOffset: CGFloat { 0 }

    /// 子类可在这里安装位于菜单上方的自定义头部。
    func setupMenuHeader() {}

    /// 首次显示页面后异步执行一次，供子类初始化 SDK 或配置调试参数。
    func setupSDK() {}

    let tableView = UITableView(frame: .zero, style: .plain)

    private let gradientLayer = CAGradientLayer()
    private var didScheduleSDKSetup = false

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupMenuHeader()
        setupTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !didScheduleSDKSetup else { return }
        didScheduleSDKSetup = true
        DispatchQueue.main.async { [weak self] in
            self?.setupSDK()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
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

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BasicMenuCardViewCell.self, forCellReuseIdentifier: BasicMenuCardViewCell.reuseID)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 92
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = menuContentInset
        tableView.tableFooterView = UIView(frame: .zero)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: menuTableTopAnchor, constant: menuTableTopOffset),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: - UITableViewDataSource
extension BasicMenuViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        menuSections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuSections[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: BasicMenuCardViewCell.reuseID,
            for: indexPath
        ) as? BasicMenuCardViewCell else {
            return UITableViewCell()
        }
        let item = menuSections[indexPath.section].items[indexPath.row]
        cell.configure(title: item.title, description: item.description)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension BasicMenuViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let makeViewController = menuSections[indexPath.section].items[indexPath.row].makeViewController
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(makeViewController(), animated: true)
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = menuSections[section].title else { return nil }
        let container = UIView()
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.6, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 32),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -4)
        ])
        return container
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        menuSections[section].title == nil ? .leastNormalMagnitude : 36
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        menuSections[section].title == nil ? .leastNormalMagnitude : 4
    }
}
