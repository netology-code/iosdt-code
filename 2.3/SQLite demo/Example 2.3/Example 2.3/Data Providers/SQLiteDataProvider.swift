//
//  SQLiteDataProvider.swift
//  Example 2.3
//
//  Created by Mikhail Rakhmalevich on 20.05.2021.
//

import Foundation
import SQLite

class SQLiteDataProvider: DataProvider {
    
    weak var delegate: DataProviderDelegate?
    
    private var db: Connection? {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dbPath = documentsPath.appendingPathComponent("contacts.sqlite").absoluteString
        return try? Connection(dbPath)
    }
    
    private let contactsTable = Table("Contacts")
    private let idField = Expression<String>("id")
    private let nameField = Expression<String>("name")
    private let numberField = Expression<String>("number")
    
    init() {
        // Create table
        _ = try? db?.run(contactsTable.create {
            $0.column(idField, primaryKey: true)
            $0.column(nameField)
            $0.column(numberField)
        })
    }
    
    func getContacts() -> [Contact] {
        let cachedContacts: AnySequence<Row>? = try? db?.prepare(contactsTable)
        return cachedContacts?.map {
            return Contact(id: $0[idField], name: $0[nameField], phoneNumber: $0[numberField])
        } ?? []
    }
    
    func addContact(_ contact: Contact) {
        let insertQuery = contactsTable.insert(idField <- contact.id, nameField <- contact.name, numberField <- contact.phoneNumber)
        let rowId = try? db?.run(insertQuery)
        if rowId != nil {
            delegate?.contactsDidChange(dataProivider: self)
        }
    }
    
    func updateContact(_ contact: Contact) {
        let cachedContact = contactsTable.filter(idField == contact.id)
        let updateQuery = cachedContact.update(nameField <- contact.name, numberField <- contact.phoneNumber)
        let rowId = try? db?.run(updateQuery)
        if rowId != nil {
            delegate?.contactsDidChange(dataProivider: self)
        }
    }
    
    func deleteContact(_ contact: Contact) {
        let cachedContact = contactsTable.filter(idField == contact.id)
        let deleteQuery = cachedContact.delete()
        let rowId = try? db?.run(deleteQuery)
        if rowId != nil {
            delegate?.contactsDidChange(dataProivider: self)
        }
    }
}
