//
//  SimpeDataProvider.swift
//  Example 2.3
//
//  Created by Mikhail Rakhmalevich on 07.04.2021.
//

import Foundation

final class SimpleDataProvider: DataProvider {
   
    weak var delegate: DataProviderDelegate?
    private var contacts: [Contact] = []
    
    func getContacts() -> [Contact] {
        return contacts
    }
    
    func addContact(_ contact: Contact) {
        contacts.append(contact)
        delegate?.contactsDidChange(dataProivider: self)
    }
    
    func updateContact(_ contact: Contact) {
        if let index = contacts.firstIndex(where: {$0.id == contact.id }) {
            contacts.remove(at: index)
            contacts.insert(contact, at: index)
            delegate?.contactsDidChange(dataProivider: self)
        }
    }
    
    func deleteContact(_ contact: Contact) {
        if let index = contacts.firstIndex(where: {$0.id == contact.id }) {
            contacts.remove(at: index)
            delegate?.contactsDidChange(dataProivider: self)
        }
    }
}
