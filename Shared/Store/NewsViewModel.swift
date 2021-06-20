//
//  NewsViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 13.06.2021.
//

import SwiftUI

@MainActor
class NewsViewModel: ObservableObject {
    @Published private(set) var newsLoadingState: LoadingState<[News]> = .loading(Array(repeating: .placeholder, count: 8))
    
    func load() async {
        do {
            let value: [News] = try await Loader.shared.fetch(.news)
            newsLoadingState = .success(value)
        } catch {
            newsLoadingState = .failure(error)
            print("getNews", error)
        }
    }
}
