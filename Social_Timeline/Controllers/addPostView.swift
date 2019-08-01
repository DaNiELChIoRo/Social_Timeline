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
    var postMultimedia: UIButton?
    var postButton: UIButton?
    var imagePicker: ImagePicker!
    var multimediaView: UIImageView?
    
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
        postButton = UIButton().createDefaultButton("Postear", .red, 12, #selector(buttonPressHandler))
        postMultimedia = UIButton().createButtonWithImage((UIImage(named: "photo-camera")?.withRenderingMode(.alwaysTemplate))!, .white, 12, #selector(buttonPressHandler), 2, .blue)
        postMultimedia?.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        postInput = UITextView().createEditableTextView(placeholder: placeholder, textSize: 24, keyboard: .alphabet)
        multimediaView = UIImageView()
        navigationItem.largeTitleDisplayMode = .never
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    func configureLayOut() {
        view.backgroundColor = .white
        view.addSubviews([postInput!, multimediaView!, postButton!, postMultimedia!])
        postInput!.backgroundColor = .red
        postInput!.textAlignment = .left
        let textViewDelegate = self
        
        guard let tabBarHeight = navigationController?.tabBarController?.tabBar.frame.height else { return }
        postInput!.delegate = textViewDelegate
        postInput!.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.width.equalToSuperview().offset(-width*0.1)
            make.centerX.equalToSuperview()
            make.height.equalTo(height*0.15)
        }
        
        multimediaView!.backgroundColor = .green
        multimediaView!.snp.makeConstraints { (make) in
            make.top.equalTo(postInput!.snp.bottom)
            make.width.equalToSuperview().offset(-width*0.1)
            make.centerX.equalToSuperview()
            make.height.equalTo(height*0.4)
        }
        
        postButton!.autoAnchorsToBottom(bottomMargin: tabBarHeight, horizontalPadding: width*0.1, heightPercentage: 0.07)
        
        postMultimedia!.snp.makeConstraints { (make) in
            let width = UIScreen.main.bounds.width * 0.15
            make.bottom.equalTo(postButton!.snp.top).offset(-20)
            make.height.equalTo(width)
            make.width.equalTo(width)
            make.centerX.equalToSuperview()
        }
        
    }
    
    @objc func buttonPressHandler(_ sender: UIButton) {
        switch (sender) {
            case postButton:
                print("postButtonHandler action")
                guard let content = postInput!.text,
                    content != placeholder else { return }
                let timestamp = Date().timeIntervalSince1970
                if let image = multimediaView?.image {
//                    coordinator?.appendPost(timestamp: timestamp, content: content, multimedia: image)
                    return
                }
//                coordinator?.appendPost(timestamp: timestamp, content: content, multimedia: nil)
            case postMultimedia:
                print("addMultimedia Button press!")                
                self.imagePicker.present()
            default:
                return
        }
    }
    
    deinit {
        print("destroying the addPostView!")
        postButton = nil
        postInput = nil
        coordinator = nil
    }

}

extension addPostView: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        if let image = image {
            multimediaView!.image = image
        }
    }
}

extension addPostView: UITextViewDelegate {
    
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
