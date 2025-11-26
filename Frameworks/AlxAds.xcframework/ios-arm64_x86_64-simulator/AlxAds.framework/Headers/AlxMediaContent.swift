//
//  AlxMediaContent.swift
//  AlxAds
//
//  Created by liu weile on 2025/5/6.
//

import Foundation
import UIKit

@objc public class AlxMediaContent: NSObject {

    @objc public var image:UIImage?
    
    @objc public internal(set) var hasVideo = false
    
    @objc public internal(set) var aspectRatio:CGFloat = 0
    
    @objc public var videoDelegate:AlxMediaVideoDelegate?

}
