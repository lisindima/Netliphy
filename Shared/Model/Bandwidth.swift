//
//  Bandwidth.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 06.04.2021.
//

import Foundation

struct Bandwidth: Codable {
    let used, included: Int
    let lastUpdatedAt: Date
    let periodStartDate, periodEndDate: String
    let additional: Int
}
