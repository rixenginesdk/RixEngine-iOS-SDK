//
//  AlxTopOnInterstitialAdapter.swift
//

import Foundation
import AnyThinkSDK
import AlxAds

@objc(AlxTopOnInterstitialAdapter)
public class AlxTopOnInterstitialAdapter: AlxTopOnBaseAdapter, ATBaseInterstitialAdapterProtocol {
    
    private static let TAG = "AlxTopOnInterstitialAdapter"
    
    private var interstitialAd: AlxInterstitialAd?
    private lazy var interstitialDelegate: AlxTopOnInterstitialDelegate = {
        let delegate = AlxTopOnInterstitialDelegate()
        delegate.adStatusBridge = self.adStatusBridge
        return delegate
    }()
    
    // MARK: - ATBaseInterstitialAdapterProtocol
    
    @objc public var adStatusBridge: ATInterstitialAdStatusBridge!
    
    // MARK: - 广告加载 / Ad Load
    
    @objc public override func loadAD(with argument: ATAdMediationArgument) {
        print("\(AlxTopOnInterstitialAdapter.TAG): loadAD(with:)")
        print("\(AlxTopOnInterstitialAdapter.TAG): loadAD: isMainThread=\(Thread.current.isMainThread ? "YES" : "NO")")
        
        DispatchQueue.main.async {
            self.interstitialDelegate = AlxTopOnInterstitialDelegate()
            self.interstitialDelegate.adStatusBridge = self.adStatusBridge
            self.interstitialDelegate.onAdLoaded = self.beginBiddingRequest(with: argument)
            guard let unitId = AlxTopOnBaseManager.parseUnitID(from: argument.serverContentDic), !unitId.isEmpty else {
                let errorStr = "unitid is empty"
                print("\(AlxTopOnInterstitialAdapter.TAG): loadAD: error = \(errorStr)")
                let error = AlxTopOnBaseManager.error(code: -100, msg: errorStr)
                self.notifyLoadFailed(error: error)
                return
            }
            print("\(AlxTopOnInterstitialAdapter.TAG): loadAD: unitid = \(unitId)")
            
            self.interstitialAd = AlxInterstitialAd()
            self.interstitialAd?.delegate = self.getInterstitialDelegate()
            self.interstitialDelegate.interstitialAd = self.interstitialAd

            print("\(AlxTopOnInterstitialAdapter.TAG): start loading ad with unitId: \(unitId)")
            let req = self.buildAdRequest(with: argument)
            self.interstitialAd?.loadAd(adUnitId: unitId, request: req)
        }
    }
    
    private func getInterstitialDelegate() -> AlxTopOnInterstitialDelegate {
        self.interstitialDelegate.adStatusBridge = self.adStatusBridge
        return self.interstitialDelegate
    }
    
    // MARK: - 动态调用辅助方法 / Dynamic Invocation Helper Methods
    
    private func notifyInterstitialLoaded(adExtra: [AnyHashable: Any]) {
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnInterstitialAdLoadedExtra:")
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
    
    @objc public func adReadyInterstitial(withInfo info: [AnyHashable: Any]) -> Bool {
        print("\(AlxTopOnInterstitialAdapter.TAG): adReadyInterstitialWithInfo")
        
        if self.interstitialAd != nil {
            print("\(AlxTopOnInterstitialAdapter.TAG): adReady = YES")
            return true
        }
        
        print("\(AlxTopOnInterstitialAdapter.TAG): adReady = NO")
        return false
    }
    
    // MARK: - 展示广告（实例方法）/ Show Ad (Instance Method)
    
    @objc(showInterstitialInViewController:)
    public func showInterstitial(in viewController: UIViewController) {
        print("\(AlxTopOnInterstitialAdapter.TAG): showInterstitialInViewController")
        
        DispatchQueue.main.async {
            if let interstitialAd = self.interstitialAd {
                interstitialAd.showAd(present: viewController)
                print("\(AlxTopOnInterstitialAdapter.TAG): ad shown")
            } else {
                print("\(AlxTopOnInterstitialAdapter.TAG): interstitialAd is nil")
            }
        }
    }
}
