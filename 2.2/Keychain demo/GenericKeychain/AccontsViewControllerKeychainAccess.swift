//
//  AccontsViewControllerKeychainAccess.swift
//  GenericKeychain
//
//  Created by Mikhail Rakhmalevich on 31.03.2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import UIKit
import KeychainAccess

class AccountsViewController: UITableViewController, AccountDetailsViewControllerDelegate {

    let cellReuseIdentifier = "Cell"
    
    var passwordItems = [String]()
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Localize the title using app-specific localizations.
        navigationItem.title = NSLocalizedString("AccountsViewControllerTitle", comment: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateTableData()
    }
    
    private func updateTableData() {
        
        let keychain = Keychain(service: KeychainConfiguration.serviceName)
        passwordItems = keychain.allKeys()
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let navigationController = segue.destination as? UINavigationController,
           let accountViewController = navigationController.children.first as? AccountDetailsViewController
        {
            if let indexPath = tableView.indexPathForSelectedRow {
                accountViewController.accountName = passwordItems[indexPath.row]
            }
            accountViewController.delegate = self
        }
    }
    
    // MARK: Unwind segues
    
    @IBAction func unwindToAccountsView(_ segue: UIStoryboardSegue) {
    }

    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passwordItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        let passwordItem = passwordItems[indexPath.row]
        
        cell.textLabel?.text = passwordItem
        
        return cell
    }
    
    // MARK: UITableViewDataDelegate

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { action, indexPath in
            // Try to delete the item from the keychain.
            let passwordItem = self.passwordItems[indexPath.row]
            let keychain = Keychain(service: KeychainConfiguration.serviceName)
            
            do {
                try keychain.remove(passwordItem)
            }
            catch {
                fatalError("Error deleting keychain item - \(error)")
            }
            
            // Delete the item from the `passwordItems` array.
            self.passwordItems.remove(at: indexPath.row)
            
            // Delete the item from the table view
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return [deleteAction]
    }
    
    // MARK: - AccountDetailsViewControllerDelegate
    
    func accountDetailsViewControllerDidSaveData(controller: AccountDetailsViewController) {
        updateTableData()
    }
}
