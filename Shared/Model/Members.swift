//
//  Member.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 15.04.2021.
//

import Foundation

struct Member: Codable, Identifiable {
    let id, fullName, email: String
    let avatar: URL
    let role: String
    let mfaEnabled: Bool
    let connectedAccounts: ConnectedAccounts?
    let siteAccess: String
    let createdAt, updatedAt: Date
}

extension Member {
    static let placeholder = Member(
        id: UUID().uuidString,
        fullName: "placeholder",
        email: "placeholder",
        avatar: URL(string: "https://apple.com")!,
        role: "placeholder",
        mfaEnabled: false,
        connectedAccounts: nil,
        siteAccess: "placeholder",
        createdAt: Date(),
        updatedAt: Date()
    )
}

extension Array where Element == Member {
    static let arrayPlaceholder = Array(repeating: .placeholder, count: 1)
}
