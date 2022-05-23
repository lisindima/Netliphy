//
//  News.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 09.04.2021.
//

import SwiftUI

struct NewsResponse: Codable {
    let type: String
    let title, body: String
    let link: String
    let updatedAt: Date
}

struct News: Identifiable {
    let id = UUID()
    let type: NewsType
    let title, body: String
    let link: URL?
    let updatedAt: Date
}

extension News {
    init(_ response: NewsResponse) {
        type = NewsType(rawValue: response.type) ?? .announcement
        title = response.title
        body = response.body
        link = URL(string: response.link.replacingOccurrences(of: " ", with: ""))
        updatedAt = response.updatedAt
    }
}

enum NewsType: String, Codable, View {
    case warning
    case announcement
    case info
    case event
    case survey
    case feature
    
    var body: some View {
        switch self {
        case .warning:
            Image(systemName: "exclamationmark.triangle")
                .font(.body.weight(.bold))
                .foregroundColor(.yellow)
        case .announcement, .event, .survey, .feature:
            Image(systemName: "megaphone")
                .font(.body.weight(.bold))
                .foregroundColor(.accentColor)
        case .info:
            Image(systemName: "info.circle")
                .font(.body.weight(.bold))
                .foregroundColor(.purple)
        }
    }
}
