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
    let supportPriority, extraConcurrentBuilds, membersCount: Int?
    let paymentMethodId, typeName, typeId: String?
    let typeSlug, monthlySeatsAddonDollarPrice: String?
    let ownerIds: [String]?
    let accountDefault, hasBuilds: Bool?
    let enforceSaml: String?
    let teamLogoUrl: URL?
}

struct Bandwidth: Codable {
    let used, included: Int64
    let lastUpdatedAt: Date
    let periodStartDate, periodEndDate: String
    let additional: Int
}
