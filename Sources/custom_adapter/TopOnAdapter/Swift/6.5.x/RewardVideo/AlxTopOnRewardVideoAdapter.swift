//
//  AlxTopOnRewardVideoAdapter.swift
//

import Foundation
import AnyThinkSDK
import AlxAds

@objc(AlxTopOnRewardVideoAdapter)
public class AlxTopOnRewardVideoAdapter: AlxTopOnBaseAdapter, ATBaseRewardedAdapterProtocol {
    
    private static let TAG = "AlxTopOnRewardVideoAdapter"
    
    private var rewardedAd: AlxRewardVideoAd?
    private lazy var rewardVideoDelegate: AlxTopOnRewardVideoDelegate = {
        let delegate = AlxTopOnRewardVideoDelegate()
        delegate.adStatusBridge = self.adStatusBridge
        return delegate
    }()
    
    // MARK: - ATBaseRewardedAdapterProtocol
    
    @objc public var adStatusBridge: ATRewardedAdStatusBridge!
    
    // MARK: - 广告加载 / Ad Load
    
    @objc public override func loadAD(with argument: ATAdMediationArgument) {
        print("\(AlxTopOnRewardVideoAdapter.TAG): loadAD(with:)")
        print("\(AlxTopOnRewardVideoAdapter.TAG): loadAD: isMainThread=\(Thread.current.isMainThread ? "YES" : "NO")")
        
        DispatchQueue.main.async {
            self.rewardVideoDelegate = AlxTopOnRewardVideoDelegate()
            self.rewardVideoDelegate.adStatusBridge = self.adStatusBridge
            self.rewardVideoDelegate.onAdLoaded = self.beginBiddingRequest(with: argument)
            guard let unitId = AlxTopOnBaseManager.parseUnitID(from: argument.serverContentDic), !unitId.isEmpty else {
                let errorStr = "unitid is empty"
                print("\(AlxTopOnRewardVideoAdapter.TAG): loadAD: error = \(errorStr)")
                let error = AlxTopOnBaseManager.error(code: -100, msg: errorStr)
                self.notifyLoadFailed(error: error)
                return
            }
            print("\(AlxTopOnRewardVideoAdapter.TAG): loadAD: unitid = \(unitId)")
            
            self.rewardedAd = AlxRewardVideoAd()
            self.rewardedAd?.delegate = self.getRewardVideoDelegate()
            self.rewardVideoDelegate.rewardedAd = self.rewardedAd

            print("\(AlxTopOnRewardVideoAdapter.TAG): start loading ad with unitId: \(unitId)")
            let req = self.buildAdRequest(with: argument)
            self.rewardedAd?.loadAd(adUnitId: unitId, request: req)
        }
    }
    
    private func getRewardVideoDelegate() -> AlxTopOnRewardVideoDelegate {
        self.rewardVideoDelegate.adStatusBridge = self.adStatusBridge
        return self.rewardVideoDelegate
    }
    
    // MARK: - 动态调用辅助方法 / Dynamic Invocation Helper Methods
    
    private func notifyRewardedAdLoaded(adExtra: [AnyHashable: Any]) {
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnRewardedAdLoadedExtra:")
            if bridge.responds(to: selector) {
                bridge.perform(selector, with: adExtra)
            }
        }
    }
    
    private func notifyLoadFailed(error: Error) {
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnAdLoadFailed:adExtra:")
            if bridge.responds(to: selector) {
                let emptyDict: [AnyHashable: Any] = [:]
                bridge.perform(selector, with: error, with: emptyDict)
            }
        }
    }
    
    // MARK: - 广告就绪检查（实例方法）/ Ad Ready Check (Instance Method)
    
    @objc public func adReadyRewarded(withInfo info: [AnyHashable: Any]) -> Bool {
        print("\(AlxTopOnRewardVideoAdapter.TAG): adReadyRewardedWithInfo")
        
        if self.rewardedAd != nil {
            print("\(AlxTopOnRewardVideoAdapter.TAG): adReady = YES")
            return true
        }
        
        print("\(AlxTopOnRewardVideoAdapter.TAG): adReady = NO")
        return false
    }
    
    // MARK: - 展示广告（实例方法）/ Show Ad (Instance Method)
    
    @objc(showRewardedVideoInViewController:)
    public func showRewardedVideo(in viewController: UIViewController) {
        print("\(AlxTopOnRewardVideoAdapter.TAG): showRewardedVideoInViewController")
        
        DispatchQueue.main.async {
            if let rewardedAd = self.rewardedAd {
                rewardedAd.showAd(present: viewController)
                print("\(AlxTopOnRewardVideoAdapter.TAG): ad shown")
            } else {
                print("\(AlxTopOnRewardVideoAdapter.TAG): rewardedAd is nil")
            }
        }
    }
}
