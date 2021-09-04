//
//  PluginsViewModel.swift
//  PluginsViewModel
//
//  Created by Дмитрий on 04.09.2021.
//

import SwiftUI

@MainActor
class PluginsViewModel: ObservableObject {
    @Published private(set) var loadingState: LoadingState<[Plugin]> = .loading(.arrayPlaceholder)
    
    func load(_ installedPlugins: [InstalledPlugins]) async {
        if Task.isCancelled { return }
        do {
            let value: [Plugin] = try await Loader.shared.fetch(for: .plugins)
            let filteredPlugins = value.filter { plugins -> Bool in
                installedPlugins.contains(where: { $0.package == plugins.package })
            }
            if Task.isCancelled { return }
            loadingState = .success(filteredPlugins)
        } catch {
            if Task.isCancelled { return }
            loadingState = .failure(error)
            print("plugins", error)
        }
    }
}
