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
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        start()
    }
    
    func start() {
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.delegate = self
        let vc = ViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func sendToLogIn() {
        let child = AuthCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
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


