//
//  UDM.swift
//  Swift Belay
//
//  Created by Jiahao Lu on 3/1/23.
//

import Foundation

/// UserDefault Singleton to save user's last used email

class UDM{
    
    static let shared = UDM()
    
    let defaults = UserDefaults()
    
}
