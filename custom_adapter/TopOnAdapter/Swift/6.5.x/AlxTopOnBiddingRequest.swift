//
//  AlxTopOnBiddingRequest.swift
//

import Foundation
import AnyThinkSDK

@objc(AlxTopOnBiddingRequest)
public class AlxTopOnBiddingRequest:NSObject {
    
    /**
     * 广告单元组模型。
     * Ad unit group model.
     */
    @objc public var unitGroup: ATUnitGroupModel
    
    /**
     * 自定义事件。
     * Custom event.
     */
    @objc public var customEvent: ATAdCustomEvent
    
    /// Unit ID
    @objc public var unitID: String?
    
    /// Placement ID
    @objc public var placementID: String?
    
    /**
     * 额外信息。
     * Extra information.
     */
    @objc public var extraInfo: [AnyHashable: Any]
    
    /**
     * 广告类型（横幅、插屏、激励视频等）。
     * Ad type (banner, interstitial, rewarded video, etc.).
     */
    @objc public var adType: ATAdFormat
    
    /**
     * 竞价完成回调。
     * Bidding completion callback.
     */
    @objc public var bidCompletion: ((ATBidInfo?, Error?) -> Void)?
    
    /**
     * 自定义对象（如 AlxInterstitialAd）。
     * Custom object (e.g., AlxInterstitialAd).
     */
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
