//
//  UsageResponse.swift
//  UsageResponse
//
//  Created by Дмитрий Лисин on 26.07.2021.
//

import Foundation
import SwiftUI

struct UsageResponse: Codable, Identifiable {
    let id, siteId: String
    let type: String
    let capabilities: [String: StatsDataResponse]
    let createdAt, lastUpdatedAt: Date
    let periodStartDate, periodEndDate: Date
    let accountId, name, description, siteName: String
}

struct StatsDataResponse: Codable {
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
