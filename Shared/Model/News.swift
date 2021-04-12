//
//  News.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 09.04.2021.
//

import Foundation

struct News: Codable {
    let type, title, body: String
    let link: URL
    let updatedAt: Date
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
