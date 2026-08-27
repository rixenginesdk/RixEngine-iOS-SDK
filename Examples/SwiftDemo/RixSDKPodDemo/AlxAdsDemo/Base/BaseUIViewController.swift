//
//  BaseUIViewController.swift
//  AlxDemo
//
//  Created by liu weile on 2025/3/31.
//

import UIKit

public class BaseUIViewController: UIViewController {

   public func createButton(title:String,action: Selector) -> UIButton{
       let tintColor = UIColor(red: 76/255.0, green: 190/255.0, blue: 196/255.0, alpha: 1.000)
       let button = UIButton()
       button.setTitle(title, for: .normal)
       button.layer.cornerRadius = 8.0
       button.layer.borderWidth = 1.5
       button.layer.borderColor = tintColor.cgColor
       button.translatesAutoresizingMaskIntoConstraints=false
       button.setTitleColor(tintColor, for: .normal)
       button.backgroundColor = .white
       button.accessibilityNavigationStyle = .automatic
       button.addTarget(self, action: action, for: .touchUpInside)
       return button
   }

    
    public func createLabel() -> UILabel{
        let label=UILabel()
        label.translatesAutoresizingMaskIntoConstraints=false
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = .zero
        return label
    }
    
    public func clearSubView(_ constainerView:UIView){
        let views=constainerView.subviews
        for view in views {
            view.removeFromSuperview()
        }
    }
}
