//
//  SBLoginSignUpViewController.swift
//  Swift Belay
//
//  Created by Jiahao Lu on 2/6/23.
//

import UIKit
import FacebookLogin
import GoogleSignIn

import FirebaseCore
import FirebaseAuth
import FirebaseDatabase

class SBLoginNavController: UIViewController, LoginButtonDelegate {

    var loginButton : UIButton!
    var signUpButton : UIButton!
    var fBLoginButton : FBLoginButton!
    var googleLoginButton : GIDSignInButton!
    var hint :  UILabel!
    
    var emailTextField : UITextField!
    var passwordTextField: UITextField!
    
    @objc func handleLoginTouchUpInside(){
        if emailTextField.isFirstResponder{
            emailTextField.resignFirstResponder()
        }
        if passwordTextField.isFirstResponder{
            passwordTextField.resignFirstResponder()
        }

        FirebaseAuth.Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { [weak self] authResult, error in
            guard let result = authResult, error == nil else{
                var alertTitle: String!
                var alertMessage: String? = "Please try again or reach out for support"
                
                if let error = error as NSError? {
                    if let authError = AuthErrorCode.Code(rawValue: error.code){
                        switch authError {
                        case .operationNotAllowed:
                            alertTitle = "Please authenticate your email"
                        case .invalidEmail:
                            alertTitle = "Please double check your email"
                        case .userDisabled:
                            alertTitle = "User Disabled"
                        case .wrongPassword:
                            alertTitle = "Wrong Password"
                        default:
                            alertTitle = "ERROR"
                            alertMessage = error.debugDescription
                        }
                    }
                }
                let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                
                print("Login error: \(error.debugDescription)")
                self?.present(alert, animated: true)
                return
            }
            
            let user = result.user
            UDM.shared.defaults.setValue(self?.emailTextField.text!, forKey: "lastUsedEmail")
            print("Logged In User: \(user)")
            
            self?.navigationController?.dismiss(animated: true)
        })

    }
    
    @objc func handleSignUpTouchUpInside(){
        let signUpVC =  SBSignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc func handleGoogleLoginTouchUpInside(){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] signInResult, error in
            guard error == nil else {
                print("Sign in With google failed:\(error.debugDescription)")
                return
            }
            guard let user = signInResult?.user, let idToken = user.idToken?.tokenString else{
                return
            }
            
            guard let email = user.profile?.email as? String,
                  let firstName = user.profile?.givenName as? String,
                    let lastName = user.profile?.familyName as? String else{
                return
            }
            
            UDM.shared.defaults.setValue(email, forKey: "lastUsedEmail")
            DatabaseManager.shared.containUser(with: email, completion: { exists in
                if !exists {
                    DatabaseManager.shared.insertUser(with: BelayUser(firstName: firstName, lastName: lastName, email: email))
                }
            })
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                guard let result = authResult, error == nil else {
                    print("Google Sign in Error")
                    return 
                }
                
                let user = result.user
                print("Logged In User: \(user) via Google")
                
                self?.dismiss(animated: true)
            }
        }
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
        signInConfig.automaticallyUpdateForSelection = true
        loginButton = UIButton(configuration: signInConfig, primaryAction: nil)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loginButton)
        loginButton.addTarget(self, action: #selector(handleLoginTouchUpInside), for: .touchUpInside)
        
        fBLoginButton = FBLoginButton(type: .roundedRect)
        fBLoginButton.translatesAutoresizingMaskIntoConstraints = false
        fBLoginButton.permissions = ["public_profile", "email"]
        fBLoginButton.delegate = self
        view.addSubview(fBLoginButton)
        
        googleLoginButton = GIDSignInButton()
        googleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        googleLoginButton.style = .wide
        googleLoginButton.addTarget(self, action: #selector(handleGoogleLoginTouchUpInside), for: .touchUpInside)
        view.addSubview(googleLoginButton)
        
        emailTextField = UITextField(frame: .zero)
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.autocapitalizationType = .none
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailTextField)
        
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
        
        hint = UILabel()
        hint.translatesAutoresizingMaskIntoConstraints = false
        hint.text = "You signed in last time with your "
        hint.textAlignment = .center
        hint.lineBreakMode = .byWordWrapping
        hint.numberOfLines = 2
        hint.isHidden = true
        if let email = UDM.shared.defaults.value(forKey: "lastUsedEmail") as? String {
            print(email)
            Auth.auth().fetchSignInMethods(forEmail: email, completion: { [weak self] signInMethods, error in
                guard error == nil else {
                    self?.hint.text = error.debugDescription
                    return
                }
                if let method = signInMethods?[0] as? String {
                    self?.hint.text?.append(method)
                }
                self?.hint.isHidden = false
            })
        }
        
        view.addSubview(hint)
        
        setUpConstraints()
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            emailTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -20),
            emailTextField.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -20),
            
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
            
            hint.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 20),
            hint.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 20),
            hint.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -20)
            ])
    }

    /// login for using Facebook log out button
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("User failed to login with FB")
            return
        }
        
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                 parameters: ["fields":"email, name"],
                                                 tokenString: token,
                                                 version: nil,
                                                 httpMethod: .get)
        
        request.start(completionHandler: { connection, result, error in
            guard let result = result as? [String:Any], error == nil else{
                print("Failed to make facebook graphic request")
                return
            }
            
            guard let userName = result["name"] as? String,
                  let email = result["email"] as? String else{
                print("failed to get email and name from fb result")
                return
            }
            
            let nameComponents = userName.components(separatedBy: " ")
            guard nameComponents.count == 2 else {return}
            
            let firstName = nameComponents[0]
            let lastName  = nameComponents[1]
            
            UDM.shared.defaults.setValue(email, forKey: "lastUsedEmail")
            DatabaseManager.shared.containUser(with: email, completion: { exists in
                if !exists {
                    DatabaseManager.shared.insertUser(with: BelayUser(firstName: firstName, lastName: lastName, email: email))
                }
            })
            
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            
            FirebaseAuth.Auth.auth().signIn(with: credential, completion: { [weak self] authResult, error in
                guard let result = authResult, error == nil else {
                    
                    var alertTitle: String!
                    var alertMessage: String? = "Please try again or reach out for support"
                    
                    if let error = error as NSError? {
                        if let authError = AuthErrorCode.Code(rawValue: error.code){
                            switch authError{
                            case .invalidCredential:
                                alertTitle = "Invalid Credential"
                            case .invalidEmail:
                                alertTitle = "Please double check your email"
                            case .emailAlreadyInUse:
                                alertTitle = "Email already in use"
                            case .operationNotAllowed:
                                alertTitle = "Please authenticate your email first"
                            case .userDisabled:
                                alertTitle = "User Disabled"
                            default:
                                alertTitle = "ERROR"
                                alertMessage = error.debugDescription
                            }
                       
                        }
                    }
                    let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    
                    print("Facebook credential failed: \(error.debugDescription)")
                    
                    return
                }
                print("Facebook Login success for user: \(result.user)")
                
                self?.dismiss(animated: true)
            })
            
        })
        
        if let error = error {
          print(error.localizedDescription)
          return
        }
        
    }
    
}
