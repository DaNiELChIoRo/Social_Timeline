//
//  ProfileController.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 6/18/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    
    weak var coordinator: ProfileCoordinator?
    var userName:UILabel? = UILabel().createDefaultLabel("UserName", 24, .bold, .black, .center)
    var userEmail:UILabel? = UILabel().createDefaultLabel("user email", 24, .bold, .black, .center)
    var logOutButton: UIButton? = UIButton().createDefaultButton("LogOut", .red, 12, #selector(logOutHandler))
    var ressetPassButton: UIButton? = UIButton().createDefaultButton("Reset Password", .red, 12, #selector(logOutHandler))
    var userImageThumbnailView:UIView? = ThumbnailImageView(image: UIImage(named: "avatar")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.title = "Profile"        
    }
    
    let height = UIScreen.main.bounds.height
    let width = UIScreen.main.bounds.width
    
    func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(userImageThumbnailView!)
        userImageThumbnailView?.backgroundColor = .gray
        userImageThumbnailView?.translatesAutoresizingMaskIntoConstraints = false
        view.autoAnchorsToTop(view: userImageThumbnailView!, topMargin: 50, horizontalPadding: nil, heightPercentage: 0.18)
        
        view.addSubview(userName!)
        userName?.backgroundColor = .red
        userName?.autoAnchorsXCenter(topView: userImageThumbnailView!, topMargin: 12, horizontalPadding: nil, heightPercentage: 0.05, widthPercentage: 0.5)
        
        
        view.addSubview(userEmail!)
        userEmail?.backgroundColor = .green
        userEmail?.autoAnchorsXCenter(topView: userName!, topMargin: 5, horizontalPadding: nil, heightPercentage: 0.05, widthPercentage: 0.4)
        
        view.addSubview(logOutButton!)
        logOutButton!.autoAnchorsToBottom(bottomMargin: 30, horizontalPadding: 50, heightPercentage: 0.065)
        
        view.addSubview(ressetPassButton!)
        ressetPassButton?.autoAnchorsXCenter(bottomView: logOutButton!, bottomMargin: 12, horizontalPadding: nil, heightPercentage: 0.065, widthPercentage: 0.4)
        
    }
    
    override func viewDidLayoutSubviews() {
        userImageThumbnailView!.clipsToBounds = true
        print(self.userImageThumbnailView!.frame.size)
        let height = self.userImageThumbnailView!.frame.size.height
        self.userImageThumbnailView!.frame.size.width = height
        self.userImageThumbnailView!.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.userImageThumbnailView!.layer.cornerRadius = height/2
    }
    
    @objc func logOutHandler() {
        print("Logout Handler!")
        FirebaseService().signOut {
            print("logout successfully")
            coordinator?.logOut()
        }
    }
    
}
