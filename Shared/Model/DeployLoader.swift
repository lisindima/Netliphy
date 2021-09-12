//
//  DeployLoader.swift
//  DeployLoader
//
//  Created by Дмитрий on 06.09.2021.
//

import Foundation

struct DeployLoader: Codable {
    let deploy: Deploy
    let site: Site
    let pluginRun: [PluginRun]
    let eventDeploy: [EventDeploy]?
}

extension DeployLoader {
    static let placeholder = DeployLoader(deploy: .placeholder, site: .placeholder, pluginRun: .arrayPlaceholder, eventDeploy: .arrayPlaceholder)
}
