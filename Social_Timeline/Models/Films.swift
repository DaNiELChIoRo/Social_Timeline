//
//  Films.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 7/12/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

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
