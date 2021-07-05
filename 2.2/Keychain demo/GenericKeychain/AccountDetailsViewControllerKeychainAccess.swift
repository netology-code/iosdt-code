//
//  AccontsDetailsViewControllerKeychainAccess.swift
//  GenericKeychain
//
//  Created by Mikhail Rakhmalevich on 31.03.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import KeychainAccess

protocol AccountDetailsViewControllerDelegate: class {
    func accountDetailsViewControllerDidSaveData(controller: AccountDetailsViewController)
}

class AccountDetailsViewController: UITableViewController {
    
    // MARK: Dependency injection properties
    
    var accountName: String?
    
    weak var delegate: AccountDetailsViewControllerDelegate?
    
    // MARK: Interface Builder outlets
    
    @IBOutlet var accountNameField: UITextField!
    
    @IBOutlet var passwordField: UITextField!
    
    @IBOutlet var clearTextSwitch: UISwitch!
    
    @IBOutlet var saveButton: UIBarButtonItem!
 
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If an account name has been set, read any existing password from the keychain.
        if let accountName = accountName {
            let keychain = Keychain(service: KeychainConfiguration.serviceName)
            accountNameField.text = accountName
            passwordField.text = keychain[accountName]
        }
        
        // Update the save button state to reflect the state of the text fields.
        updateSaveButtonState()
    }

    // MARK: Interface Builder actions
    
    @IBAction func textFieldChanged(_ sender: AnyObject) {
        updateSaveButtonState()
    }

    @IBAction func toggleClearText(_: AnyObject) {
        passwordField.isSecureTextEntry = !clearTextSwitch.isOn
    }

    @IBAction func save(_ sender: AnyObject) {
        // Check that text has been entered into both the account and password fields.
        guard let newAccountName = accountNameField.text, let newPassword = passwordField.text, !newAccountName.isEmpty && !newPassword.isEmpty else { return }
        
        do {
            let keychain = Keychain(service: KeychainConfiguration.serviceName)
            if let originalAccountName = accountName, originalAccountName != newAccountName {
                try keychain.remove(originalAccountName)
            }
            keychain[newAccountName] = newPassword
            
            delegate?.accountDetailsViewControllerDidSaveData(controller: self)
        }
        catch {
            fatalError("Error updating keychain - \(error)")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func updateSaveButtonState() {
        guard isViewLoaded else { return }
        
        // Enable the save button if both account and password fields contain text.
        if let newAccount = accountNameField.text, let newPassword = passwordField.text, !newAccount.isEmpty && !newPassword.isEmpty {
            saveButton?.isEnabled = true
        }
        else {
            saveButton?.isEnabled = false
        }
    }
}
