//
//  Firebase.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 6/18/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import Firebase

protocol FirebaseUserCreated {
    func onUserCreated(user:Usuario)
}

class FirebaseService {
    
    var userDelegate: userDelegate!
    var firebaseUserCreatedDelegate: FirebaseUserCreated!
    
    let Auth = Firebase.Auth.self
    
    init() {
        
    }
    
    init(delegateFirebaseUser: FirebaseUserCreated){
        self.firebaseUserCreatedDelegate = delegateFirebaseUser
    }
    
    func getUser() -> Usuario? {
        var usuario = Usuario()
        let user = Auth.auth().currentUser
        if let user = user {
            usuario.uid = user.uid
            usuario.email = user.email
            usuario.username = user.displayName
            return usuario
        } else {
            return nil
        }
    }
    
    func registerUser(email: String, password:String, callback: @escaping (_ error:String) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            guard let user = result?.user else {
                let errorMessage = error!.localizedDescription
                callback(errorMessage)
                return
            }
            var usuario = Usuario(uid: user.uid, username: user.email, email: user.email)
            self.firebaseUserCreatedDelegate.onUserCreated(user: usuario)
        }
    }
    
    func signIn(email:String, password:String, callback: @escaping (_ error:String) -> Void) -> Bool {
        var response = false
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Somethign went wrong while singin with the user, error: \(error)")
                callback(error.localizedDescription)
            } else {
                response = true
            }
        }
        return response
    }
    
    func signOut(handler: () -> Void) {
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
            handler()
        } catch let error as NSError {
            print("An error ocurred while trying to singOut, error: \(error)")
        }
    }
    
}

protocol userDelegate {
    func createUser()
}
