//
//  AlxTopOnBaseAdapter.swift
//  AlxAdsDemo
//
//  直接翻译 OC 代码
//  Translated directly from OC code
//

import Foundation
import AnyThinkSDK

@objc(AlxTopOnBaseAdapter)
public class AlxTopOnBaseAdapter: ATBaseMediationAdapter {
    
    @objc public override func initializeClassName() -> AnyClass {
        return AlxTopOnInitAdapter.self
    }
}
