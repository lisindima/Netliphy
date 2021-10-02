//
//  NewsViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 13.06.2021.
//

import SwiftUI

@MainActor
class NewsViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState<[News]> = .loading(.arrayPlaceholder)
    
    private let cache = DiskCache<[News]>(filename: "netliphy_news")
    
    init() {
        Task(priority: .userInitiated) {
            try? await cache.loadFromDisk()
        }
    }
    
    func load() async {
        if Task.isCancelled { return }
        
        if let cachedNews = await cache.value(forKey: "news") {
            loadingState = .success(cachedNews)
        }
        
        do {
            let value: [News] = try await Loader.shared.fetch(for: .news)
            if Task.isCancelled { return }
            
            await cache.setValue(value, forKey: "news")
            try? await cache.saveToDisk()
            
            loadingState = .success(value)
        } catch {
            if Task.isCancelled { return }
//            loadingState = .failure(error)
            print("getNews", error)
        }
    }
}
