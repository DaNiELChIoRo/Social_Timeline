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
        let height = self.frame.height
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
}
