//
//  SiteModel.swift
//  NetlifyApp
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import Foundation

struct Site: Codable {
    let id: String
    let state: String
    let plan: String
    let name: String
    let customDomain: String
    let domainAliases: [String]
    let password: String?
    let notificationEmail: String?
    let url: URL
    let sslUrl: URL
    let adminUrl: URL
    let screenshotUrl: URL
    let createdAt: Date
    let updatedAt: Date
    let userId: String
    let sessionId: String?
    let ssl: Bool
    let forceSsl: Bool
    let managedDns: Bool
    let deployUrl: URL
    let accountName: String
    let accountSlug: String
    let gitProvider: String?
    let deployHook: String
    let idDomain: String
    let buildImage: String
    let prerender: String
}
