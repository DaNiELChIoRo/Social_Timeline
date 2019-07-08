//
//  UIInputText.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 6/18/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

extension UITextField {
    
    func createDefaultTextInput(keyBoardType: UIKeyboardType, borderRadius:CGFloat, placeholder: String) -> UITextField {
        let textInput = UITextField()
        textInput.keyboardType = keyBoardType
        textInput.layer.borderWidth = 1
        textInput.borderStyle = .roundedRect
        textInput.layer.masksToBounds = true
        textInput.layer.cornerRadius = borderRadius
        textInput.textAlignment = .center
        textInput.placeholder = placeholder
        textInput.translatesAutoresizingMaskIntoConstraints = false
        return textInput
    }    
}
