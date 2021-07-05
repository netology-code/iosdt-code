//
//  SharedDataStorage.swift
//  2.2 Example Shared Code
//
//  Created by Mikhail Rakhmalevich on 31.03.2021.
//

import Foundation

public class SharedDataStorage {
    private enum SharedKeys: String {
        case sharedValue
    }
    
    static private var userDefaults: UserDefaults {
        return UserDefaults(suiteName: "group.com.mikhailra.2.2_example")!
    }
    
    static public var sharedValue: String? {
        get {
            return userDefaults.string(forKey: SharedKeys.sharedValue.rawValue)
        }
        set (newValue) {
            userDefaults.setValue(newValue, forKey: SharedKeys.sharedValue.rawValue)
        }
    }
}

