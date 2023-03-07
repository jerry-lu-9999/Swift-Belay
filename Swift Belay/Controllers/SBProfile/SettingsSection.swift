//
//  SettingsSection.swift
//  Swift Belay
//
//  Created by William Yang on 2/28/23.
//

protocol SectionType: CustomStringConvertible {
    var containsSwitch: Bool { get }
    var switchDefault: Bool { get }
}

enum SettingsSection: Int, CaseIterable, CustomStringConvertible {
    case Social
    case ConnectedAccounts
    case Communications
    
    var description: String {
        switch self {
        case .Social:         return "Social"
        case .ConnectedAccounts: return "Connected Accounts"
        case .Communications: return "Communications"
        }
    }
}

enum SocialOptions: Int, CaseIterable, SectionType  {
    case editProfile
    case logout
    
    var description: String {
        switch self {
        case .editProfile: return "Edit Profile"
        case .logout:      return "Log Out"
        }
    }
    
    var containsSwitch: Bool {
        return false
    }
    
    var switchDefault: Bool {
        return false
    }
}

enum ConnectedAccountsOptions: Int, CaseIterable, SectionType {
    case Facebook
    case Google
    var description: String {
        switch self {
        case .Facebook: return "Facebook"
        case .Google:         return "Google"
        }
    }
    
    var containsSwitch: Bool {
        return true
    }
    
    var switchDefault: Bool {
        return false
    }
}

enum CommunicationOptions: Int, CaseIterable, SectionType {
    case notifications
    case email
    case reportCrashes
    
    var description: String {
        switch self {
        case .notifications: return "Notifications"
        case .email:         return "Email"
        case .reportCrashes: return "Report Crashes"
        }
    }
    
    var containsSwitch: Bool {
        switch self {
        case .notifications: return true
        case .email:         return true
        case .reportCrashes: return true
        }
    }
    
    var switchDefault: Bool {
        return true
    }
}
