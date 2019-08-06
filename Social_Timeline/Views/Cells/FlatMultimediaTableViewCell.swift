//
//  CellViewController.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 6/18/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit
import SnapKit

protocol FlatMultimediaCell: BaseCell {
    var titleLabel: UILabel? { get }
    var publishDateLabel: UILabel? { get }
    var contentLabel: UILabel? { get }
}

class FlatMultimediaTableViewCell: UITableViewCell, FlatMultimediaCell {
    
    
    var titleLabel: UILabel? = UILabel().createDefaultLabel("", 24, .regular, .black, .left)
    var publishDateLabel: UILabel? = UILabel().createDefaultLabel("", 24, .regular, .black, .left)
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
        self.postInfo =  PostInfoView(titleLabel: self.titleLabel , releaseYearText: self.publishDateLabel, imageSize: imageSize, image: userImage!)
        self.postContent = PostContentView(content: contentLabel)
        postContent!.sizeToFit()
        
        addSubviews([postInfo!, postContent!])
        
        postInfo!.snp.makeConstraints { (make) in
            make.width.equalToSuperview().offset(-16)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.height.equalTo(imageSize)
        }
        
        postContent!.snp.makeConstraints { (make) in
            make.top.equalTo(postInfo!.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-16)
            make.height.equalTo((self.contentLabel?.snp.height)!)
            make.bottom.equalToSuperview().offset(-8)
        }
        
    }
    
    func setImage(imageURL: String, username: String) {
        postInfo?.userImage?.userImage?.downloadImageFromFireStorage(imageURL: imageURL, imageName: username + ".jpeg")
    }
}

extension FlatMultimediaTableViewCell: userImageDelegate {
    func changeUserImage() { }
}
