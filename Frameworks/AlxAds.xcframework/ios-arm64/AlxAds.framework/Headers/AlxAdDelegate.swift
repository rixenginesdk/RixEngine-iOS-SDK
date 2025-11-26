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

@objc public protocol AlxAdDelegate : NSObjectProtocol{
    
    /**
     * 广告竞价单价ecpm
     *
     * @return
     */
    @objc func getPrice()->Double
    
    /**
     * 竞价成功通知url，需要将${AUCTION_PRICE}替换为实际的价格
     *
     * @return
     */
    @objc func reportBiddingUrl()
    
    /**
     * 计费通知url，需要将${AUCTION_PRICE}替换为实际的价格
     *
     * @return
     */
    @objc func reportChargingUrl()

}
