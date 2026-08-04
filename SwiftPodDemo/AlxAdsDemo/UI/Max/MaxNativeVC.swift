//
//  MaxNativeVC.swift
//  AdsDemo
//
//  Created by liu weile on 2023/6/2.
//

import UIKit
import AppLovinSDK

class MaxNativeVC: BaseUIViewController {
    
    private let TAG = "Max-native:"

    private var label:UILabel!

    private var isLoading:Bool=false
    
    private var adContainer:UIView!

    private var adLoader:MANativeAdLoader?=nil
    private var nativeAd:MAAd?=nil

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.title=NSLocalizedString("max_native", comment: "")
        
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
        
        adContainer=UIStackView()
        adContainer.translatesAutoresizingMaskIntoConstraints=false
        contentView.addArrangedSubview(adContainer)

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
        adLoader=MANativeAdLoader(adUnitIdentifier: AdConfig.Max_Native_Ad_Id)
        adLoader?.nativeAdDelegate=self
        adLoader?.loadAd()
    }
    
    func renderAdTemplatesUI(_ nativeAdView: MANativeAdView){
        clearSubView(adContainer)
        nativeAdView.translatesAutoresizingMaskIntoConstraints=false
        adContainer.addSubview(nativeAdView)
        
        NSLayoutConstraint.activate([
            nativeAdView.widthAnchor.constraint(equalTo: adContainer.widthAnchor),
            nativeAdView.heightAnchor.constraint(equalToConstant: 500),
            nativeAdView.topAnchor.constraint(equalTo: adContainer.topAnchor),
        ])
    }

}

extension MaxNativeVC:MANativeAdDelegate{
    
    func didLoadNativeAd(_ nativeAdView: MANativeAdView?, for ad: MAAd) {
        print("\(TAG) didLoadNativeAd")
        updateUI(false, NSLocalizedString("load_success", comment: ""))
        
        if let currentNativeAd=nativeAd{
            adLoader?.destroy(currentNativeAd)
        }
        nativeAd=ad
        
        
        if let nativeAdView=nativeAdView{
            renderAdTemplatesUI(nativeAdView)
        }else{
            print("\(TAG) no template ui")
        }
    }
    
    func didFailToLoadNativeAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        let msg="\(error.code): \(error.description)"
        print("\(TAG) didFailToLoadNativeAd: \(msg)")
        updateUI(false, String(format: NSLocalizedString("load_failed", comment: ""), msg))
    }
    
    func didClickNativeAd(_ ad: MAAd) {
        print("\(TAG) didClickNativeAd")
    }
    
    
}
