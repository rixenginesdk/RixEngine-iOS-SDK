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
        print("\(AlxTopOnSplashAdapter.TAG): loadAD")
        print("\(AlxTopOnSplashAdapter.TAG): loadAD: isMainThread=\(Thread.current.isMainThread ? "YES" : "NO")")
        
        DispatchQueue.main.async {
            self.splashDelegate = AlxTopOnSplashDelegate()
            self.splashDelegate?.adStatusBridge = self.adStatusBridge
            self.splashDelegate?.onAdLoaded = self.beginBiddingRequest(with: argument)
            guard let unitId = AlxTopOnBaseManager.parseUnitID(from: argument.serverContentDic), !unitId.isEmpty else {
                let errorStr = "unitid is empty"
                print("\(AlxTopOnSplashAdapter.TAG): loadAD: error = \(errorStr)")
                let error = AlxTopOnBaseManager.error(code: -100, msg: errorStr)
                self.notifyLoadFailed(error: error)
                return
            }
            print("\(AlxTopOnSplashAdapter.TAG): loadAD: unitid = \(unitId)")
            
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
            
            self.splashAd = AlxSplashAd()
            self.splashAd?.delegate = self.getSplashDelegate()
            self.splashDelegate?.splashAd = self.splashAd
            self.splashAd?.customBottomView = bottomView
            self.splashAd?.autoCloseOnFinish = autoClose

            print("\(AlxTopOnSplashAdapter.TAG): start loading splash ad with unitId: \(unitId)")
            let req = self.buildAdRequest(with: argument)
            self.splashAd?.loadAd(adUnitId: unitId, request: req)
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
    
    // MARK: - 广告就绪检查
    @objc public func adReadySplash(withInfo info: [AnyHashable: Any]) -> Bool {
        print("\(AlxTopOnSplashAdapter.TAG): adReadySplashWithInfo")
        if let ad = self.splashAd, ad.isReady() {
            print("\(AlxTopOnSplashAdapter.TAG): adReady = YES")
            return true
        }
        print("\(AlxTopOnSplashAdapter.TAG): adReady = NO")
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
        print("\(AlxTopOnSplashAdapter.TAG): showSplashAdInWindow:inViewController:parameter:")
        DispatchQueue.main.async {
            guard let splashAd = self.splashAd else {
                print("\(AlxTopOnSplashAdapter.TAG): splashAd is nil")
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
