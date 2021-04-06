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
    let current, currentAverageSec, previous: Int
    let periodStartDate, periodEndDate: String
    let lastUpdatedAt: Date
    let includedMinutes, includedMinutesWithPacks: Int
}
