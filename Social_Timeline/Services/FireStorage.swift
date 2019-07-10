//
//  FireStorage.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 7/9/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import Foundation
import Firebase

class FireStorage {

    let storage = Storage.storage()
    let userUID = Auth.auth().currentUser

    func upload(filePath: String, file: Data, callback: @escaping (_ error: String) -> Void){
        guard let email = userUID?.email else { return }
        let filePath = "\(email)/" + "\(filePath)"
        let storageRef = self.storage.reference(withPath: filePath)
            storageRef.putData(file, metadata: StorageMetadata()) { (meta, error) in
            if let error = error {
                print("Error while uploading userImage!, Error: \(error)")
                callback(error.localizedDescription)
                return
            }
            //TODO realtimedatabase to save userImage file location!
            RealtimeDatabase().saveUserImagePath(userImagePath: "\(storageRef)")
        }
    }
    
    func download(_ storageRef: StorageReference, storagePath: String){
        storageRef.downloadURL { (url, error) in
            if let error = error {
                print("Error while trying to download file!, Error: \(error)")
                return
            }
            
        }
    }
    
}
