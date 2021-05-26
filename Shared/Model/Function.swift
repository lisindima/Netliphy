//
//  Function.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 25.05.2021.
//

import Foundation

struct FunctionInfo: Codable, Identifiable {
    let id, provider: String
    let createdAt: Date
    let functions: [Function]
    let logType: String
}

struct Function: Codable, Identifiable {
    let id: String
    let createdAt: Date
    let name: String
    let endpoint: URL
    let runtime: String
    let d, a: String
    let s: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "c"
        case name = "n"
        case endpoint = "endpoint"
        case runtime = "r"
        case d = "d"
        case a = "a"
        case s = "s"
    }
}

extension FunctionInfo {
    static let placeholder = FunctionInfo(
        id: UUID().uuidString,
        provider: "aws_lambda",
        createdAt: Date(),
        functions: [
            Function(
                id: UUID().uuidString,
                createdAt: Date(),
                name: "placeholder",
                endpoint: URL(string: "https://apple.com")!,
                runtime: "placeholder",
                d: UUID().uuidString,
                a: UUID().uuidString,
                s: 1234567890)
        ],
        logType: "socketeer"
    )
}
