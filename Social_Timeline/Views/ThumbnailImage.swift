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
    
    public var image: UIImage? = UIImage(named: "avatar")
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
    
    func setupView(){
        
         let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .lightGray
        userImage = UIImageView().defaultImageViewCreator(self.image!)
        userImage!.contentMode = .scaleAspectFit
        addSubview(userImage!)
        addConstraints(LayoutWithVisualFormat(visualFormat: "H:|-32-[v0]-32-|", alignment: .alignAllCenterX, view: ["v0": userImage!]))
        addConstraints(LayoutWithVisualFormat(visualFormat: "V:|-32-[v0]-32-|", alignment: .alignAllCenterY, view: ["v0": userImage!]))
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
    }
    
    public func changeUserImage(image: UIImage) {
        self.image = image
    }
    
    @objc func tapGestureHandler(){
        print("taoGestureHandler")
        userImageDelegate?.changeUserImage()
    }
    
}
