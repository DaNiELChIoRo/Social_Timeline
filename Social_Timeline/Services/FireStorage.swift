//
//  FireStorage.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 7/9/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import Foundation
import Firebase

protocol FireStorageDelegate {
    func onFileUploaded(_ filePath: String)
    func onError(_ error: String)
}

extension FireStorageDelegate {
    func onFileUploaded(_ filePath: String) {}
}

enum FireStoreServiceError: Error {
    case noUserEmailError
    
}

class FireStorage {

    let storage = Storage.storage()
    let userUID = Auth.auth().currentUser
    
    var delegate: FireStorageDelegate?
    
    init() {}
    
    init(delegate: FireStorageDelegate ) {
        self.delegate = delegate
    }

    func upload(filePath: String, file: Data) {
        guard let email = userUID?.email else { return }
        let filePath = "\(email)/" + "\(filePath)"
        let storageRef = self.storage.reference(withPath: filePath)
        storageRef.putData(file, metadata: StorageMetadata()) { (meta, error) in
            if let error = error {
                print("Error while uploading userImage!, Error: \(error)")
                self.delegate?.onError(error.localizedDescription)
            }
                self.delegate?.onFileUploaded(filePath)
        }
        
    }
    
    func download( fileURL: String, onsucess: @escaping (_ imagePath: String) -> Void, onError: @escaping (_ error: String) -> Void ) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let localURL = documentsURL.appendingPathComponent("userAvatar.jpeg")
        let storageRef = Storage.storage().reference().child(fileURL)
        storageRef.write(toFile: localURL) { (url, error) in
            if let error = error {
                print("error trying to download the file, Error: \(error.localizedDescription)")
                onError(error.localizedDescription)
            } else if let imagePath = url?.path {
                print("file is going to be on url: " + imagePath)
                onsucess(imagePath)
            }
        }
    }
    
}
