//
//  Site.swift
//  NetlifyApp
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import Foundation

struct Site: Codable {
    let id, state, plan, name: String
    let customDomain: String?
    let domainAliases: [String]
    let password, notificationEmail: String?
    let adminUrl, screenshotUrl, url, sslUrl: URL
    let createdAt, updatedAt: Date
    let userId: String
    let sessionId: String?
    let ssl, managedDns: Bool
    let forceSsl: Bool?
    let deployUrl: URL
    let publishedDeploy: Deploy
    let accountName, accountType, accountSlug, deployHook: String
    let gitProvider: String?
    let processingSettings: ProcessingSettings
    let buildSettings: BuildSettings
    let idDomain: String
    let buildImage: String
    let prerender: String?
}

extension Site {
    struct BuildSettings: Codable {
        let provider, repoPath, repoBranch: String
        let deployKeyId, functionsDir: String?
        let dir, cmd: String
        let allowedBranches: [String]
        let publicRepo: Bool
        let privateLogs: Bool?
        let repoUrl: URL
        let installationId: Int
        let stopBuilds: Bool
    }
    
    struct ProcessingSettings: Codable {
        let skip: Bool
        let css, js: CSS
        let images: Images
        let html: HTML
    }
    
    struct CSS: Codable {
        let bundle, minify: Bool
    }
    
    struct HTML: Codable {
        let prettyUrls: Bool
    }
    
    struct Images: Codable {
        let optimize: Bool
    }
}
