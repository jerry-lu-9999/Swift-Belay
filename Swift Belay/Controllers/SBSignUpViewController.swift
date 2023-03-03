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
        
        guard let email    = emailTextField.text,
              let password = passwordTextField.text,
                  !email.isEmpty,
                  !password.isEmpty
        else {return}

        // TODO: - a better way to handle errors
        
        DatabaseManager.shared.containUser(with: email, completion: { exist in
            guard !exist else {
                //user already exist
                return
            }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] authResult, error in
                guard let result = authResult, error == nil else {
                    var alertTitle: String!
                    var alertMessage: String = "Please try again or reach out for support"
                    
                    if let error = error as NSError? {
                        if let authError = AuthErrorCode.Code(rawValue: error.code){
                            switch authError {
                            case .invalidEmail:
                                alertTitle = "Please double check your email"
                            case .emailAlreadyInUse:
                                alertTitle = "Email already in use"
                            case .operationNotAllowed:
                                alertTitle = "Please authenticate your email first"
                            case .weakPassword:
                                alertTitle = "Weak Password"
                            default:
                                alertTitle = "ERROR"
                                alertMessage = error.debugDescription
                            }
                        }
                    }
                    let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    
                    print("Sign up error: \(error.debugDescription)")
                    self?.present(alert, animated: true)
                    return
                }
                
                DatabaseManager.shared.insertUser(with: BelayUser(firstName: "", lastName: "", email: email))
                
                UDM.shared.defaults.setValue(email, forKey: "lastUsedEmail")
                
                let user = result.user
                print("successfully created user: \(user)")
                
                self?.navigationController?.dismiss(animated: true)
                let homeVC = SBTabBarController()
                homeVC.modalPresentationStyle = .fullScreen
                self?.present(homeVC, animated: true)
            })
        })
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
