//
//  UIButton.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 6/18/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

extension UIButton {
    
    func createDefaultButton(_ title:String, _ color:UIColor, _ borderRadius:CGFloat, _ action:Selector, _ translate: Bool) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = borderRadius
        button.addTarget(self, action: action, for: .touchDown)
        button.backgroundColor = color
        button.translatesAutoresizingMaskIntoConstraints = true
        return button
    }
    
    func createDefaultButton(_ title:String, _ color:UIColor, _ borderRadius:CGFloat, _ action:Selector) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = borderRadius
        button.addTarget(self, action: action, for: .touchDown)
        button.backgroundColor = color
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func createBorderButton (_ title:String, _ color:UIColor, _ borderRadius:CGFloat, _ action:Selector, _ borderWitdh:CGFloat?, _ borderColor: UIColor) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(borderColor, for: .normal)
        button.layer.cornerRadius = borderRadius
        button.layer.borderWidth = borderWitdh ?? 1
        button.layer.borderColor = borderColor.cgColor
        button.addTarget(self, action: action, for: .touchDown)
        button.backgroundColor = color
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func createButtonWithImage (_ image:UIImage, _ color:UIColor, _ borderRadius:CGFloat, _ action:Selector, _ borderWitdh:CGFloat?, _ borderColor: UIColor) -> UIButton {
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = borderRadius
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor = .blue
        button.layer.borderWidth = borderWitdh ?? 1
        button.layer.borderColor = borderColor.cgColor
        button.addTarget(self, action: action, for: .touchDown)
        button.backgroundColor = color
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
}
