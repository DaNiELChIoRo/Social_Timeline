//
//  NoPostsView.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 6/18/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

class NoPostsView: UIView {
    
    var noPostsLabel:UILabel? = UILabel().createDefaultLabel("No hay posts aún!", 24, .bold, .black)

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = UIColor.white
        
        addSubview(noPostsLabel!)
        noPostsLabel?.backgroundColor = UIColor.red
        self.autoAnchorsToTop(view: noPostsLabel!, topMargin: 30, horizontalPadding: nil, heightPercentage: 0.4)
    }
    
}
