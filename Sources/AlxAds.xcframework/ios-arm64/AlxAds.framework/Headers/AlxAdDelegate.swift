//
//  AlxAdDelegate.swift
//  AlxAds
//
//  Created by liu weile on 2025/4/23.
//

/**
 * 广告扩展对象
 *
 * @author lwl
 * @date 2025-4-23
 */
import Foundation

@objc public protocol AlxAdDelegate: NSObjectProtocol {
    
    /**
     * 广告竞价单价ecpm
     */
    @objc func getPrice() -> Double
    
    /**
     * 已弃用的竞胜通知接口，兼容原有调用；新代码请使用reportBiddingWin(extra:)。
     */
    @available(*, deprecated, message: "请使用 reportBiddingWin(extra:)")
    @objc func reportBiddingUrl()

    /**
     * 已弃用的展示计费接口，兼容原有调用；新代码请使用reportBiddingImpression(extra:)。
     */
    @available(*, deprecated, message: "请使用 reportBiddingImpression(extra:)")
    @objc func reportChargingUrl()

    /**
     * 竞胜通知，使用广告返回的nurl；url为空时不上报。
     * extra：扩展字典，key参照AlxAdConstant.KEY，URL宏参照AlxAdConstant.MACRO。
     * 支持${AUCTION_PRICE}（取Rix返回价格）、${SECOND_PRICE}（取extra中的二价）及${WIN_PRICE}。
     * 无扩展参数时传[:]；缺失或无效的宏不替换，保留宏名称交由后台处理。
     */
    @objc func reportBiddingWin(extra: [String: Any])

    /**
     * 竞败通知，使用广告返回的lurl；url为空时不上报。
     * extra：扩展字典，价格、原因、渠道参照AlxAdConstant的key和数值常量。
     * 支持${AUCTION_PRICE}、${WIN_PRICE}、${AUCTION_LOSS}、${ADN_ID}四个宏。
     * 无扩展参数时传[:]；缺失或无效的宏不替换，保留宏名称交由后台处理。
     */
    @objc func reportBiddingLoss(extra: [String: Any])

    /**
     * 展示计费通知，使用广告返回的burl；url为空时不上报。
     * extra：扩展字典，规则与reportBiddingWin(extra:)一致，仅替换URL中存在且有有效值的宏。
     * 应在原有计费时机调用，不能用竞胜或加载成功代替展示计费。
     */
    @objc func reportBiddingImpression(extra: [String: Any])
}
