//
//  NewsViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 13.06.2021.
//

import SwiftUI

@MainActor
class NewsViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState<[News]> = .loading
    
    func load() async {
        if Task.isCancelled { return }
        
        do {
            let value: [NewsResponse] = try await Loader.shared.fetch(for: .news)
            if Task.isCancelled { return }
            loadingState = .success(value.compactMap(News.init))
        } catch {
            if Task.isCancelled { return }
            loadingState = .failure(error)
            print("getNews", error)
        }
    }
}
