//
//  PostsCoordinator.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 7/9/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

class PostsCoordinator: Coordinator {
    let filmsVC = GenericTableViewController(items: Post.stubPosts, configure: { (cell: SubtitleTableViewCell, film) in
        cell.titleLabel?.text = film.title
        cell.releaseYearTextLabel?.text = "released year: \(film.releaseYear)"
        cell.starringLabel?.text = film.starring
    }) { (film) in
        print(film.title)
    }
    
    var childCoordinators = [Coordinator]()
    weak var parentCoordinator: TabBarCoordinator?
    
    var navigationController: UINavigationController
    
    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        self.navigationController = navigationController
        
        navigationController.coordinator = self
        
        navigationController.navigationBar.prefersLargeTitles = true
//        navigationController.navigationBar.
        navigationController.title = "Algo loco"
        
        start()
    }
    
    func start() {
        filmsVC.title = "Say Something!"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonHandler))
        filmsVC.navigationItem.rightBarButtonItem = addButton
        navigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
        
        navigationController.viewControllers = [filmsVC]
    }
    
    @objc func addButtonHandler(){
        print("addButtonHandler!")
        let addPost = addPostView()
        navigationController.pushViewController(addPost, animated: true)
    }
    
}
