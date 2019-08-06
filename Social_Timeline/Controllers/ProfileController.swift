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
    var fireAuth: FireAuth!
    var userName:UILabel?
    var userEmail:UILabel?
    var logOutButton: UIButton?
    var ressetPassButton: UIButton?
    var eliminateAcountButton:UIButton?
    var userImageThumbnailView:ThumbnailImageView?
    var imagePicker: ImagePicker!
    var fireStorage: FireStorage!
    var realtimeDB: RealtimeDatabase!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    convenience init(username: String, useremail: String, userimage:String) {
        self.init()
        self.userName = UILabel().createDefaultLabel(username, 24, .bold, .black, .center)
        self.userEmail = UILabel().createDefaultLabel(useremail, 24, .bold, .black, .center)
        userImageThumbnailView = ThumbnailImageView(image: UIImage(named: "avatar")!, delegate: self)
        userImageThumbnailView?.userImage?.downloadImageFromFireStorage(imageURL: userimage, imageName: username + ".jpeg")
        self.title = username        
        setupView()
        configureLayout()
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
        self.fireStorage = FireStorage(delegate: self)
        self.realtimeDB = RealtimeDatabase(delegate: self)
        logOutButton = UIButton().createDefaultButton("LogOut", .red, 12, #selector(buttonHandler))
        ressetPassButton = UIButton().createDefaultButton("Reset Password", .red, 12, #selector(buttonHandler))
        eliminateAcountButton = UIButton().createBorderButton("Borrar Cuenta", .white, 12, #selector(buttonHandler), nil, .red)
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    @objc func buttonHandler(_ sender: UIButton){
        switch sender {
        case eliminateAcountButton:
            print("elminateAccountButtonHandler")
            coordinator?.eliminateAccount()
        case ressetPassButton:
            print("ressetPasswordButtonHandler")
            coordinator?.ressetUserPassword()
        case logOutButton:
            print("logOutButtonHandler")
            coordinator?.logOut()
        default:
            return
        }
    }
    
    override func viewDidLayoutSubviews() {
         print(self.userImageThumbnailView!.frame.size)
    }
    
    func uploadUserImage(image: UIImage, imageData: Data) {
        self.userImageThumbnailView?.changeUserImage(image: image)
        let date = Date().timeIntervalSince1970.rounded()
        guard let timestamp = Int(exactly: date) else { return }
//        fireStorage.deleteFile(withFilePath: "avatar/")
        fireStorage.upload(filePath: "avatar/avatar\(timestamp).jpeg", file: imageData, contentType: .image)
    }
    
}

extension ProfileController {
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
}

extension ProfileController: ImagePickerDelegate, userImageDelegate {
    func changeUserImage() {
         self.imagePicker.present()
    }

    func didSelect(image: UIImage?) {
        guard let image = image,
            let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        uploadUserImage(image: image, imageData: imageData)
    }
}

extension ProfileController: FireStorageDelegate {
    func onError(_ error: String) {
        self.createAlertDesctructive("Error", error, .alert, "Entendido")
    }
    
    func onFileUploaded(_ filePath: String) {
        do {
            try realtimeDB.updateUserImage(withUerImagePath: filePath)
        } catch {
            print("Error while trying to update the user's avatar filePath in the DB, error :", error.localizedDescription)
        }
    }
    
}

extension ProfileController: realtimeDelegate {
    func onUserInfoFetched(_ username: String, _ useremail: String, _ userimageURL: String) {
        self.userImageThumbnailView?.userImage?.downloadImageFromFireStorage(imageURL: userimageURL, imageName: username + ".jpeg")
    }
    
    func onSuccess() { }
    
    func onDBError(_ error: String) {
        self.createAlertDesctructive("Error", error, .alert, "Entendido")
    }
    
}
