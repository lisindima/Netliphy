//
//  Hook.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 12.05.2021.
//

import Foundation

struct Hook: Codable {
    let id, siteId: String
    let formId, formName: String?
    let userId, type: String
    let event: Event
    let data: [String: String?]
    let success: Bool?
    let createdAt, updatedAt: Date
    let actor: String
    let disabled: Bool?
    let restricted: Bool
}
