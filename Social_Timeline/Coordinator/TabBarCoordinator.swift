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
        postsCoordinator()
        profileCoordinator()
    }
    
    func profileCoordinator(){
        let child = ProfileCoordinator()
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
    
    func postsCoordinator(){
        let child = PostsCoordinator()
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
}
