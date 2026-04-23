//
//  MainVC.swift
//  AlxDemo
//
//  Created by liu weile on 2025/3/31.
//

import UIKit
import AppTrackingTransparency
import AdSupport

class MainVC: BaseMenuVC {

    private struct MainMenuItem {
        let title: String
        let subtitle: String
        let makeVC: () -> UIViewController
    }

    override var menuItems: [MenuItem] { [] }

    private var items: [MainMenuItem] {
        [
            MainMenuItem(
                title: NSLocalizedString("Alx_ad", comment: ""),
                subtitle: "Direct integration with RixEngine ad serving.",
                makeVC: { AlxMainVC() }
            ),
            MainMenuItem(
                title: NSLocalizedString("admob_ad", comment: ""),
                subtitle: "Google AdMob mediation integration.",
                makeVC: { AdmobMainVC() }
            ),
            MainMenuItem(
                title: NSLocalizedString("max_ad", comment: ""),
                subtitle: "AppLovin MAX mediation integration.",
                makeVC: { MaxMainVC() }
            ),
            MainMenuItem(
                title: NSLocalizedString("topOn_ad", comment: ""),
                subtitle: "TopOn mediation integration.",
                makeVC: { TopOnMainVC() }
            ),
            MainMenuItem(
                title: NSLocalizedString("levelPlay_ad", comment: ""),
                subtitle: "ironSource LevelPlay mediation integration.",
                makeVC: { LevelPlayMainVC() }
            )
        ]
    }

    private var lastHeaderWidth: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = nil
        configureMainListAppearance()
        setupTopHeaderView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let currentWidth = tableView.bounds.width
        guard currentWidth > 0, abs(currentWidth - lastHeaderWidth) > 0.5 else { return }
        lastHeaderWidth = currentWidth
        setupTopHeaderView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.requestATTPermission()
        }
    }
    
    private func configureMainListAppearance() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.98, alpha: 1.0)
        tableView.backgroundColor = view.backgroundColor
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 24, right: 0)
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(MainMenuCardCell.self, forCellReuseIdentifier: MainMenuCardCell.reuseID)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }

    private func setupTopHeaderView() {
        let horizontalInset: CGFloat = 24
        let container = UIView()
        container.backgroundColor = .clear

        let iconWrap = UIView()
        iconWrap.backgroundColor = UIColor(red: 0.90, green: 0.92, blue: 0.98, alpha: 1)
        iconWrap.layer.cornerRadius = 22
        iconWrap.translatesAutoresizingMaskIntoConstraints = false

        let iconImage = UIImageView()
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        iconImage.contentMode = .scaleAspectFill
        iconImage.layer.cornerRadius = 18
        iconImage.clipsToBounds = true
        iconImage.image = UIImage(named: "appLogo")
        iconWrap.addSubview(iconImage)

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "SDK Demo"
        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.10, green: 0.11, blue: 0.20, alpha: 1)

        let versionLabel = UILabel()
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        versionLabel.text = appVersionText()
        versionLabel.font = .systemFont(ofSize: 13, weight: .medium)
        versionLabel.textColor = UIColor(red: 0.55, green: 0.56, blue: 0.63, alpha: 1)

        let swiftIcon = UIImageView(image: UIImage(systemName: "swift"))
        swiftIcon.translatesAutoresizingMaskIntoConstraints = false
        swiftIcon.tintColor = UIColor(red: 0.98, green: 0.38, blue: 0.14, alpha: 1)
        swiftIcon.contentMode = .scaleAspectFit

        let swiftLabel = UILabel()
        swiftLabel.translatesAutoresizingMaskIntoConstraints = false
        swiftLabel.text = "Swift"
        swiftLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        swiftLabel.textColor = UIColor(red: 0.55, green: 0.56, blue: 0.63, alpha: 1)

        let idfaLabel = UILabel()
        idfaLabel.translatesAutoresizingMaskIntoConstraints = false
        idfaLabel.text = "IDFA:\(ASIdentifierManager.shared().advertisingIdentifier.uuidString)"
        idfaLabel.font = .systemFont(ofSize: 12, weight: .regular)
        idfaLabel.textColor = UIColor(red: 0.64, green: 0.66, blue: 0.74, alpha: 1)
        idfaLabel.numberOfLines = 2

        let titleStack = UIStackView(arrangedSubviews: [titleLabel, versionLabel, swiftIcon, swiftLabel])
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        titleStack.axis = .horizontal
        titleStack.alignment = .center
        titleStack.spacing = 8
        titleStack.setCustomSpacing(12, after: titleLabel)
        titleStack.setCustomSpacing(3, after: swiftIcon)

        container.addSubview(iconWrap)
        container.addSubview(titleStack)
        container.addSubview(idfaLabel)

        let idfaTopPreferred = idfaLabel.topAnchor.constraint(equalTo: iconWrap.bottomAnchor, constant: 14)
        idfaTopPreferred.priority = .defaultHigh
        let idfaBottomPreferred = idfaLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8)
        idfaBottomPreferred.priority = .defaultHigh

        NSLayoutConstraint.activate([
            iconWrap.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: horizontalInset),
            iconWrap.topAnchor.constraint(equalTo: container.topAnchor, constant: 6),
            iconWrap.widthAnchor.constraint(equalToConstant: 44),
            iconWrap.heightAnchor.constraint(equalToConstant: 44),

            iconImage.centerXAnchor.constraint(equalTo: iconWrap.centerXAnchor),
            iconImage.centerYAnchor.constraint(equalTo: iconWrap.centerYAnchor),
            iconImage.widthAnchor.constraint(equalToConstant: 36),
            iconImage.heightAnchor.constraint(equalToConstant: 36),

            titleStack.leadingAnchor.constraint(equalTo: iconWrap.trailingAnchor, constant: 10),
            titleStack.centerYAnchor.constraint(equalTo: iconWrap.centerYAnchor),
            titleStack.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -horizontalInset),

            swiftIcon.widthAnchor.constraint(equalToConstant: 14),
            swiftIcon.heightAnchor.constraint(equalToConstant: 14),

            idfaLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: horizontalInset),
            idfaLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -horizontalInset),
            idfaLabel.topAnchor.constraint(greaterThanOrEqualTo: iconWrap.bottomAnchor, constant: 14),
            idfaTopPreferred,
            idfaLabel.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -8),
            idfaBottomPreferred
        ])

        let fittingWidth = tableView.bounds.width
        guard fittingWidth > 0 else { return }
        let textWidth = max(0, fittingWidth - (horizontalInset * 2))
        let idfaHeight = ceil(idfaLabel.sizeThatFits(
            CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude)
        ).height)
        let headerHeight = 6 + 44 + 14 + idfaHeight + 8
        container.frame = CGRect(x: 0, y: 0, width: fittingWidth, height: headerHeight)
        tableView.tableHeaderView = container
    }

    private func appVersionText() -> String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    // MARK: - ATT

    private func requestATTPermission() {
        if #available(iOS 14, *) {
            print("requestATTPermission")
            ATTrackingManager.requestTrackingAuthorization { status in
                UserDefaults.standard.set(true, forKey: "hasRequestedTrackingAuthorization")

                switch status {
                case .authorized:   print("Authorized")
                case .denied:       print("Denied")
                case .notDetermined:print("Not Determined")
                case .restricted:   print("Restricted")
                @unknown default:   print("Unknown")
                }
                let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                print("idfa:", idfa)
            }
        } else {
            let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            print("idfa:", idfa)
        }
    }

    // MARK: - Debug

    private func lookAppCacheDir() {
        let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        print("缓存目录路径：\(cacheURL)")
    }
}

