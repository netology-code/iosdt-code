//
//  KeyStorage.swift
//  radare-demo
//
//  Created by Mikhail Rakhmalevich on 28.04.2021.
//

import Foundation

final class KeyStorage {
    static let secretKey = Bundle.main.object(forInfoDictionaryKey: "CONF_SECRET_KEY") as! String
}
