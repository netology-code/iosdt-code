//
//  ViewController.swift
//  2.2 Example B
//
//  Created by Mikhail Rakhmalevich on 31.03.2021.
//

import UIKit
import __2_Example_Shared_Code

class ViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet private var sharedValueLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSharedValue()
    }
    
    private func updateSharedValue() {
        sharedValueLabel.text = "Shared value: \(SharedDataStorage.sharedValue ?? "empty")"
    }
    
    // MARK: - Actions
    @IBAction func readSharedValue(_ sender: Any) {
        updateSharedValue()
    }
}

