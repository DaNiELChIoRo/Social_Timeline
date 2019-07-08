//
//  ProfileController.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 6/18/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    
    var userName:UILabel? = UILabel().createDefaultLabel("UserName", 24, .bold, .black, .center)
    var userEmail:UILabel? = UILabel().createDefaultLabel("user email", 24, .bold, .black, .center)
    var logOutButton: UIButton? = UIButton().createDefaultButton("LogOut", .red, 12, #selector(logOutHandler))
    var ressetPassButton: UIButton? = UIButton().createDefaultButton("Reset Password", .red, 12, #selector(logOutHandler))
    var userImage: UIImageView? = UIImageView().defaultImageViewCreator(((UIImage(named: "avatar")?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)))!))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.title = "Profile"        
    }
    
    let height = UIScreen.main.bounds.height
    let width = UIScreen.main.bounds.width
    
    func setupView() {
        view.backgroundColor = .white
        
        print("total height: \(height)")
        print("total width: \(width)")
        view.addSubview(userImage!)
        userImage?.layer.cornerRadius = 75
        userImage?.backgroundColor = .gray
        view.autoAnchorsToTop(view: userImage!, topMargin: 50, horizontalPadding: 150, heightPercentage: 0.08)
        
        
        view.addSubview(userName!)
        userName?.backgroundColor = .red
        userName?.autoAnchorsXCenter(topView: userImage!, topMargin: 12, horizontalPadding: nil, heightPercentage: 0.05, widthPercentage: 0.5)
        
        
        view.addSubview(userEmail!)
        userEmail?.backgroundColor = .green
        userEmail?.autoAnchorsXCenter(topView: userName!, topMargin: 5, horizontalPadding: nil, heightPercentage: 0.05, widthPercentage: 0.4)
        

//        view.addSubview(ressetPassButton!)
//        ressetPassButton?.autoAnchorsXCenter(bottomView: logOutButton!, bottomMargin: 15, horizontalPadding: nil, heightPercentage: 0.065, widthPercentage: 0.4)
        
        view.addSubview(logOutButton!)
        logOutButton!.autoAnchorsToBottom(bottomMargin: 0, horizontalPadding: 50, heightPercentage: 0.065)
    }
    
    @objc func logOutHandler() {
        print("Logout Handler!")
        let loginView = LoginController()
        self.dismiss(animated: true, completion: nil)       
//        FirebaseService().signOut {
//            print("SingOut sucessfully!")
//        }
    }
    
}
