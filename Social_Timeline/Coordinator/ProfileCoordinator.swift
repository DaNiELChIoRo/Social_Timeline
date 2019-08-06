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
    
    weak var parentCoordinator: TabBarCoordinator?
    
    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        self.navigationController = navigationController
        navigationController.coordinator = self
        start()
    }
    
    func start() {
        let vc = ProfileController(coordinator: self)
        navigationController.tabBarItem =  UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        navigationController.viewControllers = [vc]
    }
        
    func logOut(){
        parentCoordinator?.logOutUser()
        parentCoordinator?.childDidFinish()
    }
    
    func eliminateAccount() {
        parentCoordinator?.logOutUser()
        parentCoordinator?.childDidFinish()
    }    
}
