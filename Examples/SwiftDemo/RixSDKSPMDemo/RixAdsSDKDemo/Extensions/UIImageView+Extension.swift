//
//  UIImageView+Extension.swift
//  RixAdsSDKDemo
//
//  Created by YXk on 2026/8/30.
//

import UIKit

extension UIImageView {

    func loadUrl(_ urlString:String){
        guard let url = URL(string: urlString) else {
          return
        }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                  DispatchQueue.main.async {
                      if let image = UIImage(data:data) {
                          self.image=image
                      }
                  }
            }
        }
    }

}
