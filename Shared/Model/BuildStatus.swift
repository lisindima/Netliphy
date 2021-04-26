//
//  BuildStatus.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 06.04.2021.
//

import Foundation

struct BuildStatus: Codable {
    let active, pendingConcurrency, enqueued: Int
    let minutes: Minutes
    let buildCount: Int
}

struct Minutes: Codable {
    let current, previous: Int
    let currentAverageSec: Int?
    let periodStartDate, periodEndDate: String
    let lastUpdatedAt: Date
    let includedMinutes, includedMinutesWithPacks: Int
}

extension BuildStatus {
    static let placeholder = BuildStatus(
        active: 0,
        pendingConcurrency: 0,
        enqueued: 0,
        minutes: Minutes(
            current: 67,
            previous: 50,
            currentAverageSec: nil,
            periodStartDate: "placeholder",
            periodEndDate: "placeholder",
            lastUpdatedAt: Date(),
            includedMinutes: 100,
            includedMinutesWithPacks: 100
        ),
        buildCount: 1
    )
}
