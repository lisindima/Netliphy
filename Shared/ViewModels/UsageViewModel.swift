//
//  UsageViewModel.swift
//  UsageViewModel
//
//  Created by Дмитрий Лисин on 26.07.2021.
//

import SwiftUI

@MainActor
class UsageViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState<[Usage]> = .loading
    
    func load(_ siteId: String) async {
        if Task.isCancelled { return }
        do {
            let value: [UsageResponse] = try await Loader.shared.fetch(for: .usage(siteId))
            if Task.isCancelled { return }
            loadingState = .success(value.compactMap(Usage.init))
        } catch {
            if Task.isCancelled { return }
            loadingState = .failure(error)
            print(error)
        }
    }
}
