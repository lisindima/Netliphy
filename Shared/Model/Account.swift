//
//  Account.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 23.06.2021.
//

import SwiftUI

struct Account: Codable, Identifiable {
    var id = UUID()
    let user: User
    let teams: [Team]
    let token: String
    let typeToken: String
    
    var accessToken: String {
        typeToken + " " + token
    }
}

typealias Accounts = [Account]

extension Accounts: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8), let result = try? JSONDecoder().decode(Accounts.self, from: data) else {
            return nil
        }
        self = result
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self), let result = String(data: data, encoding: .utf8) else {
            return "[]"
        }
        return result
    }
}

let store = UserDefaults(suiteName: "group.darkfox.netliphy")
