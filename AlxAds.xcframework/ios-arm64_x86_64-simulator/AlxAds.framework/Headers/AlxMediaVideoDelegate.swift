//
//  AlxMediaVideoDelegate.swift
//  AlxAds
//
//  Created by liu weile on 2025/5/6.
//

import Foundation

@objc public protocol AlxMediaVideoDelegate: NSObjectProtocol {
    
    @objc optional func videoStart()
    
    @objc optional func videoEnd()

    @objc optional func videoPlay()
    
    @objc optional func videoPause()
    
    @objc optional func videoPlayError(error:Error)
    
    @objc optional func videoMute(isMute:Bool)
   

}
