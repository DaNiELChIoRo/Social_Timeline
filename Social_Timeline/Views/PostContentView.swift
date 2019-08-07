//
//  PostContentView.swift
//  FirebaseAuth
//
//  Created by Daniel Meneses on 7/12/19.
//

import UIKit
import SnapKit

class PostContentView: UIView {
    
    var content: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(content: UILabel?){
        self.init()
        self.content = content
        setupView()
    }
    
    func setupView() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        content!.textAlignment = .left
        content!.sizeToFit()
        addSubview(content!)
        content!.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
            make.top.equalToSuperview()
        }
                
    }
    
}
