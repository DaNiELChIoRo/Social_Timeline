//
//  RegisterController.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 6/18/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {
    
    var registerTitle: UILabel? = UILabel().createDefaultLabel("Register", 35, .bold, .blue, .center)
    var userNameInput: UITextField? = UITextField().createDefaultTextInput(keyBoardType: .emailAddress, borderRadius: 12, placeholder: "Username")
    var emailInput: UITextField? = UITextField().createDefaultTextInput(keyBoardType: .emailAddress, borderRadius: 12, placeholder: "Email")
    var passwordInput: UITextField? = UITextField().createDefaultTextInput(keyBoardType: .alphabet, borderRadius: 12, placeholder: "Password")
    var registerButton: UIButton? = UIButton().createDefaultButton("Sign Up", .red, 12, #selector(registerButtonHandler))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(registerTitle!)
        view.autoAnchorsToTop(view: registerTitle!, topMargin: 50, horizontalPadding: 35, heightPercentage: 0.1)
        
        view.addSubview(userNameInput!)
        userNameInput!.autoAnchorsXCenter(topView: registerTitle!, topMargin: 20, horizontalPadding: nil, heightPercentage: 0.08, widthPercentage: 0.7)
        
        view.addSubview(emailInput!)
        emailInput!.autoAnchorsXCenter(topView: userNameInput!, topMargin: 20, horizontalPadding: nil, heightPercentage: 0.08, widthPercentage: 0.7)
        
        view.addSubview(passwordInput!)
        passwordInput!.isSecureTextEntry = true
        passwordInput!.autoAnchorsXCenter(topView: emailInput!, topMargin: 20, horizontalPadding: nil, heightPercentage: 0.08, widthPercentage: 0.7)
        
        view.addSubview(registerButton!)
        registerButton?.autoAnchorsXCenter(topView: passwordInput!, topMargin: 20, horizontalPadding: nil, heightPercentage: 0.07, widthPercentage: 0.35)
        
        
    }
    
    @objc func registerButtonHandler() {
        print("registerButton has been pressed!")
        let viewController = ViewController()
        present(viewController, animated: true)
    }
    
}
