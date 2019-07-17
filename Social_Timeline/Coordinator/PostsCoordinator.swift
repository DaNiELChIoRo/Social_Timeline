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
    
    var navigationController: UINavigationController
    
    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        
        self.navigationController = navigationController
        super.init()
        
        navigationController.coordinator = self
        
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationItem.largeTitleDisplayMode = .never
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
        
        self.start()
        self.startFecthingAllPosts()
        postsVC.refreshControl!.isRefreshing ? postsVC.refreshControl!.endRefreshing() : nil
    }
    
    func startFecthingAllPosts(){
        posts = [Post]()
        DispatchQueue.main.async {
            self.postsVC!.tableView.reloadData()
        }
        RealtimeDatabase().fetchAllPosts(action: onAllPostsFetched, onError: showErrorAlert)
    }
    
    func onAllPostsFetched(_ username: String, _ userimage: String, _ content:String, _ timestamp:Double) {
        print("***** ALL POSTS CALLED: username: \(username), userimage: \(userimage), content: \(content), timestamp: \(timestamp)")
        let userImage = UIImage(contentsOfFile: userimage)!
        let fetchPost = Post(title: username, publishDate: timestamp, content: content, userimage: userImage)
        postsVC.appendItemToArray(item: fetchPost)
        DispatchQueue.main.async {
            self.postsVC.tableView.reloadData()
        }
//        postsArraySorter()
    }
    
    func showErrorAlert(_ error: String){
        print("Un Error ha ocurrido al intentar trear todos los posts, error: \(error)")
        postsVC.createAlertDesctructive("Error", "Ha ocurrido un error al intentar obtener las notificaciones de la DB, error: \(error)", .alert, "Entiendido")
    }
    
    func start() {
        postsVC.title = "Say Something!"
        navigationController.delegate = self
//        navigationController.navigationItem.largeTitleDisplayMode = .never
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonHandler))
        postsVC.navigationItem.rightBarButtonItem = addButton
        navigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
        navigationController.viewControllers = [postsVC]
    }
    
    func postsArraySorter(){
        var memory:Post?
        var sortedArray = [Post]()
        for post in posts {
            if memory != nil {
                if (memory!.publishDate < post.publishDate) {
                    sortedArray.append(post)
                    memory = post
                } else {
                    if let index = sortedArray.firstIndex(where: { $0.publishDate > post.publishDate }) {
                        let _memory = sortedArray[index]
                        sortedArray.insert(post, at: index)
                        sortedArray.append(_memory)
                    }
                }
            } else if memory == nil {
                sortedArray.append(post)
                memory = post
            }
        }
        posts = sortedArray
    }
    
    func appendPost(timestamp: Double, content: String, multimedia: Bool, view: UIViewController) {
        posts = [Post]()
        navigationController.popViewController(animated: true)
        RealtimeDatabase().setUserPost(timestamp: timestamp, content: content, multimedia: false)        
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
