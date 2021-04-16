//
//  Build.swift
//  Netliphy Widget
//
//  Created by Дмитрий Лисин on 16.04.2021.
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

enum BuildState: String, Codable, View {
    case done
    case skipped
    case error
    case building
    
    var body: some View {
        switch self {
        case .done:
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .imageScale(.large)
        case .skipped:
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.purple)
                .imageScale(.large)
        case .error:
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.red)
                .imageScale(.large)
        case .building:
            Image(systemName: "gearshape.2.fill")
                .foregroundColor(.yellow)
                .imageScale(.large)
        }
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
        state: .done,
        subdomain: "placeholder",
        customDomain: "placeholder",
        context: .production,
        branch: "placeholder",
        commitRef: nil,
        commitUrl: nil,
        reviewId: nil,
        reviewUrl: nil,
        title: nil,
        deployTime: nil,
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
