//
//  AlxTopOnBaseManager.swift
//

import Foundation
import AnyThinkSDK
import AlxAds

@objc(AlxTopOnBaseManager)
public class AlxTopOnBaseManager: NSObject {
    
    private static let TAG = "AlxTopOnBaseManager"
    
    public static var isInitialized:Bool = false
    
    public static let unitID = "unitid"
    public static let slotID = "slot_id"

    /// 解析广告位 ID：优先读取 `unitid`，若为空则回退读取 `slot_id`。
    @objc public static func parseUnitID(from serverInfo: [AnyHashable: Any]?) -> String? {
        guard let serverInfo = serverInfo else { return nil }
        if let rawUnitId = serverInfo["unitid"] {
            let str = "\(rawUnitId)".trimmingCharacters(in: .whitespacesAndNewlines)
            if !str.isEmpty {
                return str
            }
        }
        if let rawSlotId = serverInfo["slot_id"] {
            let str = "\(rawSlotId)".trimmingCharacters(in: .whitespacesAndNewlines)
            if !str.isEmpty {
                return str
            }
        }
        return nil
    }
    
    @discardableResult
    public static func initSDK(serverInfo: [AnyHashable: Any]) -> String?{
        print("\(AlxTopOnBaseManager.TAG): alx-sdk-version:\(AlxSdk.getSDKVersion())")
        print("\(AlxTopOnBaseManager.TAG): topon-sdk-version:\(ATAPI.sharedInstance().version())")
        print("\(AlxTopOnBaseManager.TAG): topon-adapter-version:\(AlxTopOnMetaInf.ADAPTER_VERSION)")
        
        let appid:String? = serverInfo["appid"] as? String
        let sid:String? = serverInfo["sid"] as? String
        let token:String? = serverInfo["token"] as? String
        let debug:String? = serverInfo["isdebug"] as? String
        
        print("\(AlxTopOnBaseManager.TAG): token=\(token ?? ""); appid=\(appid ?? ""); sid=\(sid ?? "")")
        guard let appid = appid,let sid=sid,let token=token else{
            let errorStr="initialize alx params: appid or sid or token is empty"
            print("\(AlxTopOnBaseManager.TAG): error: \(errorStr)")
            return errorStr
        }
        
        self.sdkInfo()
        AlxSdk.initializeSDK(token: token, sid: sid, appId: appid)
        AlxTopOnBaseManager.isInitialized = true
        
        if let debug,!debug.isEmpty {
            if debug.lowercased() == "true" {
                AlxSdk.setDebug(true)
            } else if debug.lowercased() == "false" {
                AlxSdk.setDebug(false)
            }
        }
        
        
        // User Privacy
        // MARK: - GDPR Consent Handling
        let gdprFlag = UserDefaults.standard.integer(forKey: "IABTCF_gdprApplies")
        let gdprConsent = UserDefaults.standard.string(forKey: "IABTCF_TCString")
        if gdprFlag == 1 {
            AlxSdk.setGDPRConsent(true)
        } else  {
            AlxSdk.setGDPRConsent(false)
        }
        AlxSdk.setGDPRConsentMessage(gdprConsent ?? "")
        
        return nil
    }
    
    public static func sdkInfo() {
        var data:[String:String] = [:]
        data["sdk_name"] = "TopOn"
        data["sdk_version"] = ATAPI.sharedInstance().version()
        data["adapter_version"] = AlxTopOnMetaInf.ADAPTER_VERSION
        AlxSdk.addExtraParameters(key: "alx_adapter", value: data)
    }
    
    public static func error(code: Int, msg: String) -> NSError {
        return NSError(domain: "AlxTopOnAdapter", code: code, userInfo: [NSLocalizedDescriptionKey : msg])
    }
    
}
