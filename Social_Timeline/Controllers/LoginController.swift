//
//  LoginController.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 6/18/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UITextViewDelegate {
    
    var loginTitle: UILabel? = UILabel().createDefaultLabel("Login", 35, .bold, .blue, .center)
    var emailInput: UITextField? = UITextField().createDefaultTextInput(keyBoardType: .emailAddress, borderRadius: 12, placeholder: "Email")
    var passwordInput: UITextField? = UITextField().createDefaultTextInput(keyBoardType: .alphabet, borderRadius: 12, placeholder: "Password")
    var loginButton: UIButton? = UIButton().createDefaultButton("Login", .red, 12, #selector(loginButtonHandler))
    var registerButton: UIButton? = UIButton().createDefaultButton("Sing Up!", .blue, 12, #selector(registerButtonHandler))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(loginTitle!)
        view.autoAnchorsToTop(view: loginTitle!, topMargin: 50, horizontalPadding: 35, heightPercentage: 0.1)
        
        view.addSubview(emailInput!)
        emailInput!.autoAnchorsXCenter(topView: loginTitle!, topMargin: 20, horizontalPadding: nil, heightPercentage: 0.08, widthPercentage: 0.7)
        
        view.addSubview(passwordInput!)
        passwordInput!.isSecureTextEntry = true
        passwordInput!.autoAnchorsXCenter(topView: emailInput!, topMargin: 20, horizontalPadding: nil, heightPercentage: 0.08, widthPercentage: 0.7)
        
        view.addSubview(loginButton!)
        loginButton?.autoAnchorsXCenter(topView: passwordInput!, topMargin: 20, horizontalPadding: nil, heightPercentage: 0.07, widthPercentage: 0.35)
        
        view.addSubview(registerButton!)
        registerButton!.autoAnchorsXCenter(topView: loginButton!, topMargin: 20, horizontalPadding: nil, heightPercentage: 0.07, widthPercentage: 0.35)
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.barTintColor = .white
    }
    
    func onError(_ error: String) {
        let Alert = UIAlertController(title: "Error al ingresar", message: "A ocurrido un error al intentar ingresar con tu ususario, \nError: \(error)", preferredStyle: .alert)
        let AlertAction = UIAlertAction(title: "Aceptar", style: .destructive) { (action) in
            Alert.dismiss(animated: true, completion: nil)
        }
        Alert.addAction(AlertAction)
        self.present(Alert, animated: true, completion: nil)
    }
    
    @objc func loginButtonHandler() {
        print("the login button have been pressed!")
        let response = FirebaseService().signIn(email: emailInput!.text!, password: passwordInput!.text!, callback: onError)
        if(response){
            let viewController = ViewController()
            present(viewController, animated: true)            
        }
    }
    
    @objc func registerButtonHandler() {
        print("The register button has been pressed!")
        let registerView = RegisterController()
        
        self.navigationController?.pushViewController(registerView, animated: true)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return false
    }
    
}
