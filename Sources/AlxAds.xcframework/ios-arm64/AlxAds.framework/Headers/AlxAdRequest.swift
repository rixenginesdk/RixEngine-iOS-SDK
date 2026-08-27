//
//  AlxAdRequest.swift
//  AlxAds
//
//  Created by liu weile on 2025/4/14.
//

import Foundation

/**
 后期可扩展请求参数类
 */
@objc public class AlxAdRequest: NSObject {

    /// 用户自定义参数，对齐 Android 的 setUserExtras(Map<String, String>)
    @objc public var userExt: [String: String]?

    /// 链式设置用户自定义参数
    @discardableResult
    @objc public func withUserExt(_ values: [String: String]?) -> AlxAdRequest {
        self.userExt = values
        return self
    }
}
