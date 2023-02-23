//
//  SBSignUpViewController.swift
//  Swift Belay
//
//  Created by Jiahao Lu on 2/13/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class SBSignUpViewController: UIViewController {

    var userNameTextField : UITextField!
    var emailTextField : UITextField!
    var passwordTextField : UITextField!
    
    var signUpButton : UIButton!
    
    @objc func createNewAccount() {
        guard let email    = emailTextField.text    else {return}
        guard let password = passwordTextField.text else {return}
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let result = authResult, error == nil else {
                print("error creating user: \(error.debugDescription)")
                return
            }
            
            let user = result.user
            print("successfully created user: \(user)")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.title = "Sign Up"
        view.backgroundColor = .systemBackground
        
        passwordTextField = UITextField(frame: .zero)
        passwordTextField.placeholder = "Enter Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.autocapitalizationType = .none
        passwordTextField.leftViewMode = .always
        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        
        view.addSubview(passwordTextField)
        
        emailTextField = UITextField(frame: .zero)
        emailTextField.placeholder = "Enter Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.autocapitalizationType = .none
        emailTextField.leftViewMode = .always
        emailTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        view.addSubview(emailTextField)
        
        signUpButton = UIButton(type: .system)
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.addTarget(self, action: #selector(createNewAccount), for: .touchUpInside)
        view.addSubview(signUpButton)
        
        setUpContraints()
    }
    
    
    func setUpContraints(){
        NSLayoutConstraint.activate([
            emailTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -20),
            emailTextField.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -20),
            
            passwordTextField.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -20),
            
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
