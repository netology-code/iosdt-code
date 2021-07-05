//
//  Contact.swift
//  Example 2.3
//
//  Created by Mikhail Rakhmalevich on 07.04.2021.
//

import Foundation

final class Contact {
    
    let id: String
    let name: String
    let phoneNumber: String
    
    init(id: String = UUID().uuidString, name: String, phoneNumber: String) {
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
    }
}
