//
//  UIAlert.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 7/10/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

extension UIViewController {

    func createAlertDesctructive(_ title: String, _ message: String, _ style: UIAlertController.Style, _ buttonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .destructive, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)        
    }
    
}
