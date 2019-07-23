//
//  ReatimeDatabase.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 7/8/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import Foundation
import Firebase

protocol realtimeDelegate {
    func onUserInfoFetched(_ username: String, _ useremail: String)
    func onUserImageFetched(_ imagePath: String)
    func onSuccess()
    func onError(_ error: String)
}

enum RealtimeDBError: Error {
    case emptyUserID
}

class RealtimeDatabase {
    
    var ref: DatabaseReference!
    var userid: String?
    var delegate: realtimeDelegate?
    
    init(){
        ref = Database.database().reference()
        if let userid = Auth.auth().currentUser?.uid {
            self.userid = userid
        }
    }
    
    init(userid: String) {
        ref = Database.database().reference()
        self.userid = userid
    }
    
    init(delegate: realtimeDelegate) {
        self.delegate = delegate
        ref = Database.database().reference()
        if let userid = Auth.auth().currentUser?.uid {
            self.userid = userid
        }
    }
    
    func writeUser(user:Usuario) {
        ref.child("users").child(user.uid!).setValue(["username": user.username, "useremail": user.email, "userimage": "null"])
        delegate?.onSuccess()
    }
    
    func eraseUser() throws {
        if let userid = userid {
            ref.child("users").child(userid).removeValue()
        } else {
            throw RealtimeDBError.emptyUserID
        }
    }
    
    func saveUserImagePath(userImagePath: String) throws {
        let value = ["userimage": userImagePath]
        guard let userid = userid  else {
            throw RealtimeDBError.emptyUserID
        }
        ref.child("users").child(userid).updateChildValues(value)
    }
    
    //MARK:- WHEN USER CREATE POST
    func setUserPost(timestamp: Double, content: String, multimedia: Bool) throws {
        guard let userid = userid  else {
            throw RealtimeDBError.emptyUserID
        }
        ref.child("post").childByAutoId().setValue([
            "author": userid,
            "content": content,
            "timestamp": timestamp,
            "multimedia": multimedia
            ])
    }
    
    func fetchUserInfo() throws {
        guard let userid = userid else {
            throw RealtimeDBError.emptyUserID
        }
        ref.child("users").child(userid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? NSDictionary else { return }
            guard let username = value["username"] as? String,
                let useremail = value["useremail"] as? String else { return }
            self.delegate?.onUserInfoFetched(username, useremail)
        }) { (error) in
            print("Error while trying to access user info, Error: \(error)")
            self.delegate?.onError("Error al intentar de extrear la información del usuario, error code: " + error.localizedDescription)
        }
    }
    
    func fetchUserImageRef() throws {
        guard let userid = userid else {
            throw RealtimeDBError.emptyUserID
        }
        ref.child("users").child(userid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? NSDictionary else { return }
            guard let userimageRef = value["userimage"] as? String else { return }
            if userimageRef != "null"{
                FireStorage().download( fileURL: userimageRef, onsucess: self.delegate!.onUserImageFetched, onError: self.delegate!.onError)
            } else {
                print("El usuario no tiene imagen!")
            }
        }) { (error) in
            print("Error while trying to access user info, Error: \(error)")
            self.delegate?.onError(error.localizedDescription)
        }
    }
    
    func fetchAuthorInfo(authorID: String?, action: @escaping (_ username: String, _ userimage: String) -> Void, onError: @escaping (_ error:String) -> Void) {
        ref.child("users").child(authorID!).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let value = snapshot.value as? NSDictionary else { return }
            guard let username = value["username"] as? String,
                let userimage = value["userimage"] as? String else { return }
            
            func _getUserImagePath(_ imagePath: String) {
                action(username, imagePath)
            }
            
            FireStorage().download(fileURL: userimage, onsucess: _getUserImagePath, onError: onError)
            
        }) { (error) in
            print("Error has ocurred while trying to fetch the post's author, Error: \(error)")
            onError(error.localizedDescription)
        }
    }
    
    func fetchAllPosts(action: @escaping (_ username: String, _ userimage:String, _ content: String, _ timestamp: Double) -> Void, onError: @escaping (_ error: String) -> Void) {
        let orderedChildren = (ref.child("post").queryOrdered(byChild: "timestamp"))
//        let orderedChildren = (ref.child("post").queryOrderedByKey())
//        ref.child("post")
            orderedChildren
                .observe(.value, with: { (snaptshot) in
            for child in snaptshot.children {
                let snap = snaptshot.childSnapshot(forPath: (child as AnyObject).key)

                print("children: \(snap.key)")
                guard let value = snap.value as? NSDictionary else { return }
                guard let author = value["author"] as? String,
                let content = value["content"] as? String,
                let timestamp = value["timestamp"] as? Double else { return }
                
                self.ref.child("users").child(author).observe( .childAdded, with: { (snapshot) in
                    guard let value = snapshot.value as? NSDictionary else { return }
                    guard let username = value["username"] as? String,
                        let userimage = value["userimage"] as? String else { return }
                    
                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                    let localURL = documentsURL.appendingPathComponent("\(username)_avatar.jpeg")
                    let storageRef = Storage.storage().reference().child(userimage)
                    storageRef.write(toFile: localURL) { (url, error) in
                        if let error = error {
                            print("error trying to download the file, Error: \(error.localizedDescription)")
                            onError(error.localizedDescription)
                        } else if let imagePath = url?.path {
                            
                            action(username, imagePath, content, timestamp)
                        }
                    }
                    
                })  { (error) in
                        print("Error while trying to access user info, Error: \(error)")
                        onError(error.localizedDescription)
                }
                
//                func _action(_ username: String, _ userImage: String) {
//
//                    action(username, userImage, content, timpestamp)
//                }
//                self.fetchAuthorInfo(authorID: author, action: _action, onError: onError)
            }

        })
        { (error) in
            print("An error ocurred while trying to fetch the Posts, error: \(error)")
            onError(error.localizedDescription)
        }
    }
    
}
