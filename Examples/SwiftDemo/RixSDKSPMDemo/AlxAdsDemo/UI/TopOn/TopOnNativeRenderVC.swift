//
//  TopOnNativeRenderVC.swift
//  AlxAdsDemo
//

//import UIKit
//import AnyThinkSDK
//
//final class TopOnNativeRenderVC: BaseUIViewController {
//    private let nativeAdOffer: ATNativeAdOffer
//    private let placementId: String
//
//    private var adContainer: UIView!
//    private var adView: ATNativeADView?
//
//    init(nativeAdOffer: ATNativeAdOffer, placementId: String) {
//        self.nativeAdOffer = nativeAdOffer
//        self.placementId = placementId
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    deinit {
//        destroyAd()
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        navigationItem.title = NSLocalizedString("topOn_native", comment: "")
//        setupUI()
//        renderAdUI()
//    }
//
//    private func setupUI() {
//        let scrollView = UIScrollView()
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(scrollView)
//
//        let contentView = UIView()
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.addSubview(contentView)
//
//        adContainer = UIView()
//        adContainer.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(adContainer)
//
//        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//
//            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
//            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
//            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
//            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
//            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
//
//            adContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
//            adContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            adContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            adContainer.heightAnchor.constraint(equalToConstant: 380),
//            adContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
//        ])
//    }
//
//    private func renderAdUI() {
//        let config = ATNativeADConfiguration()
//        config.adFrame = CGRect(x: 0, y: 0, width: max(view.bounds.width - 32, 280), height: 350)
//        config.delegate = self
//        config.rootViewController = self
//        config.sizeToFit = true
//
//        let nativeAdView = ATNativeADView(configuration: config, currentOffer: nativeAdOffer, placementID: placementId)
//        nativeAdView.translatesAutoresizingMaskIntoConstraints = false
//        nativeAdOffer.renderer(with: config, selfRenderView: nil, nativeADView: nativeAdView)
//        adView = nativeAdView
//
//        clearSubView(adContainer)
//        adContainer.addSubview(nativeAdView)
//        NSLayoutConstraint.activate([
//            nativeAdView.leadingAnchor.constraint(equalTo: adContainer.leadingAnchor),
//            nativeAdView.trailingAnchor.constraint(equalTo: adContainer.trailingAnchor),
//            nativeAdView.topAnchor.constraint(equalTo: adContainer.topAnchor),
//            nativeAdView.bottomAnchor.constraint(equalTo: adContainer.bottomAnchor),
//        ])
//    }
//
//    private func destroyAd() {
//        if adView?.superview != nil {
//            adView?.removeFromSuperview()
//        }
//        adView?.destroyNative()
//        adView = nil
//    }
//}
//
//extension TopOnNativeRenderVC: ATNativeADDelegate {
//    func didFinishLoadingAD(withPlacementID placementID: String!) {
//        print("TopOn-native:template: didFinishLoadingAD")
//    }
//    
//    func didFailToLoadAD(withPlacementID placementID: String!, error: (any Error)!) {
//        print("TopOn-native:template: didFailToLoadAD")
//    }
//    
//    func didShowNativeAd(in adView: ATNativeADView, placementID: String, extra: [AnyHashable: Any]) {
//        print("TopOn-native:template: didShowNativeAd")
//    }
//
//    func didClickNativeAd(in adView: ATNativeADView, placementID: String, extra: [AnyHashable: Any]) {
//        print("TopOn-native:template: didClickNativeAd")
//    }
//
//    func didTapCloseButton(in adView: ATNativeADView, placementID: String, extra: [AnyHashable: Any]) {
//        print("TopOn-native:template: didTapCloseButton")
//        destroyAd()
//    }
//}
