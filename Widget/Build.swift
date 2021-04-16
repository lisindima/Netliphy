//
//  Build.swift
//  Netliphy Widget
//
//  Created by Дмитрий Лисин on 16.04.2021.
//

import Foundation

struct Build: Codable {
    let sha: String?
    let done: Bool
    let error: String?
    let createdAt: Date
    let startedAt: Date?
    let siteID: String
    let buildTime: TimeInterval?
    let state, subdomain: String?
    let customDomain: String?
    let context: String
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

// MARK: - Links
struct Links: Codable {
    let permalink, alias: URL?
}

extension Build {
    static let placeholder = Build(
        sha: nil,
        done: true,
        error: nil,
        createdAt: Date(),
        startedAt: nil,
        siteID: "placeholder",
        buildTime: nil,
        state: "placeholder",
        subdomain: nil,
        customDomain: "placeholder",
        context: "placeholder",
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
