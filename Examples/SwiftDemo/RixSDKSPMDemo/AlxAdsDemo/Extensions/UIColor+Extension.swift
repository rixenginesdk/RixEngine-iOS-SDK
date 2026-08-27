//
//  UIColor+Extension.swift
//  AlxAdsDemo
//
//  Created by YXk on 2026/5/9.
//

import Foundation
import UIKit

extension UIColor {
    
    /// 使用十六进制字符串初始化 UIColor
    ///
    /// 支持格式：
    /// - "#FFFFFF"
    /// - "FFFFFF"
    /// - "#FFF"
    /// - "FFF"
    ///
    /// - Parameters:
    ///   - hex: 十六进制颜色字符串
    ///   - alpha: 透明度，默认 1.0
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        
        var hexString = hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()
        
        // 去掉 #
        if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }
        
        // 支持 #FFF 简写
        if hexString.count == 3 {
            hexString = hexString.map { "\($0)\($0)" }.joined()
        }
        
        // 必须为 6 位
        guard hexString.count == 6 else {
            return nil
        }
        
        var rgbValue: UInt64 = 0
        
        guard Scanner(string: hexString).scanHexInt64(&rgbValue) else {
            return nil
        }
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(
            red: red,
            green: green,
            blue: blue,
            alpha: alpha
        )
    }
    
    static func hex(_ hex: String, alpha: CGFloat = 1.0) -> UIColor {
        UIColor(hex: hex, alpha: alpha) ?? .clear
    }
}
