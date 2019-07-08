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
    
    func callback (_ error: String) { print("trantando de leer el error: \(error)")
        let Alert = UIAlertController(title: "Error al registar usuario", message: "A ocurrido un error al intentar registrar el ususario, \nError: \(error)", preferredStyle: .alert)
        let AlertAction = UIAlertAction(title: "Aceptar", style: .destructive) { (action) in
            Alert.dismiss(animated: true, completion: nil)
        }
        Alert.addAction(AlertAction)
        self.present(Alert, animated: true, completion: nil)
    }
    
    
    @objc func registerButtonHandler() {
        print("registerButton has been pressed!")
        let fireBase = FirebaseService(delegateFirebaseUser: self)
        fireBase.registerUser(email: emailInput!.text!, password: passwordInput!.text!, callback: callback)

    }
    
}

extension RegisterController: FirebaseUserCreated {
    func onUserCreated(user: Usuario) {
        RealtimeDatabase().writeUser(user: user)
        
        let viewController = ViewController()
        present(viewController, animated: true)
    }
}
