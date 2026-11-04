//
//  AlxTopOnBaseAdapter.swift
//  AlxAdsDemo
//
//  直接翻译 OC 代码
//  Translated directly from OC code
//

import Foundation
import AnyThinkSDK
import AlxAds

@objc(AlxTopOnBaseAdapter)
public class AlxTopOnBaseAdapter: ATBaseMediationAdapter {
    
    private static let TAG = "AlxTopOnBaseAdapter"

    /// 当前请求标识，用于忽略旧请求的迟到加载回调。
    private var bidRequestID = UUID()
    /// 本次请求加载成功的广告对象。
    private var biddingAd: AlxAdDelegate?
    /// 待上报的竞价结果：true为竞胜，false为竞败，nil为无待处理结果。
    private var pendingBidWin: Bool?
    /// 待上报的竞胜或竞败扩展参数，与本次结果一起暂存。
    private var pendingBidExtra: [String: Any] = [:]
    /// 本次请求是否已接收最终竞价结果。
    private var didReceiveResult = false
    /// 当前广告源在 TopOn 侧的平台 ID（用于判断竞败是否输给同平台或自有广告）。
    private var currentNetworkFirmID: Int = 0

    /// 开始新的竞价请求并重置通知状态。
    /// - Parameter argument: TopOn 广告请求参数，用于提取当前广告源的平台 ID。
    /// - Returns: 广告就绪时的绑定回调，返回false表示该广告属于旧请求。
    func beginBiddingRequest(with argument: ATAdMediationArgument? = nil) -> (AlxAdDelegate) -> Bool {
        let requestID = UUID()
        bidRequestID = requestID
        biddingAd = nil
        pendingBidWin = nil
        pendingBidExtra = [:]
        didReceiveResult = false
        currentNetworkFirmID = Self.extractNetworkFirmID(from: argument)
        return { [weak self] ad in
            guard let self = self else { return false }
            guard self.bidRequestID == requestID else { return false }
            self.biddingAd = ad
            self.reportPendingBidResult()
            return true
        }
    }

    /// 根据 TopOn 广告请求参数构建 AlxAdRequest。
    /// 仅当 TopOn 传入底价参数时才设置 `bid_floor`，避免硬编码高底价导致测试广告无填充而无法触发 C2S 竞胜/竞败回调。
    func buildAdRequest(with argument: ATAdMediationArgument) -> AlxAdRequest {
        var userExt: [String: String] = [:]
        let floorKeys = [AlxAdConstant.KEY.BIDDING_FLOOR, "p_bidfloor", "bidfloor"]
        for key in floorKeys {
            if let floorValue = argument.localInfoDic[key] ?? argument.serverContentDic[key] {
                let floorStr = "\(floorValue)".trimmingCharacters(in: .whitespacesAndNewlines)
                if let floor = Double(floorStr), floor.isFinite, floor > 0 {
                    userExt[AlxAdConstant.KEY.BIDDING_FLOOR] = floorStr
                    break
                }
            }
        }
        return userExt.isEmpty ? AlxAdRequest() : AlxAdRequest().withUserExt(userExt)
    }

