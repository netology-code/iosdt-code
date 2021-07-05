//
//  DataProvider.swift
//  Example 2.3
//
//  Created by Mikhail Rakhmalevich on 07.04.2021.
//

protocol DataProviderDelegate: class {
    func contactsDidChange(dataProivider: DataProvider)
}

protocol DataProvider: class {
    var delegate: DataProviderDelegate? { get set }
    func getContacts() -> [Contact]
    func addContact(_ contact: Contact)
    func updateContact(_ contact: Contact)
    func deleteContact(_ contact: Contact)
}
