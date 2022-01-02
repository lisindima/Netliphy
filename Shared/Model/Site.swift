//
//  Site.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import SwiftUI

struct Site: Codable, Identifiable {
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
    let plugins: [InstalledPlugins]
    
    var lastUpdate: Text {
        Text("Last update ") + Text(updatedAt, style: .relative) + Text(" ago")
    }
}

struct Capabilities: Codable {
    let forms: Forms?
    let functions: Functions?
    let identity: Identity?
}

struct Forms: Codable {
    let submissions, storage: CapabilitiesValue
}

struct Functions: Codable {
    let invocations, runtime: CapabilitiesValue
}

struct Identity: Codable {
    let activeUsers, inviteOnlyUsers: CapabilitiesValue
}

struct CapabilitiesValue: Codable {
    let included, used: Double
    let unit: String
}

struct InstalledPlugins: Codable, Identifiable {
    let package: String
    let pinnedVersion: String?
    
    var id: String { package }
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

struct Env: Codable, Identifiable {
    var key: String
    var value: String
    
    var id = UUID()
}

struct EnvHelper: Codable {
    let buildSettings: BuildSettings
    
    struct BuildSettings: Codable {
        let env: [String: String]
    }
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
            functions: nil,
            identity: nil
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
            InstalledPlugins(
                package: "placeholder",
                pinnedVersion: nil
            )
        ]
    )
}

extension Array where Element == Site {
    static let arrayPlaceholder = Array(repeating: .placeholder, count: 3)
}
