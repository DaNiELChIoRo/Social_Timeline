//
//  ThumbnailImage.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 7/8/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

protocol userImageDelegate {
    func changeUserImage()
}

class ThumbnailImageView: UIView {
    
    var image: UIImage? = UIImage(named: "avatar")
    var userImage: UIImageView?
    var userImageDelegate: userImageDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(image:UIImage, delegate: userImageDelegate){
        self.init()
        self.image = image
        self.userImageDelegate = delegate
    }
    
    override func layoutSubviews() {
        let height = frame.size.height
        print("user Thumbnail image height: \(height)")
        userImage!.layer.cornerRadius = height / 2
    }
    
    func setupView(){
        
        let height = frame.size.height
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .lightGray
        userImage = UIImageView().thumbnailImageViewCreator(self.image!, cornerRadius: height/2)
        userImage!.contentMode = .scaleAspectFill
        userImage!.clipsToBounds = true
        userImage!.backgroundColor = .red
        
        addSubview(userImage!)
        addConstraints(LayoutWithVisualFormat(visualFormat: "H:|-[v0]-|", alignment: .alignAllCenterX, view: ["v0": userImage!]))
        addConstraints(LayoutWithVisualFormat(visualFormat: "V:|-[v0]-|", alignment: .alignAllCenterY, view: ["v0": userImage!]))
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
    }
    
    public func changeUserImage(image: UIImage) {
        userImage?.image = image
    }
    
    @objc func tapGestureHandler(){
        print("taoGestureHandler")
        userImageDelegate?.changeUserImage()
    }
    
}
