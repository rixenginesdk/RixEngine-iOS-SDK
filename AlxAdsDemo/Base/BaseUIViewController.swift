//
//  BaseUIViewController.swift
//  AlxDemo
//
//  Created by liu weile on 2025/3/31.
//

import UIKit

public class BaseUIViewController: UIViewController {

   public func createButton(title:String,action: Selector) -> UIButton{
       let button=UIButton()
       button.setTitle(title, for: .normal)
       button.translatesAutoresizingMaskIntoConstraints=false
       button.setTitleColor(.white, for: .normal)
       button.backgroundColor = .darkGray
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
