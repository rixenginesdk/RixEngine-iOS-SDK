//
//  AlxSdk.swift
//  AlxAds
//
//  Created by liu weile on 2025/3/31.
//

import Foundation
import AlxAds.AlxFix

@objc public class AlxSdk: NSObject {
    
    // @objc public static let shared = AlxSdk()
    
    private static var isInit = false
    
    private override init() {
        super.init()
    }
    
    @objc public static func initializeSDK(token: String, sid: String, appId: String) {
        // 直接调用 OC 方法，这会强制链接器保留该符号
        AlxUniversalFix.injectAlxBlackMagic()
        let savedTs = Date.alx_saveCurrentMillisecondTimestampToLocal(forKey: AlxConfig.Video_Ext_Control_Timestamp_Key)
        AlxLog.d(.data, msg: "video_ext_control init save timestamp=\(savedTs), key=\(AlxConfig.Video_Ext_Control_Timestamp_Key)")
        AlxSdkManager.initializeSDK(token: token, sid: sid, appId: appId)
        isInit = true
    }
    
    @objc public static func isSDKInit() -> Bool {
        isInit
    }
    
    @objc public static func setHost(hostUrl: String) {
        AlxSdkManager.setHost(hostUrl)
    }
    
    @objc public static func setDebug(_ debug: Bool) {
        AlxSdkManager.setDebug(debug)
    }
    
    /// SDK Name
    @objc public static func getSDKName() -> String {
        AlxSdkManager.getSDKName()
    }
    
    /// Alx SDK Version
    @objc public static func getSDKVersion() -> String {
        AlxSdkManager.getSDKVersion()
    }
    
    /// RixEngineHost URL
    @objc public static func getRixEngineHost() -> String {
        AlxSdkManager.getRixEngineHost()
    }
    
    /// Pub Token
    @objc public static func getPubToken() -> String {
        AlxSdkManager.getPubToken()
    }
    
    /// Pub Sid
    @objc public static func getPubSid() -> String {
        AlxSdkManager.getPubSid()
    }
    
    /// App ID
    @objc public static func getAppID() -> String {
        AlxSdkManager.getAppID()
    }
    
    /// OMSDK Version
    @objc public static func getOMSDKVersion() -> String {
        AlxSdkManager.getOMSDKVersion()
    }
    
    /// Alx User ID
    @objc public static func getAlxUserID() -> String {
        AlxSdkManager.getAlxUserID()
    }
    
    @objc public static func addExtraParameters(key: String, value: Any) {
        AlxSdkManager.addExtraParameters(key: key,value: value)
    }
    
    @objc public static func getExtraParameters() -> [String: Any] {
        return AlxSdkManager.getExtraParameters()
    }
    
    // GDPR
    @objc public static func setGDPRConsent(_ value: Bool) {
        AlxSdkManager.setGDPRConsent(value)
    }
    
    // GDPR Consent message
    @objc public static func setGDPRConsentMessage(_ value: String) {
        AlxSdkManager.setGDPRConsentMessage(value)
    }
    
    // COPPA
    @objc public static func setCOPPAConsent(_ value: Bool) {
        AlxSdkManager.setCOPPAConsent(value)
    }
    
    // CCPA
    @objc public static func setCCPA(_ value: String) {
        AlxSdkManager.setCCPA(value)
    }
    
}
