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
    var userName:UILabel? = UILabel().createDefaultLabel("UserName", 24, .bold, .black, .center)
    var userEmail:UILabel? = UILabel().createDefaultLabel("user email", 24, .bold, .black, .center)
    var logOutButton: UIButton? = UIButton().createDefaultButton("LogOut", .red, 12, #selector(logOutHandler))
    var ressetPassButton: UIButton? = UIButton().createDefaultButton("Reset Password", .red, 12, #selector(logOutHandler))
    var userImageThumbnailView:ThumbnailImageView?
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.title = "Profile"
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    func receiveUserData(username: String, useremail: String) {
        let font = UIFont.boldSystemFont(ofSize: 24)
        let attributes = [NSAttributedString.Key.font: font]
        let emailAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .regular)]
        userName!.attributedText = NSAttributedString(string: username, attributes: attributes)
        userEmail!.attributedText = NSAttributedString(string: useremail, attributes: emailAttributes)
    }
    
    func showErrorAlert(_ error: String) {
        self.createAlertDesctructive("Error", "Error al intentar obtener la información del usuario, Error: \(error)", .alert, "Entendido")
    }
    
    func showUploadErrorAlert(_ error: String) {
        self.createAlertDesctructive("Error", "Error al intentar subir la imagen del usuario, Error: \(error)", .alert, "Pues... ¿Qué más puedo hacer?")
    }
    
    func showDownloadErrorAlert(_ error: String) {
        self.createAlertDesctructive("Error", "Error al intentar descargar la imagen del usuario, Error: \(error)", .alert, "Pues... ¿Qué más puedo hacer?")
    }
    
    func changeUserThumbnailImage(imagePath: String) {
        let image = UIImage(contentsOfFile: imagePath)
        userImageThumbnailView?.changeUserImage(image: image!)
    }

    func setupView() {
        view.backgroundColor = .white
        
        userImageThumbnailView = ThumbnailImageView(image: UIImage(named: "avatar")!, delegate: self as! userImageDelegate)
        
        view.addSubview(userImageThumbnailView!)
        userImageThumbnailView?.translatesAutoresizingMaskIntoConstraints = false
        let estimatedWidth = (height * 0.19) - width        
        view.autoAnchorsToTop(view: userImageThumbnailView!, topMargin: 50, horizontalPadding: estimatedWidth, heightPercentage: 0.19)
        
        view.addSubview(userName!)
        userName?.autoAnchorsXCenter(topView: userImageThumbnailView!, topMargin: 20, horizontalPadding: nil, heightPercentage: 0.05, widthPercentage: 0.7)
        
        view.addSubview(userEmail!)
        userEmail?.autoAnchorsXCenter(topView: userName!, topMargin: 5, horizontalPadding: nil, heightPercentage: 0.05, widthPercentage: 0.7)
        
        view.addSubview(logOutButton!)
        logOutButton!.autoAnchorsToBottom(bottomMargin: 30, horizontalPadding: 50, heightPercentage: 0.065)
        
        view.addSubview(ressetPassButton!)
        ressetPassButton?.autoAnchorsXCenter(bottomView: logOutButton!, bottomMargin: 12, horizontalPadding: nil, heightPercentage: 0.065, widthPercentage: 0.4)
        
        RealtimeDatabase().fetchUserInfo(action: receiveUserData, callback: showErrorAlert)
        RealtimeDatabase().fetchUserImageRef(onsucess: changeUserThumbnailImage, onError: showDownloadErrorAlert)
    }
    
    override func viewDidLayoutSubviews() {
         print(self.userImageThumbnailView!.frame.size)
    }
    
    @objc func logOutHandler() {
        print("Logout Handler!")
        FirebaseService().signOut {
            print("logout successfully")
            coordinator?.logOut()
        }
    }
    
}

extension ProfileController: ImagePickerDelegate, userImageDelegate {
    func changeUserImage() {
         self.imagePicker.present()
    }

    func didSelect(image: UIImage?) {
        guard let image = image,
            let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        userImageThumbnailView?.changeUserImage(image: image)
        FireStorage().upload(filePath: "avatar\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpeg", file: imageData, callback: showUploadErrorAlert)
    }
}
