//
//  File.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 6/19/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

class addPostView: UIViewController, UITextViewDelegate {
    
    var postInput: UITextView? = UITextView().createEditableTextView(placeholder: "Just say anything!", textSize: 24, keyboard: .alphabet)
    
    let tapGesture = UIGestureRecognizer(target: self, action: #selector(algo))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = .blue
        
        view.addGestureRecognizer(tapGesture)
        
        view.addSubview(postInput!)
        postInput!.backgroundColor = .red
        let textViewDelegate = self
        postInput!.delegate = textViewDelegate
        view.autoAnchorsToTop(view: postInput!, topMargin: 20, horizontalPadding: 5, heightPercentage: 0.2)
    }
    
    @objc func algo() {
        print("Algo")
        isEditing = false
    }
    
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
