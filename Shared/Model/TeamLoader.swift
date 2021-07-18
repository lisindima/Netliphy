//
//  TeamLoader.swift
//  TeamLoader
//
//  Created by Дмитрий Лисин on 18.07.2021.
//

import Foundation

struct TeamLoader: Codable {
    let bandwidth: Bandwidth
    let buildStatus: BuildStatus
    let members: [Member]
}

extension TeamLoader {
    static let placeholder = TeamLoader(bandwidth: .placeholder, buildStatus: .placeholder, members: .arrayPlaceholder)
}
