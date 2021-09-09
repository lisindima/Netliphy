//
//  Bandwidth.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 06.04.2021.
//

import Foundation

struct Bandwidth: Codable {
    let used, included: Int64
    let lastUpdatedAt: Date
    let periodStartDate, periodEndDate: String
    let additional: Int
    
    var start: Double {
        Double(used)
    }

    var finish: Double {
        Double(included)
    }
}

extension Bandwidth {
    static let placeholder = Bandwidth(
        used: 25,
        included: 100,
        lastUpdatedAt: Date(),
        periodStartDate: "placeholder",
        periodEndDate: "placeholder",
        additional: 0
    )
}
