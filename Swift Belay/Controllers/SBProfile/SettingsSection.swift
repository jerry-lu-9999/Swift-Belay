//
//  SettingsSection.swift
//  Swift Belay
//
//  Created by William Yang on 2/28/23.
//

protocol SectionType: CustomStringConvertible {
    var containsSwitch: Bool { get }
}

enum SettingsSection: Int, CaseIterable, CustomStringConvertible {
    case Social
    case Communications
    
    var description: String {
        switch self {
        case .Social:         return "Social"
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
        case .reportCrashes: return false
        }
    }
}
