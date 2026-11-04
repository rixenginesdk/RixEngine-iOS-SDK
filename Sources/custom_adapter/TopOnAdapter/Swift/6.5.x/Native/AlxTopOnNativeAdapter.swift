//
//  AlxTopOnNativeAdapter.swift
//  AlxAdsDemo
//

import Foundation
import AnyThinkSDK
import AlxAds

@objc(AlxTopOnNativeAdapter)
public class AlxTopOnNativeAdapter: AlxTopOnBaseAdapter, ATBaseNativeAdapterProtocol {
    
    private static let TAG = "AlxTopOnNativeAdapter"
    
    @objc public var adStatusBridge: ATNativeAdStatusBridge!
    
    private var nativeAdLoader: AlxNativeAdLoader?
    private var nativeAd: AlxNativeAd?
    private lazy var nativeDelegate: AlxTopOnNativeDelegate = {
        let delegate = AlxTopOnNativeDelegate()
        delegate.adStatusBridge = self.adStatusBridge
        return delegate
    }()
    private lazy var nativeEvent: AlxTopOnNativeEvent = {
        return AlxTopOnNativeEvent(info: [:], localInfo: [:])
    }()
    
    // MARK: - 广告加载 / Ad Load
    
    @objc public override func loadAD(with argument: ATAdMediationArgument) {
        print("\(AlxTopOnNativeAdapter.TAG): loadAD(with:)")
        print("\(AlxTopOnNativeAdapter.TAG): loadAD: isMainThread=\(Thread.current.isMainThread ? "YES" : "NO")")
        
        DispatchQueue.main.async {
            self.nativeDelegate = AlxTopOnNativeDelegate()
            self.nativeDelegate.adStatusBridge = self.adStatusBridge
            self.nativeAd = nil
            let bindBiddingAd = self.beginBiddingRequest(with: argument)
            self.nativeDelegate.onAdLoaded = { [weak self] ad in
                guard bindBiddingAd(ad) else { return false }
                self?.nativeAd = ad as? AlxNativeAd
                return true
            }
            guard let unitId = AlxTopOnBaseManager.parseUnitID(from: argument.serverContentDic), !unitId.isEmpty else {
                let errorStr = "unitid is empty"
                print("\(AlxTopOnNativeAdapter.TAG): loadAD: error = \(errorStr)")
                let error = AlxTopOnBaseManager.error(code: -100, msg: errorStr)
                self.notifyLoadFailed(error: error)
                return
            }
            print("\(AlxTopOnNativeAdapter.TAG): loadAD: unitid = \(unitId)")
            
            self.nativeAdLoader = AlxNativeAdLoader(adUnitID: unitId)
            self.nativeAdLoader?.delegate = self.getNativeDelegate()
            self.nativeDelegate.nativeEvent = self.nativeEvent

            print("\(AlxTopOnNativeAdapter.TAG): start loading ad with unitId: \(unitId)")
            let req = self.buildAdRequest(with: argument)
            self.nativeAdLoader?.loadAd(request: req)
        }
    }
    
    // MARK: - 渲染类 / Renderer Class
    
    @objc public static func rendererClass() -> AnyClass {
        print("\(AlxTopOnNativeAdapter.TAG): rendererClass")
        return AlxTopOnNativeRender.self
    }
    
    // MARK: - 辅助方法 / Helper Methods
    
    private func getNativeDelegate() -> AlxTopOnNativeDelegate {
        self.nativeDelegate.adStatusBridge = self.adStatusBridge
        return self.nativeDelegate
    }
    
    // MARK: - 动态调用辅助方法 / Dynamic Invocation Helper Methods
    
    private func notifyNativeAdLoaded(objects: [AlxTopOnNativeObject], adExtra: [AnyHashable: Any]) {
        if let bridge = self.adStatusBridge {
            let selector = NSSelectorFromString("atOnNativeAdLoadedArray:adExtra:")
            if bridge.responds(to: selector) {
                bridge.perform(selector, with: objects, with: adExtra)
            }
        }
    }
    
    private func notifyLoadFailed(error: Error) {
        if let bridge = self.adStatusBridge {
            let emptyDict: [AnyHashable: Any] = [:]
            let selector = NSSelectorFromString("atOnAdLoadFailed:adExtra:")
            if bridge.responds(to: selector) {
                bridge.perform(selector, with: error, with: emptyDict)
            }
        }
    }
}
