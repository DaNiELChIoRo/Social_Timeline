//
//  Post.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 7/12/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

struct Post {
    var title: String
    let publishDate: Double
    let content: String
    let multimedia: Any
    var userimage: UIImage
    
}

struct Post1: Decodable {
    let username: String
    let publishDate: Double
    let content: String
    
}
