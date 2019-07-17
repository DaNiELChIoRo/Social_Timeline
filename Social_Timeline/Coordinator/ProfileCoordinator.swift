//
//  TabBarCoordinator.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 7/9/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

class ProfileCoordinator: Coordinator{
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var fireAuth: FirebaseService?
    
    weak var parentCoordinator: TabBarCoordinator?
    
    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        self.navigationController = navigationController
        
        navigationController.coordinator = self
        
        start()
    }
    
    func start() {
        fireAuth = FirebaseService(userDelegate: self)
        let vc = ProfileController()
        navigationController.tabBarItem =  UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        vc.coordinator = self
        navigationController.viewControllers = [vc]
    }
    
    func logOut(){
        parentCoordinator?.logOutUser()
    }
    
    func eliminateAccount() {
        fireAuth?.eliminateAccount()
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
