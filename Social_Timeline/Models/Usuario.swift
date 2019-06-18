//
//  Usuario.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 6/18/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import Foundation

struct Usuario {
    
    var uid: String?
    var username: String?
    var email: String?
    var userImage: URL?
    
    init(){
        self.init(uid: nil, username: nil, email: nil)
    }
    
    init(uid: String?, username: String?, email: String?){
        self.uid = uid
        self.username = username
        self.email = email
    }
    
}
