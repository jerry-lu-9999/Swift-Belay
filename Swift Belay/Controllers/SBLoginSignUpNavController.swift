//
//  SBLoginSignUpViewController.swift
//  Swift Belay
//
//  Created by Jiahao Lu on 2/6/23.
//

import UIKit
import FacebookLogin

class SBLoginSignUpNavController: UINavigationController {

    var loginButton : UIButton!
    var signUpButton : UIButton!
    var fBLoginButton : FBLoginButton!
    var userNameTextField : UITextField!
    var passwordTextField: UITextField!
    
    @objc func handleLoginTouchUpInside(){
        if userNameTextField.isFirstResponder{
            userNameTextField.resignFirstResponder()
        }
        if passwordTextField.isFirstResponder{
            passwordTextField.resignFirstResponder()
        }
        
        let homeVC = SBTabBarController()
        homeVC.modalPresentationStyle = .fullScreen
        //self.pushViewController(homeVC, animated: true)
        self.present(homeVC, animated: true)
        
        print("clicking")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.themeColor
        title = "Let's get started!"
        
        loginButton = UIButton(type: .system)
        loginButton.setTitle("Log In", for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        loginButton.addTarget(self, action: #selector(handleLoginTouchUpInside), for: .touchUpInside)
        
        fBLoginButton = FBLoginButton()
        fBLoginButton.translatesAutoresizingMaskIntoConstraints = false
        //fBLoginButton.center = view.center
        fBLoginButton.permissions = ["public_profile", "email"]
        view.addSubview(fBLoginButton)
        //TODO:
        if let token = AccessToken.current,
            !token.isExpired {
            // User is logged in, do work such as go to next view controller.
        }
        
        userNameTextField = UITextField(frame: .zero)
        userNameTextField.placeholder = "Username or Email"
        userNameTextField.borderStyle = .roundedRect
        userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userNameTextField)
        
        passwordTextField = UITextField(frame: .zero)
        passwordTextField.placeholder = "Enter Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordTextField)
        
        setUpConstraints()
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        
            fBLoginButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            fBLoginButton.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 20),
            fBLoginButton.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -20),
            
            passwordTextField.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -20),
        
            userNameTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -20),
            userNameTextField.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 20),
            userNameTextField.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -20)
        
            
            ])
    }

}
