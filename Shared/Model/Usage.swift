//
//  Usage.swift
//  Netliphy
//
//  Created by Дмитрий on 22.05.2022.
//

import SwiftUI

struct Usage: Identifiable {
    let id, siteId: String
    let type: String
    let stats: [StatsData]
    let createdAt, lastUpdatedAt: Date
    let periodStartDate, periodEndDate: Date
    let accountId, name, description, siteName: String
}

extension Usage {
    init(_ response: UsageResponse) {
        id = response.id
        siteId = response.id
        type = response.type
        stats = response.capabilities.compactMap {
            StatsData(title: $0.key.localizedUsageKey, included: $0.value.included, used: $0.value.used, unit: $0.value.unit)
        }
        createdAt = response.createdAt
        lastUpdatedAt = response.lastUpdatedAt
        periodStartDate = response.periodStartDate
        periodEndDate = response.periodEndDate
        accountId = response.accountId
        name = response.name
        description = response.description
        siteName = response.siteName
    }
}

struct StatsData: Identifiable {
    let id = UUID()
    let title: LocalizedStringKey
    let included, used: Double
    let unit: UsageUnit
}
