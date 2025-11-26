//
//  AlxNativeAd.swift
//  AlxAds
//
//  Created by liu weile on 2025/5/6.
//

import Foundation
import UIKit

/**
 原生广告
 */
@objc public class AlxNativeAd:NSObject,AlxAdDelegate {
    
    @objc public static let Create_Type_Unknown = 0; //未知类型
    @objc public static let Create_Type_Large_Image = 1; //大图
    @objc public static let Create_Type_Small_Image = 2; //小图
    @objc public static let Create_Type_Group_Image = 3; //组图
    @objc public static let Create_Type_Video = 4; //视频
    
    internal var nativeAdAction:AlxNativeAdAction?=nil
    
    public override init() {
        super.init()
    }
    
    //   广告素材类型【如：1:大图、2:小图、3:组图、4:视频、0:未知类型】
    @objc public internal(set) var createType:Int = 0
    
    //   广告来源
    @objc public internal(set) var adSource:String?
    
    @objc public internal(set) var title:String?
    
    @objc public internal(set) var desc:String?
    
    @objc public internal(set) var icon:AlxNativeAdImage?
    
    //   广告内容多图素材
    @objc public internal(set) var images:[AlxNativeAdImage]?
    
    //   广告行为按钮的显示文字（例如："查看详情"或"下载"）
    @objc public internal(set) var callToAction:String?
    
    //   广告多媒体内容信息
    @objc public internal(set) var mediaContent:AlxMediaContent?
    
    @objc public weak var rootViewController:UIViewController?
    
    @objc public weak var delegate:AlxNativeAdDelegate?
    
    @objc public func registerView(container:UIView,clickableViews:[UIView]?){
        self.registerView(container: container, clickableViews: clickableViews, closeView: nil)
    }
    
    @objc public func registerView(container:UIView,clickableViews:[UIView]?,closeView:UIView?){
        
    }
    
    @objc public func unregisterView(){
        
    }
    
    //  Algorix logo
    @objc public var adLogo:UIImage?{
        return nativeAdAction?.getAdLogo()
    }
    
    @objc public func getPrice() -> Double{
        return nativeAdAction?.getPrice() ?? 0
    }
    
    @objc public func reportBiddingUrl(){
        nativeAdAction?.reportBiddingUrl()
    }
    
    @objc public func reportChargingUrl(){
        nativeAdAction?.reportChargingUrl()
    }
    
}
