//
//  User.swift
//  Swift Belay
//
//  Created by William Yang on 2/6/23.
//

import Foundation

struct User: Identifiable {
    var id: UUID
    var firstName: String
    var lastName: String
    var gender: String
    var dateOfBirth: Date
    
    
    init(id: UUID = UUID(), firstName: String, lastName: String, gender: String, dateOfBirth: Date) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.dateOfBirth = dateOfBirth
    }
}

extension User {
    static let testUser: User = User(firstName: "Bob", lastName: "Joe", gender: "Male", dateOfBirth: Date())
}
