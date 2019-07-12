//
//  PostsCoordinator.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 7/9/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit
import Foundation

class PostsCoordinator: Coordinator {
    let posts = [Post]()
    let postsVC : GenericTableViewController<Post, UITableViewCell>?//(items: Post.stubPosts, configure: { (cell: SubtitleTableViewCell, post) in
//        cell.titleLabel?.text = post.title
//        let date = Date(timeIntervalSince1970: Double(post.publishDate))
//        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = .current
//        dateFormatter.locale = Locale(identifier: "ES-mx")
//        dateFormatter.dateFormat = "EEE MMM dd HH:mm yyyy"
//        let stringDate = dateFormatter.string(from: date)
//        cell.releaseYearTextLabel?.text = "published: \(stringDate)"
//        cell.contentLabel?.text = post.content
//    }) { (post) in
//        print(post.title)
//    }
    
    var childCoordinators = [Coordinator]()
    weak var parentCoordinator: TabBarCoordinator?
    
    var navigationController: UINavigationController
    
    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        self.navigationController = navigationController
        
        navigationController.coordinator = self
        
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.title = "Algo loco"
        
        start()
    }
    
    func onAllPostsFetched(_ username: String, _ userimage: String, _ content:String, _ timestamp:Int) {
        print("***** ALL POSTS CALLED: username: \(username), userimage: \(userimage), content: \(content), timestamp: \(timestamp)")
    }
    
    func showErrorAlert(_ error: String){
        print("Un Error ha ocurrido al intentar trear todos los posts, error: \(error)")
    }
    
    func start() {
        postsVC.title = "Say Something!"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonHandler))
        postsVC.navigationItem.rightBarButtonItem = addButton
        navigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
        RealtimeDatabase().fetchAllPosts(action: onAllPostsFetched, onError: showErrorAlert)
        navigationController.viewControllers = [filmsVC]
    }
    
    @objc func addButtonHandler(){
        print("addButtonHandler!")
        let addPost = addPostView()
        navigationController.pushViewController(addPost, animated: true)
    }
    
}
