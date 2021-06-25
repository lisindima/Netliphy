//
//  FunctionLog.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 05.06.2021.
//

import Foundation

struct FunctionLog: Codable, Identifiable {
    var id = UUID()
    let level: String?
    let message: String?
    let requestId: String?
    let ts: TimeInterval
    let type: String
    
    var date: Date {
        Date(timeIntervalSince1970: ts)
    }
    
    enum CodingKeys: String, CodingKey {
        case level
        case message
        case requestId = "request_id"
        case ts
        case type
    }
}
