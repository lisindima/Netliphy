//
//  PluginState.swift
//  PluginState
//
//  Created by Дмитрий on 06.09.2021.
//

import Foundation

struct PluginState: Codable, Identifiable {
    let package: String
    let version, reportingEvent: String?
    let state: String
    let title, summary, text: String?
    let deployId, siteId: String
    
    var id: String { package }
}

extension PluginState {
    static let placeholder = PluginState(
        package: "package",
        version: "version",
        reportingEvent: "reportingEvent",
        state: "state",
        title: "placeholder",
        summary: "placeholder",
        text: "placeholder",
        deployId: UUID().uuidString,
        siteId: UUID().uuidString
    )
}

extension Array where Element == PluginState {
    static let arrayPlaceholder = Array(repeating: .placeholder, count: 1)
}
