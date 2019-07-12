//
//  Post.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 7/12/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

struct Post {
    let username: String
    let publishDate: Int
    let content: String
    
    static var stubPosts: [Post] {
        return [
            Post(username: "DaNiEL", publishDate: 1562146200, content: "Algo locochon"),
            Post(username: "Alex Mario", publishDate: 1562146310, content: "Feel app para saber tu estado de animo!")
        ]
    }
}
