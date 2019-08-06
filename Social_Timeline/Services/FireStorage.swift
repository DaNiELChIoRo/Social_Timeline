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
    func onFileDeleted()
    func onError(_ error: String)
}

extension FireStorageDelegate {
    func onFileUploaded(_ filePath: String) {}
    func onFileDeleted() {}
}

enum FireStoreServiceError: Error {
    case noUserEmailError
}

enum contentType: String {
    case image = "image/jpeg"
    case video = "video/mp4"
    case audio = "audio/mp3"
}

class FireStorage {

    let storage = Storage.storage()
    let userUID = Auth.auth().currentUser
    
    var delegate: FireStorageDelegate?
    
    init() {}
    
    init(delegate: FireStorageDelegate ) {
        self.delegate = delegate
    }

    func upload(filePath: String, file: Data, contentType content: contentType) {
        guard let email = userUID?.email else { return }
        let filePath = "\(email)/" + "\(filePath)"
        let storageRef = self.storage.reference(withPath: filePath)
        let metadata = StorageMetadata()
        metadata.contentType = content.rawValue
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
        let storageRef = self.storage.reference().child(fileURL)
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
    
    func updateFileMetadata(withFilePath filePath: String, withNewContentType contentType: contentType) {
        let updateRef = self.storage.reference(withPath: filePath)
        let metadata = StorageMetadata()
        metadata.contentType = contentType.rawValue
        updateRef.updateMetadata(metadata) { (metadata, error) in
            if let error = error {
                self.delegate?.onError("An error has ocurred while trying to update the metadata of the file" + filePath + " Error message: " + error.localizedDescription)
            } else {
                print("File's metadata successfully updated!")
            }
        }
    }
    
    func deleteFile(withFilePath filePath: String) {
        guard let email = userUID?.email else { return }
        let filePath = "\(email)/" + "\(filePath)"
        let deleteRef = self.storage.reference(withPath: filePath)
        deleteRef.delete { (error) in
            if let error = error {
                self.delegate?.onError("An error has ocurred while trying to erase the file" + filePath + " Error message: " + error.localizedDescription)
            } else {
                self.delegate?.onFileDeleted()
            }
        }
    }
    
}
