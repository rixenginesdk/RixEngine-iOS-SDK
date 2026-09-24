//
//  AlxTopOnSplashAdapter.swift
//  RixEngineAds
//
//  Created on 2026/9/18.
//

import Foundation
import UIKit
import AnyThinkSDK
import AlxAds

@objc(AlxTopOnSplashAdapter)
public class AlxTopOnSplashAdapter: ATAdAdapter {
    
    private static let TAG = "AlxTopOnSplashAdapter"
    
    private var splashAd: AlxSplashAd?
    private var customEvent: AlxTopOnSplashEvent?
    
    // MARK: - 初始化 / Initialization
    @objc public required init(networkCustomInfo serverInfo: [AnyHashable: Any],
                               localInfo: [AnyHashable: Any]) {
        super.init()
        NSLog("%@: init", AlxTopOnSplashAdapter.TAG)
        if !AlxTopOnBaseManager.isInitialized {
            AlxTopOnBaseManager.initSDK(serverInfo: serverInfo)
        }
    }
    
    // MARK: - 广告加载 / Ad Load
    @objc public func loadAD(withInfo serverInfo: [AnyHashable: Any],
                             localInfo: [AnyHashable: Any],
                             completion: @escaping ([[AnyHashable: Any]]?, (any Error)?) -> Void) {
        NSLog("%@: loadAD", AlxTopOnSplashAdapter.TAG)
        NSLog("%@: loadAD: isMainThread=%@", AlxTopOnSplashAdapter.TAG, Thread.current.isMainThread ? "YES" : "NO")
        
        DispatchQueue.main.async {
            if !AlxTopOnBaseManager.isInitialized {
                AlxTopOnBaseManager.initSDK(serverInfo: serverInfo)
            }
            
            let bidId = serverInfo[kATAdapterCustomInfoBuyeruIdKey] as? String
            NSLog("%@: loadAD: bidId=%@", AlxTopOnSplashAdapter.TAG, bidId ?? "nil")
            
            guard let unitId = serverInfo[AlxTopOnBaseManager.unitID] as? String, !unitId.isEmpty else {
                let errorStr = "unitid is empty"
                NSLog("%@: loadAD: error = %@", AlxTopOnSplashAdapter.TAG, errorStr)
                completion(nil, AlxTopOnBaseManager.error(code: -100, msg: errorStr))
                return
            }
            NSLog("%@: loadAD: unitid = %@", AlxTopOnSplashAdapter.TAG, unitId)
            
            // 提取自定义底部视图 (若有)
            var bottomView: UIView? = nil
            if let customBottom = localInfo[kATSplashExtraNewBottomViewKey] as? UIView {
                bottomView = customBottom
            } else if let customBottom = serverInfo[kATSplashExtraNewBottomViewKey] as? UIView {
                bottomView = customBottom
            } else if let customBottom = localInfo[kATSplashExtraContainerViewKey] as? UIView {
                bottomView = customBottom
            }
            
            // 提取 autoCloseOnFinish 配置 (若有，默认 false)
            var autoClose: Bool = false
            if let v = localInfo["autoCloseOnFinish"] as? Bool {
                autoClose = v
            } else if let v = serverInfo["autoCloseOnFinish"] as? Bool {
                autoClose = v
            } else if let v = localInfo["auto_close"] as? Bool {
                autoClose = v
            } else if let v = serverInfo["auto_close"] as? Bool {
                autoClose = v
            } else if let v = localInfo["is_auto_close"] as? Bool {
                autoClose = v
            } else if let v = serverInfo["is_auto_close"] as? Bool {
                autoClose = v
            }
            
            if bidId != nil {
                // Bidding 场景：从缓存中取出已加载的广告
                let request = AlxTopOnTool.shared.getRequestItem(withUnitID: unitId) as? AlxTopOnBiddingRequest
                if let request = request {
                    self.customEvent = request.customEvent as? AlxTopOnSplashEvent
                    self.customEvent?.requestCompletionBlock = completion
                    self.splashAd = request.customObject as? AlxSplashAd
                    if let bottomView = bottomView {
                        self.splashAd?.customBottomView = bottomView
                    }
                    self.splashAd?.autoCloseOnFinish = autoClose
                    
                    if let splashAd = self.splashAd {
                        self.customEvent?.trackSplashAdLoaded(splashAd, adExtra: nil)
                    } else {
                        NSLog("%@: loadAD: bid ad object is empty", AlxTopOnSplashAdapter.TAG)
                        completion(nil, AlxTopOnBaseManager.error(code: -100, msg: "Bid ad object is empty"))
                    }
                } else {
                    NSLog("%@: loadAD: bid request not found in cache", AlxTopOnSplashAdapter.TAG)
                    completion(nil, AlxTopOnBaseManager.error(code: -100, msg: "Bid request not found in cache"))
                }
                AlxTopOnTool.shared.removeRequestItem(withUnitID: unitId)
            } else {
                // 普通加载场景
                self.customEvent = AlxTopOnSplashEvent(info: serverInfo, localInfo: localInfo)
                self.customEvent?.requestCompletionBlock = completion
                
                let ad = AlxSplashAd()
                ad.delegate = self.customEvent
                if let bottomView = bottomView {
                    ad.customBottomView = bottomView
                }
                ad.autoCloseOnFinish = autoClose
                self.splashAd = ad
                
                ad.loadAd(adUnitId: unitId)
            }
        }
    }
    
