//
//  Deploy.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import SwiftUI

struct Deploy: Codable, Identifiable {
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
    let links: [String: URL]
    let summary: Summary?
}

struct LogAccessAttributes: Codable {
    let type: String
    let url: String
    let endpoint: String
    let path, token: String
}

enum DeployContext: String, Codable, View {
    case deployPreview = "deploy-preview"
    case production
    
    var prettyValue: String {
        switch self {
        case .deployPreview:
            return "Deploy Preview"
        case .production:
            return "Production"
        }
    }
    
    var body: some View {
        switch self {
        case .deployPreview:
            Label(prettyValue, systemImage: "bolt")
                .font(.body.weight(.bold))
                .foregroundColor(.secondary)
        case .production:
            Label(prettyValue, systemImage: "bolt.fill")
                .font(.body.weight(.bold))
                .foregroundColor(.yellow)
        }
    }
}

enum DeployState: String, Codable, View, CaseIterable, Identifiable {
    case error
    case ready
    case new
    case building
    case enqueued
    case processing
    
    var id: String { rawValue }
    
    var color: Color {
        switch self {
        case .error:
            return .red
        case .ready:
            return .green
        case .new:
            return .blue
        case .building:
            return .yellow
        case .enqueued:
            return .gray
        case .processing:
            return .brown
        }
    }
    
    var body: some View {
        switch self {
        case .error:
            Label("Error", systemImage: "xmark.circle.fill")
                .font(.body.weight(.bold))
                .foregroundColor(color)
        case .ready:
            Label("Ready", systemImage: "checkmark.circle.fill")
                .font(.body.weight(.bold))
                .foregroundColor(color)
        case .new:
            Label("New", systemImage: "cross.fill")
                .font(.body.weight(.bold))
                .foregroundColor(color)
        case .building:
            Label("Building", systemImage: "gearshape.2.fill")
                .font(.body.weight(.bold))
                .foregroundColor(color)
        case .enqueued:
            Label("Queued", systemImage: "hourglass")
                .font(.body.weight(.bold))
                .foregroundColor(color)
        case .processing:
            Label("Processing", systemImage: "clock.fill")
                .font(.body.weight(.bold))
                .foregroundColor(color)
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

struct Message: Codable, Identifiable {
    let type: Type
    let title, description: String
    let details: String?
    
    var id: String { title }

    var markdown: AttributedString? {
        try? AttributedString(markdown: description)
    }
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
                .labelStyle(.iconOnly)
        case .building:
            DeployState.building
                .labelStyle(.iconOnly)
        case .new:
            DeployState.new
                .labelStyle(.iconOnly)
        }
    }
}

extension Message {
    static let placeholder = Message(
        type: .info,
        title: "placeholder",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
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
        links: [
            "link": URL(string: "https://apple.com")!
        ],
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

extension Array where Element == Deploy {
    static let arrayPlaceholder = Array(repeating: .placeholder, count: 5)
}
