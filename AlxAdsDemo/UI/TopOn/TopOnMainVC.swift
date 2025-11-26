//
//  TopOnMainVC.swift
//  AlxAdsDemo
//
//  Created by liu weile on 2025/8/18.
//

import UIKit
import AnyThinkSDK

class TopOnMainVC: BaseUIViewController {

    var bnBanner:UIButton!
    var bnReward:UIButton!
    var bnInterstitial:UIButton!
    var bnNative:UIButton!
    
    var bnNativeSelfRender:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title=NSLocalizedString("topOn_ad", comment: "")
        
        // Mark: init SDK
        initSDK()
        
        let scrollView=UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints=false
        view.addSubview(scrollView)
        scrollView.isScrollEnabled=true
        
        let contentView=UIStackView()
        contentView.translatesAutoresizingMaskIntoConstraints=false
        scrollView.addSubview(contentView)
        contentView.axis = .vertical
        contentView.spacing = 20


        bnBanner=createButton(title: NSLocalizedString("banner_ad", comment: ""), action: #selector(buttonBanner))
        contentView.addArrangedSubview(bnBanner)

        bnReward=createButton(title: NSLocalizedString("rewardVideo_ad", comment: ""), action: #selector(buttonReward))
        contentView.addArrangedSubview(bnReward)

        bnInterstitial=createButton(title: NSLocalizedString("interstitial_ad", comment: ""), action: #selector(buttonInterstitial))
        contentView.addArrangedSubview(bnInterstitial)

        bnNative=createButton(title: NSLocalizedString("native_ad_template", comment: ""), action: #selector(buttonNative))
        contentView.addArrangedSubview(bnNative)
        
        bnNativeSelfRender=createButton(title: NSLocalizedString("native_ad_self_render", comment: ""), action: #selector(buttonNativeSelfRender))
        contentView.addArrangedSubview(bnNativeSelfRender)


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
            
            bnBanner.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bnBanner.heightAnchor.constraint(equalToConstant: 50),

            bnReward.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bnReward.heightAnchor.constraint(equalToConstant: 50),

            bnInterstitial.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bnInterstitial.heightAnchor.constraint(equalToConstant: 50),

            bnNative.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bnNative.heightAnchor.constraint(equalToConstant: 50),
            
            bnNativeSelfRender.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bnNativeSelfRender.heightAnchor.constraint(equalToConstant: 50),
            
        ])
        
    }

    @objc func buttonBanner(){
        navigationController?.pushViewController(TopOnBannerVC(), animated: false)
    }

    @objc func buttonReward(){
        navigationController?.pushViewController(TopOnRewardVideoVC(), animated: false)
    }

    @objc func buttonInterstitial(){
        navigationController?.pushViewController(TopOnInterstitialVC(), animated: false)
    }

    @objc func buttonNative(){
        navigationController?.pushViewController(TopOnNativeVC(), animated: false)
    }
    
    @objc func buttonNativeSelfRender(){
        navigationController?.pushViewController(TopOnNativeSelfRenderVC(), animated: false)
    }
    
    private func initSDK(){
        ATAPI.setLogEnabled(true)
        ATAPI.integrationChecking()
//        ATAPI.setDebuggerConfig(<#T##debuggerConfigBlock: ((ATDebuggerConfig?) -> Void)?##((ATDebuggerConfig?) -> Void)?##(ATDebuggerConfig?) -> Void#>)
//        // 创建可变数组
//        let array = NSMutableArray()
//
//        // 初始化自定义网络配置模型
//        let splashMode = ATCustomNetworkMode(
//            adapterName: "AlxTopOnInterstitialAdapter",
//            networkCacheTime: 180 * 1000,
//            bidRealTimeLoadSW: true
//        )
//
//        // 添加模型到数组
//        array.add(splashMode)
        
//        // 配置自定义适配器
//        ATSDKGlobalSetting.sharedManager().addCustomAdapterConfigArray(array as! [ATCustomNetworkMode])
        
        
        do{
            let result:()=try ATAPI.sharedInstance().start(withAppID: AdConfig.TopOn_App_Id, appKey: AdConfig.TopOn_App_Key)
            print("TopOn SDK init status:\(result)")
        }catch{
            print("TopOn sdk init error:\(error.localizedDescription)")
        }
        
    }

}
