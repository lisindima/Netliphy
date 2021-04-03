//
//  Team.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 31.03.2021.
//

import Foundation

struct Team: Codable {
    let id: String
    let name, slug: String
    let siteAccess, billingName, billingEmail: String?
    let billingDetails, billingPeriod: String?
    let rolesAllowed: [String]?
    let createdAt, updatedAt: Date
    let deployNotificationsPerRepo: Bool?
    let paymentsGatewayName: String?
    let lifecycleState: String?
    let currentBillingPeriodStart, nextBillingPeriodStart, supportLevel: String?
    let supportPriority, extraConcurrentBuilds: Int?
    let membersCount: Int
    let paymentMethodId, typeId: String?
    let typeName: String
    let typeSlug, monthlySeatsAddonDollarPrice: String?
    let ownerIds: [String]?
    let accountDefault, hasBuilds: Bool?
    let enforceSaml: String?
    let teamLogoUrl: URL?
    let capabilities: Capabilities
}

struct Capabilities: Codable {
    let bandwidth, collaborators: ProgressData
    let customPrerender, trustedCommitters: Analytics
    let concurrentBuilds: ConcurrentBuilds
    let buildMinutes: ProgressData
    let deployUrlHooks: Analytics
    let sites: ProgressData
    let analytics: Analytics
    let domains: ProgressData
}

struct Analytics: Codable {
    let included: Bool
}

struct ProgressData: Codable {
    let included, used: Int
}

struct ConcurrentBuilds: Codable {
    let included, max, used: Int
}
