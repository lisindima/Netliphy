//
//  CodableUserDefaults.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 06.03.2021.
//

import SwiftUI

@propertyWrapper
struct CodableUserDefaults<T: Codable> {
    let key: String
    let defaultValue: T
    
    init(key: String, default: T) {
        self.key = key
        defaultValue = `default`
    }
    
    var wrappedValue: T {
        get {
            guard let jsonString = UserDefaults.standard.string(forKey: key) else {
                return defaultValue
            }
            guard let jsonData = jsonString.data(using: .utf8) else {
                return defaultValue
            }
            guard let value = try? JSONDecoder().decode(T.self, from: jsonData) else {
                return defaultValue
            }
            return value
        }
        set {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            guard let jsonData = try? encoder.encode(newValue) else { return }
            let jsonString = String(bytes: jsonData, encoding: .utf8)
            UserDefaults.standard.set(jsonString, forKey: key)
        }
    }
}
