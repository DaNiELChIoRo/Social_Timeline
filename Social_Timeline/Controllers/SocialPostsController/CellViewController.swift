//
//  CellViewController.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 6/18/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

class SubtitleTableViewCell: UITableViewCell {
    
    var titleLabel: UILabel? = UILabel().createDefaultLabel("", 24, .regular, .black, .left)
    var releaseYearTextLabel: UILabel? = UILabel().createDefaultLabel("", 24, .regular, .black, .left)
    var contentLabel: UILabel? = UILabel().createDefaultLabel("", 24, .regular, .black, .center)
    var postInfo:PostInfoView?
    var postContent: PostContentView?
    var userImage: UIImage? = UIImage(named: "avatar")!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: nil)
        setupCell()
    }
    
    let height = UIScreen.main.bounds.height
    
    func setupCell() {
        let imageSize = height*0.07
        self.postInfo =  PostInfoView(titleLabel: self.titleLabel , releaseYearText: self.releaseYearTextLabel, imageSize: imageSize, image: userImage!)
        self.postContent = PostContentView(content: contentLabel)
        
        postInfo!.backgroundColor = .green
        postContent!.backgroundColor = .magenta
        addSubviews([postInfo!, postContent!])
        addConstraints(self.LayoutWithVisualFormat(visualFormat: "H:|-[v0]-|", alignment: .alignAllCenterY, view: ["v0": postInfo!]))
        addConstraints(self.LayoutWithVisualFormat(visualFormat: "H:|-[v0]-|", alignment: .alignAllCenterY, view: ["v0": postContent!]))
        addConstraints(self.LayoutWithVisualFormat(visualFormat: "V:|-[v0(\(imageSize))]-2-[v1(\(height*0.1))]-|", alignment: .alignAllCenterX, view: ["v0": postInfo!, "v1":postContent!]))
    }
    
    func setImage(image: UIImage) {
        postInfo?.userImage?.changeUserImage(image: image)
    }
}

extension SubtitleTableViewCell: userImageDelegate {
    func changeUserImage() { }
}
