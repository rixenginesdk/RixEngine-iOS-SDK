//
//  AlxTopOnSplashAdapter.swift
//  AlxAdsDemo
//
//  TopOn 6.5.x 新架构
//

import Foundation
import UIKit
import AnyThinkSDK
import AlxAds

@objc(AlxTopOnSplashAdapter)
public class AlxTopOnSplashAdapter: AlxTopOnBaseAdapter, ATBaseSplashAdapterProtocol {
    
    private static let TAG = "AlxTopOnSplashAdapter"
    
    @objc public var adStatusBridge: ATSplashAdStatusBridge!
    
    private var splashAd: AlxSplashAd?
    private var splashDelegate: AlxTopOnSplashDelegate?
    
    // MARK: - 懒加载 / Lazy Load
    private func getSplashDelegate() -> AlxTopOnSplashDelegate {
        if splashDelegate == nil {
            splashDelegate = AlxTopOnSplashDelegate()
            splashDelegate?.adStatusBridge = self.adStatusBridge
        }
        return splashDelegate!
    }
    
    // MARK: - 广告加载 / Ad Load (ATBaseSplashAdapterProtocol)
    @objc public override func loadAD(with argument: ATAdMediationArgument) {
        NSLog("%@: loadAD", AlxTopOnSplashAdapter.TAG)
        NSLog("%@: loadAD: isMainThread=%@", AlxTopOnSplashAdapter.TAG, Thread.current.isMainThread ? "YES" : "NO")
        
        let bidId = argument.serverContentDic[kATAdapterCustomInfoBuyeruIdKey] as? String
        NSLog("%@: loadAD: bidId=%@", AlxTopOnSplashAdapter.TAG, bidId ?? "空")
        
        DispatchQueue.main.async {
            let unitIdKey = AlxTopOnBaseManager.unitID
            #if DEBUG
            let unitId = "203688"
            #else
            guard let unitId = argument.serverContentDic[unitIdKey] as? String, !unitId.isEmpty else {
                let errorStr = "unitid is empty"
                NSLog("%@: loadAD: error = %@", AlxTopOnSplashAdapter.TAG, errorStr)
                let error = AlxTopOnBaseManager.error(code: -100, msg: errorStr)
                self.notifyLoadFailed(error: error)
                return
            }
            #endif
            NSLog("%@: loadAD: unitid = %@", AlxTopOnSplashAdapter.TAG, unitId)
            
            // 提取自定义底部视图 (若有)
            var bottomView: UIView? = nil
            if let customBottom = argument.localInfoDic[kATSplashExtraNewBottomViewKey] as? UIView {
                bottomView = customBottom
            } else if let customBottom = argument.serverContentDic[kATSplashExtraNewBottomViewKey] as? UIView {
                bottomView = customBottom
            } else if let customBottom = argument.localInfoDic[kATSplashExtraContainerViewKey] as? UIView {
                bottomView = customBottom
            }
            
            // 提取 autoCloseOnFinish 配置 (若有，默认 false)
            var autoClose: Bool = false
            if let v = argument.localInfoDic["autoCloseOnFinish"] as? Bool {
                autoClose = v
            } else if let v = argument.serverContentDic["autoCloseOnFinish"] as? Bool {
                autoClose = v
            } else if let v = argument.localInfoDic["auto_close"] as? Bool {
                autoClose = v
            } else if let v = argument.serverContentDic["auto_close"] as? Bool {
                autoClose = v
            } else if let v = argument.localInfoDic["is_auto_close"] as? Bool {
                autoClose = v
            } else if let v = argument.serverContentDic["is_auto_close"] as? Bool {
                autoClose = v
            }
            
            if bidId != nil {
                // Bidding 场景：从缓存中取出已加载的广告
                if let biddingRequest = AlxTopOnTool.shared.getRequestItem(withUnitID: unitId) as? AlxTopOnBiddingRequest {
                    self.splashAd = biddingRequest.customObject as? AlxSplashAd
                    if let bottomView = bottomView {
                        self.splashAd?.customBottomView = bottomView
                    }
                    self.splashAd?.autoCloseOnFinish = autoClose
                    
                    if let splashAd = self.splashAd {
                        NSLog("%@: loadAD: bid ad loaded, notify success", AlxTopOnSplashAdapter.TAG)
                        var adExtra: [AnyHashable: Any] = [:]
                        adExtra[kATAdAssetsCustomObjectKey] = splashAd
                        self.notifySplashLoaded(adExtra: adExtra)
                    } else {
                        NSLog("%@: loadAD: bid ad object is empty", AlxTopOnSplashAdapter.TAG)
                        let error = NSError(domain: "AlxTopOnAdapter", code: -100, userInfo: [NSLocalizedDescriptionKey: "Bid ad object is empty"])
                        self.notifyLoadFailed(error: error)
                    }
                } else {
                    NSLog("%@: loadAD: bid request not found in cache", AlxTopOnSplashAdapter.TAG)
                    let error = NSError(domain: "AlxTopOnAdapter", code: -100, userInfo: [NSLocalizedDescriptionKey: "Bid request not found"])
                    self.notifyLoadFailed(error: error)
                }
                AlxTopOnTool.shared.removeRequestItem(withUnitID: unitId)
            } else {
                // 普通加载场景
                self.splashAd = AlxSplashAd()
                self.splashAd?.delegate = self.getSplashDelegate()
                self.splashDelegate?.splashAd = self.splashAd
                self.splashAd?.customBottomView = bottomView
                self.splashAd?.autoCloseOnFinish = autoClose
                
                NSLog("%@: start loading splash ad with unitId: %@", AlxTopOnSplashAdapter.TAG, unitId)
                let req = AlxAdRequest().withUserExt([
                    "bid_floor": "1.68"
                ])
                self.splashAd?.loadAd(adUnitId: unitId, request: req)
            }
        }
    }
    
