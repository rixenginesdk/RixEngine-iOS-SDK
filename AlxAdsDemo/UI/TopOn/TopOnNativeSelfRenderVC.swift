//
//  TopOnNativeRenderVC.swift
//  AlxAdsDemo
//
//  Created by liu weile on 2025/8/26.
//

import Foundation
import UIKit
import AnyThinkSDK
import AnyThinkNative

class TopOnNativeSelfRenderVC: BaseUIViewController {
    
    private let TAG = "TopOn-native-selfRender:"
    
    private var label:UILabel!

    private var isLoading:Bool=false
    
    private var adContainer:UIView!

    private var adView:ATNativeADView?
    private var selfRenderView:TopOnSelfRenderView?
    private var nativeAdOffer:ATNativeAdOffer?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.title=NSLocalizedString("topOn_native_self_render", comment: "")

        let scrollView=UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(scrollView)
        scrollView.isScrollEnabled=true
        
        let contentView=UIStackView()
        contentView.translatesAutoresizingMaskIntoConstraints=false
        scrollView.addSubview(contentView)
        contentView.axis = .vertical
        contentView.spacing = 20
        
        let bnLoad=createButton(title: NSLocalizedString("load_ad", comment: ""),  action: #selector(buttonLoad))
        contentView.addArrangedSubview(bnLoad)
        
        label=createLabel()
        contentView.addArrangedSubview(label)
        
        adContainer=UIView()
        adContainer.translatesAutoresizingMaskIntoConstraints=false
        contentView.addArrangedSubview(adContainer)
//        adContainer.backgroundColor = .red
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor,constant: 20),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            bnLoad.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bnLoad.heightAnchor.constraint(equalToConstant: 50),
            
            label.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            label.heightAnchor.constraint(equalToConstant: 50),
            
            adContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            adContainer.heightAnchor.constraint(equalToConstant: 500),
        ])
    }
    
    
    @objc func buttonLoad(){
        print("bnLoad")
        if isLoading {
            return
        }

        updateUI(true, NSLocalizedString("loading", comment: ""))

        loadAd()
    }
    
    func updateUI(_ loading:Bool,_ msg:String){
        self.isLoading=loading
        self.label.text=msg
    }
    
    func loadAd() {
        var extra:[String:Any] = [:]
        extra[kATAdLoadingExtraMediaExtraKey]="media_val_NativeVC"
        extra[kATExtraInfoNativeAdSizeKey] = CGSize(width: adContainer.frame.size.width, height: 350)
        
        ATAdManager.shared().loadAD(withPlacementID: AdConfig.TopOn_Native_Ad_Id, extra: extra, delegate: self)
    }
    
    func showAd(){
        if ATAdManager.shared().nativeAdReady(forPlacementID: AdConfig.TopOn_Native_Ad_Id) {
            renderAdUI()
        }else{
            updateUI(false, "showAd: Ad wasn't ready")
            print("\(TAG) Ad wasn't ready")
        }
    }
    
    func renderAdUI(){
        // 初始化config 配置
        let config:ATNativeADConfiguration = ATNativeADConfiguration()
        // 给原生广告进行预布局
        config.adFrame=CGRect(x: 0, y: 0, width: adContainer.frame.size.width, height: 350)
        // 给视频播放器进行预布局，建议在后面添加到自定义视图后，再次进行一次布局
        config.mediaViewFrame=CGRect(x: 0, y: 0, width: adContainer.frame.size.width, height: 100)
        config.delegate = self
        config.rootViewController = self
        config.sizeToFit=true        
        config.logoViewFrame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        // 获取offer广告对象,获取后消耗一条广告缓存
        self.nativeAdOffer = ATAdManager.shared().getNativeAdOffer(withPlacementID: AdConfig.TopOn_Native_Ad_Id)
        guard let offer = self.nativeAdOffer else {
            print("offer is empty")
            return
        }
        
        // 创建广告自渲染视图
        let selfRenderView=TopOnSelfRenderView()
//        selfRenderView.translatesAutoresizingMaskIntoConstraints=false // selfRenderView 放进 ATNativeADView中，不需要设置约束。否则会影响广告渲染
        selfRenderView.setData(offer: offer)
        self.selfRenderView = selfRenderView
        
        // 创建广告nativeADView
        let nativeAdView = ATNativeADView(configuration: config, currentOffer: offer, placementID: AdConfig.TopOn_Native_Ad_Id)
        nativeAdView.translatesAutoresizingMaskIntoConstraints=false
        
        // 获取mediaView，需要自行添加到自渲染视图上，必须调用
        let mediaView = nativeAdView.getMediaView()
        if let mediaView = mediaView {
            print("mediaView exists")
            selfRenderView.mediaView = mediaView
        }
        
        // 创建可点击组件数组
        var clickableViewArray: [UIView] = [
            selfRenderView.iconImageView,
            selfRenderView.titleLabel,
            selfRenderView.logoImageView,
            selfRenderView.textLabel,
            selfRenderView.ctaLabel
        ]
        if let mediaView = selfRenderView.mediaView {
            clickableViewArray.append(mediaView)
        }
        // 注册可点击视图（不要包含父容器或关闭按钮）
        nativeAdView.registerClickableViewArray(clickableViewArray)

        // 绑定 UI 组件到 prepareInfo
        let info = ATNativePrepareInfo.load { prepareInfo in
            prepareInfo.textLabel = selfRenderView.textLabel
            prepareInfo.advertiserLabel = selfRenderView.advertiserLabel
            prepareInfo.titleLabel = selfRenderView.titleLabel
//            prepareInfo.ratingLabel = selfRenderView.ratingLabel
            prepareInfo.iconImageView = selfRenderView.iconImageView
            prepareInfo.mainImageView = selfRenderView.mainImageView
            prepareInfo.logoImageView = selfRenderView.logoImageView
            prepareInfo.ctaLabel = selfRenderView.ctaLabel
//            prepareInfo.dislikeButton = selfRenderView.dislikeButton
            
            if let mediaView = selfRenderView.mediaView {
                prepareInfo.mediaView = mediaView
            }
            
        }
        nativeAdView.prepare(with: info)
        
        //渲染广告
        offer.renderer(with: config, selfRenderView: selfRenderView, nativeADView: nativeAdView)
        self.adView = nativeAdView
        
        self.clearSubView(self.adContainer)
        self.adContainer.addSubview(nativeAdView)
        NSLayoutConstraint.activate([
            nativeAdView.widthAnchor.constraint(equalTo: self.adContainer.widthAnchor),
            nativeAdView.heightAnchor.constraint(equalTo: self.adContainer.heightAnchor),
        ])
    }
    
}

extension TopOnNativeSelfRenderVC:ATAdLoadingDelegate{
    
    func didFinishLoadingAD(withPlacementID placementID: String) {
        print("\(TAG) didFinishLoadingAD")
        updateUI(false, NSLocalizedString("load_success", comment: ""))
        showAd()
    }
    
    func didFailToLoadAD(withPlacementID placementID: String, error: (any Error)) {
        let msg="\(error.code): \(error.localizedDescription)"
        print("\(TAG) didFailToLoadAD: \(msg)")
        updateUI(false, String(format: NSLocalizedString("load_failed", comment: ""), msg))
    }
    
}

extension TopOnNativeSelfRenderVC:ATNativeADDelegate {
    func didShowNativeAd(in adView: ATNativeADView, placementID: String, extra: [AnyHashable : Any]) {
        print("\(TAG) didShowNativeAd: impression")
    }
    
    func didClickNativeAd(in adView: ATNativeADView, placementID: String, extra: [AnyHashable : Any]) {
        print("\(TAG) didClickNativeAd: click")
    }
    
    func didTapCloseButton(in adView: ATNativeADView, placementID: String, extra: [AnyHashable : Any]) {
        print("\(TAG) didTapCloseButton: close")
    }
    
}
