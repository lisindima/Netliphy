//
//  Enum.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 03.03.2021.
//

import Foundation

enum DeployStateFilter: Hashable {
    case allState
    case filteredByState(state: DeployState)
}

enum BuildStateFilter: Hashable {
    case allState
    case filteredByState(state: BuildState)
}

enum SiteNameFilter: Hashable {
    case allSites
    case filteredBySite(site: String)
}
