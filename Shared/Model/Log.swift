//
//  Log.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 13.03.2021.
//

import Foundation

struct Log: Codable, Identifiable {
    var id = UUID()
    let message: String
    let date: Date
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case message = "log"
        case date = "ts"
        case type
    }
}

extension Log {
    static let placeholder = Log(
        message: "placeholderplaceholderplaceholderplaceholderplaceholderplaceholderplaceholderplaceholder",
        date: Date(),
        type: nil
    )
}

extension Array where Element == Log {
    static let arrayPlaceholder = Array(repeating: .placeholder, count: 10)
}
