//
//  Deploy.swift
//  NetlifyApp
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import Foundation

struct Deploy: Codable {
    let id, siteId, userId, buildId: String
    let state, name: String
    let adminUrl, deployUrl, url, sslUrl, deploySslUrl: URL
    let screenshotUrl: URL?
    let reviewId: Int?
    let branch, commitRef, commitUrl: String
    let errorMessage: String?
    let skipped: Bool?
    let createdAt, updatedAt: Date
    let publishedAt: Date?
    let title: String
    let context: String
    let locked: Bool?
    let reviewUrl: URL?
    let deployTime: Int?
}
