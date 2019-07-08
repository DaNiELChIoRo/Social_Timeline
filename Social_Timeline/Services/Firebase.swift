//
//  Firebase.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 6/18/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import Firebase

class FirebaseService {
    
    var userDelegate: userDelegate!
    
    let Auth = Firebase.Auth.self
    
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
    
    func registerUser(email: String, password:String, callback: @escaping (_ error:String) -> Void) -> Bool {
        var response:Bool = false
        var usuario = Usuario()
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                let errorMessage = error.localizedDescription
                response = false
                callback(errorMessage)
            } else {
                if let result = result {
                    let user = result.user
                    usuario.email = user.email
                    usuario.uid = user.uid
                    response = true
                }
            }
        }
         return response
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
