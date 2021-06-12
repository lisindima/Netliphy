//
//  Log.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 13.03.2021.
//

import Foundation

struct LogValue: Codable {
    let message: String
    let date: Date
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case message = "log"
        case date = "ts"
        case type
    }
}

typealias Log = [String: LogValue]

extension Log {
    static let placeholder = ["placeholder": LogValue(message: "placeholderplaceholderplaceholderplaceholder", date: Date(), type: nil)] as Log
}
