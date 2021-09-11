//
//  PluginRun.swift
//  PluginRun
//
//  Created by Дмитрий on 06.09.2021.
//

import SwiftUI

struct PluginRun: Codable, Identifiable {
    let package: String
    let version, reportingEvent: String?
    let state: PluginState
    let title, summary, text: String?
    let deployId, siteId: String
    
    var id: String { package }
}

extension PluginRun {
    static let placeholder = PluginRun(
        package: "package",
        version: "version",
        reportingEvent: "reportingEvent",
        state: .success,
        title: "placeholder",
        summary: "placeholder",
        text: "placeholder",
        deployId: UUID().uuidString,
        siteId: UUID().uuidString
    )
}

extension Array where Element == PluginRun {
    static let arrayPlaceholder = Array(repeating: .placeholder, count: 1)
}
