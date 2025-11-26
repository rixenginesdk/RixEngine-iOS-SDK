//
//  AlxBannerVC.swift
//  AlxDemo
//
//  Created by liu weile on 2025/3/31.
//

import UIKit
import AlxAds

class AlxBannerVC: BaseUIViewController{
    
    private let TAG = "Alx-banner:"

    private var label:UILabel!
    
    private var isLoading:Bool=false
    
    private var bannerView:AlxBannerAdView!
    
    private var adContainer:UIView!
    private var bannerView2:AlxBannerAdView?=nil
    private var isBanner2=false


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title=NSLocalizedString("alx_banner", comment: "")

        let scrollView=UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(scrollView)
        scrollView.isScrollEnabled=true
        
        let contentView=UIStackView()
        contentView.translatesAutoresizingMaskIntoConstraints=false
        scrollView.addSubview(contentView)
        contentView.axis = .vertical
        contentView.spacing = 20
        
        
        let tip1=createLabel()
        contentView.addArrangedSubview(tip1)
        tip1.text = NSLocalizedString("banner_ad_preload", comment: "")
        tip1.contentMode = .center
        
        let bnLoad=createButton(title: NSLocalizedString("load_ad", comment: ""),  action: #selector(preloadAd))
        contentView.addArrangedSubview(bnLoad)
        
        let bnShow=createButton(title: NSLocalizedString("show_ad", comment: ""),  action: #selector(showAd))
        contentView.addArrangedSubview(bnShow)
        
        label=createLabel()
        contentView.addArrangedSubview(label)
        
        adContainer=UIView()
        adContainer.translatesAutoresizingMaskIntoConstraints=false
        contentView.addArrangedSubview(adContainer)
        
        let tip2=createLabel()
        contentView.addArrangedSubview(tip2)
        tip2.text = NSLocalizedString("banner_ad", comment: "")
        tip2.contentMode = .center
        
        let bnLoadAndShow=createButton(title: NSLocalizedString("load_and_show_ad", comment: ""),  action: #selector(loadAndShowAd))
        contentView.addArrangedSubview(bnLoadAndShow)
        
        bannerView=AlxBannerAdView()
        bannerView.translatesAutoresizingMaskIntoConstraints=false
        contentView.addArrangedSubview(bannerView)
        
        for index in 1...30 {
            let test=createLabel()
            contentView.addArrangedSubview(test)
            test.text = "\(index) Banner test title ad. use swift development"
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor,constant: 20),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
                        
            bnLoad.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bnLoad.heightAnchor.constraint(equalToConstant: 50),
            
            bnShow.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bnShow.heightAnchor.constraint(equalToConstant: 50),
            
            label.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            label.heightAnchor.constraint(equalToConstant: 50),
            
            bnLoadAndShow.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bnLoadAndShow.heightAnchor.constraint(equalToConstant: 50),
            
            adContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor),
//            adContainer.heightAnchor.constraint(equalToConstant: 50),
            
            bannerView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
//            bannerView.heightAnchor.constraint(equalToConstant: 100),
        ])
        
    }
    
    @objc func preloadAd(){
        isBanner2=true
        if isLoading {
            return
        }
        isLoading=true
        label.text=NSLocalizedString("loading", comment: "")
        
        bannerView2=AlxBannerAdView()
        bannerView2?.translatesAutoresizingMaskIntoConstraints = false
        bannerView2?.refreshInterval = 0
        bannerView2?.delegate=self
        bannerView2?.rootViewController=self
        bannerView2?.loadAd(adUnitId: AdConfig.Alx_Banner_Ad_Id)
    }
    
    @objc func showAd(){
        if isLoading == true{
            print(NSLocalizedString("show_ad_no_load", comment: ""))
            return
        }
        
        guard let bannerView = bannerView2,bannerView.isReady() else{
            return
        }
        clearSubView(adContainer)
        adContainer.addSubview(bannerView)
        
        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: adContainer.topAnchor),
            bannerView.bottomAnchor.constraint(equalTo: adContainer.bottomAnchor),
            bannerView.widthAnchor.constraint(equalTo: adContainer.widthAnchor),
        ])
    }
    
    @objc func loadAndShowAd(){
        isBanner2=false
        
        bannerView.delegate=self
        bannerView.rootViewController=self
        bannerView.isHideClose = false
        bannerView.loadAd(adUnitId: AdConfig.Alx_Banner_Ad_Id)
    }
    
    //视图将要消失【生命周期】
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(TAG) viewWillDisappear")
        bannerView.destroy()
        bannerView2?.destroy()
    }
    
    //视图已经消失【生命周期】
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("\(TAG) viewDidDisappear")
    }

}

extension AlxBannerVC:AlxBannerViewAdDelegate {
    
    
    func bannerViewAdLoad(_ bannerView: AlxBannerAdView) {
        print("\(TAG) bannerViewAdLoad: price: \(bannerView.getPrice())")
        bannerView.reportBiddingUrl()
        bannerView.reportChargingUrl()
        if isBanner2{
            self.isLoading=false
            self.label.text=NSLocalizedString("load_success", comment: "")
        }
    }
    
    func bannerViewAdFailToLoad(_ bannerView: AlxBannerAdView, didFailWithError error: Error){
        let error1=error as NSError
        let msg="\(error1.code): \(error1.localizedDescription)"
        print("\(TAG) bannerViewAdFailToLoad: \(msg)")
        if isBanner2 {
            self.isLoading=false
            self.label.text=String(format: NSLocalizedString("load_failed", comment: ""), msg)
        }
    }
    
    func bannerViewAdImpression(_ bannerView: AlxBannerAdView) {
        print("\(TAG) bannerViewAdImpression")
    }
    
    func bannerViewAdClick(_ bannerView: AlxBannerAdView) {
        print("\(TAG) bannerViewAdClick")
    }
    
    func bannerViewAdClose(_ bannerView: AlxBannerAdView) {
        print("\(TAG) bannerViewAdClose")
        if isBanner2{
            clearSubView(adContainer)
        }
    }
    
    
}
