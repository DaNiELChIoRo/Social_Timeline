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
    
    var postInput: UITextView?
    var postButton: UIButton?
    
    let height = UIScreen.main.bounds.height
    let width = UIScreen.main.bounds.width
    let placeholder = "Just say anything!"
    
    weak var coordinator: PostsCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureLayOut()
    }
    
    func setupView() {
        postButton = UIButton().createDefaultButton("Postear", .red, 12, #selector(postButtonHandler))
        postInput = UITextView().createEditableTextView(placeholder: placeholder, textSize: 24, keyboard: .alphabet)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func configureLayOut() {
        view.backgroundColor = .white
        view.addSubviews([postInput!, postButton!])
        
//        postInput!.backgroundColor = .red
        postInput!.textAlignment = .left
        let textViewDelegate = self
        
        guard let tabBarHeight = navigationController?.tabBarController?.tabBar.frame.height else { return }
        postInput!.delegate = textViewDelegate
        postInput!.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.width.equalToSuperview().offset(-width*0.1)
            make.centerX.equalToSuperview()
            make.height.equalTo(height*0.6)
        }
        postButton!.autoAnchorsToBottom(bottomMargin: tabBarHeight, horizontalPadding: width*0.1, heightPercentage: 0.07)
    }
    
    @objc func postButtonHandler() {
        print("postButtonHandler action")
        guard let content = postInput!.text,
         content != placeholder else { return }
        let timestamp = Date().timeIntervalSince1970
        coordinator?.appendPost(timestamp: timestamp, content: content, multimedia: false, view: self)
    }
    
    deinit {
        print("destroying the addPostView!")
        postButton = nil
        postInput = nil
        coordinator = nil
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
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
        }
    }
    
    //Since the TextView does not implement the UITextFieldDelegate Protocol!!
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            print("return Key pressed!!")
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
