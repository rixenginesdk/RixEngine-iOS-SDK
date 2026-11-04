//
//  AlxBannerAdView.swift
//  AlxAds
//
//  Created by liu weile on 2025/4/14.
//

import Foundation
import UIKit

@objc public class AlxBannerAdView: AlxBaseBannerView, AlxBannerViewDelegate, AlxAdDelegate {
    
    
    @objc @IBOutlet public weak var delegate: AlxBannerViewAdDelegate?
    /**
     此视图控制器用于在用户点击广告后呈现重叠式广告，通常应设置为包含AlxBannerAdView的视图控制器
     */
    @objc @IBOutlet public weak var rootViewController: UIViewController? {
        get { bannerRootViewController }
        set { bannerRootViewController = newValue }
    }
    
    /**
     设置刷新频率:单位s  【 0或30~120之间的数字。0表示不自动刷新, 默认30S 】
     */
    @objc @IBInspectable public var refreshInterval: Int {
        get { bannerRefreshInterval }
        set { bannerRefreshInterval = newValue }
    }
    
    /**
     是否隐藏关闭图标
     */
    @objc @IBInspectable public var isHideClose: Bool {
        get { bannerIsHideCloseIcon }
        set { bannerIsHideCloseIcon = newValue }
    }
    
    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @objc public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc public func loadAd(adUnitId: String) {
        self.loadAd(adUnitId: adUnitId, request: nil)
    }
    
    @objc public func loadAd(adUnitId: String, request: AlxAdRequest? = nil) {
        super.bannerViewDelegate = self
        super.load(adUnitId: adUnitId, request: request)
    }
    
    @objc public func isReady() -> Bool {
        return super.ready()
    }
    
    @objc public func destroy() {
        super.destroys()
    }
    
    @objc public func getPrice() -> Double {
        return model.getPrice()
    }
    
    /**
     * 已弃用，兼容原有上报行为；请使用reportBiddingWin(extra:)。
     */
    @available(*, deprecated, message: "请使用 reportBiddingWin(extra:)")
    @objc public func reportBiddingUrl() {
        model.reportBiddingUrl()
    }
    
    /**
     * 竞胜通知，使用广告返回的nurl；url为空时不上报。
     * extra：key和value参照AlxAdConstant，缺失或无效的宏保留原宏名称交由后台处理。
     * ${AUCTION_PRICE}始终取Rix返回价格，其他宏取extra，不修改广告原价。
     */
    @objc public func reportBiddingWin(extra: [String: Any]) {
        model.reportBiddingWin(extra: extra)
    }

    /**
     * 竞败通知，使用广告返回的lurl；url为空时不上报。
     * extra：key和value参照AlxAdConstant，缺失或无效的宏保留原宏名称交由后台处理。
     * ${AUCTION_PRICE}始终取Rix返回价格，其他宏取extra，不修改广告原价。
     */
    @objc public func reportBiddingLoss(extra: [String: Any]) {
        model.reportBiddingLoss(extra: extra)
    }

    /**
     * 展示计费通知，使用广告返回的burl；url为空时不上报。
     * extra：key和value参照AlxAdConstant，缺失或无效的宏保留原宏名称交由后台处理。
     * ${AUCTION_PRICE}始终取Rix返回价格，其他宏取extra，不修改广告原价。
     */
    @objc public func reportBiddingImpression(extra: [String: Any]) {
        model.reportBiddingImpression(extra: extra)
    }

    /**
     * 已弃用，兼容原有上报行为；请使用reportBiddingImpression(extra:)。
     */
    @available(*, deprecated, message: "请使用 reportBiddingImpression(extra:)")
    @objc public func reportChargingUrl() {
        model.reportChargingUrl()
    }
    
    // MARK: - AlxBannerViewAdDelegate
    func bannerViewLoad() {
        delegate?.bannerViewAdLoad(self)
    }
    
    func bannerViewFailToLoad(_ error: Error) {
        delegate?.bannerViewAdFailToLoad(self, didFailWithError: error)
    }
    
    func bannerViewImpression() {
        delegate?.bannerViewAdImpression?(self)
    }
    
    func bannerViewClick() {
        delegate?.bannerViewAdClick?(self)
    }
    
    func bannerViewClose() {
        delegate?.bannerViewAdClose?(self)
    }
    
}
