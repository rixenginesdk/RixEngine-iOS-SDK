//
//  BaseTableViewController.swift
//  AlxDemo
//
//  Created by liu weile on 2025/3/31.
//

import UIKit

/// 基于 UITableView 的基础视图控制器
/// 提供了预配置的 TableView，适合导航菜单类页面使用
public class BaseTableViewController: BaseUIViewController {
    
    // MARK: - Properties
    
    /// TableView 实例
    public lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .singleLine
        table.backgroundColor = .white
        table.rowHeight = 56
        return table
    }()
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    // MARK: - Setup
    
    /// 设置 TableView，子类可以重写以自定义配置
    open func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension BaseTableViewController: UITableViewDataSource {
    
    /// 默认返回 0，子类必须重写此方法
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    /// 默认返回空 cell，子类必须重写此方法
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension BaseTableViewController: UITableViewDelegate {
    
    /// 默认空实现，子类可以重写以处理点击事件
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 子类重写
    }
}
