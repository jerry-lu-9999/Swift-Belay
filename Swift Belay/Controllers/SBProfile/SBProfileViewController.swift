//
//  SBProfileViewController.swift
//  Swift Belay
//
//  Created by Jiahao Lu on 2/3/23.
//

import UIKit

import FirebaseAuth

class SBProfileViewController: UIViewController {
    
    private let reuseIdentifier = "SettingsCell"
    var tableView: UITableView!
    var userInfoHeader: UserInfoHeader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - Helper Functions
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        tableView.frame = view.frame
        
        let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: 100)
        userInfoHeader = UserInfoHeader(frame: frame)
        tableView.tableHeaderView = userInfoHeader
        tableView.tableFooterView = UIView()
    }
    
    func configureUI() {
        configureTableView()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        navigationItem.title = "Settings"
    }

}

extension SBProfileViewController: UITableViewDelegate, UITableViewDataSource {

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = SettingsSection(rawValue: section) else {return 0}
        
        switch section {
        case .Social: return SocialOptions.allCases.count
        case .Communications: return CommunicationOptions.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .white
        title.text = SettingsSection(rawValue: section)?.description
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsCell
        
        guard let section = SettingsSection(rawValue: indexPath.section) else {return UITableViewCell()}
        
        switch section {
        case .Social:
            let social = SocialOptions(rawValue: indexPath.row)
            cell.sectionType = social
        case .Communications:
            let communications = CommunicationOptions(rawValue: indexPath.row)
            cell.sectionType = communications
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = SettingsSection(rawValue: indexPath.section) else {return}
        
        switch section {
        case .Social:
            print(SocialOptions(rawValue: indexPath.row)?.description ?? "default")
        case .Communications:
            print(CommunicationOptions(rawValue: indexPath.row)?.description ?? "default")
        }
    }
}


//class SBProfileViewController: UIViewController {
//
//    private let signOutButton : UIButton! = {
//        let signOutButton = UIButton()
//        signOutButton.setTitle("Sign Out", for: .normal)
//        return signOutButton
//    }()
//
//
//    @objc func handleSignOutTouchUpInside(){
//        let firebaseAuth = Auth.auth()
//        do {
//            try firebaseAuth.signOut()
//            let homeVC = SBLoginNavController()
//            let nav    = UINavigationController(rootViewController: homeVC)
//            nav.modalPresentationStyle = .fullScreen
//            present(nav, animated: true)
//
//        } catch let signOutError as NSError {
//          print("Error signing out: %@", signOutError)
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//        title = "Profile"
//
//        signOutButton.center = view.center
//        signOutButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(signOutButton)
//        signOutButton.addTarget(self, action: #selector(handleSignOutTouchUpInside), for: .touchUpInside)
//    }
//
//}
