//
//  File.swift
//  File
//
//  Created by Дмитрий on 01.09.2021.
//

import Foundation

struct File: Codable, Identifiable {
    let id, path, sha: String
    let mimeType: String
    let size: Int64
    let siteId: String
    let deployId: String
}

extension File {
    static let placeholder = File(
        id: UUID().uuidString,
        path: "placeholder",
        sha: "placeholder",
        mimeType: "placeholder",
        size: 100,
        siteId: "placeholder",
        deployId: "placeholder"
    )
}

extension Array where Element == File {
    static let arrayPlaceholder = Array(repeating: .placeholder, count: 3)
}
