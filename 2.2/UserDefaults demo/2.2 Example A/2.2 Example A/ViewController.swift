//
//  ViewController.swift
//  2.2 Example A
//
//  Created by Mikhail Rakhmalevich on 31.03.2021.
//

import UIKit
import __2_Example_Shared_Code

class ViewController: UIViewController {
    
    enum Keys: String {
        case boolKey
        case intKey
        case doubleKey
        case stringKey
        case intArrayKey
        case customStructureKey
        case colorKey
    }
    
    struct CustomStructure: Codable {
        var firstField: String
        var secondField: Int
        var thirdField: Double
    }
    
    struct CodableColor: Codable {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        
        var uiColor: UIColor {
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
        
        init(uiColor: UIColor) {
            uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
        }
    }
    
    @IBOutlet private var sharedValueTextField: UITextField!

    @IBAction func readValues(_ sender: Any) {
        let boolValue = UserDefaults.standard.bool(forKey: Keys.boolKey.rawValue)
        let intValue = UserDefaults.standard.integer(forKey: Keys.intKey.rawValue)
        let doubleValue = UserDefaults.standard.double(forKey: Keys.doubleKey.rawValue)
        let stringValue = UserDefaults.standard.string(forKey: Keys.stringKey.rawValue)
        let intArrayValue = UserDefaults.standard.array(forKey: Keys.intArrayKey.rawValue) as? [Int]
        
        print("""
            Bool value = \(boolValue)
            Int value = \(intValue)
            Double value = \(doubleValue)
            String value = \(stringValue ?? "nil")
            Integer array = \(intArrayValue?.description ?? "nil")
            
        """)
    }
    
    @IBAction func writeValues(_ sender: Any) {
        UserDefaults.standard.setValue(true, forKey: Keys.boolKey.rawValue)
        UserDefaults.standard.setValue(10, forKey: Keys.intKey.rawValue)
        UserDefaults.standard.setValue(111.3, forKey: Keys.doubleKey.rawValue)
        UserDefaults.standard.setValue("Some string", forKey: Keys.stringKey.rawValue)
        UserDefaults.standard.setValue([0, 1, 2], forKey: Keys.intArrayKey.rawValue)
        print("Values has been written")
    }
    
    @IBAction func eraseValues(_ sender: Any) {
        let keys = UserDefaults.standard.dictionaryRepresentation().keys
        keys.forEach { UserDefaults.standard.removeObject(forKey: $0) }
        print("All values have been erased")
    }
    
    @IBAction func readCustomStructure(_ sender: Any) {
        guard let customStructureString = UserDefaults.standard.object(forKey: Keys.customStructureKey.rawValue) as? String else {
            print("Custom structure data is missing")
            return
        }
        let decoder = JSONDecoder()
        let data = customStructureString.data(using: .utf8)
        let customStructure = try! decoder.decode(CustomStructure.self, from: data!)
        print(customStructure)
    }
    
    @IBAction func writeCustomStructure(_ sender: Any) {
        let customStructure = CustomStructure(firstField: "Text field value", secondField: -1, thirdField: 11.2)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(customStructure) {
            let stringStructure = String(data: encoded, encoding: .utf8)
            UserDefaults.standard.set(stringStructure, forKey: Keys.customStructureKey.rawValue)
        }
        print("Custom structure has been written")
    }
    
    @IBAction func writeValueToAppGroup(_ sender: Any) {
        SharedDataStorage.sharedValue = sharedValueTextField.text
        print("Value has been written to the group")
    }
}

