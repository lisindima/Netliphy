//
//  DeployLoader.swift
//  DeployLoader
//
//  Created by Дмитрий on 06.09.2021.
//

import Foundation

struct DeployLoader: Codable {
    let deploy: Deploy
    let pluginState: [PluginState]
}

extension DeployLoader {
    static let placeholder = DeployLoader(deploy: .placeholder, pluginState: .arrayPlaceholder)
}
