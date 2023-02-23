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
import FirebaseFirestore
import FirebaseAuth

class SBLoginNavController: UIViewController, LoginButtonDelegate {

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
        
        FirebaseAuth.Auth.auth().signIn(withEmail: userNameTextField.text!, password: passwordTextField.text!, completion: { authResult, error in
            guard let result = authResult, error == nil else{
                print("error signing in with email")
                return
            }
            
            let user = result.user
            print("Logged In User: \(user)")
            
            let homeVC = SBTabBarController()
            homeVC.modalPresentationStyle = .fullScreen
            self.present(homeVC, animated: true)
        })

    }
    
    @objc func handleSignUpTouchUpInside(){
        let signUpVC = UINavigationController(rootViewController: SBSignUpViewController())
        signUpVC.navigationBar.prefersLargeTitles = true
        self.present(signUpVC, animated: true)
    }
    
    /*
    @objc func handleGoogleLoginTouchUpInside(){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        var isMFAEnabled = false
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in

            guard error == nil else {return}

          guard
            let authentication = signInResult.authentication
            let idToken = authentication.idToken
          else {
            return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: authentication.accessToken)

        
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                  let authError = error as NSError
                  if isMFAEnabled, authError.code == AuthErrorCode.secondFactorRequired.rawValue {
                    // The user is a multi-factor user. Second factor challenge is required.
                    let resolver = authError
                      .userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
                    var displayNameString = ""
                    for tmpFactorInfo in resolver.hints {
                      displayNameString += tmpFactorInfo.displayName ?? ""
                      displayNameString += " "
                    }
                    self.showTextInputPrompt(
                      withMessage: "Select factor to sign in\n\(displayNameString)",
                      completionBlock: { userPressedOK, displayName in
                        var selectedHint: PhoneMultiFactorInfo?
                        for tmpFactorInfo in resolver.hints {
                          if displayName == tmpFactorInfo.displayName {
                            selectedHint = tmpFactorInfo as? PhoneMultiFactorInfo
                          }
                        }
                        PhoneAuthProvider.provider()
                          .verifyPhoneNumber(with: selectedHint!, uiDelegate: nil,
                                             multiFactorSession: resolver
                                               .session) { verificationID, error in
                            if error != nil {
                              print(
                                "Multi factor start sign in failed. Error: \(error.debugDescription)"
                              )
                            } else {
                              self.showTextInputPrompt(
                                withMessage: "Verification code for \(selectedHint?.displayName ?? "")",
                                completionBlock: { userPressedOK, verificationCode in
                                  let credential: PhoneAuthCredential? = PhoneAuthProvider.provider()
                                    .credential(withVerificationID: verificationID!,
                                                verificationCode: verificationCode!)
                                  let assertion: MultiFactorAssertion? = PhoneMultiFactorGenerator
                                    .assertion(with: credential!)
                                  resolver.resolveSignIn(with: assertion!) { authResult, error in
                                    if error != nil {
                                      print(
                                        "Multi factor finanlize sign in failed. Error: \(error.debugDescription)"
                                      )
                                    } else {
                                      self.navigationController?.popViewController(animated: true)
                                    }
                                  }
                                }
                              )
                            }
                          }
                      }
                    )
                  } else {
                    self.showMessagePrompt(error.localizedDescription)
                    return
                  }
                  // ...
                  return
                }
                // User is signed in
                // ...
            }
        }
        
        
    }
    */
    
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
        
        
        // TODO: -
        if let token = AccessToken.current,
            !token.isExpired {
            // User is logged in, do work such as go to next view controller.
        }
        
        googleLoginButton = GIDSignInButton()
        googleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        googleLoginButton.style = .wide
        //googleLoginButton.addTarget(self, action: #selector(handleGoogleLoginTouchUpInside), for: .touchUpInside)
        view.addSubview(googleLoginButton)
        
        userNameTextField = UITextField(frame: .zero)
        userNameTextField.placeholder = "Username or Email"
        userNameTextField.borderStyle = .roundedRect
        userNameTextField.autocapitalizationType = .none
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

    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("User failed to login with FB")
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        
        FirebaseAuth.Auth.auth().signIn(with: credential, completion: { authResult, error in
            guard let result = authResult, error == nil else {
                print("Facebook credential failed")
                
                return
            }
            print("Facebook Login success for user: \(result.user)")
            
        })
        
        
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                 parameters: ["fields":"email, name"],
                                                 tokenString: token,
                                                 version: nil,
                                                 httpMethod: .get)
        request.start(completionHandler: { connection, result, error in
            
        })
        
        if let error = error {
          print(error.localizedDescription)
          return
        }
        
//
    }
    
}
