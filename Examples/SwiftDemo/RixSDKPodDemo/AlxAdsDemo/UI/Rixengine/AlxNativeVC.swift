//
//  AlxNativeVC.swift
//  AlxDemo
//
//  Created by liu weile on 2025/3/31.
//

import UIKit
import AlxAds

class AlxNativeVC: BaseUIViewController {
    
    private let TAG = "Alx-native:"
    
    private var label:UILabel!
    
    private var isLoading:Bool=false
    private var adContainer:UIView!
    
    //注意获取到的nativeAd对象需要全局属性设置。如果是func方法声明的nativeAd属性对象，func调用结束后nativeAd会被系统自动回收
    private var nativeAd:AlxNativeAd?=nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title=NSLocalizedString("native_ad", comment: "")
        
        let scrollView=UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(scrollView)
        scrollView.isScrollEnabled=true
        
        let contentView=UIStackView()
        contentView.translatesAutoresizingMaskIntoConstraints=false
        scrollView.addSubview(contentView)
        contentView.axis = .vertical
        contentView.spacing = 20
        
        let bnLoad=createButton(title: NSLocalizedString("load_ad", comment: ""),  action: #selector(loadAd))
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
    
    @objc func loadAd(){
        print("load ad")
        if isLoading {
            return
        }

        isLoading=true
        label.text=NSLocalizedString("loading", comment: "")

        let loader=AlxNativeAdLoader(adUnitID: AdConfig.Alx_Native_Ad_Id)
        loader.delegate = self
        loader.loadAd()
    }
    
    func showNativeAd(nativeAd:AlxNativeAd){
        self.nativeAd = nativeAd
        createTemplateView()
    }
    
    
    
    private func createTemplateView(){
        guard let nativeAd = self.nativeAd else{
            return
        }
        let rootView=UIView()
        rootView.translatesAutoresizingMaskIntoConstraints=false
        
        let topRootView=UIView()
        topRootView.translatesAutoresizingMaskIntoConstraints=false
        rootView.addSubview(topRootView)
        
        let iconView=UIImageView()
        iconView.translatesAutoresizingMaskIntoConstraints=false
        topRootView.addSubview(iconView)
        
        let titleView=createLabel()
        topRootView.addSubview(titleView)
        titleView.textAlignment = .left
        
        let mediaView=AlxMediaView()
        mediaView.translatesAutoresizingMaskIntoConstraints=false
        rootView.addSubview(mediaView)
        
        let descView=createLabel()
        rootView.addSubview(descView)
        descView.textAlignment = .left
        
        let bottomRootView=UIView()
        bottomRootView.translatesAutoresizingMaskIntoConstraints = false
        rootView.addSubview(bottomRootView)
        
        let adFlagContainer = UIStackView()
        adFlagContainer.translatesAutoresizingMaskIntoConstraints=false
        bottomRootView.addSubview(adFlagContainer)
        adFlagContainer.axis = .horizontal
        adFlagContainer.backgroundColor = UIColor(red: 169/255, green: 166/255, blue: 166/255, alpha: 71/100)
        adFlagContainer.spacing = 4
        adFlagContainer.isLayoutMarginsRelativeArrangement = true
        adFlagContainer.layoutMargins = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        
        let adTagView=createLabel()
//        adTagView.backgroundColor = .gray
        adTagView.textColor = .white
        adTagView.font = .systemFont(ofSize: 14)
        adFlagContainer.addArrangedSubview(adTagView)
        
        let adLogoView=UIImageView()
        adLogoView.translatesAutoresizingMaskIntoConstraints=false
        adFlagContainer.addArrangedSubview(adLogoView)
                
        let adSourceView=createLabel()
        bottomRootView.addSubview(adSourceView)
        
        let callToActionView=createLabel()
        bottomRootView.addSubview(callToActionView)
        callToActionView.backgroundColor = UIColor(red: 33/255, green: 78/255, blue: 243/255, alpha: 1)
        callToActionView.layer.cornerRadius = 10
        callToActionView.textColor = .white
        callToActionView.textAlignment = .center
        
        let closeView=UIImageView(image: UIImage(named: "ic_close"))
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
            
            mediaView.topAnchor.constraint(equalTo: topRootView.bottomAnchor,constant: 10),
            mediaView.widthAnchor.constraint(equalTo: rootView.widthAnchor),
            mediaView.heightAnchor.constraint(equalToConstant: 200),
            
            descView.leftAnchor.constraint(equalTo: rootView.leftAnchor),
            descView.rightAnchor.constraint(equalTo: rootView.rightAnchor),
            descView.topAnchor.constraint(equalTo: mediaView.bottomAnchor, constant: 10),
            
            bottomRootView.leftAnchor.constraint(equalTo: rootView.leftAnchor),
            bottomRootView.rightAnchor.constraint(equalTo: rootView.rightAnchor),
            bottomRootView.topAnchor.constraint(equalTo: descView.bottomAnchor),
            bottomRootView.heightAnchor.constraint(equalToConstant: 50),
            
            adFlagContainer.leadingAnchor.constraint(equalTo: bottomRootView.leadingAnchor,constant: 5),
            adFlagContainer.centerYAnchor.constraint(equalTo: bottomRootView.centerYAnchor),
                       
            adLogoView.widthAnchor.constraint(equalToConstant: 10),
            adLogoView.heightAnchor.constraint(equalToConstant: 10),
            
            adSourceView.leadingAnchor.constraint(equalTo: adFlagContainer.trailingAnchor,constant: 10),
            adSourceView.centerYAnchor.constraint(equalTo: bottomRootView.centerYAnchor),
            adSourceView.heightAnchor.constraint(equalToConstant: 20),
            
            closeView.rightAnchor.constraint(equalTo: bottomRootView.rightAnchor),
            closeView.centerYAnchor.constraint(equalTo: bottomRootView.centerYAnchor),
            closeView.widthAnchor.constraint(equalToConstant: 20),
            closeView.heightAnchor.constraint(equalToConstant: 20),
            
            callToActionView.rightAnchor.constraint(equalTo: closeView.leftAnchor,constant: -10),
            callToActionView.centerYAnchor.constraint(equalTo: bottomRootView.centerYAnchor),
            callToActionView.widthAnchor.constraint(equalToConstant: 70),
            callToActionView.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        adTagView.text = "AD"
        adLogoView.image = nativeAd.adLogo
        titleView.text = nativeAd.title
        descView.text = nativeAd.desc
        adSourceView.text = nativeAd.adSource
        callToActionView.text = nativeAd.callToAction
        
        if let url=nativeAd.icon?.url {
            iconView.loadUrl(url)
        }
        mediaView.setMediaContent(nativeAd.mediaContent)
        
        nativeAd.delegate = self
        nativeAd.rootViewController = self
        nativeAd.registerView(container: rootView, clickableViews: [titleView,iconView,mediaView,callToActionView],closeView: closeView)
    }
    
    private func closeAd(){
        clearSubView(adContainer)
    }
    
    //销毁
    deinit {
        print("deinit")
    }

}

extension AlxNativeVC:AlxNativeAdLoaderDelegate{
    func nativeAdLoaded(didReceive ads: [AlxNativeAd]) {
        print("\(TAG) nativeAdLoaded")
        self.isLoading=false
        self.label.text=NSLocalizedString("load_success", comment: "")
        
        if let ad = ads.first {
            ad.reportBiddingUrl()
            ad.reportChargingUrl()
            
            showNativeAd(nativeAd: ad)
        }
        
    }
    
    func nativeAdFailToLoad(didFailWithError error: Error) {
        let error1=error as NSError
        let msg="\(error1.code): \(error1.localizedDescription)"
        print("\(TAG) nativeAdFailedToLoad: \(msg)")
        
        self.isLoading=false
        self.label.text=String(format: NSLocalizedString("load_failed", comment: ""), msg)
    }
    
    
}

extension AlxNativeVC:AlxNativeAdDelegate{
    func nativeAdImpression(_ nativeAd:AlxNativeAd){
        print("\(TAG) nativeAdImpression")
    }
    
    func nativeAdClick(_ nativeAd:AlxNativeAd){
        print("\(TAG) nativeAdClick")
    }
    
    func nativeAdClose(_ nativeAd:AlxNativeAd){
        print("\(TAG) nativeAdClose")
        self.closeAd()
    }
}
