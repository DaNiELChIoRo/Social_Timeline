//
//  UIImageView.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 7/1/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func defaultImageViewCreator(_ image: UIImage) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    func thumbnailImageViewCreator(_ image: UIImage, cornerRadius: CGFloat) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = image
        imageView.layer.cornerRadius = cornerRadius
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
}
