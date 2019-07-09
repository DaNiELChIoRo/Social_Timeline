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

    func upload(filePath: String, file: URL, meta: StorageMetadata, callback: @escaping () -> Void){
        let filePath = "\(userUID!)" + "\(filePath)"
        let storageRef = self.storage.reference(withPath: filePath)
            storageRef.putFile(from: file, metadata: meta) { (meta, error) in
            if let error = error {
                print("Error while uploading userImage!, Error: \(error)")
                callback()
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
