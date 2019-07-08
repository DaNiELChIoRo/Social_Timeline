//
//  ThumbnailImage.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 7/8/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

class ThumbnailImageView: UIView {
    
    weak var image: UIImage?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(image:UIImage){
        self.init()
        self.image = image
    }
    
    func setupView(){
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .lightGray
//        let userImage: UIImageView? = UIImageView().defaultImageViewCreator(self.image!)
//        addSubview(userImage!)
        
    }
    
}
