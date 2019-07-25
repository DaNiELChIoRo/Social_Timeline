//
//  MainCoordinator.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 7/9/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit
import Firebase

class MainCoordinator: NSObject, Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var fireAuth: FireAuth?
    var realtimeDB: RealtimeDatabase?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.delegate = self
        fireAuth = FireAuth(userDelegate: self)
        realtimeDB = RealtimeDatabase(delegate: self)
        if Firebase.Auth.auth().currentUser != nil {
            let vc = ViewController()
            vc.coordinator = self
            navigationController.pushViewController(vc, animated: false)
        } else {
            let vc = LoginController()
            vc.coordinator = self
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func pushRegisterView() {
        let registerView = RegisterController()
        registerView.coordinator = self
        navigationController.pushViewController(registerView, animated: true)
    }
    
    func registerUser(_ username: String, _ email: String, _ password: String) {
        fireAuth?.registerUser(username: username, email: email, password: password)
    }
    
    func logOnUser(_ email: String, _ password: String) {
        fireAuth?.signIn(email: email, password: password)
    }
    
    func logOutUser() {
        let vc = LoginController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func tabBarCoordinator(){
        let child = TabBarCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
    
    func childDidFinish(_ child: Coordinator){
        for(index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {                 
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    
}

extension MainCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        if let registerController = fromViewController as? RegisterController {
            childDidFinish(registerController.coordinator!)
        }
    }
}

extension MainCoordinator: userDelegate {
    func ressetPass() { }
    
    func onError(error: String) {
        navigationController.createAlertDesctructive("Error!", error, .alert, "Entendido")
    }
    
    func createUser(user: Usuario) {
        realtimeDB?.writeUser(user: user)
    }
    
    func logInUser(user: Usuario) {
        let vc = ViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func elimateUser() { }
}

extension MainCoordinator: realtimeDelegate {
    func onPostFetched(_ username: String, _ userimage: String, _ content: String, _ timestamp: Double) { }
    
    func onPostAdded(_ username: String, _ userimage: String, _ content: String, _ timestamp: Double) { }
    
    func onUserInfoFetched(_ username: String, _ useremail: String) { }
    
    func onUserImageFetched(_ imagePath: String) { }
    
    func onDBError(_ error: String) {
        navigationController.createAlertDesctructive("Error", error, .alert, "Entendido")
    }
    
    func onSuccess() {
        let vc = ViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
