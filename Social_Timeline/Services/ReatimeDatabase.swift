//
//  ReatimeDatabase.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 7/8/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import Foundation
import Firebase

class RealtimeDatabase {
    
    var ref: DatabaseReference!
    
    func writeUser(user:Usuario){
        let userid = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        ref.child("users").child(user.uid!).setValue(["username": user.username])
    }
    
}
