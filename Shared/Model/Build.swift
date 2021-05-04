//
//  Build.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 03.05.2021.
//

import SwiftUI

struct Build: Codable {
    let sha: String?
    let done: Bool
    let error: String?
    let createdAt: Date
    let startedAt: Date?
    let siteId: String
    let buildTime: TimeInterval?
    let state: BuildState
    let subdomain: String
    let customDomain: String?
    let context: DeployContext
    let branch: String?
    let commitRef: String?
    let commitUrl: URL?
    let reviewId: Int?
    let reviewUrl: URL?
    let title: String?
    let deployTime: TimeInterval?
    let links: Links
    let id, deployId: String
    let errorMessage: String?
    let deployState: String
    let deploySslUrl: URL?
    let committer: String?
}

struct Links: Codable {
    let permalink, alias: URL?
}

enum BuildState: String, Codable, View, CaseIterable {
    case done
    case skipped
    case error
    case building
    
    var body: some View {
        switch self {
        case .error:
            DeployState.error
        case .done:
            DeployState.ready
        case .skipped:
            Label("skipped_state", systemImage: "triangle")
                .font(.body.weight(.bold))
                .foregroundColor(.purple)
        case .building:
            DeployState.building
        }
    }
}

extension Build {
    var gitInfo: String {
        var string = ""
        
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
        
        return string
    }
}

extension Build {
    static let placeholder = Build(
        sha: nil,
        done: true,
        error: nil,
        createdAt: Date(),
        startedAt: nil,
        siteId: "placeholder",
        buildTime: nil,
        state: .building,
        subdomain: "Site name",
        customDomain: "placeholder",
        context: .production,
        branch: "main",
        commitRef: nil,
        commitUrl: nil,
        reviewId: nil,
        reviewUrl: nil,
        title: nil,
        deployTime: 356,
        links: Links(
            permalink: nil,
            alias: nil
        ),
        id: UUID().uuidString,
        deployId: "placeholder",
        errorMessage: nil,
        deployState: "placeholder",
        deploySslUrl: nil,
        committer: nil
    )
}