    // MARK: - C2S Header Bidding 竞价
    @objc public static func bidRequestWithPlacementModel(_ placementModel: ATPlacementModel,
                                                          unitGroupModel: ATUnitGroupModel,
                                                          info: [AnyHashable: Any],
                                                          completion: @escaping (ATBidInfo?, Error?) -> Void) {
        NSLog("%@: bidRequestWithPlacementModel", AlxTopOnSplashAdapter.TAG)
        NSLog("%@: bidRequestWithPlacementModel: isMainThread=%@", AlxTopOnSplashAdapter.TAG, Thread.current.isMainThread ? "YES" : "NO")
        
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
    
    @objc(loadWithServerInfo:localInfo:)
    public func loadWithServerInfo(_ serverInfo: [AnyHashable: Any], localInfo: [AnyHashable: Any]) {
        NSLog("%@: loadWithServerInfo", AlxTopOnSplashAdapter.TAG)
    }
    
    // MARK: - 广告就绪检查 / Ad Readiness Check
    @objc public static func adReady(withCustomObject customObject: Any, info: [AnyHashable: Any]) -> Bool {
        NSLog("%@: adReady", AlxTopOnSplashAdapter.TAG)
        if let splashAd = customObject as? AlxSplashAd {
            let ready = splashAd.isReady()
            NSLog("%@: adReady: %d", AlxTopOnSplashAdapter.TAG, ready ? 1 : 0)
            return ready
        } else {
            NSLog("%@: adReady false", AlxTopOnSplashAdapter.TAG)
            return false
        }
    }
    
    // MARK: - 广告展示 / Ad Display
    @objc(showSplash:localInfo:delegate:)
    public static func showSplash(_ splash: ATSplash,
                                  localInfo: [AnyHashable: Any],
                                  delegate: ATSplashDelegate) {
        NSLog("%@: showSplash:localInfo:delegate:", AlxTopOnSplashAdapter.TAG)
        guard let splashAd = (splash.customObject as? AlxSplashAd) else {
            NSLog("%@: showSplash: splashAd object is nil", AlxTopOnSplashAdapter.TAG)
            return
        }
        
        splash.customEvent.delegate = delegate
        
        // 自定义底部视图
        if let customBottom = localInfo[kATSplashExtraNewBottomViewKey] as? UIView {
            splashAd.customBottomView = customBottom
        } else if let customBottom = localInfo[kATSplashExtraContainerViewKey] as? UIView {
            splashAd.customBottomView = customBottom
        }
        
        // autoCloseOnFinish
        if let v = localInfo["autoCloseOnFinish"] as? Bool {
            splashAd.autoCloseOnFinish = v
        } else if let v = localInfo["auto_close"] as? Bool {
            splashAd.autoCloseOnFinish = v
        } else if let v = localInfo["is_auto_close"] as? Bool {
            splashAd.autoCloseOnFinish = v
        }
        
        if splashAd.isReady() {
            if let window = localInfo[kATSplashExtraWindowKey] as? UIWindow {
                splashAd.showAd(inWindow: window)
            } else if let vc = localInfo[kATSplashExtraInViewControllerKey] as? UIViewController {
                splashAd.showAd(present: vc)
            } else if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first {
                splashAd.showAd(inWindow: window)
            } else if let rootVc = (UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first)?.rootViewController {
                splashAd.showAd(present: rootVc)
            } else {
                NSLog("%@: showSplash: unable to find window or viewController to present splash", AlxTopOnSplashAdapter.TAG)
            }
        } else {
            NSLog("%@: showSplash: splashAd is not ready", AlxTopOnSplashAdapter.TAG)
        }
    }
}
