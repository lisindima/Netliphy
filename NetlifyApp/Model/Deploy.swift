//
//  Deploy.swift
//  NetlifyApp
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import Foundation

struct Deploy: Codable {
    let id, siteId, userId, buildId: String
    let name: String
    let state: State
    let adminUrl, deployUrl, url, sslUrl, deploySslUrl, commitUrl: URL
    let screenshotUrl: URL?
    let reviewId: Int?
    let branch, commitRef: String
    let errorMessage: String?
    let skipped: Bool?
    let createdAt, updatedAt: Date
    let publishedAt: Date?
    let title: String
    let context: String
    let locked: Bool?
    let reviewUrl: URL?
    let deployTime: Int?
    let logAccessAttributes: LogAccessAttributes
}

struct LogAccessAttributes: Codable {
    let type: String
    let url: String
    let endpoint: String
    let path, token: String
}

extension Deploy {
    enum State: String, Codable {
        case error
        case ready
        case new
        case building
    }
}