    // MARK: - 辅助通知方法
    private func notifySplashLoaded(adExtra: [AnyHashable: Any]) {
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnSplashAdLoadedExtra:")
            if bridge.responds(to: selector) {
                bridge.perform(selector, with: adExtra)
            }
        }
    }
    
    private func notifyLoadFailed(error: Error) {
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnAdLoadFailed:adExtra:")
            if bridge.responds(to: selector) {
                bridge.perform(selector, with: error, with: nil)
            }
        }
    }
    
    // MARK: - C2S Header Bidding 竞价
    @objc public static func bidRequestWithPlacementModel(_ placementModel: ATPlacementModel,
                                                          unitGroupModel: ATUnitGroupModel,
                                                          info: [AnyHashable: Any],
                                                          completion: @escaping (ATBidInfo?, Error?) -> Void) {
        NSLog("%@: bidRequestWithPlacementModel", AlxTopOnSplashAdapter.TAG)
        
        DispatchQueue.main.async {
            if !AlxTopOnBaseManager.isInitialized {
                AlxTopOnBaseManager.initSDK(serverInfo: info)
            }
        }
        
        let customEvent = AlxTopOnSplashEvent(info: info, localInfo: info)
        customEvent.isC2SBiding = true
        
        let request = AlxTopOnBiddingRequest(
            unitGroup: unitGroupModel,
            customEvent: customEvent,
            unitID: info[AlxTopOnBaseManager.unitID] as? String,
            placementID: placementModel.placementID,
            extraInfo: info,
            adType: ATAdFormat.splash,
            bidCompletion: completion
        )
        AlxTopOnBiddingRequestManager.shared.start(with: request)
    }
    
    // MARK: - 广告就绪检查
    @objc public func adReadySplash(withInfo info: [AnyHashable: Any]) -> Bool {
        NSLog("%@: adReadySplashWithInfo", AlxTopOnSplashAdapter.TAG)
        if let ad = self.splashAd, ad.isReady() {
            NSLog("%@: adReady = YES", AlxTopOnSplashAdapter.TAG)
            return true
        }
        NSLog("%@: adReady = NO", AlxTopOnSplashAdapter.TAG)
        return false
    }
    
    @objc public static func adReady(withCustomObject customObject: Any, info: [AnyHashable: Any]) -> Bool {
        if let splashAd = customObject as? AlxSplashAd {
            return splashAd.isReady()
        }
        return false
    }
    
    // MARK: - 广告展示 (ATBaseSplashAdapterProtocol)
    @objc(showSplashAdInWindow:inViewController:parameter:)
    public func showSplashAd(in window: UIWindow, in inViewController: UIViewController, parameter: [AnyHashable: Any]?) {
        NSLog("%@: showSplashAdInWindow:inViewController:parameter:", AlxTopOnSplashAdapter.TAG)
        DispatchQueue.main.async {
            guard let splashAd = self.splashAd else {
                NSLog("%@: splashAd is nil", AlxTopOnSplashAdapter.TAG)
                return
            }
            
            // 检查是否有自定义底部视图
            if let param = parameter {
                if let customBottom = param[kATSplashExtraNewBottomViewKey] as? UIView {
                    splashAd.customBottomView = customBottom
                } else if let customBottom = param[kATSplashExtraContainerViewKey] as? UIView {
                    splashAd.customBottomView = customBottom
                }
                
                if let v = param["autoCloseOnFinish"] as? Bool {
                    splashAd.autoCloseOnFinish = v
                } else if let v = param["auto_close"] as? Bool {
                    splashAd.autoCloseOnFinish = v
                } else if let v = param["is_auto_close"] as? Bool {
                    splashAd.autoCloseOnFinish = v
                }
            }
            
            splashAd.showAd(inWindow: window)
        }
    }
}
