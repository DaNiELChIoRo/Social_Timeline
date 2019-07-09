//
//  TabBarCoordinator.swift
//  FirebaseAuth
//
//  Created by Daniel.Meneses on 7/9/19.
//

import UIKit

class TabBarCoordinator: NSObject, Coordinator {
    
    
    
    var childCoordinators = [Coordinator]()
    weak var parentCoordinator: MainCoordinator?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    func start() {
        let profileCoordinator = ProfileCoordinator()
        let postsCoordinator = PostsCoordinator()
        
        
    }
}
