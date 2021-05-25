//
//  Site.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import Foundation

struct Site: Codable {
    let id, state, plan, name: String
    let customDomain: String?
    let domainAliases: [String]
    let password, notificationEmail: String?
    let adminUrl, url, sslUrl: URL
    let screenshotUrl: URL?
    let createdAt, updatedAt: Date
    let userId: String
    let sessionId: String?
    let ssl, managedDns: Bool
    let forceSsl: Bool?
    let deployUrl: URL
    let publishedDeploy: Deploy?
    let accountName, accountType, accountSlug: String
    let capabilities: Capabilities
    let gitProvider, deployHook: String?
    let buildSettings: BuildSettings
    let idDomain: String
    let buildImage: String
    let prerender: String?
    let plugins: [Plugin]
}

struct Capabilities: Codable {
    let forms: Forms?
    let functions: Functions?
}

struct Forms: Codable {
    let submissions, storage: CapabilitiesValue
}

struct Functions: Codable {
    let invocations, runtime: CapabilitiesValue
}

struct CapabilitiesValue: Codable {
    let included: Int
    let unit: String
    let used: Int
}

struct Plugin: Codable {
    let package: String
}

struct BuildSettings: Codable {
    let provider, repoPath, repoBranch: String?
    let deployKeyId, functionsDir: String?
    let dir, cmd: String?
    let env: [String: String]?
    let allowedBranches: [String]?
    let publicRepo: Bool?
    let privateLogs: Bool?
    let repoUrl: URL?
    let installationId: Int?
    let stopBuilds: Bool?
}

extension Site {
    static let placeholder = Site(
        id: UUID().uuidString,
        state: "state",
        plan: "plan",
        name: "placeholder",
        customDomain: nil,
        domainAliases: [],
        password: nil,
        notificationEmail: nil,
        adminUrl: URL(string: "https://apple.com")!,
        url: URL(string: "https://apple.com")!,
        sslUrl: URL(string: "https://apple.com")!,
        screenshotUrl: nil,
        createdAt: Date(),
        updatedAt: Date(),
        userId: "placeholder",
        sessionId: nil,
        ssl: true,
        managedDns: true,
        forceSsl: nil,
        deployUrl: URL(string: "https://apple.com")!,
        publishedDeploy: .placeholder,
        accountName: "placeholder",
        accountType: "placeholder",
        accountSlug: "placeholder",
        capabilities: Capabilities(
            forms: nil,
            functions: nil
        ),
        gitProvider: nil,
        deployHook: nil,
        buildSettings: BuildSettings(
            provider: nil,
            repoPath: nil,
            repoBranch: nil,
            deployKeyId: nil,
            functionsDir: nil,
            dir: nil,
            cmd: nil,
            env: nil,
            allowedBranches: nil,
            publicRepo: nil,
            privateLogs: nil,
            repoUrl: nil,
            installationId: nil,
            stopBuilds: nil
        ),
        idDomain: "placeholder",
        buildImage: "placeholder",
        prerender: nil,
        plugins: [
            Plugin(package: "placeholder"),
        ]
    )
}