    /// 接收TopOn的最终竞价结果，并调用广告对象的竞胜或竞败接口。
    /// - Parameter result: TopOn返回的竞胜或竞败结果，将可确定的竞胜价格、二价、竞败原因和竞胜渠道转换为扩展参数。
    @objc(didReceiveBidResult:)
    public override func didReceiveBid(_ result: ATBidWinLossResult) {
        guard !didReceiveResult else { return }
        var isWin: Bool = false
        switch result.bidResultType {
        case .win:
            isWin = true
        case .loss:
            isWin = false
        @unknown default:
            return
        }
        didReceiveResult = true
        let fallbackWinPrice: Double? = {
            guard let adPrice = biddingAd?.getPrice(), adPrice.isFinite, adPrice > 0 else { return nil }
            return adPrice
        }()
        let extra = Self.bidExtra(
            from: result,
            currentNetworkFirmID: currentNetworkFirmID,
            fallbackWinPrice: fallbackWinPrice
        )
        let winPriceLog = extra[AlxAdConstant.KEY.BIDDING_WIN_PRICE] ?? result.winPrice
        if isWin {
            let secondPriceLog = extra[AlxAdConstant.KEY.BIDDING_SECOND_PRICE] ?? result.secondPrice
            print("\(Self.TAG): notifyBidWin: winPrice=\(winPriceLog);secondPrice=\(secondPriceLog)")
            print("\(Self.TAG): notifyBidDisplay: isWin=true;displayPrice=\(winPriceLog)")
        } else {
            let lossReason = extra[AlxAdConstant.KEY.BIDDING_LOSS_REASON] ?? ""
            let adnId = extra[AlxAdConstant.KEY.BIDDING_ADN_ID] ?? ""
            let lossPriceLog: Any = {
                if let bidInfo = result.userInfoDic[kATWinLossAdTypeKeyBidInfo] as? ATBidInfo,
                   let price = Self.parsePrice(bidInfo.price), price > 0 {
                    return price
                }
                if let adPrice = biddingAd?.getPrice(), adPrice.isFinite, adPrice >= 0 {
                    return adPrice
                }
                return ""
            }()
            print("\(Self.TAG): notifyBidLoss: lossReason=\(lossReason);winPrice=\(winPriceLog);adnId=\(adnId)")
            print("\(Self.TAG): notifyBidLoss: lossPrice=\(lossPriceLog)")
        }
        pendingBidExtra = extra
        pendingBidWin = isWin
        reportPendingBidResult()
    }

    /// 广告对象就绪后发送暂存结果，同一请求只上报一次。
    private func reportPendingBidResult() {
        guard let result = pendingBidWin, let ad = biddingAd else { return }
        var adExtra = pendingBidExtra
        pendingBidWin = nil
        pendingBidExtra = [:]
        if result {
            if adExtra[AlxAdConstant.KEY.BIDDING_WIN_PRICE] == nil {
                let adPrice = ad.getPrice()
                if adPrice.isFinite, adPrice > 0 {
                    adExtra[AlxAdConstant.KEY.BIDDING_WIN_PRICE] = adPrice
                    if adExtra[AlxAdConstant.KEY.BIDDING_SECOND_PRICE] == nil {
                        adExtra[AlxAdConstant.KEY.BIDDING_SECOND_PRICE] = adPrice
                    }
                }
            }
            ad.reportBiddingWin(extra: adExtra)
            ad.reportBiddingImpression(extra: adExtra)
        } else {
            ad.reportBiddingLoss(extra: adExtra)
        }
    }

    /// 提取竞胜价格（一价）、二价、竞败原因以及竞胜方渠道 ID，映射为 ALX SDK 标准扩展参数。
    /// 若拿不到有效二价（无其他竞争出价对手或返回 0），则二价取竞胜价本身（winPrice）。
    /// 若某字段缺失或无效则不放入字典，由 SDK 内部保留原宏名称交由后台处理。
    private static func bidExtra(
        from result: ATBidWinLossResult,
        currentNetworkFirmID: Int,
        fallbackWinPrice: Double? = nil
    ) -> [String: Any] {
        var extra: [String: Any] = [:]
        var winPrice = parsePrice(result.winPrice)
        if winPrice == nil, let rawUserWinPrice = result.userInfoDic[kATWinLossAdTypekeyWinPrice] {
            winPrice = parsePrice("\(rawUserWinPrice)")
        }
        if winPrice == nil, result.bidResultType == .win {
            winPrice = fallbackWinPrice
        }
        if let winPrice = winPrice {
            extra[AlxAdConstant.KEY.BIDDING_WIN_PRICE] = winPrice
        }
        if result.bidResultType == .win {
            if let secondPrice = parsePrice(result.secondPrice), secondPrice > 0 {
                extra[AlxAdConstant.KEY.BIDDING_SECOND_PRICE] = secondPrice
            } else if let winPrice = winPrice {
                extra[AlxAdConstant.KEY.BIDDING_SECOND_PRICE] = winPrice
            }
        } else if result.bidResultType == .loss {
            let reason: Int
            switch result.lossReasonType {
            case .withLowPriceInNormal:
                reason = AlxAdConstant.BIDDING_LOSS_REASON.LOW_PRICE_IN_NORMAL
            case .withLowPriceInHB:
                reason = AlxAdConstant.BIDDING_LOSS_REASON.LOW_PRICE_IN_HB
            case .withBiddingTimeOut:
                reason = AlxAdConstant.BIDDING_LOSS_REASON.TIMEOUT
            case .withExpire:
                reason = AlxAdConstant.BIDDING_LOSS_REASON.EXPIRE
            case .withFloorFilter:
                reason = AlxAdConstant.BIDDING_LOSS_REASON.LOW_FLOOR
            default:
                reason = AlxAdConstant.BIDDING_LOSS_REASON.OTHER
            }
            extra[AlxAdConstant.KEY.BIDDING_LOSS_REASON] = reason

            if let adnId = resolveBiddingAdnId(from: result, currentNetworkFirmID: currentNetworkFirmID) {
                extra[AlxAdConstant.KEY.BIDDING_ADN_ID] = adnId
            }
        }
        return extra
    }

