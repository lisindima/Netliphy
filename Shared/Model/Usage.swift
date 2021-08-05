//
//  Usage.swift
//  Usage
//
//  Created by Дмитрий Лисин on 26.07.2021.
//

import Foundation

struct Usage: Codable, Identifiable {
    let id, siteId: String
    let type: String
    let capabilities: [String: StatsData]
    let createdAt, lastUpdatedAt: Date
    let periodStartDate, periodEndDate: Date
    let accountId, name, description, siteName: String
}

struct StatsData: Codable {
    let included, used: Double
    let unit: UsageUnit
}

enum UsageUnit: String, Codable {
    case users
    case requests
    case seconds
    case submissions
    case bytes
}

extension Usage {
    static let placeholder = Usage(
        id: UUID().uuidString,
        siteId: UUID().uuidString,
        type: "placeholder",
        capabilities: [
            "one": StatsData(
                included: 1.0,
                used: 1.0,
                unit: .users
            ),
            "two": StatsData(
                included: 1.0,
                used: 1.0,
                unit: .users
            ),
        ],
        createdAt: Date(),
        lastUpdatedAt: Date(),
        periodStartDate: Date(),
        periodEndDate: Date(),
        accountId: "placeholder",
        name: "placeholder",
        description: "placeholder",
        siteName: "placeholder"
    )
}

extension Array where Element == Usage {
    static let arrayPlaceholder = Array(repeating: .placeholder, count: 1)
}
