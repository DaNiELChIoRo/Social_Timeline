//
//  File.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 6/19/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit
import SnapKit

class addPostView: UIViewController {
    
    var postInput: UITextView? = UITextView().createEditableTextView(placeholder: "Just say anything!", textSize: 24, keyboard: .alphabet)
    var postButton: UIButton?
    
    let tapGesture = UIGestureRecognizer(target: self, action: #selector(tapGestureHandler))
    let height = UIScreen.main.bounds.height
    let width = UIScreen.main.bounds.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        
        postButton = UIButton().createDefaultButton("Postear", .red, 10, #selector(postButtonHandler))
        
        guard let tabBarHeight = navigationController?.tabBarController?.tabBar.frame.height else { return }
        view.backgroundColor = .white
//        view.addGestureRecognizer(tapGesture)
        view.addSubviews([postInput!, postButton!])
        postInput!.backgroundColor = .red
        let textViewDelegate = self
        postInput!.delegate = textViewDelegate
        view.autoAnchorsToTop(view: postInput!, topMargin: 20, horizontalPadding: 5, heightPercentage: 0.2)
        postButton!.autoAnchorsToBottom(bottomMargin: tabBarHeight, horizontalPadding: 50, heightPercentage: 0.07)
//        postButton!.snp.makeConstraints { (make) in
//            make.bottom.equalToSuperview().offset(-(tabBarHeight + 16))
//            make.height.equalTo(height*0.07)
//            make.width.equalTo(width*0.6)
//            make.centerX.equalToSuperview()
//        }
    }
    
    @objc func postButtonHandler() {
        print("postButtonHandler action")
        guard let content = postInput!.text else { return }
        let timestamp = Date().timeIntervalSince1970        
        RealtimeDatabase().setUserPost(timestamp: timestamp, content: content, multimedia: false)
    }
    
    @objc func tapGestureHandler(){
        print("tapGestureHandler")
        isEditing = false
    }
    
    
    
}

extension addPostView: UITextViewDelegate{
    
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
