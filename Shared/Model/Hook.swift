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
    let userId, type, event: String
    let data: DataClass?
    let success: Bool?
    let createdAt, updatedAt: Date
    let actor: String?
    let disabled: Bool?
    let restricted: Bool?
}

struct DataClass: Codable {
    let accessToken: String?
    let url: String?
}
