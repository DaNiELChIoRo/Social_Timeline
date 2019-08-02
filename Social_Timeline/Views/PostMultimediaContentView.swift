//
//  PostMultimediaContentView.swift
//  Social_Timeline
//
//  Created by Daniel Meneses on 8/1/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit
import SnapKit

class PostMultimediaContentView: UIView {
    
    var contentImageView:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        self.contentImageView = UIImageView(image: UIImage(named: "avatar2")!)
        
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentImageView)
        
//        contentImageView.backgroundColor = .green
        contentImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
            make.height.lessThanOrEqualToSuperview()
        }
        
    }
    
}
