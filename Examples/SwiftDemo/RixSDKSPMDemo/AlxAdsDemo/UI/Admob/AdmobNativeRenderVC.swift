//
//  AdmobNativeRenderVC.swift
//  AlxAdsDemo
//

import UIKit
import GoogleMobileAds

final class AdmobNativeRenderVC: BaseUIViewController {
    private let nativeAd: NativeAd
    private var adContainer: UIView!

    init(nativeAd: NativeAd) {
        self.nativeAd = nativeAd
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = NSLocalizedString("admob_native", comment: "")
        setupUI()
        renderAdUI()
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

    private func renderAdUI() {
        let rootView = NativeAdView()
        rootView.translatesAutoresizingMaskIntoConstraints = false

        let topRootView = UIView()
        topRootView.translatesAutoresizingMaskIntoConstraints = false
        rootView.addSubview(topRootView)

        let iconView = UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        topRootView.addSubview(iconView)

        let titleView = createLabel()
        topRootView.addSubview(titleView)
        titleView.textAlignment = .left

        let mediaView = MediaView()
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        rootView.addSubview(mediaView)

        let descView = createLabel()
        rootView.addSubview(descView)
        descView.textAlignment = .left

        let advertiserView = createLabel()
        advertiserView.backgroundColor = .gray
        rootView.addSubview(advertiserView)

        let callToActionView = createLabel()
        callToActionView.backgroundColor = .gray
        rootView.addSubview(callToActionView)

        rootView.headlineView = titleView
        rootView.bodyView = descView
        rootView.iconView = iconView
        rootView.mediaView = mediaView
        rootView.callToActionView = callToActionView
        rootView.advertiserView = advertiserView

        rootView.mediaView?.contentMode = .scaleAspectFill
        rootView.callToActionView?.isUserInteractionEnabled = false

        clearSubView(adContainer)
        adContainer.addSubview(rootView)

        NSLayoutConstraint.activate([
            rootView.leadingAnchor.constraint(equalTo: adContainer.leadingAnchor),
            rootView.trailingAnchor.constraint(equalTo: adContainer.trailingAnchor),
            rootView.topAnchor.constraint(equalTo: adContainer.topAnchor),
            rootView.bottomAnchor.constraint(equalTo: adContainer.bottomAnchor),

            topRootView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
            topRootView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
            topRootView.topAnchor.constraint(equalTo: rootView.topAnchor),
            topRootView.heightAnchor.constraint(equalToConstant: 50),

            iconView.leadingAnchor.constraint(equalTo: topRootView.leadingAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 50),
            iconView.heightAnchor.constraint(equalToConstant: 50),

            titleView.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
            titleView.trailingAnchor.constraint(equalTo: topRootView.trailingAnchor),
            titleView.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),

            mediaView.topAnchor.constraint(equalTo: topRootView.bottomAnchor, constant: 10),
            mediaView.widthAnchor.constraint(equalTo: rootView.widthAnchor),
            mediaView.heightAnchor.constraint(equalToConstant: 200),

            descView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
            descView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
            descView.topAnchor.constraint(equalTo: mediaView.bottomAnchor, constant: 10),

            advertiserView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor, constant: 10),
            advertiserView.topAnchor.constraint(equalTo: descView.bottomAnchor, constant: 10),

            callToActionView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
            callToActionView.topAnchor.constraint(equalTo: descView.bottomAnchor, constant: 10),
        ])

        titleView.text = nativeAd.headline
        descView.text = nativeAd.body
        advertiserView.text = nativeAd.advertiser
        callToActionView.text = nativeAd.callToAction
        mediaView.mediaContent = nativeAd.mediaContent

        if let image = nativeAd.icon?.image {
            iconView.image = image
        } else if let url = nativeAd.icon?.imageURL {
            iconView.loadUrl(url.absoluteString)
        }

        rootView.nativeAd = nativeAd
    }
}
