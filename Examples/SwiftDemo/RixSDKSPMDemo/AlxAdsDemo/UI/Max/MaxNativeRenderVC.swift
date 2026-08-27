//
//  MaxNativeRenderVC.swift
//  AlxAdsDemo
//

import UIKit
import AppLovinSDK

final class MaxNativeRenderVC: UIViewController {
    private let nativeAdView: MANativeAdView
    private var adContainer: UIView!

    init(nativeAdView: MANativeAdView) {
        self.nativeAdView = nativeAdView
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = NSLocalizedString("max_native", comment: "")
        setupUI()
        showNativeAdView()
    }

    private func setupUI() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        adContainer = UIView()
        adContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(adContainer)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            adContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            adContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            adContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            adContainer.heightAnchor.constraint(equalToConstant: 420),
            adContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    private func showNativeAdView() {
        nativeAdView.removeFromSuperview()
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false
        adContainer.addSubview(nativeAdView)
        NSLayoutConstraint.activate([
            nativeAdView.topAnchor.constraint(equalTo: adContainer.topAnchor),
            nativeAdView.leadingAnchor.constraint(equalTo: adContainer.leadingAnchor),
            nativeAdView.trailingAnchor.constraint(equalTo: adContainer.trailingAnchor),
            nativeAdView.bottomAnchor.constraint(equalTo: adContainer.bottomAnchor),
        ])
    }
}
