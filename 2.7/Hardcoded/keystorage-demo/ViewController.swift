//
//  ViewController.swift
//  radare-demo
//
//  Created by Mikhail Rakhmalevich on 28.04.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var secretValueLabel: UILabel!

    @IBAction func fetchSecret(_ sender: Any) {
        secretValueLabel.text = KeyStorage.secretKey
    }
}
