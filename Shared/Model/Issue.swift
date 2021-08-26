//
//  Issue.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 17.08.2021.
//

import Foundation

struct Issue: Codable, Identifiable {
    let id: Int
    let nodeId: String
    let url, repositoryUrl: URL
    let labelsUrl: String
    let commentsUrl, eventsUrl, htmlUrl: URL
    let number: Int
    let state: State
    let title, body: String
    let locked: Bool
    let activeLockReason: String?
    let comments: Int
    let closedAt: Date?
    let createdAt, updatedAt: Date
    let authorAssociation: String
    
    enum State: String, Codable {
        case open
        case close
    }
}
