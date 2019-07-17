//
//  RegisterController.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 6/18/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {
    
    weak var coordinator: MainCoordinator?    
    var registerTitle: UILabel?
    var userNameInput: UITextField?
    var emailInput: UITextField?
    var passwordInput: UITextField?
    var registerButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureLayout()
    }
    
    func setupView() {
        registerTitle = UILabel().createDefaultLabel("Register", 35, .bold, .blue, .center)
        userNameInput = UITextField().createDefaultTextInput(keyBoardType: .emailAddress, borderRadius: 12, placeholder: "Username")
        emailInput = UITextField().createDefaultTextInput(keyBoardType: .emailAddress, borderRadius: 12, placeholder: "Email")
        emailInput!.autocapitalizationType = .none
        passwordInput = UITextField().createDefaultTextInput(keyBoardType: .alphabet, borderRadius: 12, placeholder: "Password")
        passwordInput!.isSecureTextEntry = true
        registerButton = UIButton().createDefaultButton("Sign Up", .red, 12, #selector(registerButtonHandler))
    }
    
    func configureLayout() {
        view.backgroundColor = .white
        
        view.addSubviews([registerTitle!, userNameInput!, emailInput!, passwordInput!, registerButton!])
        view.autoAnchorsToTop(view: registerTitle!, topMargin: 50, horizontalPadding: 35, heightPercentage: 0.1)
        userNameInput!.autoAnchorsXCenter(topView: registerTitle!, topMargin: 20, horizontalPadding: nil, heightPercentage: 0.08, widthPercentage: 0.7)
        emailInput!.autoAnchorsXCenter(topView: userNameInput!, topMargin: 20, horizontalPadding: nil, heightPercentage: 0.08, widthPercentage: 0.7)
        passwordInput!.autoAnchorsXCenter(topView: emailInput!, topMargin: 20, horizontalPadding: nil, heightPercentage: 0.08, widthPercentage: 0.7)
        registerButton?.autoAnchorsXCenter(topView: passwordInput!, topMargin: 20, horizontalPadding: nil, heightPercentage: 0.07, widthPercentage: 0.35)
    }

    @objc func registerButtonHandler() {
        print("registerButton has been pressed!")
        guard let username = userNameInput?.text,
            let email = emailInput?.text,
            let password = passwordInput?.text else {
                createAlertDesctructive("Error", "algunos de los campos requeridos no han sido rellenados, favor de revisar", .alert, "Entendido")
                return
        }
        coordinator?.registerUser(username, email, password)
    }
    
}
