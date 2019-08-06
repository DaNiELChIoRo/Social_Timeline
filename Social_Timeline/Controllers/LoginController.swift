//
//  LoginController.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 6/18/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UITextViewDelegate {
    
    weak var coordinator: AuthCoordinator?
    var loginTitle: UILabel?
    var emailInput: UITextField?
    var passwordInput: UITextField?
    var loginButton: UIButton?
    var registerButton: UIButton?
    var fireAuth: FireAuth?
    var realtimeDB: RealtimeDatabase?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBounds()
        setupView()
        configureLayOut()
    }
    
    init(coordinator: AuthCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureBounds() {
        self.realtimeDB = RealtimeDatabase(delegate: self)
        self.fireAuth = FireAuth(userDelegate: self)
    }
    
    func setupView() {
        loginTitle = UILabel().createDefaultLabel("Login", 35, .bold, .blue, .center)
        emailInput = UITextField().createDefaultTextInput(keyBoardType: .emailAddress, borderRadius: 12, placeholder: "Email")
        emailInput!.autocapitalizationType = .none
        passwordInput = UITextField().createDefaultTextInput(keyBoardType: .alphabet, borderRadius: 12, placeholder: "Password")
        passwordInput!.isSecureTextEntry = true
        loginButton = UIButton().createDefaultButton("Login", .red, 12, #selector(loginButtonHandler))
        registerButton = UIButton().createDefaultButton("Sing Up!", .blue, 12, #selector(registerButtonHandler))
    }
    
    func configureLayOut() {
        view.backgroundColor = .white
        view.addSubviews([loginTitle!, emailInput!, passwordInput!, loginButton!, registerButton!])
        view.autoAnchorsToTop(view: loginTitle!, topMargin: 50, horizontalPadding: 35, heightPercentage: 0.1)
        emailInput!.autoAnchorsXCenter(topView: loginTitle!, topMargin: 20, horizontalPadding: nil, heightPercentage: 0.08, widthPercentage: 0.7)
        passwordInput!.autoAnchorsXCenter(topView: emailInput!, topMargin: 20, horizontalPadding: nil, heightPercentage: 0.08, widthPercentage: 0.7)
        loginButton?.autoAnchorsXCenter(topView: passwordInput!, topMargin: 20, horizontalPadding: nil, heightPercentage: 0.07, widthPercentage: 0.35)
        registerButton!.autoAnchorsXCenter(topView: loginButton!, topMargin: 20, horizontalPadding: nil, heightPercentage: 0.07, widthPercentage: 0.35)
    }
    
    @objc func loginButtonHandler() {
        print("the login button have been pressed!")
        guard let email = emailInput!.text, let password = passwordInput!.text else {
            self.createAlertDesctructive("Error al intentar ingresar", "Error al intentar accedere a su cuenta, usuario o contraseña vacios!", .alert, "Entendido")
            return
        }
        fireAuth?.signIn(email: email, password: password)
    }
    
    @objc func registerButtonHandler() {
        print("The register button has been pressed!")
        coordinator?.goToRegisterUser()
    }
    
//    func registerUser(_ username: String, _ email: String, _ password: String) {
//        fireAuth?.registerUser(username: username, email: email, password: password)
//    }
    
    func logOnUser(_ email: String, _ password: String) {
        
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return false
    }
}

extension LoginController: realtimeDelegate {
    
    func onDBError(_ error: String) {
        self.createAlertDesctructive("Error", error, .alert, "Entendido")
    }
    
    func onSuccess() {
        
    }
}

extension LoginController: userDelegate {
    func onAuthError(error: String) {
        self.createAlertDesctructive("Error!", error, .alert, "Entendido")
    }
    
    func onUserCreated(user: Usuario) {
        self.realtimeDB?.writeUser(user: user)
    }
    
    func onUserLogIn(user: Usuario) {
        coordinator?.goToHomeView()
    }
}
