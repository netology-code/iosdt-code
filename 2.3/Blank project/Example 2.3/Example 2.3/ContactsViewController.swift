//
//  ContactsViewController.swift
//  Example 2.3
//
//  Created by Mikhail Rakhmalevich on 07.04.2021.
//

import UIKit

class ContactsViewController: UIViewController,
                              UITableViewDelegate,
                              UITableViewDataSource,
                              DataProviderDelegate {

    // MARK: - Properties
    @IBOutlet private weak var tableView: UITableView!
    private let dataProvider: DataProvider = SimpleDataProvider()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataProvider.delegate = self
    }
    
    // MARK: - Actions
    @IBAction func addSampleContact(_ sender: Any) {
        let sampleContact = Contact(name: "Test", phoneNumber: "test")
        dataProvider.addContact(sampleContact)
    }
    
    @IBAction func addContact(_ sender: Any) {
        let contactsViewController = storyboard?.instantiateViewController(identifier: "contactDetails") as! ContactDetailsViewController
        contactsViewController.mode = .add
        contactsViewController.dataProvider = dataProvider
        navigationController?.pushViewController(contactsViewController, animated: true)
    }

    // MARK: - DataProvider delegate
    func contactsDidChange(dataProivider: DataProvider) {
        tableView.reloadData()
    }
    
    // MARK: - UITableView delegate & datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.getContacts().count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = dataProvider.getContacts()[indexPath.row]
        let contactsViewController = storyboard?.instantiateViewController(identifier: "contactDetails") as! ContactDetailsViewController
        contactsViewController.dataProvider = dataProvider
        contactsViewController.mode = .edit(contact: contact)
        navigationController?.pushViewController(contactsViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = dataProvider.getContacts()[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell")!
        cell.textLabel?.text = contact.name
        cell.detailTextLabel?.text = contact.phoneNumber
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let contact = dataProvider.getContacts()[indexPath.row]
        dataProvider.deleteContact(contact)
    }
}

