//
//  ViewController.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 6/18/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

class ViewController: UITabBarController {
    
    var coordinator: MainCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        coordinator?.tabBarCoordinator()
        if let views = coordinator?.childCoordinators[0].childCoordinators {
            if views.count > 0 {
                var vis:[UIViewController] = [UIViewController]()
                views.forEach {  vis.append($0.navigationController as UIViewController) }
                viewControllers = vis
            } else {
                print("the main coordinator has no childs!")
                return
            }
        } else {
            print("Seems there are no views to display??")
        }
    } 

}
