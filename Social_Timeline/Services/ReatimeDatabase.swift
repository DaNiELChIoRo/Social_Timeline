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
    let userid = Auth.auth().currentUser?.uid
    
    func writeUser(user:Usuario){
        ref = Database.database().reference()
        ref.child("users").child(user.uid!).setValue(["username": user.username])
    }
    
    func saveUserImagePath(userImagePath: String){
        ref = Database.database().reference()
        let value = ["userimage": userImagePath]
        ref.child("users").child(userid!).setValue(value)
    }
    
}
