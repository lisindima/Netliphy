//
//  Issue.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 17.08.2021.
//

import SwiftUI

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
    
    var updateLabel: Text {
        Text("Updated ") + Text(updatedAt, style: .relative) + Text(" ago")
    }
    
    enum State: String, Codable {
        case open
        case close
        
        var color: Color {
            switch self {
            case .open:
                return .green
            case .close:
                return .red
            }
        }
    }
}

extension Issue {
    static let placeholder = Issue(
        id: 0,
        nodeId: "placeholder",
        url: URL(string: "https://apple.com")!,
        repositoryUrl: URL(string: "https://apple.com")!,
        labelsUrl: "placeholder",
        commentsUrl: URL(string: "https://apple.com")!,
        eventsUrl: URL(string: "https://apple.com")!,
        htmlUrl: URL(string: "https://apple.com")!,
        number: 0,
        state: .open,
        title: "placeholder",
        body: "placeholder",
        locked: false,
        activeLockReason: nil,
        comments: 0,
        closedAt: nil,
        createdAt: Date(),
        updatedAt: Date(),
        authorAssociation: "placeholder"
    )
}

extension Array where Element == Issue {
    static let arrayPlaceholder = Array(repeating: .placeholder, count: 5)
}
