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
@objc public class AlxNativeAd: NSObject, AlxAdDelegate {
    
    @objc public static let Create_Type_Unknown = 0 // 未知类型
    @objc public static let Create_Type_Large_Image = 1 // 大图
    @objc public static let Create_Type_Small_Image = 2 // 小图
    @objc public static let Create_Type_Group_Image = 3 // 组图
    @objc public static let Create_Type_Video = 4 // 视频
    
    internal var nativeAdAction: AlxNativeAdAction? = nil
    
    public override init() {
        super.init()
    }
    
    /// 广告素材类型【如：1:大图、2:小图、3:组图、4:视频、0:未知类型】
    @objc public internal(set) var createType: Int = 0
    
    /// 广告来源
    @objc public internal(set) var adSource: String?
    
    @objc public internal(set) var title: String?
    
    @objc public internal(set) var desc: String?
    
    @objc public internal(set) var icon: AlxNativeAdImage?
    
    /// 广告内容多图素材
    @objc public internal(set) var images: [AlxNativeAdImage]?
    
    /// 广告行为按钮的显示文字（例如："查看详情"或"下载"）
    @objc public internal(set) var callToAction: String?
    
    /// 广告多媒体内容信息
    @objc public internal(set) var mediaContent: AlxMediaContent?
    
    @objc public weak var rootViewController: UIViewController?
    
    @objc public weak var delegate: AlxNativeAdDelegate?
    
    @objc public func registerView(container: UIView, clickableViews: [UIView]?) {
        self.registerView(container: container, clickableViews: clickableViews, closeView: nil)
    }
    
    @objc public func registerView(container: UIView, clickableViews: [UIView]?, closeView: UIView?) {
        
    }
    
    @objc public func unregisterView() {
        
    }
    
    //  Alx logo
    @objc public var adLogo: UIImage? {
        return nativeAdAction?.getAdLogo()
    }
    
    // MARK: - AlxAdDelegate
    @objc public func getPrice() -> Double {
        return nativeAdAction?.getPrice() ?? 0
    }
    
    /**
     * 已弃用，兼容原有上报行为；请使用reportBiddingWin(extra:)。
     */
    @available(*, deprecated, message: "请使用 reportBiddingWin(extra:)")
    @objc public func reportBiddingUrl() {
        nativeAdAction?.reportBiddingUrl()
    }
    
    /**
     * 竞胜通知，使用广告返回的nurl；url为空时不上报。
     * extra：key和value参照AlxAdConstant，缺失或无效的宏保留原宏名称交由后台处理。
     * ${AUCTION_PRICE}始终取Rix返回价格，其他宏取extra，不修改广告原价。
     */
    @objc public func reportBiddingWin(extra: [String: Any]) {
        nativeAdAction?.reportBiddingWin(extra: extra)
    }

    /**
     * 竞败通知，使用广告返回的lurl；url为空时不上报。
     * extra：key和value参照AlxAdConstant，缺失或无效的宏保留原宏名称交由后台处理。
     * ${AUCTION_PRICE}始终取Rix返回价格，其他宏取extra，不修改广告原价。
     */
    @objc public func reportBiddingLoss(extra: [String: Any]) {
        nativeAdAction?.reportBiddingLoss(extra: extra)
    }

    /**
     * 展示计费通知，使用广告返回的burl；url为空时不上报。
     * extra：key和value参照AlxAdConstant，缺失或无效的宏保留原宏名称交由后台处理。
     * ${AUCTION_PRICE}始终取Rix返回价格，其他宏取extra，不修改广告原价。
     */
    @objc public func reportBiddingImpression(extra: [String: Any]) {
        nativeAdAction?.reportBiddingImpression(extra: extra)
    }

    /**
     * 已弃用，兼容原有上报行为；请使用reportBiddingImpression(extra:)。
     */
    @available(*, deprecated, message: "请使用 reportBiddingImpression(extra:)")
    @objc public func reportChargingUrl() {
        nativeAdAction?.reportChargingUrl()
    }
    
}
