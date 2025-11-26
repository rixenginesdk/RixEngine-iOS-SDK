//
//  AlxTopOnBiddingRequest.swift
//

import Foundation
import AnyThinkSDK

@objc(AlxTopOnBiddingRequest)
public class AlxTopOnBiddingRequest:NSObject {
    
    /// 广告单元组模型
    @objc public var unitGroup: ATUnitGroupModel
    
    /// 自定义事件
    @objc public var customEvent: ATAdCustomEvent
    
    /// Unit ID
    @objc public var unitID: String?
    
    /// Placement ID
    @objc public var placementID: String?
    
    /// 额外信息
    @objc public var extraInfo: [AnyHashable: Any]
    
    /// 广告类型（横幅、插屏、激励视频等）
    @objc public var adType: ATAdFormat
    
    /// 竞价完成回调
    @objc public var bidCompletion: ((ATBidInfo?, Error?) -> Void)?
    
    /// 自定义对象（如 AlxInterstitialAd）
    @objc public var customObject: Any?
    
//    @objc public override init() {
//        super.init()
//    }
    
    @objc public init(
        unitGroup: ATUnitGroupModel,
        customEvent: ATAdCustomEvent,
        unitID: String? = nil,
        placementID: String? = nil,
        extraInfo: [AnyHashable: Any],
        adType: ATAdFormat,
        bidCompletion: ((ATBidInfo?, Error?) -> Void)?=nil
    ) {
        self.unitGroup = unitGroup
        self.customEvent = customEvent
        self.unitID = unitID
        self.placementID = placementID
        self.extraInfo = extraInfo
        self.adType = adType
        self.bidCompletion = bidCompletion
        
        super.init()
    }
    
    deinit {
        print("AlxTopOnBiddingRequest: deinit")
    }
    
    
}
