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
    enum MenuAppearance {
        case plain
        case card
    }

    // MARK: - Subclass interface

    /// 子类覆盖，返回菜单条目列表
    var menuItems: [MenuItem] { [] }

    /// 子类覆盖，在 viewDidLoad 中做 SDK 初始化（默认空实现）
    func setupSDK() {}

    /// 子类覆盖，控制菜单视觉样式
    var menuAppearance: MenuAppearance { .plain }

    /// 子类覆盖，为卡片样式提供副标题
    func menuSubtitle(at index: Int) -> String? { nil }

    // MARK: - Private

    public let tableView = UITableView(frame: .zero, style: .plain)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = menuAppearance == .card
            ? UIColor(red: 0.95, green: 0.95, blue: 0.98, alpha: 1.0)
            : .white
        setupSDK()
        setupTableView()
    }

    // MARK: - Layout

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MenuCell")
        tableView.register(MenuCardCell.self, forCellReuseIdentifier: MenuCardCell.reuseID)
        tableView.tableFooterView = UIView()
        applyMenuAppearance()
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func applyMenuAppearance() {
        switch menuAppearance {
        case .plain:
            tableView.backgroundColor = .white
            tableView.separatorStyle = .singleLine
            tableView.showsVerticalScrollIndicator = true
            tableView.contentInset = .zero
            tableView.estimatedRowHeight = 54
            tableView.rowHeight = 54
            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0
            }
        case .card:
            tableView.backgroundColor = view.backgroundColor
            tableView.separatorStyle = .none
            tableView.showsVerticalScrollIndicator = false
            tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 18, right: 0)
            tableView.estimatedRowHeight = 92
            tableView.rowHeight = UITableView.automaticDimension
            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension BaseMenuVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if menuAppearance == .card {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MenuCardCell.reuseID,
                for: indexPath
            ) as? MenuCardCell else {
                return UITableViewCell()
            }
            let item = menuItems[indexPath.row]
            cell.configure(
                title: item.title,
                subtitle: menuSubtitle(at: indexPath.row) ?? ""
            )
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
            cell.textLabel?.text = menuItems[indexPath.row].title
            cell.textLabel?.font = .systemFont(ofSize: 16, weight: .regular)
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension BaseMenuVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        menuAppearance == .card ? UITableView.automaticDimension : 54
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        menuAppearance == .card ? 92 : 54
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = menuItems[indexPath.row].makeVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}

final class MenuCardCell: UITableViewCell {
    static let reuseID = "MenuCardCell"

    private let cardView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let chevronImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        let scale: CGFloat = highlighted ? 0.985 : 1.0
        let alpha: CGFloat = highlighted ? 0.82 : 1.0
        UIView.animate(withDuration: animated ? 0.15 : 0) {
            self.cardView.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.cardView.alpha = alpha
        }
    }

    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 18

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = UIColor(red: 0.12, green: 0.13, blue: 0.20, alpha: 1)
        titleLabel.numberOfLines = 1

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = .systemFont(ofSize: 13, weight: .regular)
        subtitleLabel.textColor = UIColor(red: 0.56, green: 0.57, blue: 0.64, alpha: 1)
        subtitleLabel.numberOfLines = 2

        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.tintColor = UIColor(red: 0.78, green: 0.79, blue: 0.84, alpha: 1)

        contentView.addSubview(cardView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(subtitleLabel)
        cardView.addSubview(chevronImageView)

        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: chevronImageView.leadingAnchor, constant: -12),

            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: chevronImageView.leadingAnchor, constant: -12),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subtitleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -14),

            chevronImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 14),
            chevronImageView.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
}
