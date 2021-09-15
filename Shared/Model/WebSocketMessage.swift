//
//  WebSocketMessage.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 05.06.2021.
//

import Foundation

struct WebSocketMessage: Codable {
    let accessToken: String?
    let accountId: String
    let functionId: String
    let siteId: String
    var from: Date? = nil
    var to: Date? = nil
}
