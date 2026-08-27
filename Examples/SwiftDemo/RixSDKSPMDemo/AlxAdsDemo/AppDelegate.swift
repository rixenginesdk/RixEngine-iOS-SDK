//
//  AppDelegate.swift
//  AlxDemo
//
//  Created by liu weile on 2025/3/28.
//

import UIKit
import AlxAds


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 延后 SDK 初始化到首帧渲染之后，避免 didFinishLaunching 阻塞导致白屏。
        DispatchQueue.main.async { [weak self] in
            self?.initAlxSDK()
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    private func initAlxSDK() {
        AlxSdk.initializeSDK(token: AdConfig.Alx_Token, sid: AdConfig.Alx_Sid, appId: AdConfig.Alx_App_Id)
        // MARK: - 需要修改
//        AlxSdk.setHost(hostUrl: AdConfig.Alx_Host)
        AlxSdk.setDebug(true)
        // 用户扩展参数
        AlxSdk.addExtraParameters(key: "uid2_token", value: "NewAdvertisingTokenIjb6u6KcMAt=")
        AlxSdk.addExtraParameters(key: "name", value: "张三")
        AlxSdk.addExtraParameters(key: "age", value: 20)
        AlxSdk.addExtraParameters(key: "isFromChina", value: true)
        AlxSdk.addExtraParameters(key: "array", value: ["张三", "李四", "王五", "刘德华", "刘亦菲"])
        AlxSdk.addExtraParameters(key: "dictionary", value: ["name": "张三", "sex": "男", "age": 55, "isNumber": true])
    }

}
