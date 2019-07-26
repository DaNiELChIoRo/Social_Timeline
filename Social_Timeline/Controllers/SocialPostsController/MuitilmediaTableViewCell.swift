//
//  MuitilmediaTableViewCell.swift
//  FirebaseAuth
//
//  Created by Daniel Meneses on 7/26/19.
//

import UIKit

class MultimediaTableViewCall: UITableViewCell {
    
    var titleLabel: UILabel?
    var publishDate: UILabel?
    var contentLabel: UILabel? = UILabel().createDefaultLabel("", 24, .regular, .black, .center)
    var postInfo:PostInfoView?
    var postContent: PostContentView?
    var userImage: UIImage? = UIImage(named: "avatar")!
    
    let height =  UIScreen.main.bounds.height
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle , reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: nil)
        setupCell()
    }
    
    func setupCell() {
        let imageSize = height*0.07
        self.postInfo =  PostInfoView(titleLabel: self.titleLabel , releaseYearText: self.publishDate, imageSize: imageSize, image: userImage!)
        self.postContent = PostContentView(content: contentLabel)
                postInfo!.backgroundColor = .green
                postContent!.backgroundColor = .blue
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
    
}
