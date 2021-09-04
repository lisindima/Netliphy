//
//  Plugin.swift
//  Netliphy
//
//  Created by Дмитрий on 04.09.2021.
//

import Foundation

struct Plugin: Codable, Identifiable {
    let author, name, description, package: String
    let repo: URL
    let version: String
    let status: String?
    
    var id: String { name }
}

extension Plugin {
    static let placeholder = Plugin(
        author: "placeholder",
        name: "placeholder",
        description: "description placeholder",
        package: "placeholder",
        repo: URL(string: "https://apple.com")!,
        version: "1.0.0",
        status: nil
    )
}

extension Array where Element == Plugin {
    static let arrayPlaceholder = Array(repeating: .placeholder, count: 1)
}
