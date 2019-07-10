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
    
    func fetchUserInfo(action: @escaping (_ username: String, _ email: String) -> Void, callback: @escaping (_ error:String) -> Void) {
        ref = Database.database().reference()
        ref.child("users").child(userid!).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? NSDictionary else { return }
            guard let username = value["username"] as? String,
                    let useremail = value["useremail"] as? String else { return }
            action(username, useremail)
            
        }) { (error) in
            print("Error while trying to access user info, Error: \(error)")
            callback(error.localizedDescription)
        }
    }
    
}
