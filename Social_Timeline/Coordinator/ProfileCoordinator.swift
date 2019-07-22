//
//  TabBarCoordinator.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 7/9/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

class ProfileCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var fireAuth: FireAuth?
    var realtimeDB: RealtimeDatabase?
    var vc: ProfileController?
    
    weak var parentCoordinator: TabBarCoordinator?
    
    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        self.navigationController = navigationController
        
        navigationController.coordinator = self
        
        start()
    }
    
    func start() {
        fireAuth = FireAuth(userDelegate: self)
        realtimeDB = RealtimeDatabase(delegate: self)
        
        realtimeDB?.fetchUserInfo()
        realtimeDB?.fetchUserImageRef()
//        RealtimeDatabase().fetchUserImageRef()
        
    }
    
    func uploadUserImage(image: UIImage, imageData: Data){
        vc?.userImageThumbnailView?.changeUserImage(image: image)
        FireStorage().upload(filePath: "avatar\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpeg", file: imageData, callback: showError)
    }
    
    func logOut(){
        parentCoordinator?.logOutUser()
    }
    
    func eliminateAccount() {
        fireAuth?.eliminateAccount()
    }
    
    func showError(_ error: String) {
        navigationController.createAlertDesctructive("Error", error, .alert, "Entendido")
    }
    
}

//MARK:- userDelegate
extension ProfileCoordinator: userDelegate {
    func onError(error: String) {
        navigationController.createAlertDesctructive("Error", error, .alert, "Entendido")
    }
    
    func createUser(user: Usuario) { }
    
    func logInUser(user: Usuario) { }
    
    func elimateUser() {
         parentCoordinator?.logOutUser()
    }
    
    func createUser() { }
}

extension ProfileCoordinator: realtimeDelegate {
    
    func onUserImageFetched(_ imagePath: String) {
        let image = UIImage(contentsOfFile: imagePath)
        vc?.userImageThumbnailView?.changeUserImage(image: image!)
    }

    func onUserInfoFetched(_ username: String, _ useremail: String) {
        vc = ProfileController(username: username, useremail: useremail)
        navigationController.tabBarItem =  UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        vc?.coordinator = self
        navigationController.viewControllers = [vc!]
    }
    
    func onSuccess() { }
    
    func onError(_ error: String) {
        navigationController.createAlertDesctructive("Error", error, .alert, "Entendido")
    }

}
