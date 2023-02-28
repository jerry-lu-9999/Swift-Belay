//
//  SBTabBarController.swift
//  Swift Belay
//
//  Created by Jiahao Lu on 1/30/23.
//

import UIKit
import FirebaseAuth

/// Controller for the root tab controller and chat, profile controller
class SBTabBarController: UITabBarController{

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        setUpThreeTabs()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        validateAuthentication()
    }
    
    private func setUpThreeTabs(){
        
        let homeVC = SBHomeViewController()
        let chatVC = SBChatViewController()
        let profileVC = SBProfileViewController()
        
        homeVC.navigationItem.largeTitleDisplayMode = .automatic
        chatVC.navigationItem.largeTitleDisplayMode = .automatic
        profileVC.navigationItem.largeTitleDisplayMode = .automatic
        
        /*
         turn viewController into NavigationController for easier access
         https://stackoverflow.com/questions/28751457/difference-between-navigation-controller-and-viewcontroller#:~:text=Navigation%20Controller%20consists%20of%20navigation,represents%20a%20single%20screen%20view.
         */
        
        let nav1 = UINavigationController(rootViewController: homeVC)
        let nav2 = UINavigationController(rootViewController: chatVC)
        let nav3 = UINavigationController(rootViewController: profileVC)
        
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(systemName: "paperplane"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 3)
        
        for nav in [nav1, nav2, nav3] {
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers([nav1, nav2, nav3], animated: true)
    }

    private func validateAuthentication(){
        if FirebaseAuth.Auth.auth().currentUser == nil {
            print("I'm loged in")
            let loginVC = SBLoginNavController()
            let nav     = UINavigationController(rootViewController: loginVC)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        }
    }
    
}

