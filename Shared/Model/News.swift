//
//  News.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 09.04.2021.
//

import Foundation

struct News: Codable, Identifiable {
    let id = UUID()
    let type, title, body: String
    let link: URL
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case type, title, body, link, updatedAt
    }
}

extension News {
    static let placeholder = News(
        type: "placeholder",
        title: "placeholder",
        body: "placeholderplaceholderplaceholderplaceholderplaceholder",
        link: URL(string: "https://apple.com")!,
        updatedAt: Date()
    )
}
