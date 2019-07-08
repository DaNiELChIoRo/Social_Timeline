//
//  AutoAnchors.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 6/18/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

extension UIView {

    func autoAnchorsToTop(view: UIView, topMargin:CGFloat, horizontalPadding:CGFloat, heightPercentage: CGFloat) {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: topMargin),
            view.widthAnchor.constraint(equalTo: self.widthAnchor, constant: (horizontalPadding * -2)),
            view.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            view.heightAnchor.constraint(equalToConstant: (self.frame.height * heightPercentage ))
        ])
    }
    
    func autoAnchorsToBottom(bottomMargin:CGFloat, horizontalPadding:CGFloat, heightPercentage: CGFloat) {
        NSLayoutConstraint.activate([
            self.bottomAnchor.constraint(equalTo: (self.superview?.safeAreaLayoutGuide.bottomAnchor)!, constant: bottomMargin),
            self.widthAnchor.constraint(equalTo: self.superview!.widthAnchor, constant: (horizontalPadding * -2)),
            self.centerXAnchor.constraint(equalTo: (self.superview?.safeAreaLayoutGuide.centerXAnchor)!),
            self.heightAnchor.constraint(equalToConstant: (((self.superview?.frame.height)!) * heightPercentage ))
            ])
    }
    
    func autoAnchorsXCenter(topView: UIView, topMargin:CGFloat, horizontalPadding:CGFloat?, heightPercentage: CGFloat, widthPercentage:CGFloat) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: topMargin),
            self.centerXAnchor.constraint(equalTo: (self.superview?.safeAreaLayoutGuide.centerXAnchor)!, constant: horizontalPadding ?? 0),
            self.widthAnchor.constraint(equalTo: (self.superview?.safeAreaLayoutGuide.widthAnchor)!, multiplier: widthPercentage),
            self.heightAnchor.constraint(equalTo: (self.superview?.safeAreaLayoutGuide.heightAnchor)!, multiplier: heightPercentage)
            ])
    }
    
    func autoAnchorForImageView(topView: UIView, topMargin:CGFloat, horizontalPadding:CGFloat?, height: CGFloat, width:CGFloat) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: topMargin),
            self.centerXAnchor.constraint(equalTo: (self.superview?.safeAreaLayoutGuide.centerXAnchor)!, constant: horizontalPadding ?? 0),
            self.widthAnchor.constraint(equalToConstant: width),
            self.heightAnchor.constraint(equalToConstant: height)
            ])
    }
    
    func autoAnchorsXCenter(bottomView: UIView, bottomMargin:CGFloat, horizontalPadding:CGFloat?, heightPercentage: CGFloat, widthPercentage:CGFloat) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: bottomMargin),
            self.centerXAnchor.constraint(equalTo: (self.superview?.safeAreaLayoutGuide.centerXAnchor)!, constant: horizontalPadding ?? 0),
            self.widthAnchor.constraint(equalToConstant: ((self.superview?.frame.width)! * widthPercentage)),
            self.heightAnchor.constraint(equalToConstant: ((self.superview?.frame.height)! * heightPercentage ))
            ])
    }
    
    func LayoutWithVisualFormat(visualFormat: String, alignment: NSLayoutConstraint.FormatOptions, view: [String: Any]) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(withVisualFormat: visualFormat, options: alignment, metrics: nil, views: view)
    }
    
}
