//
//  Log.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 13.03.2021.
//

import Foundation

struct LogValue: Codable, Hashable {
    let log: String
    let ts: Date
    let type: String?
}

typealias Log = [String: LogValue]
