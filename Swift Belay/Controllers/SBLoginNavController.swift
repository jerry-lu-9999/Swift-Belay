//
//  SBLoginSignUpViewController.swift
//  Swift Belay
//
//  Created by Jiahao Lu on 2/6/23.
//

import UIKit
import FacebookLogin
import GoogleSignIn

class SBLoginNavController: UIViewController {

    var loginButton : UIButton!
    var signUpButton : UIButton!
    var fBLoginButton : FBLoginButton!
    var googleLoginButton : GIDSignInButton!
    
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

    }
    
    @objc func handleSignUpTouchUpInside(){
        let signUpVC = UINavigationController(rootViewController: SBSignUpViewController())
        signUpVC.navigationBar.prefersLargeTitles = true
        self.present(signUpVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = Constants.themeColor
        title = "Let's get started!"
        
        var signInConfig = UIButton.Configuration.filled()
        signInConfig.cornerStyle = .capsule
        signInConfig.baseBackgroundColor = .systemIndigo
        signInConfig.title = "Sign In"
        loginButton = UIButton(configuration: signInConfig, primaryAction: nil)
        loginButton.setTitle("Sign In", for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(loginButton)
        loginButton.addTarget(self, action: #selector(handleLoginTouchUpInside), for: .touchUpInside)
        
        fBLoginButton = FBLoginButton(type: .roundedRect)
        fBLoginButton.translatesAutoresizingMaskIntoConstraints = false
        fBLoginButton.permissions = ["public_profile", "email"]
        view.addSubview(fBLoginButton)
        //TODO:
        if let token = AccessToken.current,
            !token.isExpired {
            // User is logged in, do work such as go to next view controller.
        }
        
        googleLoginButton = GIDSignInButton()
        googleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        googleLoginButton.style = .wide
        view.addSubview(googleLoginButton)
        
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
        
        signUpButton = UIButton(configuration: signInConfig, primaryAction: nil)
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.addTarget(self, action: #selector(handleSignUpTouchUpInside), for: .touchUpInside)
        view.addSubview(signUpButton)
        
        setUpConstraints()
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            userNameTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -20),
            userNameTextField.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 20),
            userNameTextField.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -20),
            
            passwordTextField.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -20),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginButton.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -20),
        
            fBLoginButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            fBLoginButton.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 20),
            fBLoginButton.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -20),
            
            googleLoginButton.topAnchor.constraint(equalTo: fBLoginButton.bottomAnchor, constant: 20),
            googleLoginButton.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 20),
            googleLoginButton.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -20),
            
            signUpButton.topAnchor.constraint(equalTo: googleLoginButton.bottomAnchor, constant: 20),
            signUpButton.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 20),
            signUpButton.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -20),
        
        
            ])
    }

}
