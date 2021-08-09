//
//  UsageViewModel.swift
//  UsageViewModel
//
//  Created by Дмитрий Лисин on 26.07.2021.
//

import SwiftUI

@MainActor
class UsageViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState<[Usage]> = .loading(.arrayPlaceholder)
    
    func load(_ siteId: String) async {
        if Task.isCancelled { return }
        do {
            let value: [Usage] = try await Loader.shared.fetch(for: .usage(siteId))
            if Task.isCancelled { return }
            print(value)
            loadingState = .success(value)
        } catch {
            if Task.isCancelled { return }
            loadingState = .failure(.arrayPlaceholder, error: error)
            print(error)
        }
    }
}
