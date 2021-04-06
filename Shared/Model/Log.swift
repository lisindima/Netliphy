//
//  Log.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 13.03.2021.
//

import Foundation

struct LogValue: Codable {
    let log: String
    let ts: Date
    let type: String?
}

typealias Log = [String: LogValue]

extension Log {
    static let placeholder = ["placeholder": LogValue(log: "placeholderplaceholder", ts: Date(), type: nil)] as Log
}
