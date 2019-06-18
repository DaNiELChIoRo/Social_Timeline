//
//  UIButton.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 6/18/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

extension UIButton {
    
    func createDefaultButton(_ title:String, _ color:UIColor, _ borderRadius:CGFloat, _ action:Selector) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = borderRadius
        button.addTarget(self, action: action, for: .touchDown)
        button.backgroundColor = color
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
}
