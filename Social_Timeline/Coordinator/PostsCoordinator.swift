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
    var postsVC : GenericTableViewController<Post, SubtitleTableViewCell>!
    
    var childCoordinators = [Coordinator]()
    weak var parentCoordinator: TabBarCoordinator?
    var realtimeDB: RealtimeDatabase!
    
    var navigationController: UINavigationController
    
    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        
        self.navigationController = navigationController
        super.init()
        
        navigationController.coordinator = self
        self.realtimeDB = RealtimeDatabase(delegate: self)
        
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationItem.largeTitleDisplayMode = .never
        navigationController.title = "Algo loco"
        
        postsVC = GenericTableViewController(items: posts, coordinator: self, configure: { (cell: [ SubtitleTableViewCell ], post) in
             if !post.multimedia {
                self.realtimeDB.fetchAuthorInfo(authorID: post.title, action: { (username, userimage) in
                cell[0].titleLabel?.text = username
                cell[0].setImage(imageURL: userimage)
                }, onError: { (error) in
                print("error" + error)
                navigationController.createAlertDesctructive("Error", "Erro al intentar conseguir las imagenes del post, error message: "+error, .alert, "Entendido")
                })
                
                let date = Date(timeIntervalSince1970: Double(post.publishDate))
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = .current
                dateFormatter.locale = Locale(identifier: "ES-mx")
                dateFormatter.dateFormat = "EEE MMM dd HH:mm yyyy"
                let stringDate = dateFormatter.string(from: date)
                cell[0].releaseYearTextLabel?.text = "published: \(stringDate)"
                cell[0].contentLabel?.text = post.content
                
                } else {
                
                }
            }
            ) { (post) in
                    print(post.title)
                }
        
        self.start()
        self.startFecthingAllPosts()
        postsVC.refreshControl!.isRefreshing ? postsVC.refreshControl!.endRefreshing() : nil
    }
    
    func startFecthingAllPosts(){
        posts = [Post]()
        DispatchQueue.main.async {
            self.postsVC!.tableView.reloadData()
        }
        realtimeDB.fetchPosts(action: onAllPostsFetched)
    }
    
    func onAllPostsFetched(_ username: String, _ userimage: String, _ content:String, _ timestamp:Double, _ multimedia: AnyObject?) {
        print("***** ALL POSTS CALLED: username: \(username), userimage: \(userimage), content: \(content), timestamp: \(timestamp)")
        let userImage = UIImage(contentsOfFile: userimage) ?? UIImage(named: "avatar" )
        if let multimedia = multimedia {
            
        }
        let fetchPost = Post(title: username, publishDate: timestamp, content: content, multimedia: false, userimage: userImage!)
        postsVC.appendItemToArray(item: fetchPost)
    }
    
    func start() {
        postsVC.title = "Say Something!"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonHandler))
        postsVC.navigationItem.rightBarButtonItem = addButton
        navigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
        navigationController.viewControllers = [postsVC]
    }
    
    func appendPost(timestamp: Double, content: String, multimedia: Bool, view: UIViewController) {
        navigationController.popViewController(animated: true)
        do {
            try realtimeDB.setUserPost(timestamp: timestamp, content: content, multimedia: false)
        } catch {
            navigationController.createAlertDesctructive("Error", "Lo sentimos ha ocurrido un error al intentar publicar su post", .alert, "Ya qué.....?")
        }
    }
    
    func getMorePosts(noPosts: UInt) {
        realtimeDB.fetchMorePosts(noPosts: noPosts)
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

extension PostsCoordinator: realtimeDelegate {    
    
    func onSuccess() {
        postsVC.eliminateAllRows()
    }
    
    func onPostFetched(_ username: String, _ userimage: String, _ content: String, _ timestamp: Double) {
        print("***** ALL POSTS CALLED: username: \(username), userimage: \(userimage), content: \(content), timestamp: \(timestamp)")
        let userImage = UIImage(contentsOfFile: userimage) ?? UIImage(named: "avatar" )
        let fetchPost = Post(title: username, publishDate: timestamp, content: content, multimedia: false, userimage: userImage!)
        postsVC.appendItemToArray(item: fetchPost)
    }
    
    func onError(_ error: String) {
        navigationController.createAlertDesctructive("Error", error, .alert, "Entendido")
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
