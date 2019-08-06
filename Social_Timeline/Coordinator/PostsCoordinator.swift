//
//  PostsCoordinator.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 7/9/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit
import Foundation

class PostsCoordinator: NSObject, Coordinator {
    
    var childCoordinators = [Coordinator]()
    weak var parentCoordinator: TabBarCoordinator?
    
    var navigationController: UINavigationController
    
    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        self.navigationController = navigationController
        super.init()
        navigationController.coordinator = self
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationItem.largeTitleDisplayMode = .never
        self.start()
    }
    
    func start() {
        let postTable = PostTableViewCellController(coordinator: self)
        postTable.title = "Say Something!"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonHandler))
        postTable.navigationItem.rightBarButtonItem = addButton        
        let myTabBarItem = UITabBarItem(title: "Posts", image: UIImage(named: "posts")!, tag: 001)
        navigationController.tabBarItem = myTabBarItem// UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
        navigationController.viewControllers = [postTable]
        navigationController.navigationBar.prefersLargeTitles = true
    }
    
    func backToPostsView() {
        navigationController.popViewController(animated: true)
    }

    @objc func addButtonHandler(){
        print("addButtonHandler!")
        let addPost = addPostView()
        addPost.coordinator = self
        navigationController.pushViewController(addPost, animated: true)
    }
    
    //MARK:- Removing view from Coordinator
    func childDidFinish(_ child: Coordinator){
        for(index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
}

extension PostsCoordinator: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController){
            return
        }
        
        if let _addPostView = fromViewController as? addPostView {
            childDidFinish(_addPostView.coordinator!)
        }
        
    }
    
}
