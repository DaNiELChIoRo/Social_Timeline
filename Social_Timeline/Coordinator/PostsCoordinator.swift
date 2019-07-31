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
    var posts = [Post]()
    var postsVC : GenericTableViewController<Post, BaseCell>!
    
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
        postsVC.refreshControl!.isRefreshing ? postsVC.refreshControl!.endRefreshing() : nil
    }
    
    func start() {
        postsVC.title = "Say Something!"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonHandler))
        postsVC.navigationItem.rightBarButtonItem = addButton
        navigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
        navigationController.viewControllers = [postsVC]
    }
    
//    func appendPost(timestamp: Double, content: String, multimedia: UIImage?) {
//        self.timestamp = timestamp
//        self.content = content
//        navigationController.popViewController(animated: true)
//        do {
//            if let multimedia = multimedia {
//                guard let multimediaData =  multimedia.jpegData(compressionQuality: 0.8) else { return }
//                fireStorage.upload(filePath: "userposts/\(timestamp).jpeg", file: multimediaData)
//                return
//            }
//            try realtimeDB.setUserPost(timestamp: timestamp, content: content, multimedia: false as AnyObject)
//        } catch {
//            navigationController.createAlertDesctructive("Error", "Lo sentimos ha ocurrido un error al intentar publicar su post", .alert, "Ya qué.....?")
//        }
//    }
    
    
    
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
