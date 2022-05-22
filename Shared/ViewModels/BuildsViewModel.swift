//
//  BuildsViewModel.swift
//  Netliphy
//
//  Created by Дмитрий Лисин on 13.06.2021.
//

import SwiftUI

@MainActor
class BuildsViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState<[Build]> = .placeholder(.arrayPlaceholder)
    
    func load(_ slug: String) async {
        if Task.isCancelled { return }
        
        do {
            let value: [Build] = try await Loader.shared.fetch(for: .builds(slug))
            if Task.isCancelled { return }
            
            loadingState = .success(value)
        } catch {
            if Task.isCancelled { return }
            loadingState = .failure(error)
            print("listBuilds", error)
        }
    }
}
