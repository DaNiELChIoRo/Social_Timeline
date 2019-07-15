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
    var posts = [Post]()
    var postsVC : GenericTableViewController<Post, SubtitleTableViewCell>!
    
    var childCoordinators = [Coordinator]()
    weak var parentCoordinator: TabBarCoordinator?
    
    var navigationController: UINavigationController
    
    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        self.navigationController = navigationController
        
        navigationController.coordinator = self
        
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.title = "Algo loco"
        
        postsVC = GenericTableViewController(items: posts, configure: { (cell: SubtitleTableViewCell, post) in
                    cell.titleLabel?.text = post.title
                    let date = Date(timeIntervalSince1970: Double(post.publishDate))
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone = .current
                    dateFormatter.locale = Locale(identifier: "ES-mx")
                    dateFormatter.dateFormat = "EEE MMM dd HH:mm yyyy"
                    let stringDate = dateFormatter.string(from: date)
                    cell.releaseYearTextLabel?.text = "published: \(stringDate)"
                    cell.contentLabel?.text = post.content
                    cell.setImage(image: post.userimage)
                }) { (post) in
                    print(post.title)
                }
        
        start()
    }
    
    func onAllPostsFetched(_ username: String, _ userimage: String, _ content:String, _ timestamp:Int) {
        print("***** ALL POSTS CALLED: username: \(username), userimage: \(userimage), content: \(content), timestamp: \(timestamp)")
        let userImage = UIImage(contentsOfFile: userimage)!
        let fetchPost = Post(title: username, publishDate: timestamp, content: content, userimage: userImage)
        postsVC.appendItemToArray(item: fetchPost)
    }
    
    func showErrorAlert(_ error: String){
        print("Un Error ha ocurrido al intentar trear todos los posts, error: \(error)")
        postsVC.createAlertDesctructive("Error", "Ha ocurrido un error al intentar obtener las notificaciones de la DB, error: \(error)", .alert, "Entiendido")
    }
    
    func start() {
        postsVC.title = "Say Something!"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonHandler))
        postsVC.navigationItem.rightBarButtonItem = addButton
        navigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
        RealtimeDatabase().fetchAllPosts(action: onAllPostsFetched, onError: showErrorAlert)
        navigationController.viewControllers = [postsVC]
    }
    
    @objc func addButtonHandler(){
        print("addButtonHandler!")
        
        let secondPost = Post(title: "Alex Mario", publishDate: 1562146310, content: "Feel app para saber tu estado de animo!", userimage:
            UIImage(named:"avatar")!)
        postsVC.appendItemToArray(item: secondPost)
        print("TableView is going to append new post!!")
//        let addPost = addPostView()
//        navigationController.pushViewController(addPost, animated: true)
    }
    
}
