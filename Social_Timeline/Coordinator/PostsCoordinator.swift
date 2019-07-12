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
    let filmsVC = GenericTableViewController(items: Post.stubPosts, configure: { (cell: SubtitleTableViewCell, post) in
        cell.titleLabel?.text = post.title
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
    
    func calculateDate(timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "ddd-MM-yyyy HH:mm"
        let stringDate = dateFormatter.string(from: date)
        return stringDate
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
