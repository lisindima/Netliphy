//
//  News.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 09.04.2021.
//

import Foundation

struct News: Codable, Identifiable {
    let type, title, body: String
    let link: URL
    @ISO8601Date
    var updatedAt: Date
    
    var id: String { title }
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

extension Array where Element == News {
    static let arrayPlaceholder = Array(repeating: .placeholder, count: 10)
}
