//
//  AdmobAdsMainListVC.swift
//  RixAdsSDKDemo
//
//  Created by YXk on 2026/8/30.
//

import UIKit

class AdmobAdsMainListVC: BasicUIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        navigationItem.title = NSLocalizedString("admob_ad", comment: "")

        setupNoticeView()
    }

    private func setupNoticeView() {
        let cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowOpacity = 0.08
        cardView.layer.shadowRadius = 8
        view.addSubview(cardView)

        let iconLabel = UILabel()
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        iconLabel.text = "ℹ️"
        iconLabel.font = .systemFont(ofSize: 44)
        iconLabel.textAlignment = .center
        cardView.addSubview(iconLabel)

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "CocoaPods / Manual Integration"
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .darkText
        titleLabel.textAlignment = .center
        cardView.addSubview(titleLabel)

        let descLabel = UILabel()
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.numberOfLines = 0
        descLabel.font = .systemFont(ofSize: 15, weight: .regular)
        descLabel.textColor = .darkGray
        descLabel.textAlignment = .center
        descLabel.text = """
To comply with the minimal external dependency principle, third-party ad network SDKs and mediation adapters are decoupled from SPM distribution.

To test AdMob mediation formats, please run the CocoaPods demo project in this workspace:

AlxAdsDemo / RixEngineObjcDemo
(Examples/RixEngineDemos.xcworkspace)
"""
        cardView.addSubview(descLabel)

        let tipLabel = UILabel()
        tipLabel.translatesAutoresizingMaskIntoConstraints = false
        tipLabel.numberOfLines = 0
        tipLabel.font = .systemFont(ofSize: 13, weight: .medium)
        tipLabel.textColor = UIColor(red: 33/255, green: 78/255, blue: 243/255, alpha: 1)
        tipLabel.textAlignment = .center
        tipLabel.text = "Sources/custom_adapter/AdmobAdapter"
        cardView.addSubview(tipLabel)

        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),

            iconLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 32),
            iconLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),

            titleLabel.topAnchor.constraint(equalTo: iconLabel.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -20),

            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            descLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),

            tipLabel.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 20),
            tipLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 24),
            tipLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -24),
            tipLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -32),
        ])
    }
}
