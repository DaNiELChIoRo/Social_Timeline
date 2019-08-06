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
    var fireStorage: FireStorage!
    var vc: ProfileController?
    
    weak var parentCoordinator: TabBarCoordinator?
    
    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        self.navigationController = navigationController
        navigationController.coordinator = self
        start()
    }
    
    func start() {
        fireStorage = FireStorage(delegate: self)
        fireAuth = FireAuth(userDelegate: self)
        realtimeDB = RealtimeDatabase(delegate: self)
        do {
            try realtimeDB?.fetchUserInfo()
        } catch {
            print("Error while trying to fetch user info!, error message: \(Error.self)")
        }        
    }
    
    
    func logOut(){
        fireAuth?.signOut(handler: {
            parentCoordinator?.logOutUser()
            parentCoordinator?.childDidFinish()
        })
    }
    
    func ressetUserPassword() {
        do {
            try fireAuth?.resetPassword()
        } catch {
            navigationController.createAlertDesctructive("Error", "\(Error.self)", .alert, "Entendido")
        }
    }
    
    func eliminateAccount() {
        fireAuth?.eliminateAccount()
    }
    
}

extension ProfileCoordinator: FireStorageDelegate {
    func onDBError(_ error: String) {
        navigationController.createAlertDesctructive("Error", error, .alert, "Entendido")
    }
}

//MARK:- userDelegate
extension ProfileCoordinator: userDelegate {
    func onError(error: String) {
        navigationController.createAlertDesctructive("Error", error, .alert, "Arrggggg.... !!")
    }
    
    func elimateUser() {
         parentCoordinator?.logOutUser()
    }
}

extension ProfileCoordinator: realtimeDelegate {

    func onUserInfoFetched(_ username: String, _ useremail: String, _ userimageURL: String) {
        vc = ProfileController(username: username, useremail: useremail, userimage: userimageURL)
        navigationController.tabBarItem =  UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        vc?.coordinator = self
        navigationController.viewControllers = [vc!]
    }
    
    func onSuccess() { }
    
    func onError(_ error: String) {
        navigationController.createAlertDesctructive("Error", error, .alert, "Entendido")
    }

}
