//
//  BelayUser.swift
//  Swift Belay
//
//  Created by Jiahao Lu on 2/26/23.
//

import Foundation

struct BelayUser{
    let firstName: String
    let lastName: String
    let email: String
    
    /// convert email to safeEmail in order to meet Firebase String requirement
    var safeEmail : String {
        let safeEmail = email.replacingOccurrences(of: ".", with: "-")
                             .replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}


extension BelayUser {
    static let testUser: BelayUser = BelayUser(firstName: "Bob", lastName: "Joe", email: "bob@gmail.com")
}
