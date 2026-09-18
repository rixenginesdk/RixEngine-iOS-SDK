//
//  String+Extension.swift
//  RixAdsSDKDemo
//
//  Created by YXk on 2026/8/30.
//

import UIKit

extension String {
    /// 将 "Key:Value" 格式文本转为富文本：冒号左侧加粗加黑，右侧加粗且保持 valueColor。
    func sdkInfoAttributedString(
        fontSize: CGFloat = 11,
        valueColor: UIColor = UIColor(red: 0.5, green: 0.5, blue: 0.6, alpha: 1),
        keyColor: UIColor = UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1)
    ) -> NSAttributedString {
        guard let colonIndex = firstIndex(of: ":") else {
            return NSAttributedString(
                string: self,
                attributes: [
                    .font: UIFont.monospacedSystemFont(ofSize: fontSize, weight: .bold),
                    .foregroundColor: valueColor,
                ]
            )
        }

        let key = String(self[...colonIndex])
        let valueStart = index(after: colonIndex)
        let value = valueStart < endIndex ? String(self[valueStart...]) : ""

        let result = NSMutableAttributedString(
            string: key,
            attributes: [
                .font: UIFont.monospacedSystemFont(ofSize: fontSize, weight: .bold),
                .foregroundColor: keyColor,
            ]
        )
        result.append(
            NSAttributedString(
                string: value,
                attributes: [
                    .font: UIFont.monospacedSystemFont(ofSize: fontSize, weight: .bold),
                    .foregroundColor: valueColor,
                ]
            )
        )
        return result
    }
}
