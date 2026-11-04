//
//  AlxRewardVideoAd.swift
//  AlxAds
//
//  Created by liu weile on 2025/3/31.
//

import Foundation
import UIKit

@objc public class AlxRewardVideoAd: NSObject, AlxAdDelegate {
    
    private var model: AlxRewardVideoModel?
    
    @objc public weak var delegate: AlxRewardVideoAdDelegate? {
        get { model?.delegate }
        set { model?.delegate = newValue }
    }
    
    @objc public override init() {
        super.init()
        model = AlxRewardVideoModel(adApi: self)
    }
    
    @objc public func loadAd(adUnitId: String) {
        self.loadAd(adUnitId: adUnitId, request: nil)
    }
    
    @objc public func loadAd(adUnitId: String, request: AlxAdRequest? = nil) {
        model?.loadAd(adUnitId: adUnitId, request: request)
    }
    
    @objc public func showAd(present: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            guard let this = self else { return }
            this.model?.showAd(present: present)
        }
//        model?.showAd(present: present)
    }
    
    @objc public func isReady() -> Bool {
        guard let isReadyOK = model?.isReady() else { return false }
        return isReadyOK
    }
    
    @objc public func destroy() {
        model?.destroy()
    }
    
    // MARK: - AlxAdDelegate
    @objc public func getPrice() -> Double {
        guard let currentPrict = model?.getPrice() else { return 0 }
        return currentPrict
    }
    
    /**
     * 已弃用，兼容原有上报行为；请使用reportBiddingWin(extra:)。
     */
    @available(*, deprecated, message: "请使用 reportBiddingWin(extra:)")
    @objc public func reportBiddingUrl() {
        model?.reportBiddingUrl()
    }
    
    /**
     * 竞胜通知，使用广告返回的nurl；url为空时不上报。
     * extra：key和value参照AlxAdConstant，缺失或无效的宏保留原宏名称交由后台处理。
     * ${AUCTION_PRICE}始终取Rix返回价格，其他宏取extra，不修改广告原价。
     */
    @objc public func reportBiddingWin(extra: [String: Any]) {
        model?.reportBiddingWin(extra: extra)
    }

    /**
     * 竞败通知，使用广告返回的lurl；url为空时不上报。
     * extra：key和value参照AlxAdConstant，缺失或无效的宏保留原宏名称交由后台处理。
     * ${AUCTION_PRICE}始终取Rix返回价格，其他宏取extra，不修改广告原价。
     */
    @objc public func reportBiddingLoss(extra: [String: Any]) {
        model?.reportBiddingLoss(extra: extra)
    }

    /**
     * 展示计费通知，使用广告返回的burl；url为空时不上报。
     * extra：key和value参照AlxAdConstant，缺失或无效的宏保留原宏名称交由后台处理。
     * ${AUCTION_PRICE}始终取Rix返回价格，其他宏取extra，不修改广告原价。
     */
    @objc public func reportBiddingImpression(extra: [String: Any]) {
        model?.reportBiddingImpression(extra: extra)
    }

    /**
     * 已弃用，兼容原有上报行为；请使用reportBiddingImpression(extra:)。
     */
    @available(*, deprecated, message: "请使用 reportBiddingImpression(extra:)")
    @objc public func reportChargingUrl() {
        model?.reportChargingUrl()
    }
    
}
