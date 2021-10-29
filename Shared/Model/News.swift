//
//  News.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 09.04.2021.
//

import SwiftUI

struct News: Codable, Identifiable {
    let type: NewsType
    let title, body: String
    let link: URL
    let updatedAt: Date
    
    var id: String { title }
}

enum NewsType: String, Codable, View {
    case warning
    case announcement
    case info
    
    var body: some View {
        switch self {
        case .warning:
            Image(systemName: "exclamationmark.triangle")
                .font(.body.weight(.bold))
                .foregroundColor(.yellow)
        case .announcement:
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

extension News {
    static let placeholder = News(
        type: .announcement,
        title: "placeholder",
        body: "placeholderplaceholderplaceholderplaceholderplaceholder",
        link: URL(string: "https://apple.com")!,
        updatedAt: Date()
    )
}

extension Array where Element == News {
    static let arrayPlaceholder = Array(repeating: .placeholder, count: 10)
}
