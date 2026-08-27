//
//  AdmobNativeVC.swift
//  AdsDemo
//
//  Created by liu weile on 2023/5/30.
//

import UIKit
import GoogleMobileAds

class AdmobNativeVC: BaseUIViewController {
    
    private let TAG = "Admob-native:"
    
    private var label:UILabel!

    private var isLoading:Bool=false
    
    private var adContainer:UIView!

    private var adLoader:AdLoader?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.title=NSLocalizedString("admob_native", comment: "")

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
        let multipleAdOptions = MultipleAdsAdLoaderOptions()
        adLoader=AdLoader(adUnitID: AdConfig.Admob_Native_Ad_Id, rootViewController: self, adTypes: [.native], options: [multipleAdOptions])
        adLoader?.delegate=self
        adLoader?.load(Request())
    }
    
    func renderAdUI(_ nativeAd: NativeAd){
        let rootView = NativeAdView()
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
        
        let mediaView=MediaView()
        mediaView.translatesAutoresizingMaskIntoConstraints=false
        rootView.addSubview(mediaView)
        
        let descView=createLabel()
        rootView.addSubview(descView)
        descView.textAlignment = .left
        
        let advertiserView=createLabel()
        advertiserView.backgroundColor = .gray
        rootView.addSubview(advertiserView)
        
        let callToActionView=createLabel()
        callToActionView.backgroundColor = .gray
        rootView.addSubview(callToActionView)
        
        rootView.headlineView=titleView
        rootView.bodyView=descView
        rootView.iconView=iconView
        rootView.mediaView=mediaView
        rootView.callToActionView=callToActionView
        rootView.advertiserView=advertiserView
        
        rootView.mediaView?.contentMode = .scaleAspectFill
        rootView.callToActionView?.isUserInteractionEnabled=false
        
        
        clearSubView(adContainer)
        adContainer.addSubview(rootView)
        
        NSLayoutConstraint.activate([
            rootView.leftAnchor.constraint(equalTo: adContainer.leftAnchor),
            rootView.rightAnchor.constraint(equalTo: adContainer.rightAnchor),
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
            
//            mediaView.leftAnchor.constraint(equalTo: rootView.leftAnchor),
//            mediaView.rightAnchor.constraint(equalTo: rootView.rightAnchor),
            mediaView.topAnchor.constraint(equalTo: topRootView.bottomAnchor,constant: 10),
            mediaView.widthAnchor.constraint(equalTo: rootView.widthAnchor),
            mediaView.heightAnchor.constraint(equalToConstant: 200),
            
            descView.leftAnchor.constraint(equalTo: rootView.leftAnchor),
            descView.rightAnchor.constraint(equalTo: rootView.rightAnchor),
            descView.topAnchor.constraint(equalTo: mediaView.bottomAnchor, constant: 10),
            
            advertiserView.leftAnchor.constraint(equalTo: rootView.leftAnchor, constant: 10),
            advertiserView.topAnchor.constraint(equalTo: descView.bottomAnchor, constant: 10),
            
            callToActionView.rightAnchor.constraint(equalTo: rootView.rightAnchor),
            callToActionView.topAnchor.constraint(equalTo: descView.bottomAnchor, constant: 10),
        ])
       
        titleView.text=nativeAd.headline
        descView.text=nativeAd.body
        advertiserView.text=nativeAd.advertiser
        callToActionView.text=nativeAd.callToAction
        mediaView.mediaContent=nativeAd.mediaContent
        
        
        if let image=nativeAd.icon?.image {
            iconView.image = image
        }else if let url=nativeAd.icon?.imageURL{
            iconView.loadUrl(url.absoluteString)
        }
        
        nativeAd.delegate=self
        rootView.nativeAd=nativeAd
    }
    
}

extension AdmobNativeVC:NativeAdLoaderDelegate{
    func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
        print("\(TAG) adLoader")
        renderAdUI(nativeAd)
    }
    
    
    func adLoaderDidFinishLoading(_ adLoader: AdLoader) {
        print("\(TAG) adLoaderDidFinishLoading")
        updateUI(false, NSLocalizedString("load_success", comment: ""))
    }
    
    
    func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
        let error1=error as NSError
        let msg="\(error1.code): \(error1.localizedDescription)"
        print("\(TAG) adLoader: error: \(msg)")
        updateUI(false, String(format: NSLocalizedString("load_failed", comment: ""), msg))
    }
    
}

extension AdmobNativeVC: NativeAdDelegate{
    
    func nativeAdDidRecordImpression(_ nativeAd: NativeAd) {
        print("\(TAG) nativeAdDidRecordImpression")
    }
    
    func nativeAdDidRecordClick(_ nativeAd: NativeAd) {
        print("\(TAG) nativeAdDidRecordClick")
    }
    
    func nativeAdWillPresentScreen(_ nativeAd: NativeAd) {
        print("\(TAG) nativeAdWillPresentScreen")
    }
}
