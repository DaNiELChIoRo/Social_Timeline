//
//  CellViewController.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 6/18/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

class SubtitleTableViewCell: UITableViewCell {
    
    var starringLabel: UILabel? = UILabel().createDefaultLabel("", 12, .regular, .red, .left)
    var titleLabel: UILabel? = UILabel().createDefaultLabel("", 12, .regular, .black, .left)
    var releaseYearTextLabel: UILabel? = UILabel().createDefaultLabel("", 12, .regular, .black, .left)
//    let userImage = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: nil)
        setupCell()
    }
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    func setupCell() {
        
        let userInfoView = UIView()
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        userInfoView.backgroundColor = .blue
        
        userInfoView.addSubview(titleLabel!)
        userInfoView.addSubview(starringLabel!)
        userInfoView.addSubview(releaseYearTextLabel!)
        
//        let h = UIScreen.main.bounds.height
//        self.heightAnchor.constraint(equalToConstant: h * 0.2)
        userInfoView.addConstraints(self.LayoutWithVisualFormat(visualFormat: "H:|-[v0]", alignment: .alignAllCenterX, view: ["v0" : titleLabel!]))
        userInfoView.addConstraints(self.LayoutWithVisualFormat(visualFormat: "H:|-[v0]", alignment: .alignAllCenterX, view: ["v0" : releaseYearTextLabel!]))
        userInfoView.addConstraints(self.LayoutWithVisualFormat(visualFormat: "H:|-[v0]", alignment: .alignAllCenterX, view: ["v0" : starringLabel!]))
        
        userInfoView.addConstraints(self.LayoutWithVisualFormat(visualFormat: "V:|-[v0]-10-[v1]-10-[v2]-|", alignment: .alignAllCenterX, view: [ "v0" : titleLabel!, "v1": releaseYearTextLabel!, "v2" : starringLabel!, "v3": userInfoView]))
        
        addSubview(userInfoView)
        
        addConstraints(self.LayoutWithVisualFormat(visualFormat: "H:|-[v0]-|", alignment: .alignAllCenterX, view: ["v0" : userInfoView]))
        addConstraints(self.LayoutWithVisualFormat(visualFormat: "V:|-[v0(\(height*0.12))]-|", alignment: .alignAllCenterX, view: ["v0" : userInfoView]))
    }

}
