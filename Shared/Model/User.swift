//
//  User.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import Foundation

struct User: Codable {
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
    let connectedAccounts: ConnectedAccounts?
    let hasPendingEmailVerification, mfaEnabled: Bool
    let preferredAccountId, trackingId: String
}

struct ConnectedAccounts: Codable {
    let github, gitlab, bitbucket: String?
}

struct OnboardingProgress: Codable {
    let slides, notificationsReadAt: String
}

extension User {
    static let placeholder = User(
        id: UUID().uuidString,
        uid: nil,
        fullName: "placeholder",
        avatarUrl: URL(string: "https://apple.com")!,
        email: "placeholder",
        affiliateId: nil,
        siteCount: 1,
        createdAt: Date(),
        lastLogin: Date(),
        loginProviders: [],
        onboardingProgress: OnboardingProgress(
            slides: "placeholder",
            notificationsReadAt: "placeholder"
        ),
        slug: "placeholder",
        sandbox: false,
        connectedAccounts: nil,
        hasPendingEmailVerification: false,
        mfaEnabled: false,
        preferredAccountId: UUID().uuidString,
        trackingId: UUID().uuidString
    )
}
