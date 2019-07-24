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
        
        postsVC = GenericTableViewController(items: posts, coordinator: self, configure: { (cell: SubtitleTableViewCell, post) in
            
            RealtimeDatabase().fetchAuthorInfo(authorID: post.title, action: { (username, userimage) in
                cell.titleLabel?.text = username
                guard let userimage = UIImage(contentsOfFile: userimage) else { return }
                cell.setImage(image: userimage)
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
                    cell.releaseYearTextLabel?.text = "published: \(stringDate)"
                    cell.contentLabel?.text = post.content
            
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
        let userImage = UIImage(contentsOfFile: userimage) ?? UIImage(named: "avatar" )
        let fetchPost = Post(title: username, publishDate: timestamp, content: content, userimage: userImage!)
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
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonHandler))
        postsVC.navigationItem.rightBarButtonItem = addButton
        navigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
        navigationController.viewControllers = [postsVC]
    }
    
    func appendPost(timestamp: Double, content: String, multimedia: Bool, view: UIViewController) {
        navigationController.popViewController(animated: true)
        do {
            try RealtimeDatabase().setUserPost(timestamp: timestamp, content: content, multimedia: false)
        } catch {
            navigationController.createAlertDesctructive("Error", "Lo sentimos ha ocurrido un error al intentar publicar su post", .alert, "Ya qué.....?")
        }
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
