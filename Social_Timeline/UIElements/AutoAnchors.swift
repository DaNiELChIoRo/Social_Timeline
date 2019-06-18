//
//  AutoAnchors.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 6/18/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

extension UIView {

    func autoAnchorsToTop(view: UIView, topMargin:CGFloat, horizontalPadding:CGFloat?, heightPercentage: CGFloat) {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: topMargin),
            view.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor, constant: horizontalPadding ?? 0),
            view.heightAnchor.constraint(equalToConstant: (self.frame.height * heightPercentage ))
        ])
    }
    
    func autoAnchorsXCenter(topView: UIView, topMargin:CGFloat, horizontalPadding:CGFloat?, heightPercentage: CGFloat, widthPercentage:CGFloat) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: topMargin),
            self.centerXAnchor.constraint(equalTo: (self.superview?.safeAreaLayoutGuide.centerXAnchor)!, constant: horizontalPadding ?? 0),
            self.widthAnchor.constraint(equalToConstant: ((self.superview?.frame.width)! * widthPercentage)),
            self.heightAnchor.constraint(equalToConstant: ((self.superview?.frame.height)! * heightPercentage ))
            ])
        
    }
    
}
