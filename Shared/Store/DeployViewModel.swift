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
        do {
            let value: Deploy = try await Loader.shared.fetch(.deploy(deployId))
            loadingState = .success(value)
        } catch {
            loadingState = .failure(.placeholder, error: error)
            print(error)
        }
    }
}
