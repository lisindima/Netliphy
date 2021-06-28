//
//  NewsItems.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 14.04.2021.
//

import SwiftUI

struct NewsItems: View {
    let news: News
    
    var body: some View {
        Link(destination: news.link) {
            Label {
                VStack(alignment: .leading, spacing: 5) {
                    Text(news.title)
                        .foregroundColor(.primary)
                        .fontWeight(.bold)
                    Text(news.body)
                        .foregroundColor(.primary)
                        .font(.footnote)
                    HStack {
                        Text(news.updatedAt, style: .relative) + Text(" ago")
                    }
                    .foregroundColor(.secondary)
                    .font(.caption2)
                }
            } icon: {
                Image(systemName: "megaphone")
            }
        }
    }
}
