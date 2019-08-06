//
//  AuthCoordinator.swift
//  Social_Timeline
//
//  Created by Daniel Meneses on 8/6/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

class AuthCoordinator:Coordinator {
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    var navigationController: UINavigationController
    var parentCoordinator: MainCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        start()
    }
    
    func start() {
        let loginController = LoginController(coordinator: self)
        navigationController.pushViewController(loginController, animated: false)
    }
    
    func goToHomeView() {        
        parentCoordinator?.tabBarCoordinator()
        navigationController.popViewController(animated: false)
        navigationController.popViewController(animated: true)
        parentCoordinator?.childDidFinish(self)
    }
    
    func goToRegisterUser() {
        let registerController = RegisterController(coordinator: self)
        navigationController.pushViewController(registerController, animated: true)
    }
    
}
