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
    
    private let cache = DiskCache<[Plugin]>(filename: "netliphy_plugins")
    
    init() {
        Task(priority: .userInitiated) {
            try? await cache.loadFromDisk()
        }
    }
    
    func load() async {
        if Task.isCancelled { return }
        
        if let cachedPlugins = await cache.value(forKey: "plugins") {
            loadingState = .success(cachedPlugins)
        }
        
        do {
            let value: [Plugin] = try await Loader.shared.fetch(for: .plugins)
            let sorted = value.sorted { $0.name < $1.name }
            if Task.isCancelled { return }
            
            await cache.setValue(sorted, forKey: "plugins")
            try? await cache.saveToDisk()
            
            loadingState = .success(sorted)
        } catch {
            if Task.isCancelled { return }
//            loadingState = .failure(error)
            print("plugins", error)
        }
    }
    
    func updatePlugins(_ siteId: String, plugins: PluginsHelper) async {
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
