//
//  DeployViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 19.06.2021.
//

import SwiftUI

@MainActor
class DeployViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState<Deploy> = .loading(.placeholder)
    
    func load(_ deployId: String) async {
        if Task.isCancelled { return }
        do {
            let value: Deploy = try await Loader.shared.fetch(for: .deploy(deployId))
            if Task.isCancelled { return }
            loadingState = .success(value)
        } catch {
            if Task.isCancelled { return }
            loadingState = .failure(.placeholder, error: error)
            print(error)
        }
    }
}
