//
//  ProfileController.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 6/18/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    
    var userName:UILabel? = UILabel().createDefaultLabel("Welcome!", 24, .bold, .black)
    var logOutButton: UIButton? = UIButton().createDefaultButton("LogOut", .red, 12, #selector(logOutHandler))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(userName!)
        view.autoAnchorsToTop(view: userName!, topMargin: 120, horizontalPadding: nil, heightPercentage: 0.4)
        
        view.addSubview(logOutButton!)
        logOutButton!.autoAnchorsXCenter(topView: userName!, topMargin: 20, horizontalPadding: nil, heightPercentage: 0.07, widthPercentage: 0.3)
    }
    
    @objc func logOutHandler() {
        print("Logout Handler!")
        let loginView = LoginController()
        present(loginView, animated: true)
//        FirebaseService().signOut {
//            print("SingOut sucessfully!")
//        }
    }
    
}
