//
//  NewsView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 09.04.2021.
//

import SwiftUI

struct NewsView: View {
    @StateObject private var newsStore = NewsStore()
    
    var body: some View {
        LoadingView(
            loadingState: newsStore.newsLoadingState,
            failure: { error in FailureView(errorMessage: error.localizedDescription) }
        ) { news in
            List {
                ForEach(news, id: \.id, content: NewsItems.init)
            }
            .refreshable {
                await newsStore.getNews()
            }
        }
        .task {
            await newsStore.getNews()
        }
        .navigationTitle("news_title")
    }
}
