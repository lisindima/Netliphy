//
//  User.swift
//  NetlifyApp
//
//  Created by Дмитрий Лисин on 04.03.2021.
//

import Foundation

struct User: Codable {
    let id: String
    let uid: String?
    let fullName: String
    let avatarUrl: URL
    let email, affiliateId: String
    let siteCount: Int
    let createdAt, lastLogin: String
    let loginProviders: [String]
    let onboardingProgress: OnboardingProgress
    let slug: String
    let sandbox: Bool
    let connectedAccounts: ConnectedAccounts
    let hasPendingEmailVerification, mfaEnabled: Bool
    let preferredAccountId, trackingId: String
}

extension User {
    struct ConnectedAccounts: Codable {
        let github, gitlab, bitbucket: String?
    }
    
    struct OnboardingProgress: Codable {
        let slides, notificationsReadAt: String
    }
}
