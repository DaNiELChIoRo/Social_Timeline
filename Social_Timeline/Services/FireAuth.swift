//
//  Firebase.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 6/18/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import Firebase


protocol userDelegate {
    func onAuthError(error: String)
    func onUserCreated(user: Usuario)
    func onUserLogIn(user: Usuario)
    func onUserEliminated()
    func onPassResset()
}

extension userDelegate {
    func onUserLogIn(user: Usuario) {}
    func onUserCreated(user: Usuario) {}
    func eliminateUser() {}
    func onUserEliminated() {}
    func onPassResset() {}
}

enum AuthError: Error {
    case LoginError
    case gettingUserError
    case userIsNotLogOn
}

class FireAuth {
    
    var userDelegate: userDelegate!
    var realtimeDB: RealtimeDatabase!
    
    var _Auth: Auth!
    
    init(userDelegate: userDelegate){
        let Auth = Firebase.Auth.self
        self._Auth = Auth.auth()
        _Auth?.useAppLanguage()
        self.userDelegate = userDelegate
        if let userid = _Auth.currentUser?.uid {
            self.realtimeDB = RealtimeDatabase(userid: userid)
        } else {
            self.realtimeDB = RealtimeDatabase()
        }
    }
    
    func getUser() throws -> Usuario? {
        var usuario = Usuario()
        let user = _Auth.currentUser
        if let user = user {
            usuario.uid = user.uid
            usuario.email = user.email
            usuario.username = user.displayName
            return usuario
        } else {
            throw AuthError.gettingUserError
        }
    }
    
    func registerUser(username: String, email: String, password:String) {
        _Auth.createUser(withEmail: email, password: password) { (result, error) in
            guard let user = result?.user else {
                if let error = error {
                    print("Somethign went wrong while trying to create new user, error: \(error)")
                    self.userDelegate.onAuthError(error: "Algo ha ocurrido al intentar crear el usuario, error code: " + error.localizedDescription)
                }
                return
            }
            let usuario = Usuario(uid: user.uid, username: username, email: user.email)
            self.userDelegate.onUserCreated(user: usuario)
        }
    }
    
    func signIn(email:String, password:String) {
        _Auth.signIn(withEmail: email, password: password) { (result, error) in
            guard let user = result?.user else {
                if let error = error {
                    print("Somethign went wrong while singin with the user, error: \(error)")
                    self.userDelegate.onAuthError(error: "Algo ha ocurrido al intentar entrar con el email \(email), error code: " + error.localizedDescription)
                }
                return
            }
            let usuario = Usuario(uid: user.uid, username: user.email)
            self.userDelegate.onUserLogIn(user: usuario)
        }
    }
    
    func signOut(handler: () -> Void) {
        do{
            try _Auth.signOut()
            handler()
        } catch let error as NSError {
            print("An error ocurred while trying to singOut, error: \(error)")
            self.userDelegate?.onAuthError(error: "Error al intentar deslogear el usuario, error code: " + error.localizedDescription)
        }
    }
    
    func eliminateAccount() {
        guard let user =  _Auth.currentUser else { return }
        user.delete { (error) in
            if let error = error {
                print("Error ocurred while trying to eliminate user account!, Error: ", error.localizedDescription)
                self.userDelegate.onAuthError(error: error.localizedDescription)
            } else {
                do {
                    try self.realtimeDB.eraseUser()
                    self.userDelegate.onUserEliminated()
                } catch RealtimeDBError.emptyUserID {
                    self.userDelegate.onAuthError(error: "No se puede acceder al ID del usuario para su borrado en la DB")
                } catch {
                    self.userDelegate.onAuthError(error: "unkwon error!")
                }
            }
        }
    }
    
    func resetPassword() throws {
        if let useremail = _Auth.currentUser?.email {
            _Auth.sendPasswordReset(withEmail: useremail) { (error) in
                if let error = error {
                    self.userDelegate?.onAuthError(error: "Algo ha ocurrido al intentar reestablecer la contraseña del usuario, error code: " + error.localizedDescription)
                }
                self.userDelegate?.onPassResset()
            }
        } else {
            throw AuthError.userIsNotLogOn
        }
    }
    
}
