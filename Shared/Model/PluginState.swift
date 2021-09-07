//
//  PluginState.swift
//  PluginState
//
//  Created by Дмитрий on 06.09.2021.
//

import SwiftUI

struct PluginState: Codable, Identifiable {
    let package: String
    let version, reportingEvent: String?
    let state: State
    let title, summary, text: String?
    let deployId, siteId: String
    
    var id: String { package }
    
    enum State: String, Codable {
        case success
        case failed = "failed_build"
        case skipped
        
        var color: Color {
            switch self {
            case .success:
                return .green
            case .failed:
                return .red
            case .skipped:
                return .purple
            }
        }
    }
}

extension PluginState {
    static let placeholder = PluginState(
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

extension Array where Element == PluginState {
    static let arrayPlaceholder = Array(repeating: .placeholder, count: 1)
}
