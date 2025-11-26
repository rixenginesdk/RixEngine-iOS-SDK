//
//  UIImageView+Extensions.swift
//  AlxDemo
//
//  Created by liu weile on 2025/5/6.
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
