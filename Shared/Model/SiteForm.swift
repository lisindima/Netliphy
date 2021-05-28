//
//  SiteForm.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 12.04.2021.
//

import Foundation

struct SiteForm: Codable,Identifiable {
    let id: String
    let siteId, name: String
    let paths: String?
    let submissionCount: Int
    let fields: [Field]
    let createdAt: Date
    let lastSubmissionAt: Date
    let honeypot, recaptcha: Bool
}

struct Field: Codable {
    let name: String
    let type: String?
}

extension SiteForm {
    static let placeholder = SiteForm(
        id: UUID().uuidString,
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
        honeypot: true,
        recaptcha: false
    )
}
