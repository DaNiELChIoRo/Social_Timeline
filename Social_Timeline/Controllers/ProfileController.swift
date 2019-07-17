//
//  ProfileController.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 6/18/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    
    let height = UIScreen.main.bounds.height
    let width = UIScreen.main.bounds.width
    
    weak var coordinator: ProfileCoordinator?
    var userName:UILabel?
    var userEmail:UILabel?
    var logOutButton: UIButton?
    var ressetPassButton: UIButton?
    var eliminateAcountButton:UIButton?
    var userImageThumbnailView:ThumbnailImageView?
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureLayout()
       
    }
    
    convenience init(username: String, useremail: String){
        self.init()
        self.userName = UILabel().createDefaultLabel(username, 24, .bold, .black, .center)
        self.userEmail = UILabel().createDefaultLabel(useremail, 24, .bold, .black, .center)
         self.title = username
    }
    
    func receiveUserData(username: String, useremail: String) {
        let font = UIFont.boldSystemFont(ofSize: 24)
        let attributes = [NSAttributedString.Key.font: font]
        let emailAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .regular)]
        userName!.attributedText = NSAttributedString(string: username, attributes: attributes)
        userEmail!.attributedText = NSAttributedString(string: useremail, attributes: emailAttributes)
    }
    
    func setupView() {
        view.backgroundColor = .white

        logOutButton = UIButton().createDefaultButton("LogOut", .red, 12, #selector(buttonHandler))
        ressetPassButton = UIButton().createDefaultButton("Reset Password", .red, 12, #selector(buttonHandler))
        userImageThumbnailView = ThumbnailImageView(image: UIImage(named: "avatar")!, delegate: self as! userImageDelegate)
        eliminateAcountButton = UIButton().createBorderButton("Borrar Cuenta", .white, 12, #selector(buttonHandler), nil, .red)
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    func configureLayout() {
        view.addSubviews([userImageThumbnailView!, userName!, userEmail!, logOutButton!, ressetPassButton!, eliminateAcountButton!])
        
        let estimatedWidth = (height * 0.19) - width
        view.autoAnchorsToTop(view: userImageThumbnailView!, topMargin: 50, horizontalPadding: estimatedWidth, heightPercentage: 0.19)
        userName?.autoAnchorsXCenter(topView: userImageThumbnailView!, topMargin: 20, horizontalPadding: nil, heightPercentage: 0.05, widthPercentage: 0.7)
        userEmail?.autoAnchorsXCenter(topView: userName!, topMargin: 5, horizontalPadding: nil, heightPercentage: 0.05, widthPercentage: 0.7)
        logOutButton!.autoAnchorsToBottom(bottomMargin: 30, horizontalPadding: 50, heightPercentage: 0.065)
        ressetPassButton?.autoAnchorsXCenter(bottomView: logOutButton!, bottomMargin: 12, horizontalPadding: nil, heightPercentage: 0.065, widthPercentage: 0.4)
        eliminateAcountButton?.autoAnchorsXCenter(bottomView: ressetPassButton!, bottomMargin: 12, horizontalPadding: nil, heightPercentage: 0.065, widthPercentage: 0.4)
    }
    
    @objc func buttonHandler(_ sender: UIButton){
        switch sender {
        case eliminateAcountButton:
            print("elminateAccountButtonHandler")
            coordinator?.eliminateAccount()
        case ressetPassButton:
            print("ressetPasswordButtonHandler")
        case logOutButton:
            print("logOutButtonHandler")
            FirebaseService().signOut {
                print("logout successfully")
                coordinator?.logOut()
            }
        default:
            return
        }
    }
    
    override func viewDidLayoutSubviews() {
         print(self.userImageThumbnailView!.frame.size)
    }
    
}

extension ProfileController: ImagePickerDelegate, userImageDelegate {
    func changeUserImage() {
         self.imagePicker.present()
    }

    func didSelect(image: UIImage?) {
        guard let image = image,
            let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        coordinator?.uploadUserImage(image: image, imageData: imageData)
    }
}
