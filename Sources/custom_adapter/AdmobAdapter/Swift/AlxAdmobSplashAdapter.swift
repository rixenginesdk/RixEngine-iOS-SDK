//
//  AlxAdmobSplashAdapter.swift
//  AlxAdsDemo
//

import Foundation
import UIKit
import GoogleMobileAds
import AlxAds

@objcMembers
@objc(AlxAdmobSplashAdapter)
public class AlxAdmobSplashAdapter: AlxAdmobBaseAdapter, MediationAppOpenAd {
    
    private static let TAG = "AlxAdmobSplashAdapter"
    
    private var splashAd: AlxSplashAd? = nil
    private var delegate: MediationAppOpenAdEventDelegate? = nil
    private var completionHandler: GADMediationAppOpenLoadCompletionHandler? = nil
    
    public func loadAppOpenAd(for adConfiguration: GADMediationAppOpenAdConfiguration, completionHandler: @escaping GADMediationAppOpenLoadCompletionHandler) {
        NSLog("%@: loadAppOpenAd", AlxAdmobSplashAdapter.TAG)
        guard let params = AlxAdmobBaseAdapter.parseAdparameter(for: adConfiguration.credentials) else {
            let errorStr = "The parameter field is not found in the adConfiguration object"
            NSLog("%@: config params is empty", AlxAdmobSplashAdapter.TAG)
            self.delegate = completionHandler(nil, self.error(code: -100, msg: errorStr))
            return
        }
        
        if !AlxAdmobBaseAdapter.isInitialized {
            AlxAdmobBaseAdapter.initSdk(for: params)
        }
        
        guard let adId = params["unitid"] as? String, !adId.isEmpty else {
            let errorStr = "unitid is empty in the parameter configuration"
            NSLog("%@: error: %@", AlxAdmobSplashAdapter.TAG, errorStr)
            self.delegate = completionHandler(nil, self.error(code: -100, msg: errorStr))
            return
        }
        
        NSLog("%@: loadAppOpenAd unitid=%@", AlxAdmobSplashAdapter.TAG, adId)
        self.completionHandler = completionHandler
        
        // autoCloseOnFinish 配置（默认 false）
        var autoClose: Bool = false
        if let v = params["autoCloseOnFinish"] as? Bool {
            autoClose = v
        } else if let v = params["auto_close"] as? Bool {
            autoClose = v
        } else if let v = params["is_auto_close"] as? Bool {
            autoClose = v
        }
        
        // 开始加载广告
        // Load ad
        self.splashAd = AlxSplashAd()
        self.splashAd?.delegate = self
        self.splashAd?.autoCloseOnFinish = autoClose
        
        // 扩展字段
        let req = AlxAdRequest().withUserExt([
            "bid_floor": "1.68"
        ])
        self.splashAd?.loadAd(adUnitId: adId, request: req)
    }
    
    public func present(from viewController: UIViewController) {
        NSLog("%@: present", AlxAdmobSplashAdapter.TAG)
        DispatchQueue.main.async {
            if let splashAd = self.splashAd, splashAd.isReady() {
                splashAd.showAd(present: viewController)
            } else {
                let errorStr = "Splash ad is not ready to present"
                NSLog("%@: error: %@", AlxAdmobSplashAdapter.TAG, errorStr)
                self.delegate?.didFailToPresentWithError(self.error(code: -101, msg: errorStr))
            }
        }
    }
}

// MARK: - AlxSplashAdDelegate
extension AlxAdmobSplashAdapter: AlxSplashAdDelegate {
    
    public func splashAdDidLoad(_ ad: AlxSplashAd) {
        NSLog("%@: splashAdDidLoad", AlxAdmobSplashAdapter.TAG)
        if let handler = self.completionHandler {
            self.delegate = handler(self, nil)
        }
    }
    
    public func splashAdDidFailToLoad(_ ad: AlxSplashAd, didFailWithError error: Error) {
        NSLog("%@: splashAdDidFailToLoad: %@", AlxAdmobSplashAdapter.TAG, error.localizedDescription)
        if let handler = self.completionHandler {
            self.delegate = handler(nil, error)
        }
    }
    
    public func splashAdDidShow(_ ad: AlxSplashAd) {
        NSLog("%@: splashAdDidShow", AlxAdmobSplashAdapter.TAG)
        self.delegate?.willPresentFullScreenView()
        self.delegate?.reportImpression()
    }
    
    public func splashAdDidClick(_ ad: AlxSplashAd) {
        NSLog("%@: splashAdDidClick", AlxAdmobSplashAdapter.TAG)
        self.delegate?.reportClick()
    }
    
    public func splashAdDidClose(_ ad: AlxSplashAd) {
        NSLog("%@: splashAdDidClose", AlxAdmobSplashAdapter.TAG)
        self.delegate?.didDismissFullScreenView()
    }
    
    public func splashAdRenderDidFail(_ ad: AlxSplashAd, didFailWithError error: Error) {
        NSLog("%@: splashAdRenderDidFail: %@", AlxAdmobSplashAdapter.TAG, error.localizedDescription)
        self.delegate?.didFailToPresentWithError(error)
    }
    
    public func splashAdCountdown(_ ad: AlxSplashAd, countdown: Int) {
        NSLog("%@: splashAdCountdown: %ld", AlxAdmobSplashAdapter.TAG, countdown)
    }
}
