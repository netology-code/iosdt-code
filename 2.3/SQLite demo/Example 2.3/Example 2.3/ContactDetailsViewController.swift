//
//  ContactDetailsViewController.swift
//  Example 2.3
//
//  Created by Mikhail Rakhmalevich on 07.04.2021.
//

import Foundation
import UIKit

class ContactDetailsViewController: UIViewController {
    
    // MARK: -
    enum Mode {
        case add
        case edit(contact: Contact)
    }
    
    // MARK: - Properties
    var mode: Mode!
    var dataProvider: DataProvider!
    
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet private weak var saveButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        switch mode! {
        case .add:
            saveButton.setTitle("Create", for: .normal)
        case .edit(let contact):
            nameTextField.text = contact.name
            phoneTextField.text = contact.phoneNumber
            saveButton.setTitle("Save", for: .normal)
        }
    }
    
    // MARK: - Actions
    @IBAction func actionSave(_ sender: Any) {
        switch mode! {
        case .add:
            let newContact = Contact(name: nameTextField.text!, phoneNumber: phoneTextField.text!)
            dataProvider.addContact(newContact)
        case .edit(let contact):
            let updatedContact = Contact(id: contact.id, name: nameTextField.text!, phoneNumber: phoneTextField.text!)
            dataProvider.updateContact(updatedContact)
        }
        navigationController?.popViewController(animated: true)
    }
}
