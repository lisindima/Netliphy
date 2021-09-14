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
    
    func load() async {
        if Task.isCancelled { return }
        do {
            let value: [Plugin] = try await Loader.shared.fetch(for: .plugins)
            let sorted = value.sorted { $0.name < $1.name }
            if Task.isCancelled { return }
            loadingState = .success(sorted)
        } catch {
            if Task.isCancelled { return }
            loadingState = .failure(error)
            print("plugins", error)
        }
    }
    
    func updatePlugins(_ siteId: String, plugins: Helper) async {
        if Task.isCancelled { return }
        do {
            let _: Site = try await Loader.shared.upload(for: .site(siteId), parameters: plugins, httpMethod: .put)
            if Task.isCancelled { return }
        } catch {
            if Task.isCancelled { return }
            print("updatePlugins", error)
        }
    }
}
