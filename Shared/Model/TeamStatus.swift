//
//  TeamStatus.swift
//  TeamStatus
//
//  Created by Дмитрий Лисин on 18.07.2021.
//

import Foundation

struct TeamStatus: Codable {
    let bandwidth: Bandwidth
    let buildStatus: BuildStatus
    let members: [Member]
}

extension TeamStatus {
    static let placeholder = TeamStatus(bandwidth: .placeholder, buildStatus: .placeholder, members: .arrayPlaceholder)
}
