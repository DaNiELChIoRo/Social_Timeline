//
//  MainCoordinator.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 7/9/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit
import Firebase

class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.delegate = self
        if Firebase.Auth.auth().currentUser != nil {
            let vc = ViewController()
            vc.coordinator = self
            navigationController.pushViewController(vc, animated: false)
        } else {
            let vc = LoginController()
            vc.coordinator = self
            navigationController.pushViewController(vc, animated: false)
        }
    }
    
    func registerUser() {
        let vc = RegisterController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
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
