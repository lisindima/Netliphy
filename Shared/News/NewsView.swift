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
            failure: { error in
                FailureView(error.localizedDescription, action: sessionStore.getNews)
            }
        ) { news in
            List {
                ForEach(news, id: \.id, content: NewsItems.init)
            }
        }
        .onAppear(perform: sessionStore.getNews)
        .navigationTitle("news_title")
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}
