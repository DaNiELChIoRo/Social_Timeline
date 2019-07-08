//
//  UILabel.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 6/18/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

extension UILabel {
    
    func createDefaultLabel(_ title:String, _ fontSize: CGFloat, _ fontWeight: UIFont.Weight, _ textColor: UIColor, _ textAlignment: NSTextAlignment) -> UILabel {
        let label = UILabel()
        let attributtedText = NSAttributedString(attributedString: NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: fontWeight)]))
        label.textColor = textColor
        label.attributedText = attributtedText
        label.textAlignment = textAlignment
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
