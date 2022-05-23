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
        if let link = news.link {
            Link(destination: link) {
                label
            }
        } else {
            label
        }
    }
}

private extension NewsItems {
    var label: some View {
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
            news.type
        }
    }
}