    private static func parsePrice(_ raw: String?) -> Double? {
        guard let text = raw?.trimmingCharacters(in: .whitespacesAndNewlines),
              let price = Double(text),
              price.isFinite, price >= 0 else {
            return nil
        }
        return price
    }

    private static func extractNetworkFirmID(from argument: ATAdMediationArgument?) -> Int {
        guard let argument = argument else { return 0 }
        if let unitGroup = argument.serverContentDic[kATAdapterCustomInfoUnitGroupModelKey] as? NSObject,
           unitGroup.responds(to: NSSelectorFromString("networkFirmID")),
           let value = unitGroup.value(forKey: "networkFirmID") as? NSNumber {
            return value.intValue
        }
        if let raw = argument.serverContentDic["nw_firm_id"] ?? argument.serverContentDic["network_firm_id"] {
            return Int("\(raw)".trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
        }
        return 0
    }

    /// 映射竞胜方网盟渠道 ID（1001~1004）。
    /// - 1001: 输给同个广告平台-瀑布流
    /// - 1002: 输给同个广告平台-竞价
    /// - 1003: 输给自有广告（TopOn MyOffer / Cross Promotion / ADX / Direct）
    /// - 1004: 输给其他广告平台
    private static func resolveBiddingAdnId(from result: ATBidWinLossResult, currentNetworkFirmID: Int) -> Int? {
        var winnerFirmID = 0
        if let rawWinner = result.userInfoDic[kATWinLossAuthNetworkKey] ?? result.userInfoDic["network_firm_id"] {
            winnerFirmID = Int("\(rawWinner)".trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
        }
        // TopOn 自有广告（MyOffer: 35, Cross Promotion: 42, ADX: 66, Direct: 67）
        let ownFirmIDs: Set<Int> = [35, 42, 66, 67]
        if winnerFirmID > 0 {
            if currentNetworkFirmID > 0 && winnerFirmID == currentNetworkFirmID {
                return result.lossReasonType == .withLowPriceInNormal
                    ? AlxAdConstant.BIDDING_ADN_ID.SAME_TO_NORMAL
                    : AlxAdConstant.BIDDING_ADN_ID.SAME_TO_BIDDING
            }
            if ownFirmIDs.contains(winnerFirmID) {
                return AlxAdConstant.BIDDING_ADN_ID.OWN
            }
            return AlxAdConstant.BIDDING_ADN_ID.OTHER
        }
        if result.lossReasonType == .withLowPriceInNormal || result.lossReasonType == .withLowPriceInHB {
            return AlxAdConstant.BIDDING_ADN_ID.OTHER
        }
        return nil
    }

    @objc public override func initializeClassName() -> AnyClass {
        return AlxTopOnInitAdapter.self
    }
}
