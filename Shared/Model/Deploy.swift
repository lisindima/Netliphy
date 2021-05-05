//
//  Deploy.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import Foundation
import SwiftUI

struct Deploy: Codable {
    let id, siteId, userId: String
    let buildId: String?
    let name: String
    let state: DeployState
    let adminUrl, deployUrl, url, sslUrl, deploySslUrl: URL
    let screenshotUrl, commitUrl: URL?
    let reviewId: Int?
    let branch: String?
    let errorMessage, commitRef: String?
    let skipped: Bool?
    let createdAt, updatedAt: Date
    let publishedAt: Date?
    let title: String?
    let context: DeployContext
    let locked: Bool?
    let reviewUrl: URL?
    let committer: String?
    let framework: String?
    let deployTime: TimeInterval?
    let manualDeploy: Bool
    let logAccessAttributes: LogAccessAttributes
    let summary: Summary?
}

struct LogAccessAttributes: Codable {
    let type: String
    let url: String
    let endpoint: String
    let path, token: String
}

enum DeployContext: String, CodingKey, Codable {
    case deployPreview = "deploy-preview"
    case production
    
    var prettyValue: String {
        switch self {
        case .deployPreview:
            return "Deploy preview"
        case .production:
            return "Production"
        }
    }
}

enum DeployState: String, Codable, View, CaseIterable {
    case error
    case ready
    case new
    case building
    
    var body: some View {
        switch self {
        case .error:
            Label("error_state", systemImage: "xmark.circle.fill")
                .font(.body.weight(.bold))
                .foregroundColor(.red)
        case .ready:
            Label("ready_state", systemImage: "checkmark.circle.fill")
                .font(.body.weight(.bold))
                .foregroundColor(.green)
        case .new:
            Label("new_state", systemImage: "star.fill")
                .font(.body.weight(.bold))
                .foregroundColor(.blue)
        case .building:
            Label("building_state", systemImage: "gearshape.2.fill")
                .font(.body.weight(.bold))
                .foregroundColor(.yellow)
        }
    }
    
    @ViewBuilder
    var widget: some View {
        switch self {
        case .error:
            StateWidgetView(title: "error_state", color: .red)
        case .ready:
            StateWidgetView(title: "ready_state", color: .green)
        case .new:
            StateWidgetView(title: "new_state", color: .purple)
        case .building:
            StateWidgetView(title: "building_state", color: .yellow)
        }
    }
}

struct Summary: Codable {
    let status: Status
    let messages: [Message]
}

enum Status: String, Codable {
    case unavailable
    case ready
    case building
}

struct Message: Codable, Hashable {
    let type: Type
    let title, description: String
    let details: String?
}

enum Type: String, Codable, View {
    case info
    case warning
    case error
    case building
    case new
    
    var body: some View {
        switch self {
        case .warning:
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.body.weight(.bold))
                .foregroundColor(.purple)
        case .info:
            Image(systemName: "info.circle.fill")
                .font(.body.weight(.bold))
                .foregroundColor(.accentColor)
        case .error:
            DeployState.error
                .labelStyle(IconOnlyLabelStyle())
        case .building:
            DeployState.building
                .labelStyle(IconOnlyLabelStyle())
        case .new:
            DeployState.new
                .labelStyle(IconOnlyLabelStyle())
        }
    }
}

extension Message {
    static let placeholder = Message(
        type: .info,
        title: "placeholder",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
        details: nil
    )
}

extension Deploy {
    var gitInfo: String {
        var string = ""
        
        if manualDeploy {
            string = "Manual deploy"
        } else {
            if let branch = branch, branch.count >= 10 {
                string.append(String(branch.prefix(10) + "... @"))
            } else if let branch = branch {
                string.append(branch + "@")
            }
            
            if let commitRef = commitRef {
                string.append(String(commitRef.prefix(7)))
            } else {
                string.append("HEAD")
            }
        }
        
        return string
    }
}

extension Deploy {
    static let placeholder = Deploy(
        id: UUID().uuidString,
        siteId: "placeholder",
        userId: "placeholder",
        buildId: nil,
        name: "Site name",
        state: .ready,
        adminUrl: URL(string: "https://apple.com")!,
        deployUrl: URL(string: "https://apple.com")!,
        url: URL(string: "https://apple.com")!,
        sslUrl: URL(string: "https://apple.com")!,
        deploySslUrl: URL(string: "https://apple.com")!,
        screenshotUrl: nil,
        commitUrl: nil,
        reviewId: nil,
        branch: nil,
        errorMessage: nil,
        commitRef: nil,
        skipped: nil,
        createdAt: Date(),
        updatedAt: Date(),
        publishedAt: nil,
        title: nil,
        context: .production,
        locked: nil,
        reviewUrl: nil,
        committer: nil,
        framework: nil,
        deployTime: 100,
        manualDeploy: true,
        logAccessAttributes: LogAccessAttributes(
            type: "placeholder",
            url: "placeholder",
            endpoint: "placeholder",
            path: "placeholder",
            token: "placeholder"
        ),
        summary: Summary(
            status: .ready,
            messages: [
                .placeholder,
                .placeholder,
                .placeholder
            ]
        )
    )
}
