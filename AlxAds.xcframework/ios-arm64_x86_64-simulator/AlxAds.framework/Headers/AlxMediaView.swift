//
//  AlxMediaView.swift
//  AlxAds
//
//  Created by liu weile on 2025/5/6.
//

import Foundation
import UIKit

@IBDesignable
@objc public class AlxMediaView: AlxMediaModelView {

    @objc public override init(frame:CGRect) {
        super.init(frame: frame)
    }
    
    @objc public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc public override func setMediaContent(_ mediaContent:AlxMediaContent?){
        super.setMediaContent(mediaContent)
    }
    
    @objc public func getAdMediaView()->UIView?{
        return mMediaView
    }

}
