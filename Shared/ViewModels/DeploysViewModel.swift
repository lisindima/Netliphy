//
//  DeploysViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 15.06.2021.
//

import SwiftUI

@MainActor
class DeploysViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState<[Deploy]> = .loading(.arrayPlaceholder)
    
    func load(_ siteId: String) async {
        if Task.isCancelled { return }
        do {
            let value: [Deploy] = try await Loader.shared.fetch(for: .deploys(siteId))
            if Task.isCancelled { return }
            loadingState = .success(value)
        } catch {
            if Task.isCancelled { return }
            loadingState = .failure(error)
        }
    }
}