// MARK: - UITableViewDataSource / UITableViewDelegate

extension MainVC {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        88
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let container = UIView()
        container.backgroundColor = .clear

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ad Platforms"
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = UIColor(red: 0.46, green: 0.47, blue: 0.55, alpha: 1)
        container.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -24),
            label.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -8),
            label.topAnchor.constraint(greaterThanOrEqualTo: container.topAnchor, constant: 6),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        return container
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        34
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MainMenuCardCell.reuseID,
            for: indexPath
        ) as? MainMenuCardCell else {
            return UITableViewCell()
        }

        let item = items[indexPath.row]
        cell.configure(title: item.title, subtitle: item.subtitle)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        navigationController?.pushViewController(item.makeVC(), animated: true)
    }
}

final class MainMenuCardCell: UITableViewCell {
    static let reuseID = "MainMenuCardCell"

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
        let scale: CGFloat = highlighted ? 0.98 : 1.0
        let alpha: CGFloat = highlighted ? 0.78 : 1.0
        UIView.animate(withDuration: animated ? 0.15 : 0) {
            self.cardView.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.cardView.alpha = alpha
        }
    }

    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        chevronImageView.tintColor = UIColor(red: 0.78, green: 0.79, blue: 0.84, alpha: 1)
        titleLabel.textColor = UIColor(red: 0.12, green: 0.13, blue: 0.20, alpha: 1)
    }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 18
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.02
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 8

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

        let cardBottom = cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        cardBottom.priority = .defaultHigh
        let subtitleBottom = subtitleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -14)
        subtitleBottom.priority = .defaultHigh

        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardBottom,

            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: chevronImageView.leadingAnchor, constant: -12),

            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: chevronImageView.leadingAnchor, constant: -12),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subtitleBottom,

            chevronImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 14),
            chevronImageView.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
}
