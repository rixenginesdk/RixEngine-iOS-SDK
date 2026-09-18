//
//  AlxTopOnInitAdapter.swift
//  AlxAdsDemo
//
//  直接翻译 OC 代码
//  Translated directly from OC code
//

import Foundation
import AnyThinkSDK
import AlxAds

@objc(AlxTopOnInitAdapter)
public class AlxTopOnInitAdapter: ATBaseInitAdapter {
    private static let TAG = "AlxTopOnBaseInitAdapter"
    
    @objc public override func initWith(_ adInitArgument: ATAdInitArgument) {
        NSLog("AlxTopOnInitAdapter: initWith")
        NSLog("%@: alx-sdk-version:%@", AlxTopOnInitAdapter.TAG, AlxSdk.getSDKVersion())
        NSLog("%@: topon-sdk-version:%@", AlxTopOnInitAdapter.TAG, ATAPI.sharedInstance().version())
        NSLog("%@: topon-adapter-version:%@", AlxTopOnInitAdapter.TAG, "\(self.adapterVersion() ?? "")")
        
        guard let appid = adInitArgument.serverContentDic["appid"] as? String,
              let sid = adInitArgument.serverContentDic["sid"] as? String,
              let token = adInitArgument.serverContentDic["token"] as? String else {
            let errorStr = "initialize alx params: appid or sid or token is empty"
            NSLog("AlxTopOnInitAdapter: error: \(errorStr)")
            let error = NSError(domain: "AlxTopOnAdapter", 
                              code: -100, 
                              userInfo: [NSLocalizedDescriptionKey: errorStr])
            notificationNetworkInitFail(error)
            return
        }
        
        let debug = adInitArgument.serverContentDic["isdebug"] as? String
        
        NSLog("AlxTopOnInitAdapter: appid = \(appid), sid = \(sid), token = \(token), debug = \(debug ?? "nil")")
        
        DispatchQueue.main.async {
            AlxSdk.initializeSDK(token: token, sid: sid, appId: appid)
            
            if let debug = debug, debug.count > 0 {
                if debug.lowercased() == "true" {
                    AlxSdk.setDebug(true)
                } else if debug.lowercased() == "false" {
                    AlxSdk.setDebug(false)
                }
            }
            
            // 读取 GDPR 合规标志 / Read GDPR compliance flags
            let gdprFlag = UserDefaults.standard.integer(forKey: "IABTCF_gdprApplies")
            let gdprConsent = UserDefaults.standard.string(forKey: "IABTCF_TCString")
            
            if gdprFlag == 1 {
                AlxSdk.setGDPRConsent(true)
            } else {
                AlxSdk.setGDPRConsent(false)
            }
            AlxSdk.setGDPRConsentMessage(gdprConsent ?? "")
            
            // 上报适配器信息 / Report adapter info
            let data: [String: Any] = [
                "sdk_name": "TopOn",
                "sdk_version": ATAPI.sharedInstance().version(),
                "adapter_version": AlxTopOnInitAdapter.adapterVersion() ?? ""
            ]
            AlxSdk.addExtraParameters(key: "alx_adapter", value: data)
            
            NSLog("AlxTopOnInitAdapter: init success")
            self.notificationNetworkInitSuccess()
        }
    }
    
    /// 返回广告平台 SDK 的版本号
    /// Returns the version number of the ad platform SDK.
    @objc public func sdkVersion() -> String? {
        return AlxSdk.getSDKVersion()
    }
    
    /// 返回适配器版本号
    /// Returns the adapter version number.
    @objc public func adapterVersion() -> String? {
        return "1.3.0"
    }
}
