//
//  Submissions.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 11.04.2021.
//

import Foundation

struct Submission: Codable, Identifiable {
    let id, formId: String
    let number: Int
    let title: String?
    let email: String?
    let name, firstName: String?
    let lastName: String?
    let company: String?
    let summary: String?
    let body: String?
    let data: SubmissionData
    let createdAt: Date
    let humanFields: HumanFields
    let orderedHumanFields: [OrderedHumanField]
    let siteUrl: URL
    let formName: String
}

struct SubmissionData: Codable {
    let name: String?
    let attachment: Attachment?
    let ip, userAgent: String?
    let referrer: String?
    let email, message: String?
}

struct Attachment: Codable {
    let filename, type: String
    let size: Int
    let url: URL
}

struct HumanFields: Codable {
    let yourName: String?
    let attachment: String?
    let email, message: String?
}

struct OrderedHumanField: Codable {
    let title, name: String
    let value: String
}

extension Submission {
    static let placeholder = Submission(
        id: UUID().uuidString,
        formId: UUID().uuidString,
        number: 1,
        title: "placeholder",
        email: "placeholder",
        name: "placeholder",
        firstName: "placeholder",
        lastName: "placeholder",
        company: "placeholder",
        summary: nil,
        body: nil,
        data: SubmissionData(
            name: "placeholder",
            attachment: nil,
            ip: "placeholder",
            userAgent: "placeholder",
            referrer: "placeholder",
            email: "placeholder",
            message: "placeholder"
        ),
        createdAt: Date(),
        humanFields: HumanFields(
            yourName: "placeholder",
            attachment: nil,
            email: nil,
            message: nil
        ),
        orderedHumanFields: [
            OrderedHumanField(
                title: "placeholder",
                name: "placeholder",
                value: "placeholder"
            ),
        ],
        siteUrl: URL(string: "https://apple.com")!,
        formName: "placeholder"
    )
}
