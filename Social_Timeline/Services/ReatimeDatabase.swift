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
        ref.child("users").child(userid!).updateChildValues(value)
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
    
    func fetchAuthorInfo(authorID: String?, action: @escaping (_ username: String, _ userimage: String) -> Void, onError: @escaping (_ error:String) -> Void) {
        ref = Database.database().reference()
        ref.child("users").child(authorID!).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? NSDictionary else { return }
            guard let username = value["username"] as? String,
                let userimage = value["userimage"] as? String else { return }
            action(username, userimage)
            }) { (error) in
                print("Error has ocurred while trying to fetch the post's author, Error: \(error)")
                onError(error.localizedDescription)
        }
    }
    
    func fetchUserImageRef(onsucess: @escaping (_ imagePath: String) -> Void, onError: @escaping (_ error:String) -> Void) {
        ref = Database.database().reference()
        ref.child("users").child(userid!).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? NSDictionary else { return }
            guard let userimageRef = value["userimage"] as? String else { return }
            FireStorage().download( fileURL: userimageRef, onsucess: onsucess, onError: onError)
            
        }) { (error) in
            print("Error while trying to access user info, Error: \(error)")
            onError(error.localizedDescription)
        }
    }
    
    func fetchAllPosts(action: @escaping (_ username: String, _ userimage:String, _ content: String, _ timestamp: Int) -> Void, onError: @escaping (_ error: String) -> Void) {
        ref = Database.database().reference()
        ref.child("post").observeSingleEvent(of: .value, with: { (snaptshot) in
//            guard let values = snaptshot.value as? NSDictionary else { return }
            for child in snaptshot.children {
                guard let snap = child as? DataSnapshot else { return }
                guard let value = snap.value as? NSDictionary else { return }
                guard let author = value["author"] as? String,
                let content = value["content"] as? String,
                let timpestamp = value["timestamp"] as? Int else { return }
                func _action(_ username: String, _ userImage: String) {
                    action(username, userImage, content, timpestamp)
                }
                self.fetchAuthorInfo(authorID: author, action: _action, onError: onError)
            }
            
            
        }) { (error) in
            print("An error ocurred while trying to fetch the Posts, error: \(error)")
            onError(error.localizedDescription)
        }
    }
    
}
