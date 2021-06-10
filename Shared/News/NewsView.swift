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
            failure: { error in FailureView(errorMessage: error.localizedDescription) }
        ) { news in
            List {
                ForEach(news, id: \.id, content: NewsItems.init)
            }
            .refreshable {
                await sessionStore.getNews()
            }
        }
        .onAppear {
            async {
                await sessionStore.getNews()
            }
        }
        .navigationTitle("news_title")
    }
}
