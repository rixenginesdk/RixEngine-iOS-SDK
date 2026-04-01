//
//  BaseMenuVC.swift
//  AlxAdsDemo
//
//  Created by liu weile on 2025/3/31.
//

import UIKit

/// 以 UITableView 列表形式展示菜单入口的基类。
/// 子类只需覆盖 `menuItems` 提供入口数据，以及覆盖 `setupSDK()` 做 SDK 初始化。
class BaseMenuVC: BaseUIViewController {

    typealias MenuItem = (title: String, makeVC: () -> UIViewController)

    // MARK: - Subclass interface

    /// 子类覆盖，返回菜单条目列表
    var menuItems: [MenuItem] { [] }

    /// 子类覆盖，在 viewDidLoad 中做 SDK 初始化（默认空实现）
    func setupSDK() {}

    // MARK: - Private

    private let tableView = UITableView(frame: .zero, style: .plain)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSDK()
        setupTableView()
    }

    // MARK: - Layout

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MenuCell")
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

// MARK: - UITableViewDataSource
extension BaseMenuVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row].title
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

// MARK: - UITableViewDelegate
extension BaseMenuVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        54
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = menuItems[indexPath.row].makeVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}
