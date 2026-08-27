//
//  AlxNativeRenderVC.swift
//  AlxDemo
//
//  Created by Cursor on 2026/5/29.
//

import UIKit
import AlxAds

final class AlxNativeRenderVC: BaseUIViewController {
    private let TAG = "Alx-native-render:"
    private let nativeAd: AlxNativeAd
    private var adContainer: UIView!
    var onEvent: ((String) -> Void)?

    init(nativeAd: AlxNativeAd) {
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
        navigationItem.title = NSLocalizedString("alx_native_render", comment: "")
        setupUI()
        renderAdUI()
    }

    private func setupUI() {
        let layout = installScrollableContentStack(in: view, spacing: 16, horizontalInset: 16, bottomInset: 16)

        adContainer = UIView()
        adContainer.translatesAutoresizingMaskIntoConstraints = false
        adContainer.backgroundColor = .white
        adContainer.layer.cornerRadius = 12
        adContainer.layer.masksToBounds = true

        layout.contentStack.addArrangedSubview(adContainer)

        NSLayoutConstraint.activate([
            adContainer.heightAnchor.constraint(equalToConstant: 500)
        ])
    }

    private func renderAdUI() {
        let rootView = UIView()
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

        let mediaView = AlxMediaView()
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        rootView.addSubview(mediaView)

        let descView = createLabel()
        rootView.addSubview(descView)
        descView.textAlignment = .left

        let bottomRootView = UIView()
        bottomRootView.translatesAutoresizingMaskIntoConstraints = false
        rootView.addSubview(bottomRootView)

        let adFlagContainer = UIStackView()
        adFlagContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomRootView.addSubview(adFlagContainer)
        adFlagContainer.axis = .horizontal
        adFlagContainer.backgroundColor = UIColor(red: 169/255, green: 166/255, blue: 166/255, alpha: 71/100)
        adFlagContainer.spacing = 4
        adFlagContainer.isLayoutMarginsRelativeArrangement = true
        adFlagContainer.layoutMargins = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)

        let adTagView = createLabel()
        adTagView.textColor = .white
        adTagView.font = .systemFont(ofSize: 14)
        adFlagContainer.addArrangedSubview(adTagView)

        let adLogoView = UIImageView()
        adLogoView.translatesAutoresizingMaskIntoConstraints = false
        adFlagContainer.addArrangedSubview(adLogoView)

        let adSourceView = createLabel()
        bottomRootView.addSubview(adSourceView)

        let callToActionView = createLabel()
        bottomRootView.addSubview(callToActionView)
        callToActionView.backgroundColor = UIColor(red: 33/255, green: 78/255, blue: 243/255, alpha: 1)
        callToActionView.layer.cornerRadius = 10
        callToActionView.textColor = .white
        callToActionView.textAlignment = .center

        let closeView = UIImageView(image: UIImage(named: "ic_close"))
        closeView.translatesAutoresizingMaskIntoConstraints = false
        bottomRootView.addSubview(closeView)

        clearSubView(adContainer)
        adContainer.addSubview(rootView)

        NSLayoutConstraint.activate([
            rootView.leadingAnchor.constraint(equalTo: adContainer.leadingAnchor),
            rootView.trailingAnchor.constraint(equalTo: adContainer.trailingAnchor),
            rootView.topAnchor.constraint(equalTo: adContainer.topAnchor),
            rootView.bottomAnchor.constraint(equalTo: adContainer.bottomAnchor),

            topRootView.leftAnchor.constraint(equalTo: rootView.leftAnchor),
            topRootView.rightAnchor.constraint(equalTo: rootView.rightAnchor),
            topRootView.topAnchor.constraint(equalTo: rootView.topAnchor),
            topRootView.heightAnchor.constraint(equalToConstant: 50),

            iconView.leftAnchor.constraint(equalTo: topRootView.leftAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 50),
            iconView.heightAnchor.constraint(equalToConstant: 50),

            titleView.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 10),
            titleView.rightAnchor.constraint(equalTo: topRootView.rightAnchor),
            titleView.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),

            mediaView.topAnchor.constraint(equalTo: topRootView.bottomAnchor, constant: 10),
            mediaView.widthAnchor.constraint(equalTo: rootView.widthAnchor),
            mediaView.heightAnchor.constraint(equalToConstant: 200),

            descView.leftAnchor.constraint(equalTo: rootView.leftAnchor),
            descView.rightAnchor.constraint(equalTo: rootView.rightAnchor),
            descView.topAnchor.constraint(equalTo: mediaView.bottomAnchor, constant: 10),

            bottomRootView.leftAnchor.constraint(equalTo: rootView.leftAnchor),
            bottomRootView.rightAnchor.constraint(equalTo: rootView.rightAnchor),
            bottomRootView.topAnchor.constraint(equalTo: descView.bottomAnchor),
            bottomRootView.heightAnchor.constraint(equalToConstant: 50),

            adFlagContainer.leadingAnchor.constraint(equalTo: bottomRootView.leadingAnchor, constant: 5),
            adFlagContainer.centerYAnchor.constraint(equalTo: bottomRootView.centerYAnchor),

            adLogoView.widthAnchor.constraint(equalToConstant: 10),
            adLogoView.heightAnchor.constraint(equalToConstant: 10),

            adSourceView.leadingAnchor.constraint(equalTo: adFlagContainer.trailingAnchor, constant: 10),
            adSourceView.centerYAnchor.constraint(equalTo: bottomRootView.centerYAnchor),
            adSourceView.heightAnchor.constraint(equalToConstant: 20),

            closeView.rightAnchor.constraint(equalTo: bottomRootView.rightAnchor),
            closeView.centerYAnchor.constraint(equalTo: bottomRootView.centerYAnchor),
            closeView.widthAnchor.constraint(equalToConstant: 20),
            closeView.heightAnchor.constraint(equalToConstant: 20),

            callToActionView.rightAnchor.constraint(equalTo: closeView.leftAnchor, constant: -10),
            callToActionView.centerYAnchor.constraint(equalTo: bottomRootView.centerYAnchor),
            callToActionView.widthAnchor.constraint(equalToConstant: 70),
            callToActionView.heightAnchor.constraint(equalToConstant: 30)
        ])

        adTagView.text = "AD"
        adLogoView.image = nativeAd.adLogo
        titleView.text = nativeAd.title
        descView.text = nativeAd.desc
        adSourceView.text = nativeAd.adSource
        callToActionView.text = nativeAd.callToAction

        if let url = nativeAd.icon?.url {
            iconView.loadUrl(url)
        }
        mediaView.setMediaContent(nativeAd.mediaContent)

        nativeAd.delegate = self
        nativeAd.rootViewController = self
        nativeAd.registerView(container: rootView, clickableViews: [titleView, iconView, mediaView, callToActionView], closeView: closeView)
        onEvent?("\(TAG) render native ad success")
    }

    private func closeAd() {
        clearSubView(adContainer)
        onEvent?("\(TAG) close ad view")
    }
}

extension AlxNativeRenderVC: AlxNativeAdDelegate {
    func nativeAdImpression(_ nativeAd: AlxNativeAd) {
        onEvent?("\(TAG) nativeAdImpression")
    }

    func nativeAdClick(_ nativeAd: AlxNativeAd) {
        onEvent?("\(TAG) nativeAdClick")
    }

    func nativeAdClose(_ nativeAd: AlxNativeAd) {
        onEvent?("\(TAG) nativeAdClose")
        closeAd()
    }
}
