//
//  ViewController.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 6/18/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

class ViewController: UITabBarController {
    
    let filmsVC = GenericTableViewController(items: Film.stubFilms, configure: { (cell: SubtitleTableViewCell, film) in
        cell.titleLabel?.text = film.title
        cell.releaseYearTextLabel?.text = "released year: \(film.releaseYear)"
        cell.starringLabel?.text = film.starring
    }) { (film) in
        print(film.title)
    }
    
    var coordinator: MainCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        coordinator?.tabBarCoordinator()
        let views = coordinator!.childCoordinators[0].childCoordinators
        var vis:[UIViewController] = [UIViewController]()
        views.forEach {  vis.append($0.navigationController as! UIViewController) }
        viewControllers = vis
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
