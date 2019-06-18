//
//  ViewController.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 6/18/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

class ViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        setupNavBar()
    }
    
    func setupView() {
        
        let filmsVC = GenericTableViewController(items: Film.stubFilms, configure: { (cell: SubtitleTableViewCell, film) in
            cell.textLabel?.text = film.title
            cell.detailTextLabel?.text = "\(film.releaseYear)"
            cell.starringLabel?.text = film.starring
        }) { (film) in
            print(film.title)
        }
        let filmsNavigationController = UINavigationController(rootViewController: filmsVC)
        filmsNavigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 001)
        
        let profileView = ProfileController()
//        profileView.navigationController?.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 002)
        let profileNavigation = UINavigationController(rootViewController: profileView)
        profileNavigation.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 002)
        
        viewControllers = [filmsNavigationController, profileNavigation]
    }
    
    func setupNavBar() {
        navigationItem.title = "Social TimeLine"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonHandler))
        navigationItem.rightBarButtonItem = addButton
    }

    @objc func addButtonHandler() {
        print("addb-uttonHandler")
    }    

}

struct Film {
    
    let title: String
    let releaseYear: Int
    let starring: String
    
    static var stubFilms: [Film] {
        return [
            Film(title: "Star Wars: A New Hope", releaseYear: 1978, starring: "Luck Skywalker"),
            Film(title: "Star Wars: Empire Strikes Back", releaseYear: 1982, starring: "Luck Skywalker"),
            Film(title: "Star Wars: Return of the Jedi", releaseYear:  1984, starring: "Luck Skywalker"),
            Film(title: "Star Wars: The Phantom Menace", releaseYear: 1999, starring: "Luck Skywalker"),
            Film(title: "Star Wars: Clone Wars", releaseYear: 2003, starring: "Luck Skywalker"),
            Film(title: "Star Wars: Revenge of the Sith", releaseYear: 2005, starring: "Luck Skywalker")]
    }
}

struct Person {
    
    let name: String
    
    static var stubPerson: [Person] {
        return [
            Person(name: "Mark Hamill"),
            Person(name: "Harrison Ford"),
            Person(name: "Carrie Fisher"),
            Person(name: "Hayden Christensen"),
            Person(name: "Ewan McGregor"),
            Person(name: "Natalie Portman"),
            Person(name: "Liam Neeson")
        ]
    }
}
