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
                do {
                    try RealtimeDatabase(userid: self.userUID!.uid).saveUserImagePath(userImagePath: "\(filePath)")
                } catch {
                    print("Error al intantar guardar la referencia del usuario en la base de datos RealtimeDatabase")
                }
        }
    }
    
    func download( fileURL: String, onsucess: @escaping (_ imagePath: String) -> Void, onError: @escaping (_ error: String) -> Void ) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let localURL = documentsURL.appendingPathComponent("userAvatar.jpeg")
        let storageRef = Storage.storage().reference().child(fileURL)
//        if let _imagePath = imageCache.object(forKey: NSString(string: fileURL)) {
//            onsucess(String(_imagePath))
//            return
//        }
        storageRef.write(toFile: localURL) { (url, error) in
            if let error = error {
                print("error trying to download the file, Error: \(error.localizedDescription)")
                onError(error.localizedDescription)
            } else if let imagePath = url?.path {
                print("file is going to be on url: " + imagePath)
//                imageCache.setObject(NSString(string: imagePath), forKey: NSString(string: fileURL))
                onsucess(imagePath)
            }
        }
    }
    
}
