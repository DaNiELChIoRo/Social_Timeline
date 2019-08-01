//
//  MuitilmediaTableViewCell.swift
//  FirebaseAuth
//
//  Created by Daniel Meneses on 7/26/19.
//

import UIKit
import SnapKit

@objc protocol BaseCell {
    var titleLabel: UILabel? { get }
    var publishDateLabel: UILabel? { get }
    var contentLabel: UILabel? { get }
}

protocol MultimediaCell: BaseCell {
    var titleLabel: UILabel? { get }
    var publishDateLabel: UILabel? { get }
    var contentLabel: UILabel? { get }
}

class MultimediaTableViewCell: UITableViewCell {
    
    var titleLabel: UILabel? = UILabel().createDefaultLabel("", 24, .regular, .black, .left)
    var publishDateLabel: UILabel? = UILabel().createDefaultLabel("", 24, .regular, .black, .left)
    var contentLabel: UILabel? = UILabel().createDefaultLabel("Default content", 24, .regular, .black, .center)
    var postInfo:PostInfoView?
    var postContent: PostContentView?
    var postMultimedia: UIView?
    var userImage: UIImage? = UIImage(named: "avatar")!
    
    let imageSize = UIScreen.main.bounds.height*0.07
    let height = UIScreen.main.bounds.height
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle , reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: nil)
        setupCell()
    }
    
    func setupCell() {
        
        backgroundColor = .red
        let imageSize = height*0.07
        self.postInfo =  PostInfoView(titleLabel: self.titleLabel , releaseYearText: self.publishDateLabel, imageSize: imageSize, image: userImage!)
        self.postContent = PostContentView(content: contentLabel)
        postContent!.sizeToFit()
        self.postMultimedia = UIView()
        
        addSubviews([postInfo!, postContent!, postMultimedia!])
        
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
//            make.bottom.equalToSuperview().offset(-8)
        }
        
        postMultimedia!.backgroundColor = .green
        postMultimedia!.snp.makeConstraints { (make) in
            make.top.equalTo(postContent!.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-16)
            make.height.equalTo(height*0.3)
            make.bottom.equalToSuperview().offset(-8)
        }
        
    }
    
    func setImage(imageURL: String) {
        if let userImage = postInfo?.userImage?.userImage {
            userImage.downloadImageFromFireStorage(imageURL: imageURL)
        }
    }
    
    func setMultimediaContent(_ contentURL: String) {
         
    }
    
}
