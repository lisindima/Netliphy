//
//  User.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import Foundation

struct User: Codable, Identifiable {
    let id: String
    let uid: String?
    let fullName: String?
    let avatarUrl: URL
    let email, affiliateId: String?
    let siteCount: Int
    let createdAt, lastLogin: Date?
    let loginProviders: [String]
    let onboardingProgress: OnboardingProgress
    let slug: String?
    let sandbox: Bool
    let connectedAccounts: [String: String]?
    let hasPendingEmailVerification, mfaEnabled: Bool
    let preferredAccountId, trackingId: String
}

struct OnboardingProgress: Codable {
    let slides: String
    let notificationsReadAt: Date
}
