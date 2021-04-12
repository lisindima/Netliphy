//
//  NewsView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 09.04.2021.
//

import SwiftUI

struct NewsView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    
    var body: some View {
        LoadingView(
            loadingState: $sessionStore.newsLoadingState,
            load: sessionStore.getNews
        ) { news in
            List {
                ForEach(news, id: \.title, content: NewsItems.init)
            }
            .listStyle(InsetGroupedListStyle())
        }
        .navigationTitle("news_title")
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}

struct NewsItems: View {
    var news: News
    
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
                        Text(news.updatedAt, style: .relative) + Text("site_items_ago")
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
