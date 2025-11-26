//
//  TopOnSelfRenderView.swift
//  AlxAdsDemo
//
//  Created by liu weile on 2025/8/25.
//

import UIKit
import Foundation
import AnyThinkNative


public class TopOnSelfRenderView: UIView {
    
    public var advertiserLabel:UILabel!
    public var titleLabel:UILabel!
    public var textLabel:UILabel!
    public var ctaLabel:UILabel!
    public var iconImageView:UIImageView!
    public var logoImageView:UIImageView!
    
    private var mediaContainerView:UIView!
    public var mainImageView:UIImageView!
    
    private var nativeAdOffer:ATNativeAdOffer?
    
    public var mediaView:UIView? {
        willSet {
            mediaView?.removeFromSuperview()
        }
        didSet {
            guard let mediaView = self.mediaView else { return }
            
            self.mediaContainerView.addSubview(mediaView)
            
            // 原生AutoLayout设置
            mediaView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                mediaView.leadingAnchor.constraint(equalTo: mediaContainerView.leadingAnchor),
                mediaView.trailingAnchor.constraint(equalTo: mediaContainerView.trailingAnchor),
                mediaView.topAnchor.constraint(equalTo: mediaContainerView.topAnchor),
                mediaView.bottomAnchor.constraint(equalTo: mediaContainerView.bottomAnchor)
            ])
        }
    }
    
    public override init(frame:CGRect) {
        super.init(frame: frame)
        print("TopOnSelfRenderView: init(frame:CGRect)")
        initView()
        makeConstraints()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("TopOnSelfRenderView: init?(coder: NSCoder)")
        initView()
        makeConstraints()
    }
    
    public func setData(offer:ATNativeAdOffer){
        self.nativeAdOffer = offer
        setupUI()
    }
    
    private func initView(){
        self.advertiserLabel=createLabel()
        self.advertiserLabel.translatesAutoresizingMaskIntoConstraints=false
        addSubview(advertiserLabel)
        
        self.titleLabel=createLabel()
        self.titleLabel.translatesAutoresizingMaskIntoConstraints=false
        addSubview(titleLabel)
        
        self.textLabel=createLabel()
        self.textLabel.translatesAutoresizingMaskIntoConstraints=false
        addSubview(textLabel)
        
        ctaLabel=createLabel()
        self.ctaLabel.translatesAutoresizingMaskIntoConstraints=false
        ctaLabel.backgroundColor = UIColor(red: 33/255, green: 78/255, blue: 243/255, alpha: 1)
        ctaLabel.layer.cornerRadius = 10
        ctaLabel.textColor = .white
        ctaLabel.textAlignment = .center
        addSubview(ctaLabel)
        
        iconImageView=UIImageView()
        iconImageView.translatesAutoresizingMaskIntoConstraints=false
        addSubview(iconImageView)
        
        logoImageView=UIImageView()
        logoImageView.translatesAutoresizingMaskIntoConstraints=false
        addSubview(logoImageView)
        
        mediaContainerView = UIView()
        mediaContainerView.translatesAutoresizingMaskIntoConstraints=false
        addSubview(mediaContainerView)
        
        mainImageView = UIImageView()
        mainImageView.translatesAutoresizingMaskIntoConstraints=false
        mediaContainerView.addSubview(mainImageView)
        
        self.addUserInteraction()
    }
    
    private func makeConstraints(){
        self.addConstraints([
            self.iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.iconImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.iconImageView.widthAnchor.constraint(equalToConstant: 50),
            self.iconImageView.heightAnchor.constraint(equalToConstant: 50),
            
            self.titleLabel.leadingAnchor.constraint(equalTo: self.iconImageView.trailingAnchor, constant: 10),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.iconImageView.centerYAnchor),
            
            self.mediaContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.mediaContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.mediaContainerView.topAnchor.constraint(equalTo: self.iconImageView.bottomAnchor, constant: 10),
            self.mediaContainerView.heightAnchor.constraint(equalToConstant: self.nativeAdOffer?.nativeAd.mainImageHeight ?? 200),
            
            self.mainImageView.leadingAnchor.constraint(equalTo: mediaContainerView.leadingAnchor),
            self.mainImageView.trailingAnchor.constraint(equalTo: mediaContainerView.trailingAnchor),
            self.mainImageView.topAnchor.constraint(equalTo: mediaContainerView.topAnchor),
            self.mainImageView.bottomAnchor.constraint(equalTo: mediaContainerView.bottomAnchor),
            
            self.textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.textLabel.topAnchor.constraint(equalTo: self.mediaContainerView.bottomAnchor,constant: 10),
            
            self.advertiserLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.advertiserLabel.topAnchor.constraint(equalTo: self.textLabel.bottomAnchor,constant: 10),
            self.advertiserLabel.heightAnchor.constraint(equalToConstant: 30),
            
            self.logoImageView.leadingAnchor.constraint(equalTo: self.advertiserLabel.trailingAnchor,constant: 10),
            self.logoImageView.topAnchor.constraint(equalTo: self.textLabel.bottomAnchor,constant: 10),
            self.logoImageView.widthAnchor.constraint(equalToConstant: 30),
            self.logoImageView.heightAnchor.constraint(equalToConstant: 30),
            
            self.ctaLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.ctaLabel.topAnchor.constraint(equalTo: self.textLabel.bottomAnchor,constant: 10),
            self.ctaLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    private func addUserInteraction(){
        self.advertiserLabel.isUserInteractionEnabled=true
        self.titleLabel.isUserInteractionEnabled=true
        self.iconImageView.isUserInteractionEnabled=true
        self.mainImageView.isUserInteractionEnabled=true
        self.mediaView?.isUserInteractionEnabled=true
        self.textLabel.isUserInteractionEnabled=true
        self.ctaLabel.isUserInteractionEnabled=true
    }

    
    func setupUI(){
        guard let nativeAdOffer = self.nativeAdOffer else { return }
        
        if let image = nativeAdOffer.nativeAd.icon {
            self.iconImageView.image = image
        }else if let url = nativeAdOffer.nativeAd.iconUrl {
            self.iconImageView.loadUrl(url)
        }
        
        if let image = nativeAdOffer.nativeAd.logo {
            self.logoImageView.image=image
        }else if let url = nativeAdOffer.nativeAd.logoUrl {
            self.logoImageView.loadUrl(url)
        }
        
        print("selfRenderView: mainImageView height=\(nativeAdOffer.nativeAd.mainImageHeight)")
        if let image = nativeAdOffer.nativeAd.mainImage {
            print("mainImageView:image数据")
            self.mainImageView?.image=image
        }else if let url = nativeAdOffer.nativeAd.imageUrl {
            print("mainImageView: url=\(url)")
            self.mainImageView?.loadUrl(url)
        }else{
            print("mainImageView:没有数据")
        }
        
        print("selfRenderView: title=\(nativeAdOffer.nativeAd.title ?? "空")")
        print("selfRenderView: mainText=\(nativeAdOffer.nativeAd.mainText ?? "空")")
        print("selfRenderView: advertiser=\(nativeAdOffer.nativeAd.advertiser ?? "空")")
        print("selfRenderView: ctaText=\(nativeAdOffer.nativeAd.ctaText ?? "空")")
        
        self.titleLabel.text = nativeAdOffer.nativeAd.title
        self.textLabel.text = nativeAdOffer.nativeAd.mainText
        self.advertiserLabel.text =  nativeAdOffer.nativeAd.advertiser
        self.ctaLabel.text = nativeAdOffer.nativeAd.ctaText
    }
    
    
    deinit {
        self.nativeAdOffer = nil
    }
    
    func createButton(title:String,action: Selector) -> UIButton{
        let button=UIButton()
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints=false
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray
        button.accessibilityNavigationStyle = .automatic
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

     
    func createLabel() -> UILabel{
         let label=UILabel()
         label.translatesAutoresizingMaskIntoConstraints=false
         label.textAlignment = .left
         label.textColor = .black
         label.numberOfLines = .zero
         return label
     }
     
    func clearSubView(_ constainerView:UIView){
         let views=constainerView.subviews
         for view in views {
             view.removeFromSuperview()
         }
     }
    
}
