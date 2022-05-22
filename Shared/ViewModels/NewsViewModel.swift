//
//  NewsViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 13.06.2021.
//

import SwiftUI

@MainActor
class NewsViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState<[News]> = .placeholder(.arrayPlaceholder)
    
    func load() async {
        if Task.isCancelled { return }
        
        do {
            let value: [News] = try await Loader.shared.fetch(for: .news)
            if Task.isCancelled { return }
            
            loadingState = .success(value)
        } catch {
            if Task.isCancelled { return }
            loadingState = .failure(error)
            print("getNews", error)
        }
    }
}
