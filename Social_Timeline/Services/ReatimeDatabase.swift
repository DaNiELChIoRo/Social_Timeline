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
    func onSuccess()
    func onUserDelete()
    func onDBError(_ error: String)
    func onPostFetched(_ username: String, _ userimage:String, _ content: String, _ timestamp: Double, _ multimedia: Any?)
    func onUserInfoFetched(_ username: String, _ useremail: String, _ userimage:String)
    func onUserInfoChanged(_ username:String, _ userimage: String)
}

extension realtimeDelegate {
    func onUserInfoFetched(_ username: String, _ useremail: String, _ userimage:String) {}
    func onPostFetched(_ username: String, _ userimage:String, _ content: String, _ timestamp: Double, _ multimedia: Any?) {}
    func onUserInfoChanged(_ username:String, _ userimage: String) {}
    func onUserDelete() {}
}

enum RealtimeDBError: Error {
    case emptyUserID
}

class RealtimeDatabase {
    
    var ref: DatabaseReference!
    var userid: String?
    var delegate: realtimeDelegate?
    var username:String?
    var userimage: String?
    var authorID: String?
    
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
            ref.child("users").child(userid).removeValue { (error, data) in
                if let error = error {
                    self.delegate?.onDBError(error.localizedDescription)
                } else {
                  self.delegate?.onUserDelete()
                }
            }
        } else {
            throw RealtimeDBError.emptyUserID
        }
    }
    
    func updateUserImage(withUerImagePath userImagePath: String) throws {
        let value = ["userimage": userImagePath]
        guard let userid = userid  else {
            throw RealtimeDBError.emptyUserID
        }
        ref.child("users").child(userid).updateChildValues(value)
    }
    
    //MARK:- WHEN USER CREATE POST
    func setUserPost(timestamp: Double, content: String, multimedia: AnyObject) throws {
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
            if let userimage = value["userimage"] as? String {
                self.delegate?.onUserInfoFetched(username, useremail, userimage)
            } else {
                self.delegate?.onUserInfoFetched(username, useremail, "")
            }
        }) { (error) in
            print("Error while trying to access user info, Error: \(error)")
            self.delegate?.onDBError("Error al intentar de extrear la información del usuario, error code: " + error.localizedDescription)
        }
    }
    
    func fetchAuthorInfo(authorID: String?, action: @escaping (_ username: String, _ imagePath: String) -> Void) {
        if self.authorID != nil && self.authorID == authorID {
            action(self.username!, self.userimage!)
            return
        }
        let orderQuery = (ref.child("users").child(authorID!).queryOrderedByKey())
        orderQuery
            .observe( .value, with: { (snapshot) in
            guard let value = snapshot.value as? NSDictionary else { return }
            guard let username = value["username"] as? String,
                let userimage = value["userimage"] as? String else { return }
                self.authorID = authorID
                self.username = username
                self.userimage = userimage
                action(username, userimage)
        }) { (error) in
            print("Error has ocurred while trying to fetch the post's author, Error: \(error)")
            self.delegate?.onDBError(error.localizedDescription)
        }
    }
    
    func fetchPosts(action: @escaping (_ username: String, _ userimage:String, _ content: String, _ timestamp: Double, _ multimedia: AnyObject?) -> Void) {
        let orderedChildren = (ref.child("post").queryOrdered(byChild: "timestamp").queryLimited(toLast: 6))
            orderedChildren
                .observe(.childAdded, with: { (snaptshot) in
                guard let value = snaptshot.value as? NSDictionary else { return }
                guard let author = value["author"] as? String,
                let content = value["content"] as? String,
                let timestamp = value["timestamp"] as? Double else { return }
                if let multimedia = value["multimedia"] as? NSDictionary {
                    action(author, "avatar", content, timestamp, multimedia)
                } else {
                    action(author, "avatar", content, timestamp, nil)
                }
        })
        { (error) in
            print("An error ocurred while trying to fetch the Posts, error: \(error)")
            self.delegate?.onDBError(error.localizedDescription)
        }
    }
    
    func fetchMorePosts(noPosts: UInt) {
        let orderedChildren = (ref.child("post").queryOrdered(byChild: "timestamp").queryLimited(toLast: noPosts))
        orderedChildren
            .observe(.childAdded, with: { (snaptshot) in
                guard let value = snaptshot.value as? NSDictionary else { return }
                guard let author = value["author"] as? String,
                    let content = value["content"] as? String,
                    let timestamp = value["timestamp"] as? Double else { return }
                if let multimedia = value["multimedia"] as? NSDictionary {
                    self.delegate?.onPostFetched(author, "avatar", content, timestamp, multimedia)
                } else {
                    self.delegate?.onPostFetched(author, "avatar", content, timestamp, nil)
                }
        })
        { (error) in
            print("An error ocurred while trying to fetch the Posts, error: \(error)")
            self.delegate?.onDBError(error.localizedDescription)
        }
    }
    
}
