//
//  StoryboardProtocol.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 7/9/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

//extension Storyboarded where Self: UIViewController {
//    static func instantiate() -> Self {
//        let fullName = NSStringFromClass(self)
//        let className = fullName.components(separatedBy: ".")[1]
//        
//    }
//}
