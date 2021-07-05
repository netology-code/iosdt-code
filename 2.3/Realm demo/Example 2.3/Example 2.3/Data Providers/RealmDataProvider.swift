//
//  RealmDataProvider.swift
//  Example 2.3
//
//  Created by Mikhail Rakhmalevich on 20.05.2021.
//

import Foundation
import RealmSwift

@objcMembers class CachedContact: Object {
    dynamic var id: String?
    dynamic var name: String?
    dynamic var phoneNumber: String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class RealmDataProvider: DataProvider {
    weak var delegate: DataProviderDelegate?
    private var notificationToken: NotificationToken?
    
    private var realm: Realm? {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("contacts.realm")
        return try? Realm(configuration: config)
    }
    
    init() {
        notificationToken = realm?.observe { [unowned self] _, _ in
            self.delegate?.contactsDidChange(dataProivider: self)
        }
    }
    
    func getContacts() -> [Contact] {
        return realm?.objects(CachedContact.self).compactMap {
            guard let id = $0.id, let name = $0.name, let phoneNumber = $0.phoneNumber else { return nil }
            return Contact(id: id, name: name, phoneNumber: phoneNumber)
        } ?? []
    }
    
    func addContact(_ contact: Contact) {
        let cachedConact = CachedContact()
        cachedConact.id = contact.id
        cachedConact.name = contact.name
        cachedConact.phoneNumber = contact.phoneNumber
        
        try? realm?.write {
            realm?.add(cachedConact)
        }
    }
    
    func updateContact(_ contact: Contact) {
        guard let cachedContact = realm?.object(ofType: CachedContact.self, forPrimaryKey: contact.id) else { return }
        
        try? realm?.write {
            cachedContact.name = contact.name
            cachedContact.phoneNumber = contact.phoneNumber
        }
    }
    
    func deleteContact(_ contact: Contact) {
        guard let cachedContact = realm?.object(ofType: CachedContact.self, forPrimaryKey: contact.id) else { return }
        
        try? realm?.write {
            realm?.delete(cachedContact)
        }
    }
}
