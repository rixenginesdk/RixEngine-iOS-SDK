//
//  ISAlxCustomAdapter.swift
//  AlxAdsDemo
//
//  LevelPlay (Unity IronSource) 自定义网络基础适配器
//  文档参考: https://docs.unity.com/zh-cn/grow/levelplay/sdk/ios/build-custom-adapter
//

import Foundation
import IronSource
import AlxAds

@objc(ISAlxCustomAdapter)
public class ISAlxCustomAdapter: ISBaseNetworkAdapter {

    private static let TAG = "ISAlxCustomAdapter"
    private static var _isInitialized = false

    static var isInitialized: Bool {
        get { _isInitialized }
        set { _isInitialized = newValue }
    }

    // MARK: - ISBaseNetworkAdapter

    /// LevelPlay 在初始化流程中调用此方法（可能被多次调用）
    /// adData.configuration 包含 LevelPlay 平台配置的 app 级参数:
    ///   appid / sid / token
    public override func `init`(_ adData: ISAdData, delegate: ISNetworkInitializationDelegate) {
        NSLog("%@: init", ISAlxCustomAdapter.TAG)

        let appid = adData.configuration["appid"] as? String
        let sid   = adData.configuration["sid"] as? String
        let token = adData.configuration["token"] as? String

        guard let appid, let sid, let token else {
            let msg = "init failed: appid / sid / token is empty"
            NSLog("%@: %@", ISAlxCustomAdapter.TAG, msg)
            (delegate as? ISAlxInitFailureReporter)?.onInitDidFail(
                withErrorCode: ISAdapterErrors.missingParams.rawValue,
                errorMessage: msg)
            return
        }

        if Self._isInitialized {
            NSLog("%@: already initialized", ISAlxCustomAdapter.TAG)
            delegate.onInitDidSucceed()
            return
        }

        // AlxAds SDK 必须在主线程初始化
        DispatchQueue.main.async {
            NSLog("%@: initializeSDK token=%@ sid=%@ appid=%@", Self.TAG, token, sid, appid)
            AlxSdk.initializeSDK(token: token, sid: sid, appId: appid)
            Self._isInitialized = true
            NSLog("%@: initializeSDK success", ISAlxCustomAdapter.TAG)
            delegate.onInitDidSucceed()
        }
    }

    // MARK: - SDK & Adapter Versions

    public override func networkSDKVersion() -> String {
        return AlxSdk.getSDKVersion()
    }

    public override func adapterVersion() -> String {
        return AlxLevelPlayMetaInfo.ADAPTER_VERSION
    }

    // MARK: - Shared Init Helper

    /// 各 ad unit 适配器调用此方法确保 SDK 已初始化（幂等）
    static func initSdk(with adData: ISAdData) {
        guard !_isInitialized else { return }
        guard let appid = adData.configuration["appid"] as? String,
              let sid   = adData.configuration["sid"] as? String,
              let token = adData.configuration["token"] as? String else {
            NSLog("%@: initSdk failed: missing params", TAG)
            return
        }
        DispatchQueue.main.async {
            AlxSdk.initializeSDK(token: token, sid: sid, appId: appid)
            _isInitialized = true
            NSLog("%@: initSdk success", TAG)
        }
    }
}

// MARK: - Failure Reporter Protocol
//
// ISAdapterAdDelegate 中的 adDidFailToLoad 和 adDidFailToShow 方法
// 因为 ISAdapterErrorType 枚举有一个 case `ISAdapterErrorTypeInternal`，
// 它被 Swift 桥接为关键字 `internal`，导致 Swift 无法通过 existential 或
// NSObject & Protocol 组合类型直接访问这两个方法。
//
// 解决方案：定义一个 @objc 协议，用 Int 替代 ISAdapterErrorType 参数
// （两者底层都是 NSInteger）。ObjC 运行时根据 selector 匹配方法实现，
// 无视 Swift 类型系统限制，因此 `as? ISAlxAdapterFailureReporter` 的
// 转型在运行时会成功，方法也能被正确调用。

@objc protocol ISAlxAdapterFailureReporter: AnyObject {
    func adDidFailToLoad(withErrorType errorType: Int,
                        errorCode: Int,
                        errorMessage: String?)
    func adDidFailToShow(withErrorCode errorCode: Int,
                        errorMessage: String?)
}

// ISNetworkInitializationDelegate 中的 onInitDidFailWithErrorCode:errorMessage:
// 在 Swift existential 下同样无法直接调用，使用相同的 @objc protocol 绕过
@objc protocol ISAlxInitFailureReporter: AnyObject {
    func onInitDidFail(withErrorCode errorCode: Int, errorMessage: String?)
}
