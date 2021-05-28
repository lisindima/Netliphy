//
//  Team.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 31.03.2021.
//

import Foundation

struct Team: Codable, Identifiable {
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
}

extension Team {
    static let placeholder = Team(
        id: UUID().uuidString,
        name: "placeholder",
        slug: "placeholder",
        siteAccess: nil,
        billingName: nil,
        billingEmail: nil,
        billingDetails: nil,
        billingPeriod: nil,
        rolesAllowed: nil,
        createdAt: Date(),
        updatedAt: Date(),
        deployNotificationsPerRepo: nil,
        paymentsGatewayName: nil,
        lifecycleState: nil,
        currentBillingPeriodStart: nil,
        nextBillingPeriodStart: nil,
        supportLevel: nil,
        supportPriority: nil,
        extraConcurrentBuilds: nil,
        membersCount: 1,
        paymentMethodId: nil,
        typeId: nil,
        typeName: "placeholder",
        typeSlug: nil,
        monthlySeatsAddonDollarPrice: nil,
        ownerIds: nil,
        accountDefault: nil,
        hasBuilds: nil,
        enforceSaml: nil,
        teamLogoUrl: nil
    )
}
