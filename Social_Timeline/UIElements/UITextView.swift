//
//  UITextView.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 6/19/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

extension UITextView {
    
    func createEditableTextView(placeholder: String, textSize:CGFloat, keyboard: UIKeyboardType) -> UITextView {
        let textView = UITextView()
//        let textViewDelegate:UITextViewDelegate = defaultTextViewDelegate()
        textView.keyboardType = keyboard
        textView.returnKeyType = .done
        textView.textColor = .lightGray
        textView.font = UIFont.systemFont(ofSize: textSize)
        textView.text = placeholder
        textView.isEditable = true
        textView.textAlignment = .center
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }
    
    func createEditableTextViewWithDelegate(placeholder: String, textSize:CGFloat, keyboard: UIKeyboardType, delegate: UITextFieldDelegate) -> UITextView {
        let textView = UITextView()
        textView.keyboardType = keyboard
        textView.returnKeyType = .done
        textView.enablesReturnKeyAutomatically = true
        textView.textColor = .lightGray
        textView.font = UIFont.systemFont(ofSize: textSize)
        textView.text = placeholder
        textView.isEditable = true
        textView.textAlignment = .center
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }
    
}

class defaultTextViewDelegate: NSObject, UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
        }
    }
    
}
