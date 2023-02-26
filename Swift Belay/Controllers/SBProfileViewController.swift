//
//  SBProfileViewController.swift
//  Swift Belay
//
//  Created by Jiahao Lu on 2/3/23.
//

import UIKit

import FirebaseAuth

class SBProfileViewController: UIViewController {

    private let signOutButton : UIButton! = {
        let signOutButton = UIButton()
        signOutButton.setTitle("Sign Out", for: .normal)
        return signOutButton
    }()
    
    
    @objc func handleSignOutTouchUpInside(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let homeVC = SBLoginNavController()
            let nav    = UINavigationController(rootViewController: homeVC)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
            
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Profile"
        
        signOutButton.center = view.center
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signOutButton)
        signOutButton.addTarget(self, action: #selector(handleSignOutTouchUpInside), for: .touchUpInside)
    }
    
}
