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
        LoadingView(viewModel.loadingState) { news in
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
        .navigationTitle("News by Netlify")
    }
}
