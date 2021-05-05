//
//  SiteForm.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 12.04.2021.
//

import Foundation

struct SiteForm: Codable {
    let siteId, name: String
    let paths: String?
    let submissionCount: Int
    let fields: [Field]
    let createdAt: Date
    let lastSubmissionAt: Date
    let id: String
    let honeypot, recaptcha: Bool
}

struct Field: Codable {
    let name: String
    let type: String?
}

extension SiteForm {
    static let placeholder = SiteForm(
        siteId: "placeholder",
        name: "placeholder",
        paths: nil,
        submissionCount: 1,
        fields: [
            Field(
                name: "placeholder",
                type: nil
            ),
        ],
        createdAt: Date(),
        lastSubmissionAt: Date(),
        id: UUID().uuidString,
        honeypot: true,
        recaptcha: false
    )
}
