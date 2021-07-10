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
    
    func load() async {
        do {
            let value: [News] = try await Loader.shared.fetch(.news)
            loadingState = .success(value)
        } catch {
            loadingState = .failure(.arrayPlaceholder, error: error)
            print("getNews", error)
        }
    }
}
