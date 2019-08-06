//
//  Helpers.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 7/12/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

public extension UIView {
    
    func addSubviews(_ views:[UIView]){
        for view in views {
            self.addSubview(view)
        }
    }
    
}

public extension UIImageView {
    
    func downloadImageFromFireStorage(imageURL: String, imageName: String) {
        if let userimage = imageCache.object(forKey: NSString(string:imageURL)) {
            self.image = userimage
            return
        } else {
            FireStorage().download(fileURL: imageURL, withFileName: imageName, onsucess: { (imagePath) in
                guard let userimage = UIImage(contentsOfFile: imagePath) else { return }
                imageCache.setObject(userimage, forKey: NSString(string: imageURL))
                self.image = userimage
                print("downloading image!!!!!!")
            }, onError: { (error) in
                print("******* Error: " + error)
            })
        }
    }
    
}
