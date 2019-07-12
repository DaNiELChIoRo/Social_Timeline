//
//  PostInfoView.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 7/12/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

class PostInfoView: UIView {
    
    var starringLabel: UILabel?
    var titleLabel: UILabel?
    var releaseYearTextLabel: UILabel?
    var userInfo: UIView? = UIView()
    var userImage:ThumbnailImageView?
    var imageSize: CGFloat!
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    convenience init(titleLabel: UILabel?, releaseYearText: UILabel?, imageSize: CGFloat?){
        self.init()
        self.titleLabel = titleLabel!
        self.releaseYearTextLabel = releaseYearText!
        self.imageSize = imageSize!
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    func setupView() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        userImage = ThumbnailImageView(image: UIImage(named: "avatar")!, delegate: self)
        userImage!.backgroundColor = .red
        
        userInfo!.translatesAutoresizingMaskIntoConstraints = false
        userInfo!.backgroundColor = .lightGray
        
        titleLabel!.font = UIFont.boldSystemFont(ofSize: 11)
        releaseYearTextLabel!.font = UIFont.systemFont(ofSize: 10)
        
        userInfo!.addSubviews([titleLabel!, releaseYearTextLabel!])
        
        userInfo!.addConstraints(self.LayoutWithVisualFormat(visualFormat: "H:|-[v0]", alignment: .alignAllCenterX, view: ["v0" : titleLabel!]))
        userInfo!.addConstraints(self.LayoutWithVisualFormat(visualFormat: "H:|-[v0]", alignment: .alignAllCenterX, view: ["v0" : releaseYearTextLabel!]))
        
        userInfo!.addConstraints(self.LayoutWithVisualFormat(visualFormat: "V:|-6-[v0]-2-[v1]-6-|", alignment: .alignAllCenterX, view: [ "v0" : titleLabel!, "v1": releaseYearTextLabel!]))
        self.addSubviews([userInfo!, userImage!])
        addConstraints(self.LayoutWithVisualFormat(visualFormat: "H:|-[v0(\(imageSize-16))]-20-[v1]-|", alignment: .alignAllCenterY, view: ["v0": userImage!, "v1": userInfo!]))
        addConstraints(self.LayoutWithVisualFormat(visualFormat: "V:|-[v0]-|", alignment: .alignAllCenterX, view: ["v0": userImage!]))
        addConstraints(self.LayoutWithVisualFormat(visualFormat: "V:|-[v0]-|", alignment: .alignAllCenterX, view: ["v0": userInfo!]))
        
    }
    
}

extension PostInfoView: userImageDelegate {
    func changeUserImage() { }
}
