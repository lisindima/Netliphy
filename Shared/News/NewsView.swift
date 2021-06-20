//
//  NewsView.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 09.04.2021.
//

import SwiftUI

struct NewsView: View {
    @StateObject private var viewModel = NewsViewModel()
    
    var body: some View {
        LoadingView(
            loadingState: viewModel.newsLoadingState,
            failure: { error in FailureView(errorMessage: error.localizedDescription) }
        ) { news in
            List {
                ForEach(news, id: \.id, content: NewsItems.init)
            }
            .refreshable {
                await viewModel.load()
            }
        }
        .task {
            await viewModel.load()
        }
        .navigationTitle("news_title")
    }
}
