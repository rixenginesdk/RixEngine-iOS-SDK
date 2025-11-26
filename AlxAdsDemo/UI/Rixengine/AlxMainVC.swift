//
//  AlxMainVC.swift
//  AlxDemo
//
//  Created by liu weile on 2025/3/31.
//

import UIKit

class AlxMainVC: BaseUIViewController {

    var bnBanner:UIButton!
    var bnBannerXib:UIButton!
    var bnReward:UIButton!
    var bnInterstitial:UIButton!
    var bnInterstitialBanner:UIButton!
    var bnNative:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title=NSLocalizedString("Alx_ad", comment: "")
        
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
        
        bnBannerXib=createButton(title: NSLocalizedString("banner_ad_xib", comment: ""), action: #selector(buttonBannerXib))
        contentView.addArrangedSubview(bnBannerXib)

        bnReward=createButton(title: NSLocalizedString("rewardVideo_ad", comment: ""), action: #selector(buttonReward))
        contentView.addArrangedSubview(bnReward)

        bnInterstitial=createButton(title: NSLocalizedString("interstitial_video_ad", comment: ""), action: #selector(buttonInterstitial))
        contentView.addArrangedSubview(bnInterstitial)
        
        bnInterstitialBanner=createButton(title: NSLocalizedString("interstitial_banner_ad", comment: ""), action: #selector(buttonInterstitialBanner))
        contentView.addArrangedSubview(bnInterstitialBanner)

        bnNative=createButton(title: NSLocalizedString("native_ad", comment: ""), action: #selector(buttonNative))
        contentView.addArrangedSubview(bnNative)


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

            bnBannerXib.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bnBannerXib.heightAnchor.constraint(equalToConstant: 50),

            bnReward.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bnReward.heightAnchor.constraint(equalToConstant: 50),

            bnInterstitial.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bnInterstitial.heightAnchor.constraint(equalToConstant: 50),

            bnInterstitialBanner.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bnInterstitialBanner.heightAnchor.constraint(equalToConstant: 50),

            bnNative.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            bnNative.heightAnchor.constraint(equalToConstant: 50),
        ])
        
    }

    @objc func buttonBanner(){
        navigationController?.pushViewController(AlxBannerVC(), animated: false)
    }
    
    @objc func buttonBannerXib(){
        navigationController?.pushViewController(AlxBannerXibVC(), animated: false)
//        navigationController?.pushViewController(AlxBannerXibVC(nibName: "AlxBannerXibVC", bundle: nil), animated: false)
    }

    @objc func buttonReward(){
        navigationController?.pushViewController(AlxRewardVideoVC(), animated: false)
    }

    @objc func buttonInterstitial(){
        navigationController?.pushViewController(AlxInterstitialVC(), animated: false)
    }
    
    @objc func buttonInterstitialBanner(){
        navigationController?.pushViewController(AlxInterstitialBannerVC(), animated: false)
    }

    @objc func buttonNative(){
        navigationController?.pushViewController(AlxNativeVC(), animated: false)
    }





}
