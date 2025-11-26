//
//  AlxSdk.swift
//  AlxAds
//
//  Created by liu weile on 2025/3/31.
//

import Foundation

@objc public class AlxSdk:NSObject {
    
    //    @objc public static let shared = AlxSdk()
    
    private static var isInit = false
    
    private override init(){
        super.init()
    }
    
    @objc public static func initializeSDK(token:String,sid:String,appId:String) {
        AlxSdkManager.initializeSDK(token: token, sid: sid, appId: appId)
        isInit = true
    }
    
    @objc public static func isSDKInit() -> Bool {
        return isInit
    }
    
    @objc public static func setDebug(_ debug:Bool) {
        AlxSdkManager.setDebug(debug)
    }
    
    @objc public static func getSDKName()->String{
        return AlxSdkManager.getSDKName()
    }
    
    @objc public static func getSDKVersion()->String{
        return AlxSdkManager.getSDKVersion()
    }
    
    @objc public static func addExtraParameters(key:String,value:Any){
        AlxSdkManager.addExtraParameters(key:key,value:value)
    }
    
    @objc public static func getExtraParameters()->[String:Any]{
        return AlxSdkManager.getExtraParameters()
    }
    
    // GDPR
    @objc public static func setGDPRConsent(_ value:Bool){
        AlxSdkManager.setGDPRConsent(value)
    }
    
    // GDPR Consent message
    @objc public static func setGDPRConsentMessage(_ value:String){
        AlxSdkManager.setGDPRConsentMessage(value)
    }
    
    // COPPA
    @objc public static func setCOPPAConsent(_ value:Bool){
        AlxSdkManager.setCOPPAConsent(value)
    }
    
    // CCPA
    @objc public static func setCCPA(_ value:String){
        AlxSdkManager.setCCPA(value)
    }
    
}
